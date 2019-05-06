import module namespace qxosmv3 = "qxosmv3" at "qxosmv3.xq";

(: TABLE SUMMARY :)

qxosmv3:table(("City","Number of Elements","Number of Nodes","Number of Ways","Number of Relations",
 "Total Contributions","Number of Contributers"),
for $city in ("Almeria","Barcelona","Bilbao","Granada",
"Madrid","Oviedo","Santander","Segovia","Sevilla","Valencia","Vigo","Zaragoza")
let $et := qxosmv3:elementTotal($city)
let $nt := qxosmv3:nodeTotal($city)
let $wt := qxosmv3:wayTotal($city)
let $rt := qxosmv3:relationTotal($city)
let $tc := qxosmv3:total-contributions($city)
let $nc := qxosmv3:number-of-contributers($city)
return
<e>
<i>{$city}</i>
<i>{$et}</i>
<i>{$nt}</i>
<i>{$wt}</i>
<i>{$rt}</i>
<i>{$tc}</i>
<i>{$nc}</i>
</e>)
