# La Bibliothèque Nationale de France et le web sémantique

Documentation:
* BNF Data: https://data.bnf.fr
* [Semantic Web and data model] (https://data.bnf.fr/semanticweb)


## Explorer les données de la BNF


Requête à exécuter sur le SPARQL Endpoint BNF data: https://data.bnf.fr/sparql/

### Compter les personnes

4422263 le 9 décembre 2025

```
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT (COUNT(*) AS ?number)
WHERE {
  ?s a foaf:Person
}
```


### Explorer les propriétés des personnes

``` sparql
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?p (COUNT(*) AS ?number)
WHERE {
  
  {SELECT ?s
    WHERE {?s a foaf:Person}
    LIMIT 100}
  
   ?s  ?p ?o
}
GROUP BY ?p
ORDER BY DESC(?number)
```

#### Résultat

<table border="0" cellspacing="0" cellpadding="0" class="table-ta1"><colgroup><col width="474"/><col width="64"/></colgroup><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>p</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-Default">
<p>number</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://www.w3.org/2002/07/owl#sameAs</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>2890</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://xmlns.com/foaf/0.1/page</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>1000</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://www.w3.org/1999/02/22-rdf-syntax-ns#type</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>1000</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://xmlns.com/foaf/0.1/familyName</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>1000</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://rdvocab.info/ElementsGr2/languageOfThePerson</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>999</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://rdaregistry.info/Elements/a/#P50102</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>999</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://xmlns.com/foaf/0.1/name</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>979</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://xmlns.com/foaf/0.1/givenName</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>979</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://rdvocab.info/ElementsGr2/countryAssociatedWithThePerson</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>915</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://rdaregistry.info/Elements/a/#P50097</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>915</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://xmlns.com/foaf/0.1/gender</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>845</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://rdvocab.info/ElementsGr2/biographicalInformation</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>837</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://rdaregistry.info/Elements/a/#P50113</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>837</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://data.bnf.fr/ontology/bnf-onto/firstYear</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>719</p>
</td></tr><tr class="row-ro1"><td style="text-align:left;width:10.836cm; " class="cell-Default">
<p>http://xmlns.com/foaf/0.1/depiction</p>
</td><td style="text-align:left;width:1.473cm; " class="cell-ce1">
<p>524</p>
</td></tr>
</table>




### Explorer les notices biographiques

```sparql
PREFIX foaf: <http://xmlns.com/foaf/0.1/>

SELECT *
WHERE {
  
  {SELECT ?s
    WHERE {?s a foaf:Person
      }
  }

  ?s  ?p ?o;
      <http://rdaregistry.info/Elements/a/#P50113> ?biogr.
  FILTER ( CONTAINS ( ?biogr, 'astron'))
  }
  LIMIT 100
```




### Chercher les URI de la BNF dans Wikidata


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
  ?s owl:sameAs ?wPerson;
          a dbo:Person.
  OPTIONAL {
  SERVICE <https://query.wikidata.org/sparql> {
            ?wPerson wdt:P268 ?idBNF.
            BIND(URI(CONCAT('http://data.bnf.fr/ark:/12148/', ?idBNF, '#about')) as ?uriBNF)
      }     
    }
       
}
LIMIT 10

```


## Explorer les information disponibles à la BNF


```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?s ?wPerson ?idBNF ?p ?o
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

&nbsp;


## 'Nationalités'

N'apporte pas grand chose, des codes de pays mais non renseignés pour la plupart de ma population


http://rdaregistry.info/Elements/a/#P50097


```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


SELECT ?o (count(*) as ?number)
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
            ?uriBNF <http://rdaregistry.info/Elements/a/#P50097> ?o.
      }     
      }
  }
  GROUP BY ?o
  ORDER BY DESC(?number)
```


&nbsp;


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
       