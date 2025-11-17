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
