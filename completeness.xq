import module namespace qxosmv3 = "qxosmv3" at "qxosmv3.xq";


(: TABLE c1. COMPARISON OF BUILDING HOUSE NUMBER BETWEEN CITIES :) 
 

 
(:
qxosmv3:table(("City","House Number","Building","Rate"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "addr:housenumber"
let $total :=   qxosmv3:tagTotal($city,$key) 
let $tagb := qxosmv3:tagTotal($city,"building")
order by $total div $tagb
return 
<e>
<i>{$city}</i>
<i>{$total}</i>
<i>{$tagb}</i>
<i>{$total div $tagb}</i>
</e>)
:)


(: TABLE c2. COMPARISON OF HIGHWAY NAME BETWEEN CITIES :) 
 

(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "name"
let $type := "highway"
let $value := ("primary","secondary","tertiary")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)


(: TABLE c3. COMPARISON OF HIGHWAY ONEWAY BETWEEN CITIES :) 
 

(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "oneway"
let $type := "highway"
let $value := ("primary","secondary","tertiary")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)


(: TABLE c4. COMPARISON OF HIGHWAY MAXSPEED BETWEEN CITIES :) 
 
(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "maxspeed"
let $type := "highway"
let $value := ("primary","secondary","tertiary")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)


 


(: TABLE c5. COMPARISON OF PUBLIC TRANSPORT NAME BETWEEN CITIES :) 

(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "name"
let $type := "public_transport"
let $value := ("stop_position","stop_area","station")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)


(: TABLE c6. COMPARISON OF AMENITY NAME BETWEEN CITIES :) 
 
(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "name"
let $type := "amenity"
let $value := ("restaurant","bar","cafe")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)

 

(: TABLE c7. COMPARISON OF AMENITY OPENING HOURS BETWEEN CITIES :) 
 
 
(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "opening_hours"
let $type := "amenity"
let $value := ("restaurant","bar","cafe")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)


(: TABLE c8. COMPARISON OF AMENITY PHONE BETWEEN CITIES :) 
 
 
(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "phone"
let $type := "amenity"
let $value := ("restaurant","bar","cafe")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)

(: TABLE c9. COMPARISON OF SHOP NAME BETWEEN CITIES :) 
 
 
(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "name"
let $type := "shop"
let $value := ("convenience","supermarket","clothes","hairdresser","bakery","car_repair","yes")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)

 
(: TABLE c10. COMPARISON OF SHOP OPENING HOURS BETWEEN CITIES :) 

(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "opening_hours"
let $type := "shop"
let $value := ("convenience","supermarket","clothes","hairdresser","bakery","car_repair","yes")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)

(: TABLE c11. COMPARISON OF SHOP PHONE BETWEEN CITIES :) 

(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "phone"
let $type := "shop"
let $value := ("convenience","supermarket","clothes","hairdresser","bakery","car_repair","yes")
let $result :=qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)

(: TABLE c12. COMPARISON OF LEISURE NAME BETWEEN CITIES :) 

(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "name"
let $type := "leisure"
let $value := ("pitch","swimming_pool","park","playground","garden","sports_centre")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)

(: TABLE c13. COMPARISON OF TOURISM NAME BETWEEN CITIES :) 

(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "name"
let $type := "tourism"
let $value := ("information","hotel","attraction","viewpoint","picnic_site","guest_house","camp_site","artwork",
"museum","hostel","motel")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)

 

 

(: TABLE c14. COMPARISON OF RELIGION NAME BETWEEN CITIES :) 

(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "name"
let $type := "religion"
let $value := ("christian", "muslim")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)

(: TABLE c15. COMPARISON OF HISTORIC NAME BETWEEN CITIES :) 

(:
qxosmv3:table(("City","Total","Missing","Percentage"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $key := "name"
let $type := "historic"
let $value := ("memorial", "archaeological_site", "ruins", "yes", "monument", "castle", "building")
let $result := qxosmv3:missing_key_value($city,$key,$value,$type)
order by 
$result/missing/text() div $result/total/text()*100
return 
<e>
<i>{$city}</i>
<i>{$result/total/text()}</i>
<i>{$result/missing/text()}</i>
<i>{$result/missing/text() div $result/total/text()*100}</i>
</e>)
:)