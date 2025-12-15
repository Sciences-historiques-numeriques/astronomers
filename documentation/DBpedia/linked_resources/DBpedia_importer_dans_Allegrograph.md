# Alimenter un triplestore pour la recherche personnelle




## Importation des triplets de la population




### Inspecter les personnes à importer


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/> 
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

    SELECT ?person ?label
    WHERE {
    SERVICE <https://dbpedia.org/sparql> {
        dbr:List_of_astronomers ?p ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate ;
            rdfs:label ?label.
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
            FILTER ( ?birthYear > 1770  && LANG(?label) = 'en')
        }
    }

### Construire les données à importer

```
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


CONSTRUCT {?person rdfs:label ?label;
                    a dbo:Person;
                    dbo:birthYear ?birthYear.
            }
WHERE {
SERVICE <https://dbpedia.org/sparql> {
    dbr:List_of_astronomers ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        rdfs:label ?label.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770  && LANG(?label) = 'en')
    }    
}
```




### Insérer les triplets

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/> 
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


    INSERT {?person rdfs:label ?label;
                        a dbo:Person;
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
                        dbo:birthYear ?birthYear.
               }
    WHERE {
    SERVICE <https://dbpedia.org/sparql> {
        dbr:List_of_astronomers ?p ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate ;
            rdfs:label ?label.
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
            FILTER ( ?birthYear > 1770  && LANG(?label) = 'en')
        }
      
    }



### Inspecter les triplets importés


#### Les compter

    PREFIX dbo: <http://dbpedia.org/ontology/> 

    SELECT (COUNT(*) as ?number)
    WHERE {?s a dbo:Person}


#### Les inspecter

```
PREFIX dbo: <http://dbpedia.org/ontology/> 
SELECT ?s ?p ?o
WHERE {?s a dbo:Person;
        ?p ?o.
FILTER (?o != dbo:Person)
    }
ORDER BY ?s ?p
LIMIT 100
```




