# Import Birth Places


## Get all birth places of our population

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT DISTINCT (?item AS ?person_uri) ?birth_place_uri
#SELECT (COUNT(*) AS ?n)
WHERE {
            {?item wdt:P106 wd:Q11063}  # astronomer
            UNION
            {?item wdt:P101 wd:Q333}     # astronomy
            UNION
            {?item wdt:P106 wd:Q169470}  # physicist
            UNION
            {?item wdt:P101 wd:Q413}     # physics   
  
            ?item wdt:P31 wd:Q5;  # Any instance of a human.
                wdt:P569 ?birthDate; # It must necessarily have a birth date property
        BIND(year(?birthDate) as ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981 )
       
       ?item wdt:P19 ?birth_place_uri.
       
        }
```

* execute the SPARQL query and store the result as a CSV: 
data/wdt_csv_data/person_birth_place_import.csv
* import into the database as a new table with this same name


### Get the places with English labels, class and coordinates

You must execute this query on the QLever SPARQL-endpoint, it won't work on Wikidata because of timeout


```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT ?birth_place_uri (MIN(?birth_place_label) as ?place_label) (MIN(?coordinates) as ?long_lat) ?place_class_label ?place_class_uri
#SELECT (COUNT(*) AS ?n)
WHERE {  
       {SELECT DISTINCT ?birth_place_uri
        WHERE {                
            {?item wdt:P106 wd:Q11063}  # astronomer
            UNION
            {?item wdt:P101 wd:Q333}     # astronomy
            UNION
            {?item wdt:P106 wd:Q169470}  # physicist
            UNION
            {?item wdt:P101 wd:Q413}     # physics   
  
            ?item wdt:P31 wd:Q5;  # Any instance of a human.
                wdt:P569 ?birthDate; # It must necessarily have a birth date property
        BIND(year(?birthDate) as ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981 )
       
       ?item wdt:P19 ?birth_place_uri.
          }
        ORDER BY ?birth_place_uri
       
        }

       OPTIONAL {?birth_place_uri rdfs:label ?birth_place_label.
       FILTER(LANG(?birth_place_label) = 'en')
                }
       ?birth_place_uri wdt:P625 ?coordinates.
       ?birth_place_uri wdt:P31 ?place_class_uri.
       ?place_class_uri rdfs:label ?place_class_label.
       FILTER(LANG(?place_class_label) = 'en')
       
        }
GROUP BY ?birth_place_uri ?place_class_label ?place_class_uri  

```

* export the data to as CSV file:
data/wdt_csv_data/birth_places_import.csv
* import into the SQlite database as a new table:
*birth_places_import*

* inspect the new tables with the SQL code in the [da2-birth-places.sql file](da2-birth-places.sql).
  * open the file in DBeaver
  * activate a connection to the database
  * run the different queries
