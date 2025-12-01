# Situer DBPedia dans le web sémantique et chercher de nouvelles informations




## Ressources liées

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?person ?object
    WHERE { 
    dbr:List_of_astronomers ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        <http://www.w3.org/2002/07/owl#sameAs> ?object.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770)
    }
    LIMIT 100


## Compter

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    SELECT ?addr (COUNT(*) AS ?number)
    WHERE { 
    dbr:List_of_astronomers ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        owl:sameAs ?object.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770)
    BIND(SUBSTR(STR(?object), 1, 20) as ?addr)
    }
    GROUP BY ?addr
    ORDER BY DESC(?number)



<table>
  <tr>
    <th>addr</th>
    <th>number</th>
  </tr>
  <tr>
    <td><pre>http://d-nb.info/gnd/1</pre></td>
    <td><pre>391</pre></td>
  </tr>
  <tr>
    <td><pre>http://www.wikidata.or</pre></td>
    <td><pre>369</pre></td>
  </tr>
  <tr>
    <td><pre>https://global.dbpedia</pre></td>
    <td><pre>367</pre></td>
  </tr>
  <tr>
    <td><pre>http://rdf.freebase.co</pre></td>
    <td><pre>347</pre></td>
  </tr>
  <tr>
    <td><pre>http://yago-knowledge.</pre></td>
    <td><pre>335</pre></td>
  </tr>
  <tr>
    <td><pre>http://fr.dbpedia.org/</pre></td>
    <td><pre>316</pre></td>
  </tr>
  <tr>
    <td><pre>http://de.dbpedia.org/</pre></td>
    <td><pre>300</pre></td>
  </tr>
  <tr>
    <td><pre>http://es.dbpedia.org/</pre></td>
    <td><pre>282</pre></td>
  </tr>
  <tr>
    <td><pre>http://ru.dbpedia.org/</pre></td>
    <td><pre>272</pre></td>
  </tr>
  <tr>
    <td><pre>http://it.dbpedia.org/</pre></td>
    <td><pre>265</pre></td>
  </tr>
  </table>


## GND


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>

    SELECT ?person ?object
    WHERE { 
    dbr:List_of_astronomers ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        owl:sameAs ?object.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770 && CONTAINS(STR(?object), 'gnd'))
    }
    LIMIT 10



### Vérifier sur le point d'accès SPARQL de la GND

SPARQL Endpoint: https://sparql.dnb.de

Inspecter la forme des URI des personnes

    PREFIX gndo: <https://d-nb.info/standards/elementset/gnd#>
    SELECT * WHERE {
    ?s a gndo:DifferentiatedPerson
    }
    LIMIT 10


http://d-nb.info/gnd/116461357

https://d-nb.info/gnd/100000355



### Documentation GND

https://www.dnb.de/EN/Professionell/Metadatendienste/Datenbezug/LDS/lds.html?nn=58244#doc328464bodyText2

Example: 
https://d-nb.info/118540238/about/lds

Noter le  http**s**


### Requête sur le point d'accès SPARQL de la GND

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

    SELECT ?person ?gndUri ?p1 ?o1
    WHERE {

    SERVICE <https://dbpedia.org/sparql> {
    SELECT ?person ?gndUri ?object
        WHERE { 
        dbr:List_of_astronomers ?p ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate ;
            owl:sameAs ?object.
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
            FILTER ( ?birthYear > 1770 && CONTAINS(STR(?object), 'gnd'))
            BIND( URI(REPLACE(STR(?object), 'http', 'https'))  AS ?gndUri)
        }
        LIMIT 3
    }
    
    ?gndUri ?p1 ?o1
    }


### Informations disponibles

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

    SELECT ?p1 (COUNT(*) as ?number)
    WHERE {

    SERVICE <https://dbpedia.org/sparql> {
    SELECT ?person ?gndUri ?object
        WHERE { 
        dbr:List_of_astronomers ?p ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate ;
            owl:sameAs ?object.
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
            FILTER ( ?birthYear > 1770 && CONTAINS(STR(?object), 'gnd'))
            BIND( URI(REPLACE(STR(?object), 'http', 'https'))  AS ?gndUri)
        }
        
    }
    
    ?gndUri ?p1 ?o1
    }
    GROUP BY ?p1
    ORDER BY DESC(?number) 

    



## global.dbpedia.org 

Apparemment le projet n'a pas eu de suite


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?person ?object
    WHERE { 
    dbr:List_of_astronomers ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        <http://www.w3.org/2002/07/owl#sameAs> ?object.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770 && CONTAINS(STR(?object) , 'global'))
    }
    LIMIT 10


### GlobalFactSyncRE 

https://global.dbpedia.org/?s=https%3A%2F%2Fglobal.dbpedia.org%2Fid%2FewCm

https://meta.wikimedia.org/wiki/Grants:Project/DBpedia/GlobalFactSyncRE





## Wikidata

### Liste d'URIs depuis DBpedia

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?person ?object
    WHERE { 
    dbr:List_of_astronomers ?p ?person.
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

    PREFIX wdt: <http://www.wikidata.org/prop/direct/>
    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>   
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>


    SELECT  ?wdPerson ?wdPersonLabel ?uriBNF
    WHERE {
    


    SERVICE <https://dbpedia.org/sparql> {
        SELECT ?wikidataUri #?person ?birthYear
        WHERE {            
        dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate.
        ?person <http://www.w3.org/2002/07/owl#sameAs> ?wikidataUri.
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
            FILTER ( ?birthYear > 1770 && CONTAINS(STR(?wikidataUri), 'wikidata'))
        }
        LIMIT 10
        } 
    
    
    ?wikidataUri wdt:P31 wd:Q5; # classe personne humaine
         #   wdt:P106 wd:Q1106 ;
                 wdt:P268 ?uriBNF.

    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
    }
     
     


It does not work, timeout !



### Les pages Wikipedia, vues depuis Wikidata

    select *
    where {
    <http://www.wikidata.org/entity/Q91> ^schema:about ?article .
        ?article schema:isPartOf <https://en.wikipedia.org/>
        }


https://en.wikipedia.org/wiki/Galileo_Galilei


### Les astronomes vus depuis Wikidata

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


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>   
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>


SELECT DISTINCT  ?wdPerson ?wdPersonLabel ?article ?p ?s ?sLabel
WHERE {?wdPerson wdt:P31 wd:Q5;
        wdt:P106 wd:Q11063;
                ^schema:about ?article .
    ?article schema:isPartOf <https://en.wikipedia.org/>
    
    }
limit 200







### Query on DBpedia


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
        

    SELECT ?person ?object ?pw ?o
    WHERE {
        {
            SELECT ?person ?object
                WHERE { 
                dbr:List_of_astronomers ?p ?person.
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

It does not work! "Must have SELECT privileges on view DB.DBA.SPARQL_SINV_2 for group ID 110 (SPARQL), user ID 110 (SPARQL)"



### Using a third SPARQL endpoint

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>   
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
prefix bd: <http://www.bigdata.com/rdf#>

SELECT ?person ?wikidataUri ?p1 ?o1 ?o1Label
WHERE {

    
    {SERVICE <https://dbpedia.org/sparql> {
    SELECT ?person ?wikidataUri
        WHERE { 
        dbr:List_of_astronomers ?p ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate ;
            <http://www.w3.org/2002/07/owl#sameAs> ?wikidataUri.
            BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
            FILTER ( ?birthYear > 1770 && CONTAINS(STR(?wikidataUri), 'wikidata'))
        }
        LIMIT 5
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

### Compter les propriétés

Fonctionnne sur Yago mais non Allegograph

    PREFIX wikibase: <http://wikiba.se/ontology#>
    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>   
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    prefix bd: <http://www.bigdata.com/rdf#>

    SELECT ?p1 ?propLabel (COUNT(*) as ?number)
    WHERE {

        
        {SERVICE <https://dbpedia.org/sparql> {
        SELECT ?person ?wikidataUri
            WHERE { 
            dbr:List_of_astronomers ?p ?person.
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
        {SELECT ?wikidataUri ?p1  ?o1 ?o1Label ?propLabel
        WHERE {
            ?wikidataUri ?p1 ?o1.
        ?prop wikibase:directClaim ?p1.
        FILTER(CONTAINS(STR(?p1), 'direct'))
            
        SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
        
        }
        }
        }
    }
    group BY ?p1 ?propLabel
    order by desc(?number)






### Test dans Wikidata sur un individu

IRIs:
* http://www.wikidata.org/entity/Q91
* http://www.wikidata.org/entity/Q739455


SELECT DISTINCT ?p ?o ?oLabel
where {<http://www.wikidata.org/entity/Q705048> ?p ?o .
      FILTER(CONTAINS(STR(?p), 'direct'))
      SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
      }
limit 100





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