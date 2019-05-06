import module namespace qxosmv3 = "qxosmv3" at "qxosmv3.xq";



(: TABLE con1 . CONSISTENCE OF HIGHWAY :)



(:
qxosmv3:table(("City","Primary","Secondary","Tertiary","Average"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $type := "highway"
let $s1 := qxosmv3:standard_deviation_key($city,$type,"primary")
let $s2 := qxosmv3:standard_deviation_key($city,$type,"secondary")
let $s3 := qxosmv3:standard_deviation_key($city,$type,"tertiary")
return
<e>
<c>{$city}</c>
<p>{$s1}</p>
<s>{$s2}</s>
<t>{$s3}</t>
<t>{avg(($s1,$s2,$s3))}</t>
</e>
)
:)


(: TABLE con2 . CONSISTENCE OF SHOP :)



(:
qxosmv3:table(("City","Convenience","Supermarket","Clothes","Average"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $type := "shop"
let $s1 := qxosmv3:standard_deviation_key($city,$type,"convenience")
let $s2 := qxosmv3:standard_deviation_key($city,$type,"supermarket")
let $s3 := qxosmv3:standard_deviation_key($city,$type,"clothes")
return
<e>
<c>{$city}</c>
<p>{$s1}</p>
<s>{$s2}</s>
<t>{$s3}</t>
<t>{avg(($s1,$s2,$s3))}</t>
</e>
)
:)

(: TABLE con3 . CONSISTENCE OF TOURISM :)



(:
qxosmv3:table(("City","Information","Hotel","Attraction","Average"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $type := "tourism"
let $s1 := qxosmv3:standard_deviation_key($city,$type,"information")
let $s2 := qxosmv3:standard_deviation_key($city,$type,"hotel")
let $s3 := qxosmv3:standard_deviation_key($city,$type,"attraction")
return
<e>
<c>{$city}</c>
<p>{$s1}</p>
<s>{$s2}</s>
<t>{$s3}</t>
<t>{avg(($s1,$s2,$s3))}</t>
</e>
)
:)


(: TABLE gra1. GRANULARITY OF A BUILDING. :)



(:
qxosmv3:table(("City","Average","Median"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $type := "building"
let $s1 := qxosmv3:average_key($city,$type)
let $s2 := qxosmv3:median($city,$type)
return
<e>
<c>{$city}</c>
<a>{$s1}</a>
<m>{$s2}</m>
</e>)
:)

(: TABLE gra2. GRANULARITY OF A SHOP. :)



(:
qxosmv3:table(("City","Average","Median"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $type := "shop"
let $s1 := qxosmv3:average_key($city,$type)
let $s2 := qxosmv3:median($city,$type)
return
<e>
<c>{$city}</c>
<a>{$s1}</a>
<m>{$s2}</m>
</e>)
:)


(: TABLE gra3. GRANULARITY OF A TOURISM. :)



(:
qxosmv3:table(("City","Average","Median"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $type := "tourism"
let $s1 := qxosmv3:average_key($city,$type)
let $s2 := qxosmv3:median($city,$type)
return
<e>
<c>{$city}</c>
<a>{$s1}</a>
<m>{$s2}</m>
</e>)
:)

(: TABLE rich1. RICHNESS OF BUILDING :)

(:
qxosmv3:table(("City","Richness","Score"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $type := "building"
let $r := qxosmv3:richness_type($city,$type)
return
<e>
<c>{$city}</c>
<r>{$r}</r>
<s>{$r div 53 * 100}</s>
</e>)
:)

(: TABLE rich2. RICHNESS OF SHOP :)

(:
qxosmv3:table(("City","Richness","Score"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $type := "shop"
let $r := qxosmv3:richness_type($city,$type)
return
<e>
<c>{$city}</c>
<r>{$r}</r>
<s>{$r div 186 * 100}</s>
</e>)
:)


(: TABLE rich3. RICHNESS OF TOURISM :)

(:
qxosmv3:table(("City","Richness","Score"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $type := "tourism"
let $r := qxosmv3:richness_type($city,$type)
return
<e>
<c>{$city}</c>
<r>{$r}</r>
<s>{$r div 36 * 100}</s>
</e>)
:)