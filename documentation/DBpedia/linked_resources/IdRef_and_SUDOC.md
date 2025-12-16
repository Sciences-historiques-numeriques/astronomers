
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



## Inspecter les propriétés disponibles pour la population

### Les lister

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


## Propriétés entrantes

Les propriétés dont 
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
       
### Résultat

<table border="0" cellspacing="0" cellpadding="0" class="table-ta1"><colgroup><col width="474"/><col width="64"/></colgroup><tr class="row-ro1"><td colspan="2" style="text-align:left;width:10.836cm; " class="cell-ce1">
</td></tr>
<tr class="row-ro1"><td>p</td><td colspan="2" style="text-align:left;width:10.836cm; " class="cell-ce1">
<p>number</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-ce1">
<p>http://id.loc.gov/vocabulary/relators/aut</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>"8920"</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-ce1">
<p>http://purl.org/dc/terms/subject</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>"2449"</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-ce1">
<p>http://id.loc.gov/vocabulary/relators/aui</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>"513"</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-ce1">
<p>edt</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>"338"</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-ce1">
<p>pbd</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>"298"</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-ce1">
<p>foaf:primaryTopic</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>"266"</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-ce1">
<p>rcp</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>"219"</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-ce1">
<p>dcterms:contributor</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>"131"</p>
</td></tr>
</table>




## Identifier des ressources bibliographiques

Compter les propriétés sortantes des ouvrages dont les individus de notre population sont auteurs.

Noter ces propriétés:

| Propriété  | Nombre | 
|-------|-----|
| <http://id.loc.gov/vocabulary/relators/aut>| 38872       |
| <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> | 14721 |
| <http://purl.org/dc/terms/subject> | 10451                |
| <http://purl.org/dc/terms/bibliographicCitation> | 8985   |
| <http://purl.org/dc/elements/1.1/date> | 8045             |


&nbsp;

### Compter les propriétés sortantes des ouvrages dont les individus de notre population sont auteurs

```
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
            ?s <http://id.loc.gov/vocabulary/relators/aut> ?idrefPerson;
                     ?p ?o      
      }     
  }
GROUP BY ?p
ORDER BY DESC(?number)
```



### On inspecte les types pour les livres auteur

Noter les livres:
<http://purl.org/ontology/bibo/Book>


```
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?type (count(*) as ?number)
WHERE {
        ?person owl:sameAs ?idrefPerson;
            a dbo:Person.
    FILTER (CONTAINS(STR(?idrefPerson), 'idref'))  
     
  SERVICE <https://data.idref.fr/sparql> {
            ?s <http://id.loc.gov/vocabulary/relators/aut> ?idrefPerson;
                     <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> ?type
  
    
      }     
  }
GROUP BY ?type
ORDER BY DESC(?number)
```

## Publications de la population

On pourrait aussi chercher les publications concernant la population



```
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT DISTINCT ?person ?idrefPerson ?idrefPersonLabel 
                ?sDate ?biblioRef ?s
WHERE {
        ?person owl:sameAs ?idrefPerson;
            a dbo:Person.
    FILTER (CONTAINS(STR(?idrefPerson), 'idref'))  
     
  SERVICE <https://data.idref.fr/sparql> {
            ?s <http://id.loc.gov/vocabulary/relators/aut> ?idrefPerson;
              <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://purl.org/ontology/bibo/Book>;
             <http://purl.org/dc/terms/bibliographicCitation>  ?biblioRef;
             <http://purl.org/dc/elements/1.1/date> ?sDate.

    ?idrefPerson <http://xmlns.com/foaf/0.1/name> ?idrefPersonLabel.
  
    
      }     
  }
LIMIT 10
```





## Co-rédaction de livres

```
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT DISTINCT ?person ?idrefPerson ?idrefPersonLabel ?personAuthor ?personAuthorLabel  
     ?s ?sDate
WHERE {
        ?person owl:sameAs ?idrefPerson;
            a dbo:Person.
    FILTER (CONTAINS(STR(?idrefPerson), 'idref'))  
     
  SERVICE <https://data.idref.fr/sparql> {
            ?s <http://id.loc.gov/vocabulary/relators/aut> ?idrefPerson;
              <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://purl.org/ontology/bibo/Book>;
             <http://id.loc.gov/vocabulary/relators/aut> ?personAuthor;
             <http://purl.org/dc/elements/1.1/date> ?sDate.
    FILTER(?idrefPerson != ?personAuthor)

    ?personAuthor <http://xmlns.com/foaf/0.1/name> ?personAuthorLabel.
    ?idrefPerson <http://xmlns.com/foaf/0.1/name> ?idrefPersonLabel.
  
    
      }     
  }
LIMIT 10

```