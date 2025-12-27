


## Importer les URI de Wikidata



### Inspecter les triplets à importer



    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/> 
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>

    SELECT ?person  ?wikidataUri
        WHERE {

        ?person a dbo:Person.

        SERVICE <https://dbpedia.org/sparql> {
            ?person owl:sameAs ?wikidataUri.
                FILTER (CONTAINS(STR(?wikidataUri), 'wikidata'))
            }
    }



### Insérer les triples d'alignement DBPedia / Wikidata

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/> 
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>

    # CONSTRUCT {?person owl:sameAs ?wikidataUri.}
    INSERT {?person owl:sameAs ?wikidataUri.}
        WHERE {

        ?person a dbo:Person.

        SERVICE <https://dbpedia.org/sparql> {
            ?person owl:sameAs ?wikidataUri.
                FILTER (CONTAINS(STR(?wikidataUri), 'wikidata'))
            }
    }



### Compter les relations owl:sameAs

PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX dbo: <http://dbpedia.org/ontology/> 

SELECT (COUNT(*) AS ?number)
WHERE {?s a dbo:Person;
          owl:sameAs ?o.
       }




### Inspecter les données importées


    PREFIX dbo: <http://dbpedia.org/ontology/> 

    SELECT ?s ?p ?o
    WHERE {?s a dbo:Person;
            ?p ?o.
    FILTER (?o != dbo:Person)
        }
    ORDER BY ?s ?p

