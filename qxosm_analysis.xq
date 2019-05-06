import module namespace qxosmv3 = "qxosmv3" at "qxosmv3.xq";

(: SUMMARY :)

(:qxosmv3:summary("Almeria"):)

(:qxosmv3:summary_type("Almeria",("building","highway","amenity","natural","shop")):)

(:qxosmv3:summary_edition_avg("Almeria",("building","highway","amenity","natural","mierda")):)

(: COMPLETENESS :)

(:qxosmv3:comp_missing_keys("Almeria",("name","oneway","maxspeed","source"),"highway"):)

(:qxosmv3:comp_missing_key_values("Almeria",("name","oneway","maxspeed","source"),("primary","secondary","tertiary"),"highway"):)

(:qxosmv3:comp_missing_types_key("Almeria","name",("building","highway","amenity","natural","shop")):)

(: COMPLIANCE - KEY UNKNOWN :)

(:qxosmv3:compli_some_key_unknown("Almeria",(10,20,50,100,200,300,400)):)

(:qxosmv3:compli_some_key_unknown_type("Almeria","building",(10,20,50,100,200,300,400)):)

(:qxosmv3:compli_some_key_unknown_type_values("Almeria","highway",("primary","secondary","tertiary"),(10,20,50,100,200,300,400)):)

(: COMPLIANCE - WRONG COMBINATION :)

(:qxosmv3:compli_wrong_combination_keys("Almeria","building",(10,20,50,100,200,300,400)):)

(:
qxosmv3:compli_wrong_combination_keys_values("Almeria","highway",("primary","secondary","tertiary"),(10,20,50,100,200,300,400))
:)

(: GRANULARITY :)

(:qxosmv3:gra_summary_key("Almeria","building"):)

(: LOGIC CONSISTENCE :)

(:qxosmv3:log_summary_key_value("Almeria","highway","primary"):)

(: RICHNESS :)

(:qxosmv3:rich_summary_values("Almeria","building"):)

(: TRUST - VERSIONS  :)

(:qxosmv3:trust_summary_versions("Almeria","highway"):)

(: TRUST - TAGS :)

(:qxosmv3:trust_summary_tags("Almeria",5):)

(: TRUST - USERS :)

(:qxosmv3:trust_summary_users_type("Almeria","building"):)

qxosmv3:trust_summary_users("Almeria")

(: TRUST - DATES :)

(:qxosmv3:trust_summary_dates_type("Almeria","building"):)

(:qxosmv3:trust_summary_dates("Almeria"):)

(: TRUST - SOURCES :)

(:qxosmv3:trust_summary_sources_type("Almeria","building"):)

(:qxosmv3:trust_summary_sources_type("Granada","building"):)

(:TRUST - CONTRIBUTIONS :)

(:qxosmv3:trust_number_contributions_type("Almeria","building",(0,5,10,20,50)):)

(:qxosmv3:trust_number_contributions("Almeria",(0,5,10,20,50)):)

(: TRUST - CONTRIBUTERS :)

(:qxosmv3:trust_changeset_type("Almeria","building",(0,10,100,1000,10000)):)

(:qxosmv3:trust_changeset("Almeria",(0,10,100,1000,10000)):)