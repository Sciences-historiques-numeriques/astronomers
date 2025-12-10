

## Wikidata

Cette partie est purement illustrative et d'exploration de contenu du moment que Wikidata ne permet pas une connexion directe sur DBpedia.

### Liste d'URIs depuis DBpedia

Serveur pour la requête: https://dbpedia.org/sparql


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?person ?object
    WHERE { 
    dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        <http://www.w3.org/2002/07/owl#sameAs> ?object.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770 && CONTAINS(STR(?object), 'wikidata'))
    }
    LIMIT 10




### Example

https://dbpedia.org/resource/Sallie_Baliunas
https://www.wikidata.org/wiki/Q7404989


https://dbpedia.org/resource/Herbert_Alonzo_Howe
https://www.wikidata.org/wiki/Q11192569




### Query on Wikidata

Requête SPARQL à exécuter sur le serveur https://query.wikidata.org

Mais attention: généralement ça ne marchera pas, ça donnera un message de temps limite dépassé.

    Unknown error. upstream request timeout

&nbsp;

La requête pour récupérer les URI de la Bibliothèque nationale de France (BNF):

    PREFIX wdt: <http://www.wikidata.org/prop/direct/>
    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>   
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>


    SELECT  ?wdPerson ?wdPersonLabel ?uriBNF
    WHERE {

    SERVICE <https://dbpedia.org/sparql> {
        SELECT ?wikidataUri #?person ?birthYear
        WHERE {
        {dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate.
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
            FILTER ( ?birthYear > 1770 && CONTAINS(STR(?wikidataUri), 'wikidata'))
        }
          
          ?person <http://www.w3.org/2002/07/owl#sameAs> ?wikidataUri.
          }
        LIMIT 10
        } 

    ?wikidataUri wdt:P31 wd:Q5; # classe personne humaine
         #   wdt:P106 wd:Q1106 ;
                 wdt:P268 ?uriBNF.

    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
    }
     




### Les pages Wikipedia, vues depuis Wikidata

Requête SPARQL à exécuter sur le serveur https://query.wikidata.org

    SELECT *
    WHERE {
    <http://www.wikidata.org/entity/Q91> ^schema:about ?article .
        ?article schema:isPartOf <https://en.wikipedia.org/>
        }


https://en.wikipedia.org/wiki/Galileo_Galilei



### Les astronomes vus depuis Wikidata

Requête SPARQL à exécuter sur le serveur https://query.wikidata.org


    PREFIX wdt: <http://www.wikidata.org/prop/direct/>
    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>   
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>


    SELECT DISTINCT  ?wdPerson ?wdPersonLabel ?article ?p ?s ?sLabel
    WHERE {?wdPerson wdt:P31 wd:Q5;
            wdt:P106 wd:Q11063;
                    ^schema:about ?article .
        ?article schema:isPartOf <https://en.wikipedia.org/>}
    limit 200


&nbsp;


## Requête sur DBpedia

Le même blocage se trouve du côté de DBpedia qui ne permet plus de faire des requêtes fédérées pointant sur d'autres serveurs.

Résultat: 

"It does not work! "Must have SELECT privileges on view DB.DBA.SPARQL_SINV_2 for group ID 110 (SPARQL), user ID 110 (SPARQL)"



    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
        

    SELECT ?person ?object ?pw ?o
    WHERE {
        {
            SELECT ?person ?object
                WHERE { 
                dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
                ?person a dbo:Person;
                        dbo:birthDate ?birthDate ;
                    <http://www.w3.org/2002/07/owl#sameAs> ?object.
                    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
                    FILTER ( ?birthYear > 1770 && CONTAINS(STR(?object), 'wikidata'))
                }
            LIMIT 1
        }
    SERVICE <https://query.wikidata.org/sparql> {
    ?object ?pw ?o
        }   
    }




### On utilise donc un point d'accès SPARQL tiers 


Point d'accès SPARQL du projet **YAGO** : https://yago-knowledge.org/sparql

L'astuce consiste à aller sur un point d'accès tiers et exécuter deux requêtes fédérées.

Yago est une version filtrée et nettoyée de Wikidata/DBpedia:

"YAGO is a large knowledge base with general knowledge about people, cities, countries, movies, and organizations."


&nbsp;

```
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>   
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?person ?wikidataUri ?p1 ?o1 ?o1Label
WHERE {

    
    {SERVICE <https://dbpedia.org/sparql> {
    SELECT ?person ?wikidataUri
        WHERE { 
        dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate ;
            <http://www.w3.org/2002/07/owl#sameAs> ?wikidataUri.
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
            FILTER ( ?birthYear > 1770 && CONTAINS(STR(?wikidataUri), 'wikidata'))
        }
        LIMIT 3
    }
    }
SERVICE <https://query.wikidata.org/sparql> {
    {SELECT ?wikidataUri ?p1  ?o1 ?o1Label
    WHERE {
        ?wikidataUri ?p1 ?o1.
    
    FILTER(CONTAINS(STR(?p1), 'direct'))
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
    
    }
    }
    }
}
```

&nbsp;


### Compter les propriétés sur les 100 premiers individus

Fonctionnne sur Yago (mais parfois timeout): https://yago-knowledge.org/sparql

```
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>   
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
prefix bd: <http://www.bigdata.com/rdf#>

SELECT ?p1 ?propLabel ?number
WHERE {

    {SERVICE <https://dbpedia.org/sparql> {
    SELECT ?person ?wikidataUri
        WHERE { 
        dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate ;
            <http://www.w3.org/2002/07/owl#sameAs> ?wikidataUri.
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
            FILTER ( ?birthYear > 1770 && CONTAINS(STR(?wikidataUri), 'wikidata'))
        }
        LIMIT 100
    }
}
    
SERVICE <https://query.wikidata.org/sparql> {
    {SELECT ?p1  ?propLabel (COUNT(*) as ?number)
    WHERE {
        ?wikidataUri ?p1 ?o1.
    ?prop wikibase:directClaim ?p1.
    FILTER(CONTAINS(STR(?p1), 'direct'))
        
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
    
    }
    GROUP BY ?p1 ?propLabel
    }
    }
}

ORDER BY desc(?number)
```



### Test dans Wikidata sur un individu

IRIs:
* http://www.wikidata.org/entity/Q91
* http://www.wikidata.org/entity/Q739455

&nbsp;


    SELECT DISTINCT ?p ?o ?oLabel
    where {<http://www.wikidata.org/entity/Q705048> ?p ?o .
        FILTER(CONTAINS(STR(?p), 'direct'))
        SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
    limit 100


&nbsp;




PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>   
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
prefix bd: <http://www.bigdata.com/rdf#>

SELECT ?p1 ?propLabel 
WHERE {

    {SERVICE <https://dbpedia.org/sparql> {
    SELECT ?person ?wikidataUri
        WHERE { 
        dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate ;
            <http://www.w3.org/2002/07/owl#sameAs> ?wikidataUri.
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
            FILTER ( ?birthYear > 1770 && CONTAINS(STR(?wikidataUri), 'wikidata'))
        }
        LIMIT 2
    }
  }
    
SERVICE <https://query.wikidata.org/sparql> {
    {SELECT ?p1  ?propLabel 
    WHERE {
        ?wikidataUri ?p1 ?o1.
    ?prop wikibase:directClaim ?p1.
    FILTER(CONTAINS(STR(?p1), 'direct'))
        
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
    
    }
    }
    }
}










### Yago

https://yago-knowledge.org/sparql


    PREFIX schema: <http://schema.org/>
    PREFIX yago: <http://yago-knowledge.org/resource/>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    SELECT distinct  ?p WHERE {
    ?s owl:sameAs <http://www.wikidata.org/entity/Q410>;
        ?p ?o
    } 
    LIMIT 100




    PREFIX schema: <http://schema.org/>
    PREFIX yago: <http://yago-knowledge.org/resource/>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    SELECT ?p (count(*) as ?number)
    WHERE {
    ?s owl:sameAs <http://www.wikidata.org/entity/Q6722>;
        ?p ?o.
    FILTER( !CONTAINS(STR(?p), 'ame'))
    } 
    group by ?p
    order by desc(?number)




