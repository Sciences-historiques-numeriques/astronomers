# Exploration de DBpedia
## 'Fiche' d'une personne

Il ne s'agit pas d'une fiche mais d'une collection de triplets

```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
SELECT *
WHERE 
{
  dbr:Giovanni_Domenico_Cassini ?p ?o
}
```

```sparql
### Afficher une propriété seulement une fois
PREFIX dbr: <http://dbpedia.org/resource/>
SELECT DISTINCT ?p
WHERE 
{
  dbr:Giovanni_Domenico_Cassini ?p ?o
}
```

```sparql
### Regrouper et compter les propriétés disponibles
PREFIX dbr: <http://dbpedia.org/resource/>
SELECT ?p (COUNT(*) as ?number)
WHERE 
{
  dbr:Giovanni_Domenico_Cassini ?p ?o
}
GROUP BY ?p
ORDER BY DESC(?number)

```
## Liste de ma population

Créer la liste de la population à traiter dans DBpedia

```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>

SELECT DISTINCT ?person ?birthDate
WHERE { ?person dbo:occupation dbr:Astronomer .
    OPTIONAL { 
               ?person dbo:birthYear ?birthDate .
               }
      }
LIMIT 5

```

```sparql

```

```sparql

```

```sparql
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT ?o1 
WHERE {
   dbr:List_of_astronomers ?p ?person.
   ?o1 a dbo:Person;
        dbo:birthDate ?birthDate.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( ?birthYear < 1770) 
  }
```

```sparql

```
