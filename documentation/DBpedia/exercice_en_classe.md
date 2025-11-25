

https://en.wikipedia.org/wiki/John_Herschel  URL


http://dbpedia.org/resource/John_Herschel  URI IRI



PREFIX dbr: <http://dbpedia.org/resource/>
SELECT *
WHERE 
{
  dbr:John_Herschel ?p ?o
}



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