import module namespace qxosmv3 = "qxosmv3" at "qxosmv3.xq";


(: TABLE cp1. KEY UNKNOWN. COMPARISON BETWEEN CITIES :) 
 
(:
qxosmv3:table(("City","Total","Rare Key","Percentage"),
for $city in  ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $result := qxosmv3:some_key_unknown($city,1,300)
order by xs:float($result/missing/text() div $result/total/text() * 100)  
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text() * 100 }</i>
</e>
)
:) 

 

 

(: TABLE cp2. WRONG COMBINATION OF KEYS IN HIGHWAY. COMPARISON BETWEEN CITIES :)

(:
qxosmv3:table(("City","Total","Unusual","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $result := qxosmv3:wrong_combination_keys($city,"highway",1,300)
order by xs:float($result/missing/text() div $result/total/text() * 100)  
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text() * 100}</i>
</e>)
:)


(: TABLE cp3. WRONG COMBINATION OF KEYS IN SHOP. COMPARISON BETWEEN CITIES :)

(:
qxosmv3:table(("City","Total","Unusual","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $result := qxosmv3:wrong_combination_keys($city,"shop",1,300)
order by xs:float($result/missing/text() div $result/total/text() * 100)  
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text() * 100}</i>
</e>)
:)
 
 
(: TABLE cp4. WRONG COMBINATION OF KEYS IN TOURISM. COMPARISON BETWEEN CITIES :)

(:
qxosmv3:table(("City","Total","Unusual","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $result := qxosmv3:wrong_combination_keys($city,"tourism",1,300)
order by xs:float($result/missing/text() div $result/total/text() * 100)  
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text() * 100}</i>
</e>)
:)
  