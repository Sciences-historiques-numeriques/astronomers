




    SELECT DISTINCT ?item ?itemLabel ?itemDescription ?birthYear ?statement ?school ?schoolLabel ?startYear ?startTime ?endTime
    WHERE {

        # physicist, astronomer, astrologer
        {?item  wdt:P106 wd:Q169470} # physicist 32123
        UNION
        {?item  wdt:P106 wd:Q155647}     
        UNION
        {?item  wdt:P106 wd:Q11063}
                        

        #    UNION
        # {?item  wdt:P106 wd:Q901} # scientist
            
        ?item wdt:P31 wd:Q5; # Any instance of a human.
                wdt:P569 ?birthDate;
                # educated at
                p:P69 ?statement.
            ?statement ps:P69 ?school.
        OPTIONAL {
                        ?statement pq:P580 ?startTime;
                        pq:P582 ?endTime.
            }
        
        BIND(REPLACE(str(?startTime), "(.*)([0-9]{4})(.*)", "$2") AS ?startYear)
        
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?birthYear)
        FILTER(?birthYear > '1370' ) # && ?birthYear < '1901')
        SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
        }
    order by ?birthYear ?startYear






