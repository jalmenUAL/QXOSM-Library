module namespace qxosmv3 = "qxosmv3";
 
(: TAGINFO :) 
 
 
declare function  qxosmv3:combinations($label,$s,$e)
{
let $tags :=   http:send-request(
  <http:request 
    method='get'  
    href = 'https://taginfo.openstreetmap.org/api/4/key/combinations?key={$label}&amp;filter=all&amp;sortname=to_count&amp;sortorder=desc&amp;page={$s}&amp;rp={$e}&amp;qtype=other_key&amp;format=json_prettyy'/>)[2]/json/data/_/other__key
return $tags 
};
 
  
 
declare function qxosmv3:iskey($s,$e)
{
let $tags :=   http:send-request(
  <http:request 
    method='get'  
    href = 'https://taginfo.openstreetmap.org/api/4/keys/all?include=prevalent_values&amp;sortname=count_all&amp;sortorder=desc&amp;page={$s}&amp;rp={$e}&amp;qtype=key&amp;format=json_pretty'/>)
return $tags[2]/json/data/_/key
}; 
 
 
(: SUMMARY :)


declare function qxosmv3:summary($map)
{
<result>
<row><x>Total of Elements</x><y>{qxosmv3:elementTotal($map)}</y></row>
<row><x>Total of Nodes</x><y>{qxosmv3:nodeTotal($map)}</y></row>
<row><x>Total of Ways</x><y>{qxosmv3:wayTotal($map)}</y></row>
<row><x>Total of Relations</x><y>{qxosmv3:relationTotal($map)}</y></row>
<row><x>Total of Contributions</x><y>{qxosmv3:total-contributions($map)}</y></row>
<row><x>Total of Contributers</x><y>{qxosmv3:number-of-contributers($map)}</y></row>
<row><x>Average of Editions</x><y>{qxosmv3:editionNumberAvg($map)}</y></row>
</result>  
};

declare function qxosmv3:elementTotal($map){
 count(db:open-pre($map,0)/osm/(node|way|relation)[tag])
};

declare function qxosmv3:nodeTotal($map){
 count(db:open-pre($map,0)/osm/node[tag])
};

declare function qxosmv3:relationTotal($map){
 count(db:open-pre($map,0)/osm/relation[tag])
};

declare function qxosmv3:wayTotal($map){
 count(db:open-pre($map,0)/osm/way[tag])
}; 

 

declare function qxosmv3:tagTotal($map,$tag){
 count(db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$tag])
}; 


declare function qxosmv3:total-contributions($map)
{
sum(db:open-pre($map,0)/osm/(node|way|relation)[@user]/@version)
};
 
declare function qxosmv3:number-of-contributers($map)
{
count(distinct-values(db:open-pre($map,0)/osm/(node|way|relation)/@user))
}; 

declare function qxosmv3:editionNumberAvg($map)
{
 avg(data(db:open-pre($map,0)/osm/(node[tag]|way|relation)/@version))
};

(: SUMMARY OF NUMBER OF ITEMS BY TYPE :)


declare function qxosmv3:summary_type($map,$types)
{
<result>
{for $type in $types
return
<row><x>{$type}</x><y>{qxosmv3:elementNumberByType($map,$type)}</y></row>
}
</result>  
};

declare function qxosmv3:elementNumberByType($map,$type){
 count(db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]) 
};

(: SUMMARY OF EDITION AVG BY TYPE :)
 
declare function qxosmv3:summary_edition_avg($map,$types)
{
<result>
{for $type in $types
return
<row><x>{$type}</x><y>{qxosmv3:editionNumberAvgbyType($map,$type)}</y></row>
}
</result>  
}; 

 
declare function qxosmv3:editionNumberAvgbyType($map,$type)
{
  
 let $a := db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]/@version
 return
 if ($a)
 then avg(data($a))
 else 0
};

(: COMPLETENESS :)

(: MISSING KEYS OF A CERTAIN TYPE :) 
 
declare function qxosmv3:comp_missing_keys($map,$ks,$type)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$type]])}</total>
{for $k in $ks return
<row><x>{$k}</x><y>{qxosmv3:missing_key($map,$k,$type)/missing/text()}</y></row>
}</result>  
  
};
 
(: MISSING KEYS OF A CERTAIN TYPE AND VALUES :)  

declare function qxosmv3:comp_missing_key_values($map,$ks,$values,$type)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$type]])}</total>
{for $k in $ks return
<row><x>{$k}</x><y>{qxosmv3:missing_key($map,$k,$type)/missing/text()}</y>
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$type and @v=$values]])}</total>
{for $v in $values
return 
<row><x>{$v}</x><y>{qxosmv3:missing_key_value($map,$k,$v,$type)/missing/text()}</y></row>
}
</result>
</row>
}
</result>  
};


(: MISSING KEY IN CERTAIN TYPES :) 

declare function qxosmv3:comp_missing_types_key($map,$k,$types)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$types]])}</total>
{for $t in $types return
<row><x>{$t}</x><y>{qxosmv3:missing_key($map,$k,$t)/missing/text() div qxosmv3:missing_key($map,$k,$t)/total/text() * 100}</y>
</row>
}</result>  
  
};

(: MISSING KEY IN A CERTAIN TYPE :)

declare function qxosmv3:missing_key($map,$k,$type)
{
let $t := db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$type]]   
let $count := count($t)
let $mkv := 
(for $x in $t where not ($x/tag/@k=$k) return $x)
let $cmkv := count($mkv)
return
<result>{<total>{$count}</total>,<missing>{$cmkv}</missing>}</result>

};
 
(: MISSING KEY IN A CERTAIN TYPE and VALUE :) 
 
declare function qxosmv3:missing_key_value($map,$k,$value,$type)
{
let $t := db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$type and @v=$value]]   
let $count := count($t)
let $mkv := 
(for $x in $t where not ($x/tag/@k=$k) return $x)
let $cmkv := count($mkv)
return
<result>{<total>{$count}</total>,<missing>{$cmkv}</missing>}</result>

};

(: COMPLIANCE :)

(: SOME KEY IS UNKNOWN IN A RANGE OF TAGINFO :)


declare function qxosmv3:compli_some_key_unknown($map,$es)
{
<result>  
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag])}</total>
{for $e in $es
return
<row>
<x>{$e}</x>
<y>{qxosmv3:some_key_unknown($map,1,$e)/missing/text()}</y>
</row>
}
</result>  
};

declare function qxosmv3:some_key_unknown($map,$s,$e){
let $d := db:open-pre($map,0)/osm/(node|way|relation)[tag]
let $ik := qxosmv3:iskey($s,$e)
let $t := count($d)
let $w := 
for $x in $d 
where some $tag in $x/tag satisfies not($ik=$tag/@k)  
return $x
return <result><total>{$t}</total><missing>{count($w)}</missing></result>
};


(: SOME KEY IS UNKNOWN IN A CERTAIN TYPE AND RANGE OF TAGINFO :)


declare function qxosmv3:compli_some_key_unknown_type($map,$type,$es)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type])}</total>
{  
for $e in $es
return
<row>
<x>{$e}</x>
<y>{qxosmv3:some_key_unknown_type($map,$type,1,$e)/missing/text()}</y>
</row>
}
</result>  
};

declare function qxosmv3:some_key_unknown_type($map,$type,$s,$e){
let $d := db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
let $ik := qxosmv3:iskey($s,$e)
let $t := count($d)
let $w := 
for $x in $d 
where some $tag in $x/tag satisfies not($ik=$tag/@k)  
return $x
return <result><total>{$t}</total><missing>{count($w)}</missing></result>
};

(: SOME KEY IS UNKNOWN IN A CERTAIN TYPE AND VALUES IN A RANGE OF TAGINFO :)

declare function qxosmv3:compli_some_key_unknown_type_values($map,$type,$values,$es)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$type]])}</total>
{
for $value in $values
return
<row><x>{$value}</x><y>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$type and @v=$value]])}</y>{qxosmv3:compli_some_key_unknown_type_value($map,$type,$value,$es)}</row>
}
</result>  
};
 
declare function qxosmv3:compli_some_key_unknown_type_value($map,$type,$value,$es)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$type and @v=$value]])}</total>
{  
for $e in $es
return
<row>
<x>{$e}</x>
<y>{qxosmv3:some_key_unknown_type_value($map,$type,$value,1,$e)/missing/text()}</y>
</row>
}
</result>  
};

declare function qxosmv3:some_key_unknown_type_value($map,$type,$value,$s,$e){
let $d := db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$type and @v=$value]]
let $ik := qxosmv3:iskey($s,$e)
let $t := count($d)
let $w := 
for $x in $d 
where some $tag in $x/tag satisfies not($ik=$tag/@k)  
return $x
return <result><total>{$t}</total><missing>{count($w)}</missing></result>
};
  


(: COMPLIANCE   :)


(:  WRONG COMBINATION OF KEYS IN A RANGE OF TAGINFO :)
 
declare function qxosmv3:compli_wrong_combination_keys($map,$label,$es)
{
<result>  
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag])}</total>
{for $e in $es
return
<row>
<x>{$e}</x>
<y>{qxosmv3:wrong_combination_keys($map,$label,1,$e)/missing/text()}</y>
</row>
}
</result>    
};

declare function qxosmv3:wrong_combination_keys($map,$label,$s,$e)
{
let $d := db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$label]
let $c := qxosmv3:combinations($label,$s,$e)
let $t := count($d)
let $w :=
for $x in $d
where 
(some $tag in $x/tag satisfies not($tag/@k=$label)  
and not($tag/@k=$c))
return $x
return <result><total>{$t}</total><missing>{count($w)}</missing></result>
}; 

(:  WRONG COMBINATION OF KEYS FOR VALUES IN A RANGE OF TAGINFO :)

declare function qxosmv3:compli_wrong_combination_keys_values($map,$label,$values,$es)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$label]])}</total>
{
for $value in $values
return
<row><x>{$value}</x><y>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$label and @v=$values]])}</y>{qxosmv3:compli_wrong_combination_keys_value($map,$label,$value,$es)}</row>
}
</result>
};

declare function qxosmv3:compli_wrong_combination_keys_value($map,$label,$value,$es)
{
<result>  
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$label and @v=$value]])}</total>
{for $e in $es
return
<row>
<x>{$e}</x>
<y>{qxosmv3:wrong_combination_keys_value($map,$label,$value,1,$e)/missing/text()}</y>
</row>
}
</result>    
};

declare function qxosmv3:wrong_combination_keys_value($map,$label,$value,$s,$e)
{
let $d := db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$label and @v=$value]]
let $c := qxosmv3:combinations($label,$s,$e)
let $t := count($d)
let $w :=
for $x in $d
where 
(some $tag in $x/tag satisfies not($tag/@k=$label)  
and not($tag/@k=$c))
return $x
return <result><total>{$t}</total><missing>{count($w)}</missing></result>
}; 



(: GRANULARITY :)

(: SUMMARY OF A KEY BY TAGS  :) 

declare function qxosmv3:gra_summary_key($map,$type)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type])}</total>
{for $s in qxosmv3:summary_key($map,$type)
return
<row><x>{$s/tags/text()}</x><y>{$s/count/text()}</y></row>
}
</result>  
};

declare function qxosmv3:summary_key($map,$type)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := string-join($t/tag/@k,' ')
group by $g 
return
(<partial><tags>{$g}</tags><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: SUMMARY OF NUMBER OF TAGS BY KEY :)

declare function qxosmv3:summary_key_ordered($map,$type)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := count($t/tag/@k) (:string-join($t/tag/@k,' '):)
group by $g 
order by count($t) descending
return
(<partial><tags>{$g}</tags><count>{count($t)}</count></partial>))

return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: AVERAGE OF TAGS OF A TYPE :)
 
declare function qxosmv3:average_key($city,$type)
{
  avg(for $x in db:open-pre($city,0)/osm/(node|way|relation)[tag[@k=$type]]
  return count($x/tag))
}; 

declare function qxosmv3:median($city,$type)
{
  let $items := db:open-pre($city,0)/osm/(node|way|relation)[tag[@k=$type]]
  let $seq := (for $x in $items
  order by count($x/tag)
  return count($x/tag))
  let $size := count($items)
  return $seq[$size idiv 2]
};  

(: RICHNESS :)

(: SUMMARY OF TAGS IN A KEY  :) 

declare function qxosmv3:rich_summary_values($map,$type)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type])}</total>
{for $s in qxosmv3:summary_values($map,$type)
return
<row><x>{$s/value/text()}</x><y>{$s/count/text()}</y></row>
}
</result>  
};

declare function qxosmv3:summary_values($map,$type)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := $t/tag[@k=$type]/@v 
group by $g 
return
(<partial><value>{$g}</value><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: SUMMARY OF NUMBER OF TAGS IN A KEY :)

declare function qxosmv3:summary_values_ordered($map,$type)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := $t/tag[@k=$type]/@v 
group by $g 
order by count($t) descending
return
(<partial><value>{$g}</value><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: NUMBER OF VALUES OF A TYPE :)

declare function qxosmv3:richness_type($city,$type)
{
  count(distinct-values(db:open-pre($city,0)/osm/(node|way|relation)/tag[@k=$type]/@v))
};


(: CONSISTENCE :)

(: SUMMARY OF TAGS IN A KEY AND A VALUE :) 

declare function qxosmv3:log_summary_key_value($map,$type,$value)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$type and @v=$value]])}</total>
{for $s in qxosmv3:summary_key_value($map,$type,$value)
return
<row><x>{$s/tags/text()}</x><y>{$s/count/text()}</y></row>
}
</result>  
};

declare function qxosmv3:summary_key_value($map,$type,$value)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$type and @v=$value]]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := string-join($t/tag/@k,' ')
group by $g 
return
(<partial><tags>{$g}</tags><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: SUMMARY OF NUMBER OF TAGS IN A KEY AND A VALUE :) 

declare function qxosmv3:summary_key_value_ordered($map,$type,$value)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag[@k=$type and @v=$value]]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := count($t/tag/@k) (:string-join($t/tag/@k,' '):)
group by $g 
order by count($t) descending
return
(<partial><tags>{$g}</tags><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: STANDARD DEVIATION OF A TYPE AND VALUE :)

declare function qxosmv3:standard_deviation_key($city,$type,$value)
{
  let $d := db:open-pre($city,0)/osm/(node|way|relation)[tag[@k=$type and @v=$value]]
  let $div := count($d) 
  let $avg := avg(for $x in $d return count($x/tag))
  let $sqrt := math:sqrt(sum(for $x in $d return (count($x/tag)-$avg) * (count($x/tag)-$avg) div $div))
  return $sqrt
}; 

(: TRUST :)



(: TRUST - TAGS :)

(: SUMMARY OF TAGS BY VERSION :) 

declare function qxosmv3:trust_summary_tags($map,$version)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag and @version=$version])}</total>
{for $s in qxosmv3:summary_tags($map,$version)
return
<row><x>{$s/tags/text()}</x><y>{$s/count/text()}</y></row>
}
</result>  
};

declare function qxosmv3:summary_tags($map,$version)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag and @version=$version]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := string-join($t/tag/@k,' ')
group by $g 
return
(<partial><tags>{$g}</tags><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: SUMMARY OF NUMBER OF TAGS BY VERSION :)

declare function qxosmv3:summary_tags_ordered($map,$version)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag and @version=$version]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := string-join($t/tag/@k,' ')
group by $g 
order by count($t) descending
return
(<partial><tags>{$g}</tags><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: AVERAGE OF TAGS :)

declare function qxosmv3:average_tags($city)
{
  avg(
  for $x in db:open-pre($city,0)/osm/(node|way|relation)[tag]
  return count($x/tag)
)
}; 


(: TRUST - VERSIONS :)

 
(: SUMMARY OF VERSIONS BY TYPE :)

declare function qxosmv3:trust_summary_versions($map,$type)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type])}</total>
{
for $s in qxosmv3:summary_versions($map,$type)
return
<row><x>{$s/version/text()}</x><y>{$s/count/text()}</y></row>
}
</result>  
};


declare function qxosmv3:summary_versions($map,$type)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := $t/@version
group by $g 
return
(<partial><version>{$g}</version><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: SUMMARY OF NUMBER OF VERSIONS BY TYPE :)

declare function qxosmv3:summary_versions_ordered($map,$type)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := $t/@version
group by $g 
order by count($t) descending
return
(<partial><version>{$g}</version><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};


(: AVERAGE OF VERSIONS :)


declare function qxosmv3:average_versions($city)
{
  avg(
  for $x in db:open-pre($city,0)/osm/(node|way|relation)[tag]
  return $x/@version
)
}; 

  


(: TRUST - USERS :)

(: SUMMARY OF USERS :)

declare function qxosmv3:trust_summary_users($map)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag])}</total>
{
for $s in qxosmv3:summary_users($map)
return
<row><x>{$s/user/text()}</x><y>{$s/count/text()}</y></row>
}
</result>  
};

declare function qxosmv3:summary_users($map)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := $t/@user
group by $g 
return
(<partial><user>{$g}</user><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: SUMMARY OF NUMBER OF ITEMS BY USER :)

declare function qxosmv3:summary_users_ordered($map)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := $t/@user
group by $g 
order by count($t) descending
return
(<partial><user>{$g}</user><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: SUMMARY OF USERS BY TYPE :)


declare function qxosmv3:trust_summary_users_type($map,$type)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type])}</total>
{
for $s in qxosmv3:summary_users_type($map,$type)
return
<row><x>{$s/user/text()}</x><y>{$s/count/text()}</y></row>
}
</result>  
};

declare function qxosmv3:summary_users_type($map,$type)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
let $ct := count($total) 
for  $gp in
(for $t in $total
let $g := $t/@user
group by $g 
return
(<partial><user>{$g}</user><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};




(: GINI INDEX OF CONTRIBUTIONS  :)

declare function qxosmv3:distribution_users($city)
{
  
  let $pairs :=
  (
  let $d :=
  (
  <rank>{
  for $x in db:open-pre($city,0)/osm/(node|way|relation)[tag]
  let $u := $x/@user
  group by $u
  order by count($x)
  return (<user>{$u}</user>,<count>{count($x)}</count>) 
}</rank>)
  let $n := count($d/count/text())
  let $un := qxosmv3:accumulated($d/count/text(),$n)
  return 
  <values>
  {
  for $i in 1 to $n - 1
  let $ui := qxosmv3:accumulated($d/count/text(),$i)
  let $pi := $i div $n * 100
  let $qi := $ui div $un * 100
  return (<p>{$pi}</p>,<q>{$qi}</q>)
  }
  </values>)
  return 1 - (sum($pairs/q) div sum($pairs/p))
};  


declare function qxosmv3:accumulated($v,$i)
{
  if ($i=1) then $v[$i]
  else $v[$i] + qxosmv3:accumulated($v,$i - 1) 
};

(: TRUST - DATES :)

(: SUMMARY OF CONTRIBUTIONS BY DATE :)

declare function qxosmv3:trust_summary_dates($map)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag])}</total>
<row><x>2007-01-01-2008-01-01</x><y>{qxosmv3:summary_dates($map,"2007-01-01","2008-01-01")/date/text()}</y></row>
<row><x>2008-01-01-2009-01-01</x><y>{qxosmv3:summary_dates($map,"2008-01-01","2009-01-01")/date/text()}</y></row>
<row><x>2009-01-01-2010-01-01</x><y>{qxosmv3:summary_dates($map,"2009-01-01","2010-01-01")/date/text()}</y></row>
<row><x>2010-01-01-2011-01-01</x><y>{qxosmv3:summary_dates($map,"2010-01-01","2011-01-01")/date/text()}</y></row>
<row><x>2011-01-01-2012-01-01</x><y>{qxosmv3:summary_dates($map,"2011-01-01","2012-01-01")/date/text()}</y></row>
<row><x>2012-01-01-2013-01-01</x><y>{qxosmv3:summary_dates($map,"2012-01-01","2013-01-01")/date/text()}</y></row>
<row><x>2013-01-01-2014-01-01</x><y>{qxosmv3:summary_dates($map,"2013-01-01","2014-01-01")/date/text()}</y></row>
<row><x>2014-01-01-2015-01-01</x><y>{qxosmv3:summary_dates($map,"2014-01-01","2015-01-01")/date/text()}</y></row>
<row><x>2015-01-01-2016-01-01</x><y>{qxosmv3:summary_dates($map,"2015-01-01","2016-01-01")/date/text()}</y></row>
<row><x>2016-01-01-2017-01-01</x><y>{qxosmv3:summary_dates($map,"2016-01-01","2017-01-01")/date/text()}</y></row>
<row><x>2017-01-01-2018-01-01</x><y>{qxosmv3:summary_dates($map,"2017-01-01","2018-01-01")/date/text()}</y></row>

</result>  
};

declare function qxosmv3:summary_dates($map,$s,$e)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag]
let $ct := count($total) 
let $t := count($total[$s <=@timestamp and @timestamp < $e]) 
return
<result><date>{$t}</date><total>{$ct}</total></result>
};

 
(: SUMMARY OF CONTRIBUTIONS OF A TYPE BY DATE :)

declare function qxosmv3:trust_summary_dates_type($map,$type)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type])}</total>
<row><x>2007-01-01-2008-01-01</x><y>{qxosmv3:summary_dates_type($map,$type,"2007-01-01","2008-01-01")/date/text()}</y></row>
<row><x>2008-01-01-2009-01-01</x><y>{qxosmv3:summary_dates_type($map,$type,"2008-01-01","2009-01-01")/date/text()}</y></row>
<row><x>2009-01-01-2010-01-01</x><y>{qxosmv3:summary_dates_type($map,$type,"2009-01-01","2010-01-01")/date/text()}</y></row>
<row><x>2010-01-01-2011-01-01</x><y>{qxosmv3:summary_dates_type($map,$type,"2010-01-01","2011-01-01")/date/text()}</y></row>
<row><x>2011-01-01-2012-01-01</x><y>{qxosmv3:summary_dates_type($map,$type,"2011-01-01","2012-01-01")/date/text()}</y></row>
<row><x>2012-01-01-2013-01-01</x><y>{qxosmv3:summary_dates_type($map,$type,"2012-01-01","2013-01-01")/date/text()}</y></row>
<row><x>2013-01-01-2014-01-01</x><y>{qxosmv3:summary_dates_type($map,$type,"2013-01-01","2014-01-01")/date/text()}</y></row>
<row><x>2014-01-01-2015-01-01</x><y>{qxosmv3:summary_dates_type($map,$type,"2014-01-01","2015-01-01")/date/text()}</y></row>
<row><x>2015-01-01-2016-01-01</x><y>{qxosmv3:summary_dates_type($map,$type,"2015-01-01","2016-01-01")/date/text()}</y></row>
<row><x>2016-01-01-2017-01-01</x><y>{qxosmv3:summary_dates_type($map,$type,"2016-01-01","2017-01-01")/date/text()}</y></row>
<row><x>2017-01-01-2018-01-01</x><y>{qxosmv3:summary_dates_type($map,$type,"2017-01-01","2018-01-01")/date/text()}</y></row>

</result>  
};

declare function qxosmv3:summary_dates_type($map,$type,$s,$e)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
let $ct := count($total) 
let $t := count($total[$s <=@timestamp and @timestamp < $e]) 
return
<result><date>{$t}</date><total>{$ct}</total></result>
};

(: AVERAGE OF DATES :)

declare function qxosmv3:average_year($city)
{
  avg(
  for $x in db:open-pre($city,0)/osm/(node|way|relation)[tag]
  return year-from-dateTime($x/@timestamp)
)
};




(: TRUST - SOURCES :)

(: SUMMARY OF SOURCES :)

declare function qxosmv3:trust_summary_sources($map)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag])}</total>
{
for $s in qxosmv3:summary_sources($map)
return
<row><x>{$s/source/text()}</x><y>{$s/count/text()}</y></row>
}
</result>  
};
 

declare function qxosmv3:summary_sources($map)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag]
let $source :=   $total[tag/@k="source"]
let $ct := count($total) 
for  $gp in
(for $t in $source
let $g := $t/tag[@k="source"]/@v
group by $g 
return
(<partial><source>{$g}</source><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: SUMMARY OF NUMBER OF CONSTRIBUTIONS BY SOURCE :)

declare function qxosmv3:summary_sources_ordered($map)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag]
let $source :=   $total[tag/@k="source"]
let $ct := count($total) 
for  $gp in
(for $t in $source
let $g := $t/tag[@k="source"]/@v
group by $g 
order by count($t) descending
return
(<partial><source>{$g}</source><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};

(: SUMMARY OF SOURCES OF A TYPE :)

declare function qxosmv3:trust_summary_sources_type($map,$type)
{
<result>
<total>{count(db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type])}</total>
{
for $s in qxosmv3:summary_sources_type($map,$type)
return
<row><x>{$s/source/text()}</x><y>{$s/count/text()}</y></row>
}
</result>  
};
 



declare function qxosmv3:summary_sources_type($map,$type)
{

let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
let $source :=   $total[tag/@k="source"]
let $ct := count($total) 
for  $gp in
(for $t in $source
let $g := $t/tag[@k="source"]/@v
group by $g 
return
(<partial><source>{$g}</source><count>{count($t)}</count></partial>))
return
<result>{$gp/*,<total>{$ct}</total>}</result>
};


(: PERCENTAGE OF SOURCES :)

declare function qxosmv3:rating_source($city)
{
  count(
  db:open-pre($city,0)/osm/(node|way|relation)[tag/@k="source"]
  ) div  count(db:open-pre($city,0)/osm/(node|way|relation)[tag]) * 100
};

(: TRUST - CONTRIBUTIONS :)


(: SUMMARY OF CONTRIBUTIONS BY RANGE. LOCAL KNOWNLEDGE :)

declare function qxosmv3:trust_number_contributions($map,$limits)
{
let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag]
return
<result>
<total>{count($total)}</total>
{
let $c := count($limits)  
for $i in 1 to $c - 1
return
<row><x>{$limits[$i]} to {$limits[$i+1]}</x><y>{count(qxosmv3:top_trusted_number_contributions($map,$limits[$i],$limits[$i+1]))}</y></row>
}
</result>
};


declare function qxosmv3:top_trusted_number_contributions($map,$lower,$upper)
{
let $tc := qxosmv3:top_contributers($map,$lower,$upper)
for $x in  db:open-pre($map,0)/osm/(node|way|relation)[tag]
where  $tc/name=data($x/@user)
return $x
};

(: SUMMARY OF NUMBER OF CONTRIBUTIONS OF A TYPE BY RANGE. LOCAL KNOWNLEDGE:)

declare function qxosmv3:trust_number_contributions_type($map,$type,$limits)
{
let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
return
<result>
<total>{count($total)}</total>
{
let $c := count($limits)  
for $i in 1 to $c - 1
return
<row><x>{$limits[$i]} to {$limits[$i+1]}</x><y>{count(qxosmv3:top_trusted_number_contributions_type($map,$type,$limits[$i],$limits[$i+1]))}</y></row>
}
</result>
};


declare function qxosmv3:top_trusted_number_contributions_type($map,$type,$lower,$upper)
{
let $tc := qxosmv3:top_contributers($map,$lower,$upper)
for $x in  db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
where  $tc/name=data($x/@user)
return $x
};




declare function qxosmv3:top_contributers($map,$lower,$upper)
{
let $con :=  
(for $x in db:open-pre($map,0)/osm/(node|way|relation)[@user]
let $y := $x/@user
group by $y
order by count($x) descending
return <result><name>{$y}</name><count>{count($x)}</count></result>)
return $con[$lower <= position() and position()<=$upper]
};

 



 

(: TRUST - CONTRIBUTERS :)

(: SUMMARY OF CONTRIBUTERS IN A RANGE. GLOBAL KNOWNLEDGE :)

declare function qxosmv3:trust_changeset($map,$limits)
{
let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag]
return
<result>
<total>{count($total)}</total>
{
let $c := count($limits)
for $i in 1 to $c - 1
return
<row><x>{$limits[$i]} to {$limits[$i+1]}</x><y>{count(qxosmv3:top_trusted_changeset($map,$limits[$i],$limits[$i+1]))}</y></row>
}
</result>
};


declare function qxosmv3:top_trusted_changeset($map,$lower,$upper)
{
for $x in  db:open-pre($map,0)/osm/(node|way|relation)[tag]
where  qxosmv3:changesetsById(data($x/@uid))>=$lower and 
qxosmv3:changesetsById(data($x/@uid))<=$upper
return $x
};

(: SUMMARY OF CONTRIBUTERS OF A TYPE IN A RANGE. GLOBAL KNOWLEDGE :)

declare function qxosmv3:trust_changeset_type($map,$type,$limits)
{
let $total :=   db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
return
<result>
<total>{count($total)}</total>
{
let $c := count($limits)
for $i in 1 to $c - 1
return
<row><x>{$limits[$i]} to {$limits[$i+1]}</x><y>{count(qxosmv3:top_trusted_changeset_type($map,$type,$limits[$i],$limits[$i+1]))}</y></row>
}
</result>
};



declare function qxosmv3:top_trusted_changeset_type($map,$type,$lower,$upper)
{
for $x in  db:open-pre($map,0)/osm/(node|way|relation)[tag/@k=$type]
where  qxosmv3:changesetsById(data($x/@uid))>=$lower and 
qxosmv3:changesetsById(data($x/@uid))<=$upper
return $x
};

declare function qxosmv3:changesetsById($id)
{
let $add :=concat("https://www.openstreetmap.org/api/0.6/user/",$id)
let $res :=
try 
{xs:double(doc($add)/osm/user/changesets/@count)
}
catch * {0}
return $res
};


(: AVERAGE OF GLOBAL KNOWLEDGE :)

declare function qxosmv3:rate_users_global($city)
{
qxosmv3:ranking_global($city) div qxosmv3:elementTotal($city)
};

declare function qxosmv3:ranking_global($city)
{
let $g :=
(
<local>
{
  for $x in db:open-pre($city,0)/osm/(node|way|relation)[tag] 
let $u := $x/@uid

group by $u 
return <users><user>{$u}</user><count>{count($x)}</count></users>
}
</local>
)
return
sum(
for $i in $g/users
return
$i/count/text()*qxosmv3:changesetsById(data($i/user)))
};

declare function qxosmv3:ranking_global2($city)
{
let $g :=
(
<local>
{
  for $x in db:open-pre($city,0)/osm/(node|way|relation)[tag] 
let $u := $x/@uid

group by $u 
return <users><user>{$u}</user><count>{count($x)}</count></users>
}
</local>
)
return
for $i in $g/users
return
<c>
<u>{$i/user}</u>
<ch>{qxosmv3:changesetsById(data($i/user))}</ch>
</c>
};


(: AVERAGE OF LOCAL KNOWLEDGE :)

declare function qxosmv3:rate_users_local($city)
{
qxosmv3:ranking_local($city) 
};

declare function qxosmv3:ranking_local($city)
{
let $local :=
(
for $x in db:open-pre($city,0)/osm/(node|way|relation)[tag] 
let $u := $x/@user
group by $u 
return <users><user>{$u}</user><count>{count($x)}</count></users>
)
return
sum($local/count) div count($local)
};




(: TABLE GENERATOR :)


declare function qxosmv3:htmlHead($heads, $colspan){
  for $h in $heads
  return
  <th colspan="{$colspan}">{$h}</th>
};

declare function qxosmv3:htmlFunctions($functions){
   for $f in $functions
  return
  <td align="center">{$f}</td>
};

declare function qxosmv3:table($head,$element){
<html>
<body>
<p align="center"><b>QXOSM Analytics</b></p>
<p>
<table border="1" align="center">
<tr>{qxosmv3:htmlHead($head, 0)}</tr>
{for $el in $element
return
<tr>{qxosmv3:htmlFunctions($el/*/text())}</tr>
}
</table>
</p>
</body>
</html>
};


 