
# Définition de la population

## Compter la population définie

    SELECT (COUNT(?item) as ?eff)
        WHERE {
            {
            {?item wdt:P106 wd:Q169470}
            UNION
            {?item wdt:P101 wd:Q413}  
          UNION 
          {?item wdt:P106 wd:Q11063}
            UNION
            {?item wdt:P101 wd:Q333} 
            UNION
              {?item wdt:P106 wd:Q155647}
            UNION
            {?item wdt:P101 wd:Q34362} 
              }
          
          ?item wdt:P31 wd:Q5;  # Any instance of a human.
              wdt:P569 ?birthDate;
                wdt:P21 ?gender.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1350 )
        } 








## School


    select ?item ?itemLabel ?birthYear ?statement ?school ?schoolLabel ?startYear ?startTime ?endTime
    where {
           
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
      FILTER(?birthYear > '1450' )# && ?birthYear < '1901')
     SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
    }
    order by ?birthYear ?startYear




## Chercher les astronomes dans Wikidata

    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

    select distinct ?item ?itemLabel ?itemDescription ?birthDate ?year ?birthPlace ?birthPlaceLabel
    where {
        ?item wdt:P31 wd:Q5;  # Any instance of a human.
            wdt:P106 wd:Q11063;
            wdt:P569 ?birthDate;
            wdt:P19 ?birthPlace.
    #    ?birthPlace wdt:P31 ?birthPlaceType.
    #   filter not exists {?birthPlace a wdno:P6}.

    BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
    FILTER(?year > '1400' && ?year < '1760')
    ### Filtrage sur les années comme entiers si souhaité
    # FILTER(xsd:integer(?year) < "890"^^xsd:integer)
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en,nl" }
    }

    ORDER BY ?year

    LIMIT 500 





### Les 'assertions' (statements)

    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

    select distinct ?item ?itemLabel ?itemDescription ?p ?o
    where {
        ?item wdt:P31 wd:Q5;  # Any instance of a human.
            p:P106 ?statement.
            ?statement ps:P106 wd:Q11063;
                    ?p ?o.
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en,nl" }
    }
    LIMIT 100 

## Découper par tranches de un siècle

### Effectifs

| Période   | Effectif |
| --------- | -------- |
| 1351-1600 | 884      |
| 1601-1800 | 2292     |
| 1801-1900 | 6111     |
| 1901-     | 25849    |


### Compter

        select (count(*) as ?eff)
        where {
            #  wdt:P106 wd:Q413 # physics 2
            #  wdt:P106 wd:Q155647  # astrologer 1364
            #  wdt:P106 wd:Q11063  # astronomer 10162
            #  wdt:P106 wd:Q170790  # mathematician 39562    
            {?item  wdt:P106 wd:Q169470} # physicist 32123
            UNION
            {?item  wdt:P106 wd:Q155647}     
            UNION
            {?item  wdt:P106 wd:Q11063}
                            

            #    UNION
            # {?item  wdt:P106 wd:Q901} # scientist
                
            ?item wdt:P31 wd:Q5; # Any instance of a human.
                    wdt:P569 ?birthDate.
               
                BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(?year > '1700' && ?year < '1801')
            }

### Lister les propriétés sortantes

    SELECT ?p ?propLabel ?eff
        WHERE {
        {
        select ?p  (count(*) as ?eff)
        where {
                
            {?item  wdt:P106 wd:Q169470} # physicist 32123
            UNION
            {?item  wdt:P106 wd:Q155647}     
            UNION
            {?item  wdt:P106 wd:Q11063}
                            

            #    UNION
            # {?item  wdt:P106 wd:Q901} # scientist
                
            ?item wdt:P31 wd:Q5; # Any instance of a human.
                    wdt:P569 ?birthDate.
            ?item  ?p ?o.

                BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(?year > '1700' && ?year < '1721')
            }
        GROUP BY ?p 
        
            }

        SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
        
        ?prop wikibase:directClaim ?p .
         
            
        }  
        ORDER BY DESC(?eff)

