# Import citizenships

In this notebook we add to the imported Wikidata population properties regarding citizenship in countries

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
### Some examples of persons
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?s ?label ?birthYear
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5;
            rdfs:label ?label;
            wdt:P569 ?birthYear}
}
ORDER BY ?s
LIMIT 3

```

```sparql
### Prepare and inspect the data to be imported


PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

CONSTRUCT {?item wdt:P27 ?citizenship.
            ?citizenship rdfs:label ?citizenshipLabel}
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
                ?item wdt:P27 ?country.
                BIND (?citizenshipLabel as ?citizenshipLabel)
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


WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {?item wdt:P27 ?citizenship.}
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        #OFFSET 8000
        #OFFSET 16000
        #OFFSET 24000
        #OFFSET 32000
        LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ?item wdt:P27 ?citizenship.
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
  {wdt:P27 rdfs:label 'country of citizenship'.}
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
                ?s wdt:P27 ?o.
            }
            }
    
```

```sparql
### Persons without a country of citizenship
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?n)
WHERE 
{GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        
    {?item a wd:Q5;
        rdfs:label ?label.
    MINUS {
            ?item wdt:P27 ?country   .
        }     
    }
}

```

```sparql
### Persons without a country of citizenship
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?item ?label
WHERE 
{GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        
    {?item a wd:Q5;
        rdfs:label ?label.
    MINUS {
            ?item wdt:P27 ?country   .
        }     
    }
}
OFFSET 10000
LIMIT 10
```

```sparql
### Persons with more than one citizenship
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?citizenship ?citizenshipLabel (COUNT(*) as ?n) 
WHERE {
GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
{
   ?item wdt:P27 ?citizenship.
    ?citizenship rdfs:label ?citizenshipLabel.
}

}
GROUP BY ?citizenship ?citizenshipLabel
ORDER BY DESC(?n)

LIMIT 5
```
### Add missing citizenships

On April 2nd, 2025 a number of citizenships are missing in the SPARQL endpoint of Wikidata as wdt:P27 properties but they are present in the statements: cf. following example



```sparql
### test a specific person

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>


SELECT ?item ?o ?p ?statement_o
    {

        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                 
                BIND(<http://www.wikidata.org/entity/Q1001072> as ?item)
                {
                    ?item ?p ?statement_o.
                    FILTER(contains(str(?p), 'P27'))
                }
                OPTIONAL{
                    ?item wdt:P27 ?o.
                }

            }
                
        }
```

```sparql
### Get the country value

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX p: <http://www.wikidata.org/prop/>
PREFIX ps: <http://www.wikidata.org/prop/statement/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>



SELECT ?item ?os ?osLabel

WHERE
    {

        ## 
        SERVICE <https://query.wikidata.org/sparql>
        {
            {

                BIND(<http://www.wikidata.org/entity/Q1001072> as ?item)
                ?item p:P27 [ps:P27 ?os]

                BIND(?osLabel AS ?osLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
            }        
                
        }
    }
```

```sparql
### Get the country value

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX p: <http://www.wikidata.org/prop/>
PREFIX ps: <http://www.wikidata.org/prop/statement/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>



SELECT ?item ?os ?osLabel

WHERE
    {

        {SELECT ?item
        WHERE 
                {?item a wd:Q5.
                MINUS {
                        ?item wdt:P27 ?country   .
                    }  
        }
                
        ORDER BY ?item  
       
        }

        ## 
        SERVICE <https://query.wikidata.org/sparql>
        {
            {

                ?item p:P27 [ps:P27 ?os]

                BIND(?osLabel AS ?osLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
            }        
                
        }
    }
    LIMIT 20
```
### Conslusion about missing citizenships

Apparently, there are only five persons with this special situation, all other around 8700 are missing, as a quick inspection shows.

They will be excluded from the analysis
### Inspect the available information

With the queries [in this sparqlbook](wdt_available_information.sparqlbook) you can inspect the available information

```sparql
### Basic query about persons' properties

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?p ?label (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5;
            ?p ?o.
        OPTIONAL {?p rdfs:label ?label}    
          }
}
GROUP BY ?p ?label
ORDER BY DESC(?n)
```
## Enrich the information available in your graph about countries  

```sparql
### Get the labels of the countries 
# Prepare the insert

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

CONSTRUCT  {
    ?country rdfs:label ?countryLabel.
}
#SELECT DISTINCT ?country ?countryLabel
WHERE {

    {
    SELECT DISTINCT ?country
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
            {
                ?s wdt:P27 ?country.
            }
            }
    LIMIT 5
    }

    SERVICE <https://query.wikidata.org/sparql>
                {
                BIND (?country as ?country)
                BIND (?countryLabel as ?countryLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
                }



}
```

```sparql
### Execute the INSERT, from the sparqlbook or on Allegrograph

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md> 
INSERT  {
    ?citizenship rdfs:label ?citizenshipLabel.
}
WHERE {

    {
    SELECT DISTINCT ?citizenship
    WHERE {
            {
                ?s wdt:P27 ?citizenship.
            }
          }
    }

    SERVICE <https://query.wikidata.org/sparql>
                {
                BIND (?citizenship as ?citizenship)
                BIND (?citizenshipLabel as ?citizenshipLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
                }



}
```

```sparql
###  Inspect the citizenships
# number of persons having this citizenship

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?citizenship ?citizenshipLabel (COUNT(*) as ?n)
WHERE {
GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
{
   ?s wdt:P27 ?citizenship.
   ?citizenship rdfs:label ?citizenshipLabel.
}

}
GROUP BY ?citizenship ?citizenshipLabel
ORDER BY DESC(?n)
limit 20
```
### Add the country class

```sparql
###  Inspect the countries:
# number of different countries

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?n)
WHERE
   {
   SELECT DISTINCT ?country
   WHERE {
      GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
         {
            ?s wdt:P27 ?country.
         }
      }
   }
```

```sparql
### Insert the class 'country' for all countries
# Please note that strictly speaking Wikidata has no ontology,
# therefore no classes. We add this for our convenience

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {
   ?country rdf:type wd:Q6256.
}
WHERE
   {
   SELECT DISTINCT ?country
   WHERE {
         {
            ?s wdt:P27 ?country.
         }
      }
   }
```

```sparql
### Ajouter le label pour le concept Country

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

INSERT DATA {
GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
    {    wd:Q6256 rdfs:label "Country".
    }    
}


```
### Persons with more thant one citizenship

```sparql
### Persons with more than one citizenship
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?item (COUNT(*) as ?n) ( GROUP_CONCAT(?citizenshipLabel; separator=", ") AS ?countries )
WHERE {
GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
{
   ?item wdt:P27 ?citizenship.
    ?citizenship rdfs:label ?citizenshipLabel.
}

}
GROUP BY ?item
HAVING (?n > 1)
ORDER BY DESC(?n)
OFFSET 10
LIMIT 5
```

```sparql
### Number of persons with more than one citizenship
# We see that we have an issue: 1/5 of population with more than one citizenship
# How to treat this ?

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) AS ?no)
WHERE {
    SELECT ?item (COUNT(*) as ?n)
    WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
    {
    ?item wdt:P27 ?citizenship.
        ?citizenship rdfs:label ?citizenshipLabel.
    }

    }
    GROUP BY ?item
    HAVING (?n > 1)
}
```
### Add the continents

```sparql
### Get the continents — prepare the data

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

CONSTRUCT  {
    ?citizenship wdt:P30 ?continent.
    ?continent rdfs:label ?continentLabel.
}
#SELECT DISTINCT ?citizenship ?citizenshipLabel
WHERE {

    {
    SELECT DISTINCT ?citizenship
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
            {
                ?s wdt:P27 ?citizenship.
            }
            }
    LIMIT 5
    }

    SERVICE <https://query.wikidata.org/sparql>
                {

                ?citizenship wdt:P30 ?continent.
                # BIND (?continent as ?citizenship)
                BIND (?continentLabel as ?continentLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
                }



}

```

```sparql
### Get the labels of the countries or citizenships
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

WITH  <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>   
INSERT  {
    ?citizenship wdt:P30 ?continent.
    ?continent rdfs:label ?continentLabel.
}
#SELECT DISTINCT ?citizenship ?citizenshipLabel
WHERE {

    {
    SELECT DISTINCT ?citizenship
    WHERE {
            {
                ?s wdt:P27 ?citizenship.
            }
            }
    }

    SERVICE <https://query.wikidata.org/sparql>
                {

                ?citizenship wdt:P30 ?continent.
                # BIND (?continent as ?citizenship)
                BIND (?continentLabel as ?continentLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
                }



}

```

```sparql
### Insert the property label
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {wdt:P30 rdfs:label 'continent'.}
}
```
### Add the continent class

```sparql
###  Inspect the continents:
# number of different continents

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?n)
WHERE
   {
   SELECT DISTINCT ?continent
   WHERE {
      GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
         {
            ?s wdt:P30 ?continent.
         }
      }
   }
```

```sparql
### Insert the class 'continent' for all continents
# Please note that strictly speaking Wikidata has no ontology,
# therefore no classes. We add this for our convenience

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {
   ?continent rdf:type wd:Q5107.
}
WHERE
   {
   SELECT DISTINCT ?continent
   WHERE {
         {
            ?s wdt:P30 ?continent.
         }
      }
   }
```

```sparql
### Ajouter le label pour la classe "Continent"

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

INSERT DATA {
GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
    {    wd:Q5107 rdfs:label "Continent".
    }    
}


```
### Inspect the persons in relations to continents

```sparql
###  Inspect the persons in continents
# number of persons having this citizenship

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?continent ?continentLabel (COUNT(*) as ?n)
WHERE {
GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
{
   ?s wdt:P27 ?country.
   ?country wdt:P30 ?continent.
   ?continent rdfs:label ?continentLabel.
}

}
GROUP BY ?continent ?continentLabel
ORDER BY DESC(?n)

```

```sparql
### Persons with more than one citizenship
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?item (COUNT(*) as ?n) ( GROUP_CONCAT(?continentLabel; separator=", ") AS ?continents )
    ( GROUP_CONCAT(?countryLabel; separator=", ") AS ?countries )
WHERE {
    SELECT DISTINCT ?item ?continentLabel ?coutryLabel
    WHERE 
        {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
            {
            ?item wdt:P27 ?country.
            ?country wdt:P30 ?continent;
                rdfs:label ?countryLabel.
            ?continent rdfs:label ?continentLabel.
            ## Excluding Eurasia, Australia and Oceania insular
            FILTER ( ?continent NOT IN (wd:Q538, wd:Q3960, wd:Q5401))
            }
        }
}
GROUP BY ?item
#HAVING (?n > 1)
ORDER BY DESC(?n)
#OFFSET 10
LIMIT 10
```

```sparql
### Persons with more than one citizenship
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?item (COUNT(*) as ?n) 
            ( GROUP_CONCAT(?continentLabel; separator=", ") AS ?continents )
#            ( GROUP_CONCAT(?countryLabel; separator=", ") AS ?countries )
WHERE {
    SELECT DISTINCT ?item 
    ?continentLabel 
    # ?countryLabel
    WHERE 
        {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
            {
            ?item wdt:P27 ?country.
            ?country wdt:P30 ?continent;
                rdfs:label ?countryLabel.
            ?continent rdfs:label ?continentLabel.
            ## Excluding Eurasia, Australia and Oceania insular
            FILTER ( ?continent NOT IN (wd:Q538, wd:Q3960, wd:Q5401))
            }
        }
}
GROUP BY ?item
HAVING (?n > 1)
ORDER BY DESC(?n)
#OFFSET 10
LIMIT 10
```

```sparql
### Number of persons with more than one citizenship
# We see that we have an issue: 1/5 of population with more than one citizenship
# How to treat this ?

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) AS ?no)
WHERE {
    SELECT ?item (COUNT(*) as ?n) ( GROUP_CONCAT(?continentLabel; separator=", ") AS ?continents )
    WHERE {
        SELECT DISTINCT ?item ?continentLabel
        WHERE 
            {
            GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
                {
                ?item wdt:P27 ?country.
                ?country wdt:P30 ?continent.
                ?continent rdfs:label ?continentLabel.
                ## Excluding Eurasia, Australia and Oceania insular
                FILTER ( ?continent NOT IN (wd:Q538, wd:Q3960, wd:Q5401))
                }
            }
    }
    GROUP BY ?item
    HAVING (?n > 1)
}
```
