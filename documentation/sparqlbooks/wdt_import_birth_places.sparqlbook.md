# Import Birth Places

In this notebook we add to the imported Wikidata population properties regarding their birth place, notably geographical places with geocoordinates.



Management note: This notebook is the master file, the MD esport is this file [Import Birth Places](../wikidata/data-production/wdt_import_birth_places.md)



```sparql
### Number of persons in our population
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?s a wd:Q5.}
}

```

```sparql
### Number of birth places per 10000 persons
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        #ORDER BY ?item      
        #OFFSET 10000
        # LIMIT 10000
        LIMIT 10000

        }

         SERVICE <https://query.wikidata.org/sparql>
            {
                ### place of birth
                ?item wdt:P19 ?birthPlace.
                #SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
                ?birthPlace rdfs:label ?itemLabel.
                FILTER(LANG(?itemLabel) = 'en')  
            }
}

```

```sparql
### Prepare and inspect the data to be imported


PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX sdh: <https://sdhss.org/ontology/core/>

CONSTRUCT {?item wdt:P19 ?birthPlace.
            ?birthPlace rdfs:label ?birthPlaceLabel;

            ## we add this class from the SDHSS ontology
                        rdf:type sdh:C13}
WHERE
    {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>

        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        LIMIT 10

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ### place of birth
                ?item wdt:P19 ?birthPlace.
                OPTIONAL {
                    ?birthPlace rdfs:label ?birthPlaceLabel.
                    FILTER(LANG(?birthPlaceLabel) = 'en')
                            }
            }
                
        }
```

```sparql
## By this number of persons, you have to carry out the query in three steps. The accepted limit by Wikidata 
## of instances in a variable ('item' in our case) appears to be 10000.
## You therefore have to have three steps for a population of around 23000 persons  

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


WITH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
INSERT {?item wdt:P19 ?birthPlace.
            ?birthPlace rdfs:label ?birthPlaceLabel;
                        rdf:type sdh:C13.}
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        #OFFSET 10000
        #OFFSET 20000
        #OFFSET 30000
        LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ### place of birth
                ?item wdt:P19 ?birthPlace.
                OPTIONAL {
                    ?birthPlace rdfs:label ?birthPlaceLabel.
                    FILTER(LANG(?birthPlaceLabel) = 'en')
                            }
            }
                
        }
```
### Add property/class label and inspect data

```sparql
### Insert the label of the property
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


INSERT DATA {
  GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
  {wdt:P19 rdfs:label 'place of birth'.}
}
```

```sparql
### Get the number of created 'birth places'
# 22469

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


    SELECT (COUNT(*) as ?n) 
    WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
            {
                ?s wdt:P19 ?place.
            }
            }
    
```
Comment: Missing birth places

* We observe that around a third of the population doesn't have a birth place in Wikidata
* We could try to get the places from a different source: DBpedia, library catalogs...

```sparql
### Get the number of created 'places'
# 8728
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX sdh: <https://sdhss.org/ontology/core/>


    SELECT (COUNT(*) as ?n) 
    WHERE {
        SELECT DISTINCT ?place
        WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
            {
                ?place a sdh:C13.
            }
            }
    }
    
```

```sparql
### Get the number of created 'places' without a label
# now 13 but this is because labels in other languages 
# were added to 131 places without English label.
# After import : 136 places without label 
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX sdh: <https://sdhss.org/ontology/core/>


    SELECT (COUNT(*) as ?n) 
    WHERE {
        SELECT DISTINCT ?place
        WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
            {
                ?place a sdh:C13.
                MINUS{ ?place rdfs:label ?label }
            }
            }
    }
    
```

```sparql
### Get the missing labels in languages other than English
# 
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX sdh: <https://sdhss.org/ontology/core/>

SELECT DISTINCT  ?place (MIN(?placeLabel) AS ?mPlaceLabel)
    WHERE {
        {
        SELECT DISTINCT ?place
        WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
            {
                ?place a sdh:C13.
                MINUS{ ?place rdfs:label ?label }
            }
            }
        LIMIT 10
    } 
    
    SERVICE <https://query.wikidata.org/sparql>
            {
                ### place of birth
                ?place rdfs:label ?placeLabel.
                FILTER(LANG(?placeLabel) != 'en')              
                }
    }    
    GROUP BY ?place
    
```

```sparql

## Add the missing labels.

# We take only the first one in alphabetical order


PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


WITH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
INSERT {?place rdfs:label ?mPlaceLabel}
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT DISTINCT  ?place (MIN(?placeLabel) AS ?mPlaceLabel)
    WHERE {
        {
        SELECT DISTINCT ?place
        WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
            {
                ?place a sdh:C13.
                MINUS{ ?place rdfs:label ?label }
            }
            }
        #LIMIT 10
    } 
    
    SERVICE <https://query.wikidata.org/sparql>
            {
                ### place of birth
                ?place rdfs:label ?placeLabel.
                FILTER(LANG(?placeLabel) != 'en')              
                }
    }    
    GROUP BY ?place}    
                
        }
```

```sparql
### Inspect the places without a label
# In fact it appears that the problem is in Wikidata

PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


    SELECT ?s ?place
    WHERE {
        SELECT DISTINCT ?s ?place
        WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
            {
                ?s wdt:P19 ?place.
                MINUS{ ?place rdfs:label ?label }
            }
            }
    }
    
```

```sparql
### Get the number of created 'places' with a label
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX sdh: <https://sdhss.org/ontology/core/>


    SELECT (COUNT(*) as ?n) 
    WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
            {
                ?geogPlace rdf:type sdh:C13;
                        rdfs:label ?placeLabel.
            }
            }
    
```

```sparql
### Get the created 'places' with more than one label
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX sdh: <https://sdhss.org/ontology/core/>


    SELECT ?geogPlace (COUNT(*) as ?n) (GROUP_CONCAT(DISTINCT ?placeLabel; separator=" | ") AS ?placeLabels) 
    WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
            {
                ?geogPlace rdf:type sdh:C13;
                        rdfs:label ?placeLabel.
            }
            }
    GROUP BY ?geogPlace
    HAVING (COUNT(*) > 1)
    ORDER BY DESC(?n)
    LIMIT 10
    
```

```sparql
### Insert the label of the Geographical Place class
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX sdh: <https://sdhss.org/ontology/core/>


INSERT DATA {
  GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
  {sdh:C13 rdfs:label 'Geographical Place'.}
}
```

```sparql
### Inspect your data
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT DISTINCT ?item ?birthPlace ?birthPlaceLabel
WHERE { 
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
    {?item wdt:P19 ?birthPlace.
            ?birthPlace rdfs:label ?birthPlaceLabel;
                        rdf:type sdh:C13.}}
OFFSET 500
LIMIT 5


```
### Persons without birthplace



```sparql
### Inspect

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT DISTINCT *
WHERE { 
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
    {?item a wd:Q5;
     rdfs:label ?persLabel.
     MINUS {?item wdt:P19 ?birthPlace}}
     }
ORDER BY ?item
OFFSET 100 
LIMIT 5


```

```sparql
# count: 10872
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT (count(*) as ?number)
WHERE { 
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
    {?item a wd:Q5;
     rdfs:label ?persLabel.
     MINUS {?item wdt:P19 ?birthPlace}}
     }



```
### Persons with multiple birth places

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT ?item ?persLabel (count(*) as ?n) (GROUP_CONCAT(DISTINCT ?birthPlaceLabel; separator=" | ") AS ?birthPlaces) 
WHERE { 
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
    {?item a wd:Q5;
           rdfs:label ?persLabel;
        wdt:P19 ?birthPlace.
     ?birthPlace rdfs:label ?birthPlaceLabel}
     }
GROUP BY ?item ?persLabel
HAVING (count(*) > 1)
ORDER BY DESC(?n)
# OFFSET 5
LIMIT 5


```
### Find and import place types

```sparql
### Number of persons in our population
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT ?place ?placeLabel ?pseudoClass ?pseudoClassLabel # (COUNT(*) as ?n)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {SELECT ?place ?placeLabel
        WHERE 
                {?place rdf:type sdh:C13;
                       rdfs:label  ?placeLabel}
        #ORDER BY ?item      
        #OFFSET 10000
        #LIMIT 10

        }

         SERVICE <https://query.wikidata.org/sparql>
            {
                ### property: instance of (equivalent to rdf:type)
                ?place wdt:P31 ?pseudoClass.
                BIND (?pseudoClassLabel as ?pseudoClassLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
        FILTER(CONTAINS(?pseudoClassLabel, 'country'))    
}
limit 10


```

```sparql
### Prepare and inspect the data to be imported


PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX sdh: <https://sdhss.org/ontology/core/>

CONSTRUCT {?place wdt:P31 ?placeClass.
            ?placeClass rdfs:label ?placeClassLabel}
WHERE
    {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>

        ## Find the persons in the imported graph
        {SELECT ?place
        WHERE 
                {?place rdf:type sdh:C13}
        ORDER BY ?place      
        OFFSET 0
        #OFFSET 10000
        LIMIT 20

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                 ### property: instance of
                ?place wdt:P31 ?placeClass.
                BIND (?placeClassLabel as ?placeClassLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
```

```sparql
### Insert the data


PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX sdh: <https://sdhss.org/ontology/core/>

WITH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
INSERT {?place wdt:P31 ?placeClass.
            ?placeClass rdfs:label ?placeClassLabel}
WHERE
    {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>

        ## Find the persons in the imported graph
        {SELECT ?place
        WHERE 
                {?place rdf:type sdh:C13}
        ORDER BY ?place      
        #OFFSET 0
        #OFFSET 10000
        #LIMIT 20

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                 ### property: instance of
                ?place wdt:P31 ?placeClass.
                BIND (?placeClassLabel as ?placeClassLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
```

```sparql
### Number of classes
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT ?placeClass ?placeClassLabel (COUNT(*) as ?n)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?place rdf:type sdh:C13;
                       wdt:P31 ?placeClass.
                ?placeClass rdfs:label ?placeClassLabel
       }
        
}
GROUP BY ?placeClass ?placeClassLabel
ORDER BY DESC(?n)
LIMIT 5

```

```sparql
### Places without classes
# The issue is in Wikidata 
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT ?place ?placeLabel
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?place rdf:type sdh:C13.
        ?place rdfs:label ?placeLabel.
        MINUS{?place wdt:P31 ?placeClass.}
       }
        
}
LIMIT 5

```

```sparql
### Places without classes
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT (COUNT(*) AS ?n)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?place rdf:type sdh:C13.
        ?place rdfs:label ?placeLabel.
        MINUS{?place wdt:P31 ?placeClass.}
       }
        
}

```
### Get the geographical coordinates

```sparql
### Inspect the available data
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT ?place ?placeLabel ?coordinates
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {SELECT ?place ?placeLabel
        WHERE 
                {?place rdf:type sdh:C13;
                       rdfs:label  ?placeLabel}
        #ORDER BY ?item      
        #OFFSET 10000
        #LIMIT 10

        }

         SERVICE <https://query.wikidata.org/sparql>
            {
                ### coordinate location
                ?place wdt:P625 ?coordinates.
            }
}
ORDER BY ?place
LIMIT 5
```

```sparql
### Inspect the available data
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT (COUNT(*) AS ?n)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {SELECT DISTINCT ?place 
                WHERE 
                {?place rdf:type sdh:C13}
        }

         SERVICE <https://query.wikidata.org/sparql>
            {
                ### coordinate location
                ?place wdt:P625 ?coordinates.
            }
}
```

```sparql
### Inspect the available data
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT ?place (COUNT(*) AS ?n) (GROUP_CONCAT(DISTINCT ?coordinates; separator=" | ") AS ?geoCoords) 
WHERE {
    {SELECT ?place ?coordinates
    WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
            {SELECT DISTINCT ?place 
                    WHERE 
                    {?place rdf:type sdh:C13}
            }

            SERVICE <https://query.wikidata.org/sparql>
                {
                    ### coordinate location
                    ?place wdt:P625 ?coordinates.
                }
            }
    }
}
GROUP BY ?place
HAVING (COUNT(*) > 1)
OFFSET 100
LIMIT 10
```

```sparql
### Prepare the import
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX sdh: <https://sdhss.org/ontology/core/>

CONSTRUCT {?place wdt:P625 ?maxCoordinates.}
WHERE {
        {
        SELECT ?place (max(?coordinates) as ?maxCoordinates)
        WHERE {
            GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
                {SELECT DISTINCT ?place 
                        WHERE 
                        {?place rdf:type sdh:C13}
                }

                SERVICE <https://query.wikidata.org/sparql>
                    {
                        ### coordinate location
                        ?place wdt:P625 ?coordinates.
                    }
                }
        GROUP BY ?place
        }
    }
OFFSET 20
LIMIT 10

```

```sparql
### Insert the data
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX sdh: <https://sdhss.org/ontology/core/>

WITH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
INSERT {?place wdt:P625 ?maxCoordinates.}
WHERE {
        {
        SELECT ?place (max(?coordinates) as ?maxCoordinates)
        WHERE {
            GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
                {SELECT DISTINCT ?place 
                        WHERE 
                        {?place rdf:type sdh:C13}
                }

                SERVICE <https://query.wikidata.org/sparql>
                    {
                        ### coordinate location
                        ?place wdt:P625 ?coordinates.
                    }
                }
        GROUP BY ?place
        }
    }



```
### lieux sans coordonnées cf. merkel


```sparql
### Insert the label of the property
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


INSERT DATA {
  GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
  {wdt:P625 rdfs:label 'coordinate location'.}
}
```
## Explore collected data

```sparql
### Nombre de personnes

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?person ?personLabel ?birthDate ?birthPlace ?placeLabel ?location
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?person a wd:Q5;
            rdfs:label ?personLabel;
            wdt:P569 ?birthDate;
            wdt:P19 ?birthPlace.
            ?birthPlace wdt:P625 ?location;
                rdfs:label ?placeLabel.  
          FILTER(CONTAINS(?personLabel, 'Eisenberg'))      
          }
}
ORDER BY ?person
#OFFSET 100
LIMIT 10
```

```sparql
### Nombre de personnes

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?person ?personLabel ?birthDate ?birthPlace ?placeLabel ?location
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?person a wd:Q5;
            rdfs:label ?personLabel;
            wdt:P569 ?birthDate.
        OPTIONAL {  ?person  wdt:P19 ?birthPlace;
                        rdfs:label ?placeLabel.}
        OPTIONAL {   ?birthPlace wdt:P625 ?location
                
        }  
          FILTER(CONTAINS(?personLabel, 'Merkel'))      
          }
}
ORDER BY ?person
LIMIT 10
```
### Heisenberg is missing

```sparql
### Nombre de personnes

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?person ?personLabel ?birthDate ?birthPlace ?placeLabel ?location
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        # Heisenberg
        {wd:Q40904 a wd:Q5.
          }
}

```

```sparql
### Nombre de personnes

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?person ?personLabel ?birthDate ?birthPlace ?placeLabel ?location
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        # Heisenberg
        {wd:Q40904 a wd:Q5.
          }
}

```

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT DISTINCT ?item?itemLabel
        WHERE {

        ## note the service address  
        SERVICE <https://query.wikidata.org/sparql>
            {
            
            ?item wdt:P106 wd:Q169470;  # physicist
                wdt:P31 wd:Q5;  # Any instance of a human.
                # wdt:P569 ?birthDate; # It must necessarily have a birth date property
                    rdfs:label ?itemLabel.
             FILTER(CONTAINS(?itemLabel, 'Heisenbe'))
    }
        }
        
    LIMIT 10
```

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT DISTINCT ?o ?oLabel
WHERE {
        ## note the service address  
        SERVICE <https://query.wikidata.org/sparql>
            {
            ### manquent des triplets !
            wd:Q40904 wdt:P106 ?o.
             ?o rdfs:label ?oLabel.
             filter(lang(?oLabel) = 'en')
            }
        }
        
        
    LIMIT 100
```
