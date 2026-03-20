
```sparql
### Number of persons 
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5.}
}

```

```sparql
### Number of persons 
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?s
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5.}
}
LIMIT 3

```

```sparql


## Explorer les idref

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?item ?idRef
WHERE
    {

         GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
   
        ## Find the persons in the imported graph
        {SELECT ?item ?birthYear
        WHERE 
                {?item a wd:Q5}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        #OFFSET 20000
       LIMIT 1000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ?item wdt:P269 ?idRefId.
                BIND(URI(CONCAT('http://www.idref.fr/', ?idRefId, '/id')) as ?idRef)

            }
                
        }
ORDER BY ?birthYear 
LIMIT 5

```

```sparql
### Prepare the data to be imported
# With LIMIT clause 
## Apparently labels are not repeated if already available
# We therefore car integrate them directly in the INSERT below

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

CONSTRUCT {?item wdt:P269 ?idRef.}
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        #OFFSET 20000
        LIMIT 10

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # IdRef
                ?item wdt:P269 ?idRefId.
                BIND(URI(CONCAT('http://www.idref.fr/', ?idRefId, '/id')) as ?idRef)

            }
                
        }
```

```sparql
### Prepare the data to be imported
# With LIMIT clause 
## Apparently labels are not repeated if already available
# We therefore car integrate them directly in the INSERT below

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {?item wdt:P269 ?idRef.}
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        #OFFSET 10000
        #OFFSET 20000
        OFFSET 30000
        LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # IdRef
                ?item wdt:P269 ?idRefId.
                BIND(URI(CONCAT('http://www.idref.fr/', ?idRefId, '/id')) as ?idRef)

            }
                
        }
```
### Inspect imported information

```sparql
### Basic query about number of persons per employers

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        { ?item wdt:P269 ?idRefId
         }         
}


```

```sparql
### Insert the label of the property
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {wdt:P269 rdfs:label 'same as IdRef'.}
}
```
## Explore IdRef available information

```sparql

  PREFIX wdt: <http://www.wikidata.org/prop/direct/>
  PREFIX owl: <http://www.w3.org/2002/07/owl#>
  PREFIX wd: <http://www.wikidata.org/entity/>

  SELECT ?idRef
  WHERE {  
    { SELECT DISTINCT ?idRef
      WHERE {
          GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        { ?item wdt:P269 ?idRef
        }                   
      }
      LIMIT 5
    }
  }

      
```

```sparql

PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>

SELECT ?p ?o
WHERE {  
  { SELECT DISTINCT ?idRef
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
      { ?item wdt:P269 ?idRef
      }                   
    }
    OFFSET 10
    LIMIT 3
  }
  SERVICE <https://data.idref.fr/sparql> {
    ?idRef ?p ?o.
  }
}

```
## Inspect available information in IdRef / SUDOC
### Outgoing properties


We can observe that there is a number of instances maximum set for queries, so we observe the first 4000 persons.


The outgoing properties provide basic identification information, like names, _same as_ references to other data stores, citizenships, gender, births (as events)




```sparql
### Outgoing properties

PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>

SELECT ?p (COUNT(*) as ?n)
WHERE {  
  { SELECT DISTINCT ?idRef
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
      { ?item wdt:P269 ?idRef
      }                   
    }
    OFFSET 8000
    LIMIT 4000
  }
  SERVICE <https://data.idref.fr/sparql> {
    ?idRef ?p ?o.
  }
}
GROUP BY ?p
ORDER BY DESC(?n)
```
### Incoming properties


The information provided by the incoming properties (namely from the SUDOC collective catalogue of university libraries) is richer.

It is about authorship of books, being an editor, etc.

We can also see that many properties are expressed using the Library of Congress catalogue vocabulary. 

Examples of properties can be found [in this file](../Wikidata/idref_properties_20250425.csv).


```sparql
### Incoming properties
# The result is stored 
# in the 'Wikidata/idref_properties_20250425.csv' file

PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>

SELECT ?p (COUNT(*) as ?n)
WHERE {  
  { SELECT DISTINCT ?idRef
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
      { ?item wdt:P269 ?idRef
      }                   
    }
    LIMIT 4000
  }
  SERVICE <https://data.idref.fr/sparql> {
    ?s ?p ?idRef.
  }
}
GROUP BY ?p
ORDER BY DESC(?n)
```
## Inspect ABES data sources and available information

```sparql
### Resources base-URI in the ABES data repository
# substr	ns
# www.sudoc.fr	1062
# /hal.archive	608
# hub.abes.fr/	300
# www.idref.fr	163
# /zbmath.org/	50
# www.calames.	29
# www.numdam.o	22
# /orbi.uliege	13
# /archive-ouv	9





PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>

SELECT ?substr (STR(COUNT(*)) as ?ns) (COUNT(*) as ?n)
WHERE {  
  { SELECT DISTINCT ?idRef
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
      { ?item wdt:P269 ?idRef
      }                   
    }
    LIMIT 300
  }
  SERVICE <https://data.idref.fr/sparql> {
    ?s <http://id.loc.gov/vocabulary/relators/aut> ?idRef.
    BIND (substr(str(?s), 8, 12) as ?substr)
  }
}
GROUP BY ?substr
ORDER BY DESC(?n)
```

```sparql
### Properties of SUDOC items of which the population persons
# are authors


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>

SELECT ?p (COUNT(*) as ?n)
WHERE {  
  { SELECT DISTINCT ?idRef
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
      { ?item wdt:P269 ?idRef
      }                   
    }
    OFFSET 10000
    LIMIT 4000
  }
  SERVICE <https://data.idref.fr/sparql> {
    ?s <http://id.loc.gov/vocabulary/relators/aut> ?idRef;
         ?p ?o.
    FILTER (CONTAINS(STR(?s), 'sudoc'))
  }
}
GROUP BY ?p
HAVING (?n > 20)
ORDER BY DESC(?n)
```

```sparql
### Examples of books


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

SELECT DISTINCT ?s ?idRef ?author ?date ?bibliographicCitation ?dcterms_subject
WHERE {  
  { SELECT DISTINCT ?idRef
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
      { ?item wdt:P269 ?idRef
      }                   
    }
    OFFSET 10
    LIMIT 3
  }
  SERVICE <https://data.idref.fr/sparql> {
          
          { 
            {
              ?s marcrel:aut ?idRef.
              FILTER (CONTAINS(STR(?s), 'sudoc'))
            }
            
            ?s marcrel:aut ?author.
            FILTER (STR(?idRef) != STR(?author))
            }
            ?s dc11:date ?date;
                dcterms:bibliographicCitation	?bibliographicCitation.
        
        OPTIONAL {?s dcterms:subject	?dcterms_subject}
        #OPTIONAL {?s rdf:type	?rdf_type}
        #OPTIONAL {?s dc11:subject	?dc11_subject}
    
  }
}

ORDER BY ?s ?idRef ?author ?date
```

```sparql
### Properties of journal articles of which the population persons
# are authors
## Cf. https://scienceplus.abes.fr/ 


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>

SELECT ?p (COUNT(*) as ?n)
WHERE {  
  { SELECT DISTINCT ?idRef
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
      { ?item wdt:P269 ?idRef
      }                   
    }
    LIMIT 1000
  }
  SERVICE <https://data.idref.fr/sparql> {
    ?s <http://id.loc.gov/vocabulary/relators/aut> ?idRef;
         ?p ?o.
    FILTER (CONTAINS(STR(?s), 'hub.abes'))
  }
}
GROUP BY ?p
ORDER BY DESC(?n)
```

```sparql
### Examples of periodical articles


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

SELECT DISTINCT ?s ?idRef ?author ?date ?title ?dcterms_subject
WHERE {  
  { SELECT DISTINCT ?idRef
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
      { ?item wdt:P269 ?idRef
      }                   
    }
    LIMIT 7
  }
  SERVICE <https://data.idref.fr/sparql> {
        ?s marcrel:aut ?idRef;
            marcrel:aut ?author;
            dc11:date	?date;
            dcterms:title	?title.
        FILTER (STR(?idRef) != STR(?author))
        FILTER (CONTAINS(STR(?s), 'hub.abes'))
        OPTIONAL {?s dcterms:subject	?dcterms_subject}
        #OPTIONAL {?s rdf:type	?rdf_type}
        #OPTIONAL {?s dc11:subject	?dc11_subject}
    
  }
}

ORDER BY ?s ?idRef ?author ?date
```
## Import SUDOC publications

```sparql
### Examples of books


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

SELECT DISTINCT ?s ?idRef
WHERE {  
  { SELECT DISTINCT ?idRef
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
      { ?item wdt:P269 ?idRef
      }                   
    }
    LIMIT 7
  }
  SERVICE <https://data.idref.fr/sparql> {
        ?s marcrel:aut ?idRef.
    FILTER (CONTAINS(STR(?s), 'sudoc'))
  }
}
ORDER BY ?s ?idRef 
```

```sparql
### Import SUDOC bibliographic references


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>


INSERT {GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
      {?s marcrel:aut ?idRef}
      } 
WHERE {  
  { SELECT DISTINCT ?idRef
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
      { ?item wdt:P269 ?idRef
      }                   
    }
    ### wdt:P269 same as IdRef 12770
    OFFSET 12000 # 9000 6000  3000 0
    LIMIT 3000
  }
  SERVICE <https://data.idref.fr/sparql> {
        ?s marcrel:aut ?idRef.
    ## Only works in SUDOC    
    FILTER (CONTAINS(STR(?s), 'sudoc'))
  }
}
```

```sparql
### Number of books and authors


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>


SELECT (COUNT(*) as ?n)
WHERE
   {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
      {?s marcrel:aut ?idRef}
       

  }      

```

```sparql
### Number of books and authors


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>


SELECT (COUNT(*) as ?n)
WHERE
   {
    SELECT ?s (COUNT(*) as ?auth_number)
    WHERE
    {GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
      {?s marcrel:aut ?idRef}
    }  
    GROUP BY ?s

  }      

```

```sparql
### Number of books and authors


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>


SELECT ?auth_number (COUNT(*) as ?n)
WHERE
   {
    SELECT ?s (COUNT(*) as ?auth_number)
    WHERE
    {GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
      {?s marcrel:aut ?idRef}
    }  
    GROUP BY ?s

  } 
  GROUP BY ?auth_number
  ORDER BY DESC(?auth_number)

```
## Get additional elements from ABES data


In order to collect this information, and put it into a specific graph, we will use a dedicated [Python jupyter notebook](../notebooks_jupyter/wikidata_exploration/wdt_idref_abes_get_additional_information.ipynb)

This is the [IdRef graph](../graphs/idref.md) we will use to store the information.

```sparql
### Resources authors and, optionally, editors


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

SELECT DISTINCT ?s ?date ?author ?editor
WHERE {  
  {
    SELECT DISTINCT ?s ?idRef ?editor
  WHERE {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
    {?s marcrel:aut ?idRef}
    } 
    OFFSET 30
    LIMIT 10
  }
  SERVICE <https://data.idref.fr/sparql> {
         ?s marcrel:aut ?author;
          dc11:date	?date.   
         OPTIONAL {?s marcrel:edt ?editor}
  }
}
ORDER BY ?s
```

```sparql
### Resources authors and, optionally, editors


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

CONSTRUCT {
  ?s marcrel:aut ?author.
 ?s marcrel:edt ?editor.
 }
WHERE {  
  {
    SELECT DISTINCT ?s ?idRef ?editor
  WHERE {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
    {?s marcrel:aut ?idRef}
    } 
    # OFFSET 100
    LIMIT 10
  }
  SERVICE <https://data.idref.fr/sparql> {
         ?s marcrel:aut ?author.   
         OPTIONAL {?s marcrel:edt ?editor}
  }
}
ORDER BY ?s
```
For the INSERT query see [this Python jupyter notebook](../notebooks_jupyter/wikidata_exploration/wdt_idref_abes_get_additional_information.ipynb)

```sparql
## Editors
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

SELECT (COUNT(*) as ?n)
WHERE {  
  {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
    {?s marcrel:edt ?editor}
    } 
  }
```

```sparql
## Authors
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

SELECT (COUNT(*) as ?n)
WHERE {  
  {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
    {?s marcrel:aut ?author}
    } 
  }
```
## Inspect graph properties

```sparql
### Propriétés dans le graphe

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?p ?label (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
        {?s ?p ?o.
        OPTIONAL {?p rdfs:label ?label}    
          }
}
GROUP BY ?p ?label
ORDER BY DESC(?n)
```
## Add correspondent classes to instances of the IdRef graph

We use here the classes provided by data.idref.fr


* Persons: http://xmlns.com/foaf/0.1/Person
* Bibliographic references: http://purl.org/ontology/bibo/Document


```sparql
### Types of bibliographic objects
# It appears that bibo:Document is associated to each instance

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

SELECT ?rdf_type (count(*) as ?n)
WHERE {  
  {
  SELECT DISTINCT ?s 
  WHERE {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
    {?s marcrel:aut ?author.
    } 
  }
  LIMIT 1000
  }

  SERVICE <https://data.idref.fr/sparql> {
         ?s rdf:type ?rdf_type.
  }
}
group by ?rdf_type
order by desc(?n)
```

```sparql
### Insert the class 'bibo:Document' for all publications

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX bibo: <http://purl.org/ontology/bibo/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>

WITH  <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
INSERT {
   ?s rdf:type bibo:Document.
}
WHERE
   {
   SELECT DISTINCT ?s
   WHERE {
         ?s marcrel:aut ?author
         } 
   }
```

```sparql
 
PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX bibo: <http://purl.org/ontology/bibo/>


SELECT (COUNT(*) as ?n) 
  WHERE {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
    {?document a bibo:Document.
    } 
  }
```

```sparql
### Insert the class 'foaf:Person' for all authors

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>

WITH  <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
INSERT {
   ?person rdf:type foaf:Person.
}
WHERE
   {
   SELECT DISTINCT ?person
   WHERE {
         ?s marcrel:aut ?person
         } 
   }
```

```sparql
### Insert the class 'foaf:Person' for all editors

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>

WITH  <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
INSERT {
   ?person rdf:type foaf:Person.
}
WHERE
   {
   SELECT DISTINCT ?person
   WHERE {
         ?s marcrel:edt ?person
         } 
   }
```

```sparql

```

```sparql
## Authors
PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

SELECT ?s ?author
WHERE {  
  {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
    {?s marcrel:aut ?author}
    } 
  }
  LIMIT 10
```

```sparql
## Graphe
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

SELECT ?s ?author_1 ?author_2
WHERE {  
  {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
    {?s marcrel:aut ?author_1;
        marcrel:aut ?author_2.
     FILTER(  str(?author_1) > str(?author_2))   
      }
    } 
  }
  LIMIT 10
```

```sparql
### ...


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

SELECT DISTINCT ?s ?date ?biblio
WHERE {  
  {
  SELECT DISTINCT ?s 
  WHERE {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
    {?s marcrel:aut ?author
    } 
  }
  LIMIT 15
  }
  SERVICE <https://data.idref.fr/sparql> {
         ?s  dc11:date	?date;
              #dcterms:bibliographicCitation ?biblio;
              rdf:type <http://purl.org/ontology/bibo/Book>

         #OPTIONAL  {?s dcterms:title	?title.}
        #OPTIONAL {?s dcterms:subject	?dcterms_subject}
        #
        #OPTIONAL {?s rdf:type	?rdf_type}
        #OPTIONAL {?s dc11:subject	?dc11_subject}
    
  }
}

#ORDER BY ?s ?idRef ?author ?date
```

```sparql
## Graphe
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>

SELECT ?s ?author_1 ?author_2
WHERE {  
  {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
    {?s marcrel:aut ?author_1;
        marcrel:aut ?author_2.
     FILTER(  str(?author_1) > str(?author_2))   
      }
    } 
  }
  LIMIT 10
```

```sparql
### Number of authors already in the database


PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX marcrel:	<http://id.loc.gov/vocabulary/relators/>
PREFIX dc11:	<http://purl.org/dc/elements/1.1/>


SELECT (COUNT(*) as ?n)
WHERE
   {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/idref.md>
      {?s marcrel:aut ?idRef}
       
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
      { ?item wdt:P269 ?idRef
      }  
  }      

```

```sparql

```
