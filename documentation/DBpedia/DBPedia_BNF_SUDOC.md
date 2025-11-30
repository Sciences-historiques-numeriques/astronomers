



PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?p
WHERE {
  
  {SELECT ?s
    WHERE {?s a foaf:Person}
    LIMIT 1000}
  
   ?s  ?p ?o
}



SELECT *
WHERE {
  
  {SELECT ?s
    WHERE {?s a foaf:Person
       }
}
  
   ?s  ?p ?o;
       bioel:biographicalInformation ?biogr.
  FILTER ( CONTAINS ( ?biogr, 'astron'))
}