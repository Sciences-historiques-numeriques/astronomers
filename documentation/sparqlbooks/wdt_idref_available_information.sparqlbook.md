### IdRef Data inspection of available information

```sparql
 
PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX bibo: <http://purl.org/ontology/bibo/>


SELECT ?type (COUNT(*) as ?n) 
  WHERE {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
    {?item a ?type.
    } 
  }
  GROUP BY ?type
  ORDER BY DESC(?n)
```

```sparql
### Available properties in the graph

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>

SELECT ?p ?label (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
        {?s ?p ?o.
        OPTIONAL {?p rdfs:label ?label}    
          }
}
GROUP BY ?p ?label
ORDER BY DESC(?n)
```

```sparql

```

```sparql

```
## Inspect single persons


### Values
<http://www.idref.fr/031038549/id>

```sparql
### Types of bibliographic objects
# It appears that bibo:Document is associated to each instance

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

SELECT ?item ?p ?o
WHERE {  

    VALUES ?item { <http://www.idref.fr/031038549/id> }  
    SERVICE <https://data.idref.fr/sparql> {     
       
        ?item ?p ?o.
  }
}
```

```sparql

```

```sparql

```

```sparql

```
