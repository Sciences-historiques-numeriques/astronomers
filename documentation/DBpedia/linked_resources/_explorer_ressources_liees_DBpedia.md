# Situer DBPedia dans le web sémantique et chercher de nouvelles informations

Dans la logique des Linked Open Data (LOD) et du web sémantique on utilise les liens entre identifiants de ressources dans différents système d'information.

Ce document décrit les premiers pas de cette exploration.


## Ressources liées

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
        FILTER ( ?birthYear > 1770)
    }
    LIMIT 100

### Requête si le filtre sur la date n'est pas nécessaire


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?person ?object
    WHERE { 
    dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
    ?person a dbo:Person;
        <http://www.w3.org/2002/07/owl#sameAs> ?object.
    }
    LIMIT 100


## Compter

Serveur pour la requête: https://dbpedia.org/sparql

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    SELECT ?addr (COUNT(*) AS ?number)
    WHERE { 
    dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        owl:sameAs ?object.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770)
    BIND(SUBSTR(STR(?object), 1, 20) as ?addr)
    }
    GROUP BY ?addr
    ORDER BY DESC(?number)

### Requête sans filtre sur la date

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    SELECT ?addr (COUNT(*) AS ?number)
    WHERE { 
    dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
    ?person a dbo:Person;
        owl:sameAs ?object.
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


## L'exemple de la GND

Serveur pour la requête: https://dbpedia.org/sparql

On ajoute un filtre qui ne retient que les URIs qui contiennent la châine de caractères 'gnd', les URIs donc qui font partie du système de la Bibliothèque nationale allemande.


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>

    SELECT ?person ?object
    WHERE { 
    dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        owl:sameAs ?object.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770 && CONTAINS(STR(?object), 'gnd'))
    }
    LIMIT 10



### Vérifier sur le point d'accès SPARQL de la GND


SPARQL Endpoint: https://sparql.dnb.de

Inspecter la **forme des URIs** des personnes

    PREFIX gndo: <https://d-nb.info/standards/elementset/gnd#>
    SELECT * WHERE {
    ?s a gndo:DifferentiatedPerson
    }
    LIMIT 10


http://d-nb.info/gnd/116461357

http**s**://d-nb.info/gnd/100000355

Noter le  http**s**


### Documentation GND

https://www.dnb.de/EN/Professionell/Metadatendienste/Datenbezug/LDS/lds.html?nn=58244#doc328464bodyText2

Example: 
https://d-nb.info/118540238/about/lds


&nbsp;


### Requête sur le point d'accès SPARQL de la GND


SPARQL Endpoint: https://sparql.dnb.de

Le point important à noter est qu'on va exécuter la requête sur le serveur de la Bibliothèque nationale allemande, et que depuis ce serveur on vient sur DBpedia chercher la population (avec la clause SERVICE, cf. [documentation](https://www.w3.org/TR/2013/REC-sparql11-federated-query-20130321/#simpleService)), puis on cherche dans la GND les informations concernant cette population.

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

    SELECT ?person ?gndUri ?p1 ?o1
    WHERE {

    SERVICE <https://dbpedia.org/sparql> {
    SELECT ?person ?gndUri ?object
        WHERE { 
        dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
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


### Compter et inspecter les informations disponibles

SPARQL Endpoint: https://sparql.dnb.de

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

    SELECT ?p1 (COUNT(*) as ?number)
    WHERE {

    SERVICE <https://dbpedia.org/sparql> {
    SELECT ?person ?gndUri ?object
        WHERE { 
        dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
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

    
### GND Ontology

[Lien vers la documentation de l'ontologie](https://d-nb.info/standards/elementset/gnd#publication)

"GND stands for Gemeinsame Normdatei (Integrated Authority File) and offers a broad range of elements to describe authorities. The GND originates from the German library community and aims to solve the name ambiguity problem in the library world."



&nbsp;



## global.dbpedia.org 

Apparemment le projet n'a pas eu de suite ou il a uniquement servi à enrichir les relations owl:sameAs



    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?person ?object
    WHERE { 
    dbr:List_of_astronomers dbo:wikiPageWikiLink ?person.
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


