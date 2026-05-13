## Get the relations to all the organisations

On 8 of Mai 2026: 81199 rows


```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT DISTINCT ?person_uri ?organisation_uri ?relationship
WHERE {
        ### subquery adding the distinct clause
        {
        SELECT DISTINCT ?person_uri
        WHERE {
        ?person_uri wdt:P31 wd:Q5; 
              wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?person_uri wdt:P106 wd:Q11063}
            UNION
            {?person_uri wdt:P101 wd:Q333} 
            UNION
            {?person_uri wdt:P106 wd:Q169470}
            UNION
            {?person_uri wdt:P101 wd:Q413}  
            }
        } 

        ### Note the structure of the union clause:
        # we add a type of relation
        {?person_uri wdt:P108 ?organisation_uri.
        BIND('employment' AS ?relationship)
        }   
        UNION
        {?person_uri wdt:P463 ?organisation_uri.
        BIND('membership' AS ?relationship)
        }   
        UNION
        {?person_uri wdt:P69 ?organisation_uri.
        BIND('education' AS ?relationship)
        }  

    }
# LIMIT 100          
```

### Important comment

Note that we already stored the 'employment' relation in the 'import_employer_table'.

For the sake of clarity, and for avoiding errors in the existing code, we create a new table for the challenges 6 and 7: 'import_person_organisation' . Its contents will partly overlap with the already existing table.

* execute the query on Wikidata or [QLever](https://qlever.dev/wikidata)
* download the result as a CSV file: *import_person_organisations.csv*
* import the file into a *import_person_organisations* table into the database using DBeaver





## Get the list of the organisations: English labels

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?organisation_uri (min(?organisation_lab) as ?organisation_label) 
            (min(?country_lab) as ?country_label)
            (min(?org_coord) as ?org_coordinate)
WHERE {
        ### subquery adding the distinct clause
        {
        SELECT DISTINCT ?person_uri
        WHERE {
        ?person_uri wdt:P31 wd:Q5; 
              wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?person_uri wdt:P106 wd:Q11063}
            UNION
            {?person_uri wdt:P101 wd:Q333} 
            UNION
            {?person_uri wdt:P106 wd:Q169470}
            UNION
            {?person_uri wdt:P101 wd:Q413}  
            }
        } 

        ### Note the structure of the union clause:
        # we add a type of relation
        {?person_uri wdt:P108 ?organisation_uri.}   
        UNION
        {?person_uri wdt:P463 ?organisation_uri.}   
        UNION
        {?person_uri wdt:P69 ?organisation_uri.}  

        

        ?organisation_uri rdfs:label ?organisation_lab.
        FILTER(LANG(?organisation_lab) = 'en')

        OPTIONAL {
            ?organisation wdt:P17 ?country.
            ?country rdfs:label ?country_lab.
            FILTER(LANG(?country_lab) = 'en')  
            }
        OPTIONAL {
            ?organisation wdt:P625 ?org_coord.
            }    
    }     
    GROUP BY ?organisation_uri 
# LIMIT 100          
```

* execute the query on Wikidata or [QLever](https://qlever.dev/wikidata)
* download the result as a CSV file and REPLACE the existing file: 'import_organisations.csv'
* delete the existing import_organisations' table in the database using DBeaver
* import the file as a new 'import_organisations' table into the database using DBeaver




## Get the list of the organisations: non-English labels

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?organisation_uri (min(?organisation_lab_al) as ?organisation_label) 
            (min(?country_lab) as ?country_label)
            (min(?org_coord) as ?org_coordinate)
WHERE {
        ### subquery adding the distinct clause
        {
        SELECT DISTINCT ?person_uri
        WHERE {
        ?person_uri wdt:P31 wd:Q5; 
              wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?person_uri wdt:P106 wd:Q11063}
            UNION
            {?person_uri wdt:P101 wd:Q333} 
            UNION
            {?person_uri wdt:P106 wd:Q169470}
            UNION
            {?person_uri wdt:P101 wd:Q413}  
            }
        } 

        ### Note the structure of the union clause:
        # we add a type of relation
        {?person_uri wdt:P108 ?organisation_uri.}   
        UNION
        {?person_uri wdt:P463 ?organisation_uri.}   
        UNION
        {?person_uri wdt:P69 ?organisation_uri.}  

        
        MINUS{?organisation_uri rdfs:label ?organisation_lab.
        FILTER(LANG(?organisation_lab) = 'en')}
		
		?organisation_uri rdfs:label ?organisation_lab_al.

        OPTIONAL {
            ?organisation_uri wdt:P17 ?country.
            ?country rdfs:label ?country_lab.
            FILTER(LANG(?country_lab) = 'en')  
            }
        OPTIONAL {
            ?organisation_uri wdt:P625 ?org_coord.
            }    
    }     
    GROUP BY ?organisation_uri 
# LIMIT 100          
```

* execute the query on Wikidata or [QLever](https://qlever.dev/wikidata)
* download the result as a CSV file : 'import_organisations_non-en_label.csv'
* import the file into the same 'import_organisations' table into the database using DBeaver:
  * command: import data
  * open the CSV then choose as 'target table' the existing one
  * import -> the new data will be at the end of the table




