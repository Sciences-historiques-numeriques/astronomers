

https://en.wikipedia.org/wiki/John_Herschel  URL


http://dbpedia.org/resource/John_Herschel  URI IRI



PREFIX dbr: <http://dbpedia.org/resource/>
SELECT *
WHERE 
{
  dbr:John_Herschel ?p ?o
}


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



https://d-nb.info/gnd/100000355


### compter les ressources disponibles

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










PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT DISTINCT ?list
WHERE {
  dbr:Lists_of_singers dbo:wikiPageWikiLink  ?list.

FILTER(CONTAINS(STR(?list), 'http://dbpedia.org/resource/List_of'))
    }
LIMIT 100



PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT DISTINCT ?list (STR(?listLabel) AS ?label)
WHERE {
  dbr:Lists_of_singers dbo:wikiPageWikiLink  ?list.
?list rdfs:label ?listLabel.
FILTER(LANG(?listLabel) = 'en')
FILTER(CONTAINS(STR(?list), 'http://dbpedia.org/resource/List_of'))
    }
LIMIT 100


PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT DISTINCT ?person (STR(?psLabel) as ?persLabel) ?listId ?list 
WHERE {
  dbr:Lists_of_singers dbo:wikiPageWikiLink  ?list.
 ?list ?p ?person.
?person a dbo:Person;
     rdfs:label ?psLabel.
BIND(SUBSTR(STR(?list), STRLEN('http://dbpedia.org/resource/')+1) AS ?listId)
FILTER(CONTAINS(STR(?list), 'http://dbpedia.org/resource/List_of'))
FILTER(LANG(?psLabel) = 'en')
    }
LIMIT 100



PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT  ?listId  (COUNT(*) AS ?number)
WHERE {
  dbr:Lists_of_singers dbo:wikiPageWikiLink  ?list.
 ?list ?p ?person.
?person a dbo:Person
BIND(SUBSTR(STR(?list), STRLEN('http://dbpedia.org/resource/')+1) AS ?listId)
FILTER(CONTAINS(STR(?list), 'http://dbpedia.org/resource/List_of'))
    }
GROUP BY ?listId 
ORDER BY DESC(?number)










SELECT  ?p (COUNT(*) AS ?number)
WHERE 
{
  <http://dbpedia.org/resource/Giovanni_Domenico_Cassini> ?p ?o
}
GROUP BY ?p



PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT DISTINCT ?p ?o1 
WHERE { 
  dbr:List_of_astronomers ?p ?o1.
  ?o1 a dbo:Person.
  }
LIMIT 10




<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>

PREFIX <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

rdf:type


 	

632

http://dbpedia.org/ontology/award








PREFIX dbr: <http://dbpedia.org/resource/>
SELECT ?award
WHERE 
{
  dbr:John_Herschel <http://dbpedia.org/ontology/award> ?award
}


PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT ?award (COUNT(*) as ?eff)
WHERE { 
dbr:List_of_astronomers ?p ?o1.
?o1 a dbo:Person;
    dbo:award ?award.
  }
GROUP BY ?award
ORDER BY DESC(?eff)