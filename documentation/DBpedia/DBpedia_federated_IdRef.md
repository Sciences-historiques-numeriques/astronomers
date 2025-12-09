
## Explorer les données de la BNF


### Chercher les URI dans Wikidata


Requête à exécuter sur le serveur Allegrograph


ATTENTION: observer la reécriture URI


```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT *
WHERE {
  ?s owl:sameAs ?wPerson;
          a dbo:Person.
  OPTIONAL {
  SERVICE <https://query.wikidata.org/sparql> {
            ?wPerson wdt:P269 ?idRef.
            BIND(URI(CONCAT('http://www.idref.fr/', ?idRef, '/id')) as ?uriIdRef)
      }     
    }
       
}
LIMIT 10

```


## Explorer les information disponibles au SUDIC/IdREf data

### Tester les URI

```sparql
select *
where {
    SERVICE <https://data.idref.fr/sparql> {
            <http://www.idref.fr/032799128/id> ?p ?o.
      }     
      }
```


```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?s ?wPerson ?idBNF ?p ?o
WHERE {
  ?s owl:sameAs ?wPerson;
          a dbo:Person.
  OPTIONAL {
  SERVICE <https://query.wikidata.org/sparql> {
            ?wPerson wdt:P269 ?idRef.
            BIND(URI(CONCAT('http://www.idref.fr/', ?idRef, '/id')) as ?uriIdRef)
      }     
    }
     
  OPTIONAL {
  SERVICE <https://data.bnf.fr/sparql> {
            ?uriBNF ?p ?o.
      }     
      }
  }
ORDER BY ?s ?p

  LIMIT 300
       

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
  {?s owl:sameAs ?wPerson;
          a dbo:Person.
  SERVICE <https://query.wikidata.org/sparql> {
            ?wPerson wdt:P268 ?idBNF.
            BIND(URI(CONCAT('http://data.bnf.fr/ark:/12148/cb', ?idBNF, '#about')) as ?uriBNF)
      }
  }     
  OPTIONAL {
  SERVICE <https://data.bnf.fr/sparql> {
            ?uriBNF ?p ?o.
      }     
      }
  }
  GROUP BY ?p
  order by desc(?number)
       

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
  {?s owl:sameAs ?wPerson;
          a dbo:Person.
  SERVICE <https://query.wikidata.org/sparql> {
            ?wPerson wdt:P268 ?idBNF.
            BIND(URI(CONCAT('http://data.bnf.fr/ark:/12148/cb', ?idBNF, '#about')) as ?uriBNF)
      }
  }     
  OPTIONAL 
  {
  SERVICE <https://data.bnf.fr/sparql> {
            ?s2 ?p ?uriBNF 
      }     
     }
  }
  GROUP BY ?p
  order by desc(?number)
```
       


## Identifier des ressources bibliographiques


### Chosir une propriété: auteur



* <http://id.loc.gov/vocabulary/relators/aut>
  * Vocabulaire de la Library of congress
  * pas intéressant

* <http://purl.org/dc/terms/creator>
* <http://purl.org/dc/terms/subject>



```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?p2 (count(*) as ?number)
WHERE {
  {?s owl:sameAs ?wPerson;
          a dbo:Person.
  SERVICE <https://query.wikidata.org/sparql> {
            ?wPerson wdt:P268 ?idBNF.
            BIND(URI(CONCAT('http://data.bnf.fr/ark:/12148/cb', ?idBNF, '#about')) as ?uriBNF)
      }
  }     
  OPTIONAL 
  {
  SERVICE <https://data.bnf.fr/sparql> {
            ?s2 <http://purl.org/dc/terms/subject> ?uriBNF;

            ?p2 ?o2
             
      }     
     }
  }
  GROUP BY ?p2
  ORDER BY DESC(?number)
```
       