

### Insérer les triples d'alignement DBPedia / Wikidata

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/> 
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>

    INSERT {?person owl:sameAs ?wikidataUri;
                a dbo:Person.}
        WHERE {
        SERVICE <https://dbpedia.org/sparql> {
            dbr:List_of_astronomers ?p ?person.
            ?person a dbo:Person;
                    dbo:birthDate ?birthDate ;
                <http://www.w3.org/2002/07/owl#sameAs> ?wikidataUri.
                BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
                FILTER ( ?birthYear > 1770 && CONTAINS(STR(?wikidataUri), 'wikidata'))
            }
    }


### Compter les personnes

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/> 
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>


    SELECT (COUNT(*) as ?number)
    WHERE {?s a dbo:Person}


### compter les relations owl:sameAs


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/> 
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>

    SELECT (COUNT(*) as ?number) 
    WHERE {?s owl:sameAs ?wPerson}
