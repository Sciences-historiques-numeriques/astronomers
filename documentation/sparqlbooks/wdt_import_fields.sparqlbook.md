# Import fields of activity of persons


In this notebook we import fields of activity of our populations and try to find ways to aggregate them

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
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?s ?label ?birthYear
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5;
            rdfs:label ?label;
            wdt:P569 ?birthYear}
}
ORDER BY ?s
LIMIT 3

```
## Fields

```sparql
## Explore fields

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?item ?birthYear ?field ?fieldLabel 
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item ?birthYear
        WHERE 
                {?item a wd:Q5;
                    wdt:P569 ?birthYear}
        ORDER BY ?item      
        #OFFSET 10000
        #OFFSET 20000
        LIMIT 100

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ?item wdt:P101 ?field.
                BIND (?fieldLabel as ?fieldLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
ORDER BY ?item ?field
limit 20

```

```sparql
## Explore fields

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT (COUNT(*) as ?n)
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item ?birthYear
        WHERE 
                {?item a wd:Q5}
        ORDER BY ?item      
        #OFFSET 10000
        OFFSET 20000
       LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ?item wdt:P101 ?field .
            }
                
        }

```

```sparql
## Group and count

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?field ?fieldLabel (COUNT(*) as ?n)
WHERE
    {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>

        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        #OFFSET 20000
       LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ?item wdt:P101 ?field.
                BIND (?fieldLabel as ?fieldLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
GROUP BY ?field ?fieldLabel
ORDER BY DESC(?n)
LIMIT 20

```

```sparql
## Group and count

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?field ?fieldLabel ?fieldClassLabel (COUNT(*) as ?n)
WHERE
    {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>

        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        #OFFSET 20000
       LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # field
                ?item wdt:P101 ?field.
                # instance of
                ?field wdt:P31 ?fieldClass.
                BIND (?fieldLabel as ?fieldLabel)
                BIND (?fieldClassLabel as ?fieldClassLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
GROUP BY ?field ?fieldLabel ?fieldClassLabel
ORDER BY DESC(?n)
LIMIT 20

```
### Import data

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

CONSTRUCT {?item wdt:P101 ?field.
            ?field rdfs:label ?fieldLabel}
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
        LIMIT 7

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ?item wdt:P101 ?field.
                BIND (?fieldLabel as ?fieldLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
```

```sparql
### This insert query has to be carried out directly on the Allegrograph server
## Also, you have to carry it out in three steps. The accepted limit by Wikidata 
## of instances in a variable ('item' in our case) appears to be 10000.
## You therefore have to have three steps for a population of around 23000 persons  

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {?item wdt:P101 ?field.
         ?field rdfs:label ?fieldLabel}
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
                ?item wdt:P101 ?field.
                BIND (?fieldLabel as ?fieldLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
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
  {wdt:P101 rdfs:label 'field'.}
}
```
### Add the field class

This is not properly speaking a class, but we use it here as such: wd:Q12737077

```sparql
###  Inspect the fields:
# number of different fields

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?n)
WHERE
   {
   SELECT DISTINCT ?field
   WHERE {
      GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
         {
            ?s wdt:P101 ?field.
         }
      }
   }
```

```sparql
### Insert the class 'field of work' for all the fields
# Please note that strictly speaking Wikidata has no ontology,
# therefore no classes. We add this for our convenience
# Also, Wikidata 'fields' are not explicitly associated 
# with the Q627436 'Field of work' concept. We retain this concept
# as more global than the parly overlapping Q1047113 'field of study'

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {
   ?field rdf:type wd:Q627436.
}
WHERE
   {
   SELECT DISTINCT ?field
   WHERE {
         {
            ?s wdt:P101 ?field.
         }
      }
   }
```

```sparql
### Ajouter le label pour le concept field

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

INSERT DATA {
GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
    {    wd:Q627436 rdfs:label "Field of Work".
    }    
}


```
### Inspect the available information

With the queries [in this sparqlbook](wdt_available_information.sparqlbook) you can inspect the available information

```sparql
### Basic query about persons' field

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?field ?fieldLabel (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item wdt:P101 ?field.
        OPTIONAL {?field rdfs:label ?fieldLabel}    
          }
}
GROUP BY ?field ?fieldLabel 
ORDER BY DESC(?n)
LIMIT 10
```
# La partie suivante est à reprendre


## Get the fields' parent fields ('classes')


Given the dispersion of fields observed in the [analysis notebook](../notebooks_jupyter/wikidata_exploration/wdt_fields_triplestore_exploration.ipynb), we try to obtain parent terms of fields to see if some groupings are possible.

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT (COUNT(*) as ?n)
WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item a wd:Q12737077.}
        }
         
```

```sparql
## 

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?field ?fieldLabel (COUNT(*) as ?n)
WHERE
    {
        ## Find the fields in the imported graph
        {SELECT DISTINCT ?item
        WHERE 
            {?item a wd:Q12737077.}
        ORDER BY ?item      
        LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # subclass of
                ?item wdt:P279 ?field.
                BIND (?fieldLabel as ?fieldLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
GROUP BY ?field ?fieldLabel
ORDER BY DESC(?n)
LIMIT 20

```

```sparql
## Prepare import

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

CONSTRUCT {
    ?item  wdt:P279 ?field.
    ?field rdfs:label ?fieldLabel.
    # rdf:type field
    ?field a wd:Q12737077.
    }
WHERE
    {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q12737077.}
        ORDER BY ?item      
        LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # subclass of
                ?item wdt:P279 ?field.
                BIND (?fieldLabel as ?fieldLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
ORDER BY DESC(?item)
LIMIT 5

```
### Insert parent fields

**WARNING** : if you repeat this INSERT query more than once, each time you will add one more level in the hierarchy of fields.

I repeated the INSERT *three times*, so I have three levels in my data.

The levels become the facto more then three because some higher level terms are used in the first and second levels, and then augmente with their parent and ancestors.

**IMPORTANT** : execute the classification levels' queries below after each insert and observe what happens

You will be able to observe that there are multiple parallel classifications in Wikidata, and the fact that of using the same class and parenthood property adds more levels than expected!

You can then transverse these levels with property paths.

```sparql
### Insert the label of the property

## This is needed just once

PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {wdt:P279 rdfs:label 'subclass of'.}
}
```

```sparql
### INSERT

## IMPORTANT : execute the classification levels' queries below 
# after each insert and observe what happens

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {
    ?item  wdt:P279 ?field.
    ?field rdfs:label ?fieldLabel.
    # rdf:type field
    ?field a wd:Q12737077.
    }
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q12737077.}
        ORDER BY ?item      
        LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # subclass of
                ?item wdt:P279 ?field.
                BIND (?fieldLabel as ?fieldLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }



```
### Inspect imported data

```sparql
### Propriétés des fields: outgoing

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?p ?label (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q12737077;
            ?p ?o.
        OPTIONAL {?p rdfs:label ?label}    
          }
}
GROUP BY ?p ?label
ORDER BY DESC(?n)
```

```sparql
### field classifications

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?birthYear ?o ?oLabel ?p ?o1 ?o1Label
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item a wd:Q5;
            wdt:P569 ?birthYear;
            wdt:P106 ?o.
        ?o a wd:Q12737077;
            wdt:P279 ?o1.
        OPTIONAL {?o rdfs:label ?oLabel}    
        OPTIONAL {?o1 rdfs:label ?o1Label}    
          }
}
ORDER BY ?s
LIMIT 10
```
#### First classification level

```sparql
### First classification level

# filled after first insert

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?parentfield ?parentfieldlabel (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5.
        
        # ?s wdt:P106 ?field.
        # ?field wdt:P279 ?parentfield
        ## property path:
        ?s  wdt:P106/wdt:P279  ?parentfield

        OPTIONAL {?parentfield rdfs:label ?parentfieldlabel}    
          }
}
GROUP BY ?parentfield ?parentfieldlabel 
ORDER BY DESC(?n)
LIMIT 20
```
#### Second classification level

```sparql
### Second classification level

# no result after first insert
# result after first insert

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?parentfield ?parentfieldlabel (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5.
        
        ## property path:
        ?s  wdt:P106/wdt:P279/wdt:P279  ?parentfield

        OPTIONAL {?parentfield rdfs:label ?parentfieldlabel}    
          }
}
GROUP BY ?parentfield ?parentfieldlabel 
ORDER BY DESC(?n)
LIMIT 20
```
#### Third classification level

```sparql
### Third classification level

# no result after first insert
# result after first insert ! 



PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?parentfield ?parentfieldlabel (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5.
        
        ## property path:
        ?s  wdt:P106/wdt:P279/wdt:P279/wdt:P279  ?parentfield

        OPTIONAL {?parentfield rdfs:label ?parentfieldlabel}    
          }
}
GROUP BY ?parentfield ?parentfieldlabel 
ORDER BY DESC(?n)
LIMIT 20
```

```sparql
### Third classification level

# explicit query path to check
# that there are no recursions



PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?parentfield ?parentfieldlabel (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5.
        
        ## property path:
        ?s  wdt:P106 ?c1.
        ?c1 wdt:P279 ?c2.
        ?c2 wdt:P279 ?c3.
        ?c3 wdt:P279  ?parentfield
        ## Avoid recursivity
        FILTER ( ?c2 != ?c1)
        FILTER ( ?c3 not in (?c1, ?c2) )
        FILTER (  ?parentfield not in (?c1, ?c2, ?c3) )

        OPTIONAL {?parentfield rdfs:label ?parentfieldlabel}    
          }
}
GROUP BY ?parentfield ?parentfieldlabel 
ORDER BY DESC(?n)
LIMIT 20
```
#### Fourth classification level

```sparql
### Fourth classification level

# no result after first insert
# result after first insert ! 



PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?parentfield ?parentfieldlabel (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5.
        
        ## property path:
        ?s  wdt:P106 ?c1.
        ?c1 wdt:P279 ?c2.
        ?c2 wdt:P279 ?c3.
        ?c3 wdt:P279 ?c4.
        ?c4 wdt:P279  ?parentfield
        FILTER ( ?c2 != ?c1)
        FILTER ( ?c3 not in (?c1, ?c2) )
        FILTER ( ?c4 not in (?c1, ?c2, ?c3) )
        FILTER (  ?parentfield not in (?c1, ?c2, ?c3, ?c4) )

        OPTIONAL {?parentfield rdfs:label ?parentfieldlabel}    
          }
}
GROUP BY ?parentfield ?parentfieldlabel 
ORDER BY DESC(?n)
LIMIT 20
```
### Test: get rid of the classifications and restart

**Beware**, the created parent and ancestor fields will also be deleted

**Beware**, do not execute theses queries after you added *instance of* 'classes' to the fields 

```sparql
### First classification level

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?s ?o ?oClass
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {
            ## retrieves all the classifications:
            ?s wdt:P279 ?o.
            ?o a ?oClass
          }
}
LIMIT 20
```

```sparql
### Delete all classifications, any level

## Execute directly in Allegrograph

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
# Protection #  DELETE {?s  wdt:P279 ?o .
    ?o rdfs:label ?fieldLabel.
    # rdf:type field
    ?o a wd:Q12737077.}
WHERE {
        {
            ## retrieves all the classifications:
            ?s wdt:P279 ?o.
          }
}
```
## Inspect the *instance of* metaclasses to fields

**CAUTION** : add these classifications ONLY after you are finished with your two (or more) inserts of fields as parents of other fields

```sparql
## 

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?field ?fieldLabel ?metaclass ?metaclassLabel ?n
WHERE
    {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        ## Find the persons in the imported graph
        {SELECT ?field ?fieldLabel (COUNT(*) as ?n)
        WHERE 
                {?item a wd:Q5.
                ?item wdt:P106 ?field.
                ?field rdfs:label ?fieldLabel}
        GROUP BY ?field ?fieldLabel      

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # instance of
                ?field wdt:P31 ?metaclass.
                BIND (?metaclassLabel as ?metaclassLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
ORDER BY DESC(?n)
LIMIT 30

```
**CONCLUSION**

We observe that this kind of classification does not allow to separate scientific and other fields.

We do not therefore move further in this direction
## Inspect parent fields fields

The aim is to find a way to distinguish between fields

```sparql
### Find fields and parent fields of parent fields

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?field ?fieldLabel
          ?parentfield ?parentfieldlabel 
          ?fieldField ?fieldFieldLabel
          ?knowledgeClassification ?knowledgeClassificationLabel
          ?parentKnowledgeClassification ?parentKnowledgeClassificationLabel
          (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {SELECT ?field ?fieldLabel
          ?parentfield ?parentfieldlabel 
          ?parentKnowledgeClassification ?parentKnowledgeClassificationLabel
        
        WHERE
        {?s a wd:Q5.
        
        ?s  wdt:P106 ?field.
        ?field  wdt:P279  ?parentfield.
        ?field rdfs:label ?fieldLabel.
        ?parentfield rdfs:label ?parentfieldlabel    
        }
        LIMIT 3000
        }

        SERVICE <https://query.wikidata.org/sparql>
          {
              # field of this field
              ?parentfield wdt:P425 ?fieldField.
              # instance of
              ?fieldField wdt:P31 ?knowledgeClassification.
              # subclass of
              ?knowledgeClassification wdt:P279 ?parentKnowledgeClassification.


              BIND (?fieldFieldLabel as ?fieldFieldLabel)
              BIND (?knowledgeClassificationLabel as ?knowledgeClassificationLabel)
              BIND (?parentKnowledgeClassificationLabel as ?parentKnowledgeClassificationLabel)
              SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
          }

}
GROUP BY ?field ?fieldLabel
          ?parentfield ?parentfieldlabel 
          ?fieldField ?fieldFieldLabel
          ?knowledgeClassification ?knowledgeClassificationLabel
          ?parentKnowledgeClassification ?parentKnowledgeClassificationLabel
ORDER BY DESC(?n)
LIMIT 20
```

```sparql
### Simplified query

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT DISTINCT 
?field ?fieldLabel ?parentField ?parentFieldLabel
?n
          #?parentKnowledgeClassification ?parentKnowledgeClassificationLabel 
          # (SUM(?n) as ?sn)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {
          SELECT ?field ?fieldLabel
          ?parentfield (COUNT(*) as ?n)
        
        WHERE
        {
          ?s a wd:Q5;  
              wdt:P106 ?field.
          ?field rdfs:label ?fieldLabel.
          ?field  wdt:P279  ?parentfield.
          }  
        GROUP BY ?field ?fieldLabel
          ?parentfield
        }

        SERVICE <https://query.wikidata.org/sparql>
          {
              # field of parent field / instance of /  subclass of  
              ?parentfield wdt:P425 / wdt:P31 ?parentField.
              # ?parentField wdt:P279 ?parentKnowledgeClassification.


              #BIND (?field as ?fieldLabel)
              BIND (?parentFieldLabel as ?parentFieldLabel)
              # BIND (?parentKnowledgeClassificationLabel as ?parentKnowledgeClassificationLabel)
              SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
          }

}
# GROUP BY ?field ?fieldLabel ?parentField ?parentFieldLabel
          # ?parentKnowledgeClassification ?parentKnowledgeClassificationLabel 
ORDER BY DESC(?n)
LIMIT 30
```
## A faire

* ajouter les 'metaclasses'
* ajouter les classes de metaclasses: metaclass, second-order class
* vérifier l'association de fields à metaclasses
* vérifier si les metaclasses permettent de classer
* vérifier si toute personne a des fields dans les principales metaclasses
* préparer des requêtes pour l'analyse

```sparql
### Create pairs of fields 
# and add the birth year of the person

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?item ?birthYear ?field ?fieldLabel ?field_1 ?field_1Label
WHERE
    {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>

        ## Find the persons in the imported graph
        {SELECT ?item ?birthYear
        WHERE 
                {?item a wd:Q5;
                    wdt:P569 ?birthYear}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        #OFFSET 20000
       LIMIT 5

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ?item wdt:P106 ?field.
                ?item wdt:P106 ?field_1.
                FILTER (str(?fieldLabel) < str(?field_1Label))
                BIND (?fieldLabel as ?fieldLabel)
                BIND (?field_1Label as ?field_1Label)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }


```
