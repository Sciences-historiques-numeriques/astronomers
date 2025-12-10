
## Explorer les données des notices d'autorité IdRef et du catalogue SUDOC


### Chercher les URI dans Wikidata


Requête à exécuter sur le **serveur Allegrograph** après avoir préalablement importé la population de DBpedia


ATTENTION: observer la reécriture URI


```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT *
WHERE {
  ?s owl:sameAs ?wdPerson;
          a dbo:Person.
  FILTER (CONTAINS(STR(?wdPerson), 'wikidata'))        
  SERVICE <https://query.wikidata.org/sparql> {
            ?wdPerson wdt:P269 ?idRef.
            BIND(URI(CONCAT('http://www.idref.fr/', ?idRef, '/id')) as ?uriIdRef)
      }     
}
LIMIT 10

```


## Explorer les information disponibles au SUDOC/IdRef data

### Tester les URI

```sparql
select *
where {
    SERVICE <https://data.idref.fr/sparql> {
            <http://www.idref.fr/032799128/id> ?p ?o.
      }     
      }
```



### Insérer les triples d'alignement DBPedia / Wikidata


```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

# CONSTRUCT {?person owl:sameAs ?uriIdRef.}
INSERT {?person owl:sameAs ?uriIdRef.}
    WHERE {

      ?person owl:sameAs ?wdPerson;
            a dbo:Person.
    FILTER (CONTAINS(STR(?wdPerson), 'wikidata'))        
    SERVICE <https://query.wikidata.org/sparql> {
              ?wdPerson wdt:P269 ?idRef.
              BIND(URI(CONCAT('http://www.idref.fr/', ?idRef, '/id')) as ?uriIdRef)
        }  
  }
```




```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?person ?idrefPerson ?p ?o
WHERE {
        ?person owl:sameAs ?idrefPerson;
            a dbo:Person.
    FILTER (CONTAINS(STR(?idrefPerson), 'idref'))  
     
  SERVICE <https://data.idref.fr/sparql> {
            ?idrefPerson ?p ?o.
      }     
  }
ORDER BY ?person
LIMIT 100
```

### Les compter


```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?p (count(*) as ?number)
WHERE {
        ?person owl:sameAs ?idrefPerson;
            a dbo:Person.
    FILTER (CONTAINS(STR(?idrefPerson), 'idref'))  
     
  SERVICE <https://data.idref.fr/sparql> {
            ?idrefPerson ?p ?o.
      }     
  }
GROUP BY ?p
ORDER BY DESC(?number)
```


### Propriétés entrantes

Utiliser ces propriétés pour trouver les ouvrages


```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?p (count(*) as ?number)
WHERE {
        ?person owl:sameAs ?idrefPerson;
            a dbo:Person.
    FILTER (CONTAINS(STR(?idrefPerson), 'idref'))  
     
  SERVICE <https://data.idref.fr/sparql> {
            ?s ?p ?idrefPerson.
      }     
  }
GROUP BY ?p
ORDER BY DESC(?number)
```
       


## Identifier des ressources bibliographiques


### Chosir une propriété: auteur

