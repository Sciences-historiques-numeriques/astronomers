# Import Birth Places

For this challenge, we need to find the birthplaces for our population, and their geo-coordinates.

Additionally we will explore the place classes.

&nbsp;

## Get birth places of the population with an English label

Get the places with English labels if existing

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT DISTINCT (?item AS ?person_uri) ?birth_place_uri (MIN(?birth_place_label) as ?place_label) 
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
        ### Places without English labels won't be in the result.
        # We use the next query to get them 
        ?birth_place_uri rdfs:label ?birth_place_label.
                FILTER(LANG(?birth_place_label) = 'en')
   
        }
        GROUP BY ?item ?birth_place_uri
```

* execute the SPARQL query and store the result as a CSV file. Address:
  *data/wdt_csv_data/import_person_birth_place.csv*
* import into the database as a new table with this same name

### Get the places with non English names

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT DISTINCT (?item AS ?person_uri) ?birth_place_uri (MIN(?person_name_al) as ?place_label) 
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

    MINUS{?birth_place_uri rdfs:label ?place_label_en.
                  FILTER(LANG(?place_label_en) = 'en') }
          ?birth_place_uri rdfs:label ?person_name_al. 
        
        }
        GROUP BY ?item ?birth_place_uri


```

* execute the SPARQL query and store the result as a CSV file:
 * data/wdt_csv_data/import_person_birth_place_non_en.csv*
* import into the database BY ADDING these rows to the ALREADY EXISTING the table *import_person_birth_place*

### Get the places' geo-coordinates

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT ?birth_place_uri (MIN(?coordinates) as ?long_lat)
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
        }
   
       ?birth_place_uri wdt:P625 ?coordinates.
   
        }
GROUP BY ?birth_place_uri
```

* export the data to as CSV file:
  data/wdt_csv_data/import_birth_places_coordinates.csv
* import into the SQlite database as a new table:
  *import_birth_places_coordinates*
* inspect the new tables with the SQL code in the [da2-birth-places.sql file](da2-birth-places.sql).
  * open the file in DBeaver
  * activate a connection to the database
  * run the different queries

## Export the data for analysis in the Python notebook

Cf. the file **[da2-birth-places.sql](da2-birth-places.sql)** -> Query for analysis in notebook: persons and birth places

Export the result file into a CSV file to be analysed: 

&nbsp;

## Explore the place type taxonomy

OPTIONAL

### Get the 'classes' of the places

We import the 'classes' the places belong to, i.e. their types according to Wikidata

```sparql
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT DISTINCT ?birth_place_uri ?birth_place_label  ?place_class_uri ?place_class_label
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
   OPTIONAL {?birth_place_uri rdfs:label ?birth_place_label.
                FILTER(LANG(?birth_place_label) = 'en')
                }
   ?birth_place_uri wdt:P31 ?place_class_uri.
   ?place_class_uri rdfs:label ?place_class_label .
	FILTER(LANG(?place_class_label) = 'en')
      }  
```

We take in this query also the classes of the classes at two levels.

The aim is to explore the Wikidata place taxonomy.

```sparql
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT DISTINCT ?place_class_uri ?place_class_label 
?place_class_of_class_uri ?place_class_of_class_label
?place_class_of_class_lev2_label ?place_class_of_class_lev2_uri
WHERE {

    {
      SELECT DISTINCT ?place_class_uri ?place_class_label 
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
        ?birth_place_uri wdt:P31 ?place_class_uri.
        ?place_class_uri rdfs:label ?place_class_label .
        FILTER(LANG(?place_class_of_class_label) = 'en')
      }
      LIMIT 100
    }

   # wdt:P279 = subclass of
   ?place_class_uri wdt:P279 ?place_class_of_class_uri.
	?place_class_of_class_uri rdfs:label ?place_class_of_class_label .
	FILTER(LANG(?place_class_of_class_label) = 'en')

   # wdt:P279 subclass of
    ?place_class_of_class_uri wdt:P279 ?place_class_of_class_lev2_uri.
	?place_class_of_class_lev2_uri rdfs:label ?place_class_of_class_lev2_label .
	FILTER(LANG(?place_class_of_class_lev2_label) = 'en')

      }

```

```
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT ?birth_place_uri 
(GROUP_CONCAT(DISTINCT ?place_class_label; separator=", ") AS ?place_class_labels)
?place_class_of_class_lev2_label ?place_class_of_class_lev2_uri
WHERE {

{SELECT DISTINCT ?birth_place_uri ?place_class_uri ?place_class_label
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
% 
   ?item wdt:P19 ?birth_place_uri.
   ?birth_place_uri wdt:P31 ?place_class_uri.
   ?place_class_uri rdfs:label ?place_class_label .
	FILTER(LANG(?place_class_label) = 'en')
      }
    }

   

   OPTIONAL {
    # wdt:P279 subclass of
    ?place_class_uri wdt:P279 / wdt:P279 ?place_class_of_class_lev2_uri.
	?place_class_of_class_lev2_uri rdfs:label ?place_class_of_class_lev2_label .
	FILTER(LANG(?place_class_of_class_lev2_label) = 'en')
   }
  

    }
	GROUP BY ?birth_place_uri ?place_class_of_class_lev2_uri ?place_class_of_class_lev2_label
```

* export the data to as CSV file:
  data/wdt_csv_data/import_birth_places_classes.csv
* import into the SQlite database as a new table:
  *import_birth_places_classes*
* inspect the new tables with the SQL code in the [da2-birth-places.sql file](da2-birth-places.sql)
