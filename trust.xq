import module namespace qxosmv3 = "qxosmv3" at "qxosmv3.xq";


(: TRUST :)
 
 (:
 qxosmv3:table(("City","Version Average","Provenance","Local Experience","Global Experience"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $s1 :=  qxosmv3:average_versions($city)
let $s2 := qxosmv3:rating_source($city)
let $s3 := qxosmv3:rate_users_local($city)
let $s4 := qxosmv3:rate_users_global($city)
return
<e>
<i>{$city}</i>
<i>{$s1}</i>
<i>{$s2}</i>
<i>{$s3}</i>
<i>{$s4}</i>
</e>
)
:)

 qxosmv3:ranking_global2("Almeria")
 