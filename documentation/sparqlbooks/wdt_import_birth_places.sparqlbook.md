# Import Birth Places

In this notebook we add to the imported Wikidata population properties regarding their birth place and geographical origin

```sparql
### Number of persons in our population
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
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
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        #ORDER BY ?item      
        #OFFSET 10000
        LIMIT 10000

        }

         SERVICE <https://query.wikidata.org/sparql>
            {
                ### place of birth
                ?item wdt:P19 ?birthPlace.
                #BIND (?citizenshipLabel as ?citizenshipLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
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
                        rdf:type sdh:C13}
WHERE
    {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>

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
                BIND (?birthPlaceLabel as ?birthPlaceLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
```

```sparql
### To be sure, the insert query has to be carried out directly on the Allegrograph server
# but it also could work if executed in this notebook
## Also, you have to carry it out in three steps. The accepted limit by Wikidata 
## of instances in a variable ('item' in our case) appears to be 10000.
## You therefore have to have three steps for a population of around 23000 persons  

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
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
        OFFSET 30000
        LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ### place of birth
                ?item wdt:P19 ?birthPlace.
                BIND (?birthPlaceLabel as ?birthPlaceLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
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
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {wdt:P19 rdfs:label 'place of birth'.}
}
```

```sparql
### Get the number of created 'citizenships'
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


    SELECT (COUNT(*) as ?n) 
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
            {
                ?s wdt:P19 ?o.
            }
            }
    
```

```sparql
### Get the number of created 'citizenships'
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX sdh: <https://sdhss.org/ontology/core/>


    SELECT (COUNT(*) as ?n) 
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
            {
                ?geogPlace rdf:type sdh:C13.
            }
            }
    
```

```sparql
### Insert the label of the property
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX sdh: <https://sdhss.org/ontology/core/>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {sdh:C13 rdfs:label 'Geographical Place'.}
}
```

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT DISTINCT ?item ?birthPlace ?birthPlaceLabel
WHERE { 
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
    {?item wdt:P19 ?birthPlace.
            ?birthPlace rdfs:label ?birthPlaceLabel;
                        rdf:type sdh:C13.}}
LIMIT 5


```
### Persons without birthplace



```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX sdh: <https://sdhss.org/ontology/core/>


SELECT DISTINCT *
WHERE { 
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
    {?item a wd:Q5;
     rdfs:label ?persLabel.
     MINUS {?item wdt:P19 ?birthPlace}}
     }
ORDER BY ?item
OFFSET 100 
LIMIT 20


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


SELECT DISTINCT ?item (count(*) as ?n) (GROUP_CONCAT(DISTINCT ?birthPlaceLabel; separator=" | ") AS ?birthPlaces) 
WHERE { 
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
    {?item a wd:Q5;
     rdfs:label ?persLabel;
     wdt:P19 ?birthPlace.
     ?birthPlace rdfs:label ?birthPlaceLabel}
     }
GROUP BY ?item     
HAVING (count(*) > 1)
ORDER BY DESC(?n)
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
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
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
                ### instance of
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
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>

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
                 ### instance of
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

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {?place wdt:P31 ?placeClass.
            ?placeClass rdfs:label ?placeClassLabel}
WHERE
    {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>

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
                 ### instance of
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
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?place rdf:type sdh:C13;
                       wdt:P31 ?placeClass.
                ?placeClass rdfs:label ?placeClassLabel
       }
        
}
GROUP BY ?placeClass ?placeClassLabel
ORDER BY DESC(?n)
LIMIT 5

```
### Get the geogr. coordinates

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
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
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

CONSTRUCT {?place wdt:P625 ?coordinates.}
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {SELECT ?place ?placeLabel
        WHERE 
                {?place rdf:type sdh:C13;
                       rdfs:label  ?placeLabel}
        #ORDER BY ?item      
        #OFFSET 10000
        LIMIT 10

        }

         SERVICE <https://query.wikidata.org/sparql>
            {
                ### coordinate location
                ?place wdt:P625 ?coordinates.
            }
}
ORDER BY ?place
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

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {?place wdt:P625 ?coordinates.}
WHERE {
        {SELECT ?place 
        WHERE 
                {?place rdf:type sdh:C13}
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



```

```sparql
### Insert the label of the property
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
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

SELECT ?person ?personLabel ?birthDate ?birthPlace
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?person a wd:Q5;
            rdfs:label ?personLabel;
            wdt:P569 ?birthDate;
            wdt:P19 ?birthPlace.
          }
}
LIMIT 10
```

```sparql
PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?person 
        (MIN(?personLabel) AS ?persLabel) 
        ?birthDate ?geoPlace 
        (MIN(?placeLabel) AS ?geoPlaceLabel)
        (MIN(?location) AS ?minLocation)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {
            ?person a wd:Q5;
                rdfs:label ?personLabel;
                wdt:P569 ?birthDate;
                wdt:P19 ?geoPlace.
            ?geoPlace wdt:P625 ?location;
                rdfs:label ?placeLabel.   
          }
}
GROUP BY ?person ?birthDate ?geoPlace 
limit 10
```
