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

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/> 
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


    CONSTRUCT {?person rdfs:label ?label;
                        a dbo:Person;
                        dbo:birthYear ?bYI.
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

    PREFIX dbo: <http://dbpedia.org/ontology/> 
    SELECT ?s ?p ?o
    WHERE {?s a dbo:Person;
            ?p ?o.
    FILTER (?o != dbo:Person)
        }
    ORDER BY ?s ?p
    LIMIT 100



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



### Inspecter les données importées


    PREFIX dbo: <http://dbpedia.org/ontology/> 

    SELECT ?s ?p ?o
    WHERE {?s a dbo:Person;
            ?p ?o.
    FILTER (?o != dbo:Person)
        }
    ORDER BY ?s ?p




## Inspecter les informations disponibles dans Wikidata


Quelles sont les informations disponibles dans Wikidata sur ma population


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/> 
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX wdt: <http://www.wikidata.org/prop/direct/>


    SELECT ?s ?wPerson ?p ?o
    WHERE {
    ?s owl:sameAs ?wPerson;
            a dbo:Person.
    OPTIONAL {
    SERVICE <https://query.wikidata.org/sparql> {
                ?wPerson ?p ?o.
        FILTER(CONTAINS(STR(?p), 'direct'))
        }     
        }
        
    }

### Compter les propriétés

Compter les propriétés disponibles dans Wikidata pour sa population

Malheureusement, on ne peut pas afficher directement les étiquettes des propriétés pour une question de technologie (cf. la requête suivante)

On doit donc avoir recours directement à Wikidata pour chercher les propriétés ou les inspecter l'une après l'autre: cf. plus bas


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/> 
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX wdt: <http://www.wikidata.org/prop/direct/>


    SELECT ?p (count(*) as ?number) ('' as ?label)
    WHERE {
    ?s owl:sameAs ?wPerson;
            a dbo:Person.
    OPTIONAL {
    SERVICE <https://query.wikidata.org/sparql> {
                ?wPerson ?p ?o.
        FILTER(CONTAINS(STR(?p), 'direct'))
        }     
        }
    }
    GROUP by ?p
    ORDER BY DESC(?number)


### Requête qui tente d'ajouter les labels aux propriétés

Elle appelle des fonctionnalités de Wikidata qui ne semblent fonctionner que directement sur Wikidata


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/> 
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX wdt: <http://www.wikidata.org/prop/direct/>
    PREFIX wikibase: <http://wikiba.se/ontology#>
    PREFIX bd: <http://www.bigdata.com/rdf#>


    SELECT ?p ?propLabel ?number
    WHERE {
    ?s owl:sameAs ?wPerson;
            a dbo:Person.
    
    SERVICE <https://query.wikidata.org/sparql> {
        SELECT ?p ?propLabel (COUNT(*) AS ?number)
        WHERE {
        {SELECT ?propLabel ?p
        WHERE {
                {?wPerson ?p ?o.
                FILTER(CONTAINS(STR(?p), 'direct'))
                }
        ?prop wikibase:directClaim ?p.
        SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
        }     
        }
        }
        GROUP BY ?p ?propLabel   
    }
    }
    order by desc(?number)



## Inspecter les propriétés de Wikidata


### Récupérer un ensemble de personnes et explorer leurs propriétés

Requête à exécuter sur le point d'accès Wikidata: https://query.wikidata.org


On peut inspecter aussi les personnes individuellement: http://www.wikidata.org/entity/Q705048



    SELECT DISTINCT ?p ?propLabel (count(*) as ?number)
    WHERE {
        VALUES ?list {<http://www.wikidata.org/entity/Q705048> 
                <http://www.wikidata.org/entity/Q4347768>
                <http://www.wikidata.org/entity/Q1376098>
                <http://www.wikidata.org/entity/Q14281>
                <http://www.wikidata.org/entity/Q9095>
            }
            ?list  ?p ?o .
        FILTER(CONTAINS(STR(?p), 'direct'))
        ?prop wikibase:directClaim ?p.
        SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
    GROUP BY ?p ?propLabel
    ORDER BY DESC (?number)