## Import the data into a triplestore


&nbsp;


In this notebook we describe the steps needed to import the data into your own triplestore.

The triplestore can be local or online. The configuration of the access has to be managed at the level of the sparqlbook plugin and a connection must be active in order to execute these queries.

First we check the basic properties of the population: name, gender, year of birth.

```sparql
PPREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT DISTINCT ?item  ?gender ?year ?itemLabel
        WHERE {

        ## note the service address            
        SERVICE <https://query.wikidata.org/sparql>
            {
            {?item wdt:P106 wd:Q11063}  # astronomer
            UNION
            {?item wdt:P101 wd:Q333}     # astronomy
            UNION
            {?item wdt:P106 wd:Q169470}  # physicist
            UNION
            {?item wdt:P101 wd:Q413}     # physics   
          
            ?item wdt:P31 wd:Q5;  # Any instance of a human.
                wdt:P569 ?birthDate; # It must necessarily have a birth date property
                wdt:P21 ?gender. # It must necessarily have a gender property
        BIND(year(?birthDate) as ?year)
        #BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981 )
    
        OPTIONAL {
	     ?item rdfs:label ?itemLabel.
        FILTER(LANG(?itemLabel) = 'en')
    }
        

        ## No name is added at this stage
        }
        }
        LIMIT 10
    
```


### Count number of persons to import

32781 personnes le 8 mars 2026

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT (count(*) as ?effectif)
WHERE {
    SELECT DISTINCT ?item  ?gender ?year
            WHERE {

            ## note the service address            
            SERVICE <https://query.wikidata.org/sparql>
                {
                {?item wdt:P106 wd:Q11063}  # astronomer
                UNION
                {?item wdt:P101 wd:Q333}     # astronomy
                UNION
                {?item wdt:P106 wd:Q169470}  # physicist
                UNION
                {?item wdt:P101 wd:Q413}     # physics   
            
                ?item wdt:P31 wd:Q5;  # Any instance of a human.
                    wdt:P569 ?birthDate; # It must necessarily have a birth date property
                    wdt:P21 ?gender. # It must necessarily have a gender property
            BIND(year(?birthDate) as ?year)
            #BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
            FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981 )
            

            ## No name is added at this stage
            }
            }
}
```

### Preparing to import data

* Here we use the CONSTRUCT query to prepare the triples for import into a graph database.
* We limit the test to a few rows to avoid displaying thousands of them.
* Inspect and check the triplets that are generated.
* Reuse if possible the Wikidata properties 

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

CONSTRUCT 
        {
           ?item wdt:P21 ?gender.
           ?item  wdt:P569 ?year.
           # ?item  wdt:P31 wd:Q5.
           # Noter qu'on modifie pour disposer de la propriété standard
           # pour déclarer l'appartenance d'une instance à une classe
           ?item  rdf:type wd:Q5. }
        
        WHERE {

        ## note the service address            
        SERVICE <https://query.wikidata.org/sparql>
            {
            {?item wdt:P106 wd:Q11063}  # astronomer
            UNION
            {?item wdt:P101 wd:Q333}     # astronomy
            UNION
            {?item wdt:P106 wd:Q169470}  # physicist
            UNION
            {?item wdt:P101 wd:Q413}     # physics   
          
            ?item wdt:P31 wd:Q5;  # Any instance of a human.
                wdt:P569 ?birthDate;
                wdt:P21 ?gender.
        BIND(year(?birthDate) as ?year)
        #BIND(xsd:integer(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2")) AS ?year)
        FILTER(?year > 1780  && ?year < 1981) 

        
        }
        }
        LIMIT 5
    

```
### Import the triples into a dedicated graph

Two import strategies are possible: 
* [to be preferred] directly in your triplestore using a federated query
  * the query can be executed on a sparql-book 
  * or directly in the query page of your triplestore
* directly in Wikidata with export of the data and then import to your triplestore 
  * execute a CONTRUCT query with the complete data (without the SERVICE and LIMIT clause) and export it to the Turtle format (suffix: .ttl)
  * then import the data into your triplestore using the import graphical interface


This is the recommended format for a graph URI:
```
<https://attereb.github.io/astronomers/graphs-defs.html#wikidata>
```

Or expressed in a generic way:
```
<https://[your girhub pseudo].github.io/[your repo name]/graphs-defs.html#wikidata>
```


The graph URI is in fact a URL pointing to a page with the description of the [imported data](../graphs/wikidata-imported-data.md)

noter pour écrire l'URL doit être /astronphysicists

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

INSERT {

        ### Note that the data is imported into a named graph and not the DEFAULT one
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?item  wdt:P21 ?gender.
           ?item wdt:P569 ?year. 
           # ?item  wdt:P31 wd:Q5.
           # modifier pour disposer de la propriété standard
           ?item  rdf:type wd:Q5.
           }
}
        
        WHERE {
        ## note the service address            
        SERVICE <https://query.wikidata.org/sparql>
            {
            {?item wdt:P106 wd:Q11063}  # astronomer
            UNION
            {?item wdt:P101 wd:Q333}     # astronomy
            UNION
            {?item wdt:P106 wd:Q169470}  # physicist
            UNION
            {?item wdt:P101 wd:Q413}     # physics   
          
            ?item wdt:P31 wd:Q5;  # Any instance of a human.
                wdt:P569 ?birthDate;
                wdt:P21 ?gender.
        BIND(year(?birthDate) as ?year)
        #BIND(xsd:integer(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2")) AS ?year)
        FILTER(?year > 1780  && ?year < 1981) 
        }
        }
        

```




### Inspect imported data
```
PREFIX wd: <http://www.wikidata.org/entity/>

SELECT *
WHERE {
  GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
  ?item  a wd:Q5.
        ?p ?o
        }
}
ORDER BY ?item ?p
LIMIT 20
        
```


### Count imported data

Imported: 32677

La différence d'effectif peut s'expliquer par des propriétés doubles.

```
PREFIX wd: <http://www.wikidata.org/entity/>

SELECT (COUNT(*) as ?number)
WHERE {
  GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
  ## deux expressions équivalentes
  # ?item  rdf:type wd:Q5
  ?item  a wd:Q5
        }
}
        
```


### Multiple dates
```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?number) ?item
WHERE {
  GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
  ## deux expressions équivalentes
  # ?item  rdf:type wd:Q5
  ?item  a wd:Q5;
   wdt:P569 ?birthDate.
        }
}
GROUP BY ?item
HAVING (COUNT(*) > 1)
```



### Multiple genders
```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?number) ?item
WHERE {
  GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
  ## deux expressions équivalentes
  # ?item  rdf:type wd:Q5
  ?item  a wd:Q5;
   wdt:P21 ?gender.
        }
}
GROUP BY ?item
HAVING (COUNT(*) > 1)
```




## Add labels


```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

# CONSTRUCT {?item rdfs:label ?itemLabel}
INSERT {
  GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> 
	{?item rdfs:label ?itemLabel}
}
WHERE {
  GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
  ## deux expressions équivalentes
  # ?item  rdf:type wd:Q5
  ?item  a wd:Q5.
  SERVICE <https://query.wikidata.org/sparql>
    {
      ?item rdfs:label ?itemLabel.
        FILTER(LANG(?itemLabel) = 'en')
    }
    
        }
}

```






### Find English labels

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT ?item ?itemLabel
WHERE {
  GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
  ## deux expressions équivalentes
  # ?item  rdf:type wd:Q5
  ?item  a wd:Q5.
  SERVICE <https://query.wikidata.org/sparql>
    {
      ?item rdfs:label ?itemLabel.
        FILTER(LANG(?itemLabel) = 'en')
    }
    
        }
}
LIMIT 10
```




#### Add a label to the class "Person"



```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

INSERT DATA {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
    {
        wd:Q5 rdfs:label "Person".
    }
}

```
### Add the gender class

```sparql
###  Inspect the genders:
# number of different countries

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?n)
WHERE
   {
   SELECT DISTINCT ?gender
   WHERE {
      GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
         {
            ?s wdt:P21 ?gender.
         }
      }
   }
```

```sparql
### Insert the class 'gender' for all types of gender
# Please note that strictly speaking Wikidata has no ontology,
# therefore no classes. We add this for our convenience

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {
   ?gender rdf:type wd:Q48264.
}
WHERE
   {
   SELECT DISTINCT ?gender
   WHERE {
         {
            ?s wdt:P21 ?gender.
         }
      }
   }
```

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

INSERT DATA {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
    {
        wd:Q48264 rdfs:label "Gender Identity".
    }
}

```
### Verify imported triples and add labels to genders

```sparql
### Number of triples in the graph
SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s ?p ?o}
}
```

```sparql
### Number of persons with more than one label : no person
SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s rdf:label ?o}
}
GROUP BY ?s
HAVING (?n > 1)
```
### Explore the gender

```sparql
### Number of persons having more than one gender
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?s (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s wdt:P21 ?gen}
}
GROUP BY ?s
HAVING (?n > 1)
```

```sparql
### Number of persons per gender
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?gen (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
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
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
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

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?gen ?genLabel
WHERE {

    

    {SELECT DISTINCT ?gen
    WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>    
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
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>    
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
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>    
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
            GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>  
                    {
            ?s wdt:P21 ?gen.
            }
        }    
        GROUP BY ?gen        
    }    
    ?gen rdfs:label ?genLabel
    }   

```
### Prepare data to analyse

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT ?s ?label ?birthDate ?genLabel
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
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

```sparql
### Number of persons

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {
          # ?s wdt:P31 wd:Q5 
          ?s a wd:Q5
          }
}
```

```sparql
### Personnes avec choix aléatoire de modalités pour variables doubles

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>


SELECT  ?s (MAX(?label) as ?label) (xsd:integer(MAX(?birthDate)) as ?birthDate) 
    (MAX(?gen) as ?gen) (MAX(?genLabel) AS ?genLabel)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s wdt:P21 ?gen;
            rdfs:label ?label;
            wdt:P569 ?birthDate.
        ?gen rdfs:label ?genLabel    
          }
}
GROUP BY ?s
LIMIT 10

```

```sparql
### Nombre de personnes avec propriétés de base sans doublons (choix aléatoire par MAX)

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT (COUNT(*) as ?n)
WHERE {
SELECT  ?s (MAX(?label) as ?label) (xsd:integer(MAX(?birthDate)) as ?birthDate) 
            (MAX(?gen) as ?gen) (MAX(?genLabel) AS ?genLabel)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s wdt:P21 ?gen;
            rdfs:label ?label;
            wdt:P569 ?birthDate.
          }
}
GROUP BY ?s
}
```

```sparql
### Ajouter le label pour la propriété "date of birth"

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

INSERT DATA {
GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
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
GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
{    wdt:P21 rdfs:label "sex or gender"
}    
}


```
