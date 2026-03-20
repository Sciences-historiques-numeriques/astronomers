
```sparql

```

```sparql
### Propriétés des personnes

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?s ?label 
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {
            ?s a wd:Q5;
            rdfs:label ?label.
        }     
}
LIMIT 5
```

```sparql
### Propriétés des personnes

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

SELECT ?s ?label ?sDbp
WHERE
    {
    

        {
        SELECT ?s ?label 
        WHERE {
            GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
                {
                    ?s a wd:Q5;
                    rdfs:label ?label.
                }     
        }
       LIMIT 10000
        }


 SERVICE <https://dbpedia.org/sparql> {
        ?sDbp owl:sameAs ?s.
        
    }

    }
    LIMIT 10
```
### Import data

```sparql
### Prepare the data to be imported
# With LIMIT clause 
## Apparently labels are not repeated if already available
# We therefore car integrate them directly in the INSERT below
PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

CONSTRUCT {?s owl:sameAs ?sDbp}
WHERE
    {
    

        {
        SELECT ?s ?label 
        WHERE {
            GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
                {
                    ?s a wd:Q5;
                    rdfs:label ?label.
                }     
        }
       LIMIT 10000
        }


 SERVICE <https://dbpedia.org/sparql> {
        ?sDbp owl:sameAs ?s.
        
    }

    }
    LIMIT 10
```

```sparql
### Prepare the data to be imported
# With LIMIT clause 
## Apparently labels are not repeated if already available
# We therefore car integrate them directly in the INSERT below
PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {?s owl:sameAs ?sDbp}
WHERE
    {
    

        {
        SELECT ?s ?label 
        WHERE {
                {
                    ?s a wd:Q5.
                }     
        }
        OFFSET 1000
        #OFFSET 20000
        #OFFSET 30000
        LIMIT 1000
        }


 SERVICE <https://dbpedia.org/sparql> {
        ?sDbp owl:sameAs ?s.
        
    }

    }

```
## Autre méthode
### Version anglaise

```sparql
### Db pedia en anglais

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX schema: <http://schema.org/>

SELECT ?s ?article ?uri_dbpedia
WHERE
    {
        {SELECT ?s ?label 
            WHERE {
                GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
                    {
                        ?s a wd:Q5;
                        rdfs:label ?label.
                    }     
            }
        LIMIT 10}

        SERVICE <https://query.wikidata.org/sparql> {
         ?article schema:about ?s .
         ?article schema:inLanguage "en" .
         #FILTER (SUBSTR(str(?article), 1, 25) = "https://en.wikipedia.org/")
         FILTER (CONTAINS(str(?article), "https://en.wikipedia.org/"))
            BIND (URI(replace(str(?article), "https://en.wikipedia.org/wiki/", "http://dbpedia.org/resource/")) AS ?uri_dbpedia)
     }

    }
```

```sparql
PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX schema: <http://schema.org/>

CONSTRUCT {?s owl:sameAs ?uri_dbpedia}
WHERE
    {
        {SELECT ?s ?label 
            WHERE {
                GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
                    {
                        ?s a wd:Q5;
                        rdfs:label ?label.
                    }     
            }
        LIMIT 10}

        SERVICE <https://query.wikidata.org/sparql> {
         ?article schema:about ?s .
         ?article schema:inLanguage "en" .
         FILTER (SUBSTR(str(?article), 1, 25) = "https://en.wikipedia.org/")
            BIND (URI(replace(str(?article), "https://en.wikipedia.org/wiki/", "http://dbpedia.org/resource/")) AS ?uri_dbpedia)
     }

    }
```

```sparql
PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX schema: <http://schema.org/>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {?s owl:sameAs ?uri_dbpedia}
WHERE
    {
    

        {
        SELECT ?s 
        WHERE {
            GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
                {
                    ?s a wd:Q5.
                }     
        }
        #OFFSET 10000
        # OFFSET 20000
        OFFSET 30000
        LIMIT 10000
        }

        SERVICE <https://query.wikidata.org/sparql> {
         ?article schema:about ?s .
         ?article schema:inLanguage "en" .
         FILTER (SUBSTR(str(?article), 1, 25) = "https://en.wikipedia.org/")
            BIND (URI(replace(str(?article), "https://en.wikipedia.org/wiki/", "http://dbpedia.org/resource/")) AS ?uri_dbpedia)
     }

    }
```

```sparql
PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX schema: <http://schema.org/>


SELECT ?s ?label (COUNT(*) as ?number)
    ( GROUP_CONCAT(DISTINCT ?sameAs; separator=", ") AS ?concatSameAs ) 
   #(MIN(?sameAs) as ?sA)
    WHERE {
            GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
                {
                    ?s a wd:Q5; 
                        rdfs:label ?label;
                        owl:sameAs ?sameAs

                }     
        }
GROUP BY ?s ?label
HAVING (?number > 1)
LIMIT 10       
```

```sparql
PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX schema: <http://schema.org/>


SELECT ?p (COUNT(*) as ?number)
   #(MIN(?sameAs) as ?sA)
    WHERE {
            {SELECT ?s ?sameAs
            WHERE
{            GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
                {
                    ?s a wd:Q5; 
                        rdfs:label ?label;
                        owl:sameAs ?sameAs

                }     
}               
 LIMIT 2000
        }
        
         SERVICE <https://dbpedia.org/sparql> {
        ?sameAs ?p ?o.
        
    }

        
        
        
        
        }
GROUP BY ?p
ORDER BY DESC(?number)
```
### Version francophone

```sparql
### DBPedia en français

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX schema: <http://schema.org/>

SELECT ?s ?article ?uri_dbpedia
WHERE
    {
        {SELECT ?s ?label 
            WHERE {
                GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
                    {
                        ?s a wd:Q5;
                        rdfs:label ?label.
                    }     
            }
        LIMIT 10}

        SERVICE <https://query.wikidata.org/sparql> {
         ?article schema:about ?s .
         ?article schema:inLanguage "fr" .
         FILTER (SUBSTR(str(?article), 1, 25) = "https://fr.wikipedia.org/")
            BIND (URI(replace(str(?article), "https://fr.wikipedia.org/wiki/", "http://fr.dbpedia.org/resource/")) AS ?uri_dbpedia)
     }

    }
```

```sparql
### DBPedia en allemand — ne semble pas marcher le 10 avril 2025

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX schema: <http://schema.org/>

SELECT ?s ?article ?uri_dbpedia
WHERE
    {
        {SELECT ?s ?label 
            WHERE {
                GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
                    {
                        ?s a wd:Q5;
                        rdfs:label ?label.
                    }     
            }
        LIMIT 10}

        SERVICE <https://query.wikidata.org/sparql> {
         ?article schema:about ?s .
         ?article schema:inLanguage "de" .
         FILTER (SUBSTR(str(?article), 1, 25) = "https://de.wikipedia.org/")
            BIND (URI(replace(str(?article), "https://de.wikipedia.org/wiki/", "http://de.dbpedia.org/resource/")) AS ?uri_dbpedia)
     }

    }
```

```sparql

```

```sparql
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX schema: <http://schema.org/>

SELECT DISTINCT ?item ?article ?uri_dbpedia
      WHERE {
      # SERVICE <https://query.wikidata.org/sparql>
      {
            
       {
        {?item wdt:P106 wd:Q169470}
        UNION
        {?item wdt:P106 wd:Q11063}
        UNION
        {?item wdt:P106 wd:Q155647}
        }
          
          ?item wdt:P31 wd:Q5;  # Any instance of a human.
              wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1300 )
          # OPTIONAL {
      ?article schema:about ?item .
      ?article schema:inLanguage "en" .
     FILTER (SUBSTR(str(?article), 1, 25) = "https://en.wikipedia.org/")
      BIND (replace(str(?article), "https://en.wikipedia.org/wiki/", "http://dbpedia.org/resource/") AS ?uri_dbpedia)       

#  }
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
  {wdt:P106 rdfs:label 'occupation'.}
}
```
