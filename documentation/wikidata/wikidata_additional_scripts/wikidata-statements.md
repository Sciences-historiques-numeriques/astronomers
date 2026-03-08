



### Membership with role

```
PREFIX wd: <http://www.wikidata.org/entity/>


select ?s ?sLabel ?o1 ?o1Label ?o2 ?o2Label

   where {?s  wdt:P31 wd:Q5;
       # membership
      p:P463 ?st1.
        # organisation
        ?st1 ps:P463 ?o1;
        # role  
             pq:P2868 ?o2
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
   }
LIMIT 100
```


### Role with employer

```
PREFIX wd: <http://www.wikidata.org/entity/>


select ?s ?sLabel ?o1 ?o1Label ?o2 ?o2Label

   where {?s  wdt:P31 wd:Q5;
      # subject has role
      p:P2868 ?st1.
        ?st1 ps:P2868 ?o1;
        # employer
             pq:P108 ?o2
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
   }
LIMIT 100
```


### Role with organisation directed by the person

```
PREFIX wd: <http://www.wikidata.org/entity/>


select ?s ?sLabel ?o1 ?o1Label ?o2 ?o2Label

   where {?s  wdt:P31 wd:Q5;
      # subject has role
      p:P2868 ?st1.
        ?st1 ps:P2868 ?o1;
        # organisation directed by office or position
             pq:P2389 ?o2
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
   }
LIMIT 100
```











## Exemple de requête concernant les appartenances à une organisation, avec dates optionnelles si connues


On doit dans cette requête sortir du cadre classique de la simple propriété 'member of' et passer à travers l'assertion, le *statement*. Un statement de _Wikidata_ apparait en quelques sortes comme une entité temporelle même si elle n'associe que deux entités principales, comme une propriété.

```
    SELECT DISTINCT ?item ?itemLabel ?birthYear ?statement ?organization ?organizationLabel 
                    ?startYear ?endYear  ?startTime ?endTime
    where {
            
        {?item wdt:P106 wd:Q11063}
                UNION
                {?item wdt:P101 wd:Q333}
            
        ?item wdt:P31 wd:Q5; # Any instance of a human.
                wdt:P569 ?birthDate;
                # member of
                p:P463 ?statement.
            ?statement ps:P463 ?organization.
        OPTIONAL {
                        ?statement pq:P580 ?startTime;
                        pq:P582 ?endTime.
            }
        
        BIND(REPLACE(str(?startTime), "(.*)([0-9]{4})(.*)", "$2") AS ?startYear)
        BIND(REPLACE(str(?endTime), "(.*)([0-9]{4})(.*)", "$2") AS ?endYear)
        
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?birthYear)
        FILTER(xsd:integer(?birthYear) > 1780 && xsd:integer(?birthYear) < 1881)
            
        SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
        }
    ORDER BY ?birthYear ?startYear
```

### Autre exemple

```
     SELECT DISTINCT ?item ?itemLabel ?birthYear ?statement ?organization ?organizationLabel 
                    ?startYear ?endYear  ?startTime ?endTime
    where {
            
        {?item wdt:P106 wd:Q11063}
                UNION
                {?item wdt:P101 wd:Q333}
            
        ?item wdt:P31 wd:Q5; # Any instance of a human.
                wdt:P569 ?birthDate;
                # member of
                # p:P463 ?statement.
                # ?statement ps:P463 ?organization.
                # educated at
                p:P69 ?statement.
                ?statement ps:P69 ?organization.
              # employer
                #p:P108 ?statement.
                #?statement ps:P108 ?organization.
      #  OPTIONAL
      {
                        ?statement pq:P580 ?startTime;
                        pq:P582 ?endTime.
            }
        
        BIND(REPLACE(str(?startTime), "(.*)([0-9]{4})(.*)", "$2") AS ?startYear)
        BIND(REPLACE(str(?endTime), "(.*)([0-9]{4})(.*)", "$2") AS ?endYear)
        
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?birthYear)
        FILTER(xsd:integer(?birthYear) > 1800 && xsd:integer(?birthYear) < 1901)
            
        SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
        }
    ORDER BY ?item
    
```


```
PREFIX wd: <http://www.wikidata.org/entity/>


select ?p ?propLabel (count(*) as ?number)

   where {?s  wdt:P31 wd:Q5;
      p:P463 ?st1.
        ?st1 ?p ?o.
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
  ?prop wikibase:directClaim ?p .
   }
group by ?p ?propLabel
order by desc(?number)

```
