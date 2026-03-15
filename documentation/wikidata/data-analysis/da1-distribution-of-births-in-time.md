# Distribution of births and genders in time






## Explore available data

### Count available triples
```sparql
### Number of triples in the graph
SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?s ?p ?o}
}
```


### Inspect the labels

Number of persons with more than one label : 696

```sparql
### 
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

# This part of the query counts how many persons have more then one label 
SELECT (COUNT(*) as ?n)
WHERE {
  # This part of the query finds persons with more than one label  
  SELECT (COUNT(*) as ?n)
  WHERE {
      GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
          {?s a wd:Q5;
               rdfs:label ?label}
  }
  GROUP BY ?s
  HAVING (?n > 1)
}
```




### Explore the gender

#### Group by and count genders

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?genLabel (COUNT(*) as ?n)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
  {
    ?s a wd:Q5.   
    OPTIONAL {
      ?s wdt:P21 ?gen.
      ?gen rdfs:label ?genLabel
    }
  }
}
GROUP BY ?genLabel
ORDER BY DESC(?n)
```

#### Persons with more than one gender

| s                                           | labels                       |
| ------------------------------------------- | ---------------------------- |
| <http://www.wikidata.org/entity/Q67541374>  | female \| male               |
| <http://www.wikidata.org/entity/Q136969949> | female \| male               |
| <http://www.wikidata.org/entity/Q42207726>  | transmasculine \| non-binary |
| <http://www.wikidata.org/entity/Q57136415>  | female \| male               |
| <http://www.wikidata.org/entity/Q108220002> | female \| male               |
| <http://www.wikidata.org/entity/Q107165887> | female \| male               |


```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?s (GROUP_CONCAT(?genLabel; separator= ' | ') AS ?labels)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
      ?s wdt:P21 ?gen.
      ?gen rdfs:label ?genLabel
  }
 } 
GROUP BY ?s
HAVING(COUNT(*) > 1)

```






## Prepare data to analyse

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT ?s ?label ?birthDate ?genLabel
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {
            ## A property path passes through 
            # two or more properties
            ?s wdt:P21 / rdfs:label ?genLabel;
            rdfs:label ?label;
            wdt:P569 ?birthDate.
          }
}
ORDER BY ?birthDate
LIMIT 10
```



### Number of persons (with double labels, genders, etc.)

Nuber: 32956

```sparql

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {
          # ?s wdt:P31 wd:Q5 
          ?s a wd:Q5
          }
}
```



### Take ony person only once (FINAL QUERY)

This is the query to prepare the data for the analysis

```
### If there are two values for a property we take just one

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>


SELECT  ?s (MIN(?label) as ?label) (xsd:integer(MIN(?birthDate)) as ?birthDate) (MIN(?genLabel) AS ?genLabel)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?s a wd:Q5;
            wdt:P21 ?gen;
            rdfs:label ?label;
            wdt:P569 ?birthDate.
        ?gen rdfs:label ?genLabel  
          }
}
GROUP BY ?s
LIMIT 10

```

#### Number of real persons, without double labels, etc.

Number: 32693

```sparql

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT (COUNT(*) as ?n)
WHERE {
    SELECT  ?s (MIN(?label) as ?label) (xsd:integer(MIN(?birthDate)) as ?birthDate) (MIN(?genLabel) AS ?genLabel)
    WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
            {?s a wd:Q5;
                wdt:P21 ?gen;
                rdfs:label ?label;
                wdt:P569 ?birthDate.
            ?gen rdfs:label ?genLabel  
            }
    }
    GROUP BY ?s
}
```


## Export the data for analysis

Execute the query, export the data in CSV format and store the *birth-dates-gender.csv* file in the *notebooks_jupyter/wikidata_exploration/da1_data/* directory

```
### If there are two values for a property we take just one

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>


SELECT  ?s (MIN(?label) as ?label) (xsd:integer(MIN(?birthDate)) as ?birthDate) (MIN(?genLabel) AS ?genLabel)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?s a wd:Q5;
            wdt:P21 ?gen;
            rdfs:label ?label;
            wdt:P569 ?birthDate.
        ?gen rdfs:label ?genLabel  
          }
}
GROUP BY ?s

```















------

# reprendre


PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?n)
WHERE {
  SELECT ?s (COUNT(*) as ?n)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?s wdt:P21 ?gen}
}
GROUP BY ?s
HAVING (?n > 1)
}




```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?gen 
WHERE {
SELECT DISTINCT ?gen
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?s wdt:P21 ?gen}
}
}
```

VALUES ?vs {
<http://www.wikidata.org/entity/Q6581097> <http://www.wikidata.org/entity/Q6581072> <http://www.wikidata.org/entity/Q113124952> <http://www.wikidata.org/entity/Q48270> <http://www.wikidata.org/entity/Q2449503> <http://www.wikidata.org/entity/Q27679766> <http://www.wikidata.org/entity/Q1052281>
}




```sparql
### Number of persons per gender
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?gen (COUNT(*) as ?n)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?s wdt:P21 ?gen}
}
GROUP BY ?gen
#HAVING (?n > 1)
```

```sparql
### Number of persons per gender in relation to a period
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?gen (COUNT(*) as ?n)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?s wdt:P21 ?gen;
            wdt:P569 ?birthDate.
        FILTER (?birthDate < '1900')   
          }
}
GROUP BY ?gen
#HAVING (?n > 1)
```

```sparql
### Add the label to the gender

# This query will first retrieve all the genders, 
# then fetch in Wikidata the gender's labels

PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?gen ?genLabel
WHERE {  

    {SELECT DISTINCT ?gen
    WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>  
            {?s wdt:P21 ?gen}
    }
    }   

    SERVICE  <https://query.wikidata.org/sparql> {
        ## Add this clause in order to fill the variable  
        BIND(?gen as ?gen)
        ?gen rdfs:label ?genLabel
    FILTER(LANG(?genLabel) = 'en')
    }
}
```

```sparql
### Add the label to the gender

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

CONSTRUCT {
     ?gen rdfs:label ?genLabel
  
} 
WHERE {

  

    {SELECT DISTINCT ?gen
    WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>  
            {?s wdt:P21 ?gen}
    }
    }   

    SERVICE  <https://query.wikidata.org/sparql> {
        ## Add this clause in order to fill the variable  
        BIND(?gen as ?gen)
        BIND ( ?genLabel as ?genLabel)
        SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }  
    }
}
```

```sparql
### Add the label to the gender: INSERT

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md> 
INSERT {
     ?gen rdfs:label ?genLabel
  
} 
WHERE {  

    {SELECT DISTINCT ?gen
    WHERE {
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>  
            {?s wdt:P21 ?gen}
    }
    }   

    SERVICE  <https://query.wikidata.org/sparql> {
        ## Add this clause in order to fill the variable  
        BIND(?gen as ?gen)
        BIND ( ?genLabel as ?genLabel)
        SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }  
    }
}
```

```sparql
### Verify data insertion - using only Allegrograph data

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?gen ?genLabel ?n
WHERE
{
    {
    SELECT ?gen (COUNT(*) as ?n)
        WHERE {
            GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>  
                    {
            ?s wdt:P21 ?gen.
            }
        }  
        GROUP BY ?gen  
    }  
    ?gen rdfs:label ?genLabel
    }   

```
```sparql
### Ajouter le label pour la propriété "date of birth"

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

INSERT DATA {
GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
{    wdt:P569 rdfs:label "date of birth"
}  
}


```

```sparql
### Nombre de personnes avec propriétés de base sans doublons (choix aléatoire)

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

INSERT DATA {
GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
{    wdt:P21 rdfs:label "sex or gender"
}  
}


```
