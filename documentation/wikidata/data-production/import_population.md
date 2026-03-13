## Import the data into a triplestore

&nbsp;

In this notebook we describe the steps needed to import the data into your own triplestore. As a triplestore you can use Fuseki, or Allegrograph, or any other technology.

The triplestore can be local or online.

First we check the basic properties of the population: name, gender, year of birth.

Copy-paste this query to the SPARQL-editor of your choice (Fuseki, Allegrograph, etc.)

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
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

        BIND(year(?birthDate) as ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981 )
  
        OPTIONAL {
            # The item can have or not a gender property
            ?item wdt:P21 ?gender.
        }
  
        OPTIONAL {
	     ?item rdfs:label ?itemLabel.
        FILTER(LANG(?itemLabel) = 'en')
    }
        }
        }
        LIMIT 10
  
```

### Get the number of persons to be imported

39170 people on March 8, 2026

Note, however, that there are likely duplicate names, birthdates, etc., so the actual number is probably lower. We will discuss this further below.

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT (count(*) as ?effectif)
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
  
        BIND(year(?birthDate) as ?year)

        ## DO NOT USE THIS FILTER IF NOT NEEDED
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981 )
  
        OPTIONAL {
            # The item can have or not a gender property
            ?item wdt:P21 ?gender.
        }
  
        OPTIONAL {
	     ?item rdfs:label ?itemLabel.
        FILTER(LANG(?itemLabel) = 'en')
    }
   
        }
        }
```

### Preparing to import data

* Here we use the CONSTRUCT query to prepare the triples for import into a graph database.
* We limit the test to a few rows to avoid displaying thousands of them.
* Inspect and check the triplets that are generated.
* We reuse the Wikidata properties in the CONSTRUCT query unless there are more standard properties like *rdf:type*

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

CONSTRUCT 
        {
           ?item wdt:P21 ?gender.
           ?item  wdt:P569 ?year.
           ?item rdfs:label ?itemLabel.
           # ?item  wdt:P31 wd:Q5.
           # Noter qu'on modifie pour disposer de la propriété standard
           # afin de déclarer l'appartenance d'une instance à une classe
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
                wdt:P569 ?birthDate; # It must necessarily have a birth date property

        BIND(year(?birthDate) as ?year)

        ## DO NOT USE THIS FILTER IF NOT NEEDED
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981 )

        OPTIONAL {
            # The item can have or not a gender property
            ?item wdt:P21 ?gender.
        }
  
        OPTIONAL {
	     ?item rdfs:label ?itemLabel.
        FILTER(LANG(?itemLabel) = 'en')
    }
   
        }
        }
        LIMIT 5
  

```


## Import the triples into a dedicated graph



### Import approaches

There are two import approaches possible:

* [to be preferred] directly in your triplestore using a federated query (clause SERVICE <service.url>)
  * the query can be executed on a sparql-book
  * or directly in the query page of your triplestore
* [??? rewrite !!! wikidata changed the policy] directly in Wikidata with export of the data and then import to your triplestore
  * execute a CONTRUCT query with the complete data (without the SERVICE and LIMIT clause) and export it to the Turtle format (suffix: .ttl)
  * then import the data into your triplestore using the import graphical interface


&nbsp;

In a triplestore so called GRAPHs allow to keep together a set of triples. This kind of triples are then called *quads* because they have this form:


| g                         | s                     | p                     | o                     |
| ------------------------- | --------------------- | --------------------- | --------------------- |
| &lt;http://test1.org/graph1&gt; | &lt;http://test1.org/i1&gt; | &lt;http://test1.org/p1&gt; | &lt;http://test1.org/i2&gt; |
|                           |                       |                       |                       |

A *quad*: graph, subject, property, opject

A *triple*: subject, property, opject


A graph is a set of triples.

&nbsp;


This is the recommended format for a graph URI in this context:

```
<https://attereb.github.io/astronomers/graphs-defs.html#wikidata>

```

Or expressed in a generic way:

```
<https://[your girhub pseudo].github.io/[your repo name]/graphs-defs.html#wikidata>

```

The graph URI is in fact a URL pointing to a page with the description of the [imported data](https://historian.digital/astronomers/graphs-defs.html).





### Import triples into your RDF repository



```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

INSERT {

        ### Note that the data is imported into a named graph and not the DEFAULT one
        GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
        {?item  wdt:P21 ?gender.
           ?item wdt:P569 ?year. 
           ?item rdfs:label ?itemLabel.           # ?item  wdt:P31 wd:Q5.
           # modifier pour disposer de la propriété standard
           ?item  rdf:type wd:Q5.
           }
}
  
        WHERE {
  
  			SELECT DISTINCT ?item ?year ?gender ?itemLabel
  
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
                wdt:P569 ?birthDate. # It must necessarily have a birth date property



        BIND(year(?birthDate) as ?year)

        ## DO NOT USE THIS FILTER IF NOT NEEDED
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981 )
  
        OPTIONAL {
            # The item can have or not a gender property
            ?item wdt:P21 ?gender.
        }
  
        OPTIONAL {
	     ?item rdfs:label ?itemLabel.
        FILTER(LANG(?itemLabel) = 'en')
    }
   
        }
        }
    ORDER BY ?item 
    OFFSET 0
    LIMIT 10000
}

```

#### Query limit and solution

Wikidata limits exports to 10'000 entities. Therefore, if the population is greater than 10'000, we have to query in multiple steps.

First, we retrieve the first 10'000 triples (cf. the query above).

```
OFFSET 0
LIMIT 10000
```

Then, once the update is successful, we take the next ten thousand:

```
OFFSET 10000
LIMIT 20000
```

and so on, until you have all your population imported.




### Inspect imported data

```
PREFIX wd: <http://www.wikidata.org/entity/>

SELECT *
WHERE {
  GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
  ?item  a wd:Q5;
        ?p ?o.
        }
}
ORDER BY ?item ?p
LIMIT 20
  
```





#### Empty your graph and reimport the data

If for some reason you are not happy with the results, simply clear your graph and start again. 

However, be aware that this query will EMPTY YOUR GRAPH of all the triples.

```
CLEAR GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>

```


### Count imported data

Imported: 32677.



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

The difference in the number of elements can be explained by duplicate properties.

We must therefore inspect the properties.

This issue will be addressed when the data is prepared for analysis.



### Multiple dates

Inspect the pages of some persons in Wikidata: there will be two birth dates.

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
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

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

### Multiple labels

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT (COUNT(*) as ?number) ?item
WHERE {
  GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
  ## deux expressions équivalentes
  # ?item  rdf:type wd:Q5
  ?item  a wd:Q5;
    rdfs:label ?label.
        }
}
GROUP BY ?item
HAVING (COUNT(*) > 1)
```





### Find persons without labels

1911 persons

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT (COUNT(*) AS ?number)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
    ?item  a wd:Q5.
    MINUS { ?item rdfs:label ?label}
    }
}
```

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT ?item ?itemLabel
WHERE {
    {GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
        ?item  a wd:Q5.
        MINUS { ?item rdfs:label ?label}
        }
    }
  SERVICE <https://query.wikidata.org/sparql>
    {
      ?item rdfs:label ?itemLabel.
        FILTER(LANG(?itemLabel) = 'ru')
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
