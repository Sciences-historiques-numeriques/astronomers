# Inspect available information in your repository's Wikidata graph

```sparql
### Count instances of 'classes' in the repository

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

SELECT ?class ?classLabel (COUNT(*) AS ?n)
WHERE {
    GRAPH  <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>   
    {
        ?s rdf:type ?class.
        OPTIONAL {?class rdfs:label ?classLabel}
    }
}
GROUP BY ?class ?classLabel
ORDER BY DESC(?n)
```

```sparql
PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?p ?pLabel (COUNT(*) AS ?n)
WHERE {
    GRAPH  <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>   
    {
        ?s ?p ?o.
        OPTIONAL {?p rdfs:label ?pLabel}
    }
}
GROUP BY ?p ?pLabel
ORDER BY DESC(?n)
```
## Information about persons

```sparql
### Nombre de personnes

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5;
        rdfs:label ?label.
          }
}
```

```sparql
### Nombre de personnes à double

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5
          }
}
GROUP BY ?s
HAVING ( ?n > 1)
```

```sparql
### Propriétés des personnes

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

```sparql
### Insert the label of the property rdf:type
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {rdf:type rdfs:label 'has type'.}
}
```

```sparql
### Insert the label of the property rdf:type
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {rdfs:label rdfs:label 'has label'.}
}
```

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT (min(?birthDate) as ?minDate) (max(?birthDate) as ?maxDate)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5;
           wdt:P569 ?birthDate.
          }
}
```
## Propriétés des Occupations

```sparql
### Effectif des occupations
PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT (COUNT(*) as ?n)
WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item a wd:Q12737077.}
        }
         
```

```sparql
### Propriétés des Occupations: outgoing

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?p ?label (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q12737077;
            ?p ?o.
        OPTIONAL {?p rdfs:label ?label}    
          }
}
GROUP BY ?p ?label
ORDER BY DESC(?n)
```

```sparql
### Propriétés des Occupations: incoming

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?p ?label (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q12737077.
         ?s1 ?p ?s.
        OPTIONAL {?p rdfs:label ?label}    
          }
}
GROUP BY ?p ?label
ORDER BY DESC(?n)
```
### Propriétés des personnes disponibles dans Wikidata


On souhaite partir de la liste de la population dans son propre graphe, puis interroger Wikidata pour connaître les propriétés disponibles et leurs effectifs.



La difficulté est ici de disposer des labels.

Pour que la requête marche, il faut un LIMIT à 100 sur le graphe.

Avec la clause OFFSET on peut explorer différentes parties du graphe 

Se référer donc au fichier CSV précédemment réalisé directement sur Wikidata


```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

SELECT ?p ?propLabel   (COUNT(*) as ?number)
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE {
            GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
                {?item a wd:Q5.}
                }
        OFFSET 10000        
        LIMIT 100

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ?item ?p ?o.
                FILTER (CONTAINS(STR(?p), "prop/direct/"))

                ?prop wikibase:directClaim ?p .
                BIND(?propLabel as ?propLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
                
            }    
                
        }
GROUP BY ?p ?propLabel       
ORDER BY DESC(?number)
#OFFSET 50
LIMIT 50
```
