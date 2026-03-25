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



Execute the import queries directly in your triplestore using a federated query (clause SERVICE <service.url>) to fetch the data from Wikidata and write them into your triplestore.


### Insert the triples in a dedicated graph.

In a triplestore so called GRAPHs allow to keep together a set of triples. This kind of triples are then called *quads* because they have this form:


| g                               | s                           | p                           | o                           |
| ------------------------------- | --------------------------- | --------------------------- | --------------------------- |
| &lt;http://test1.org/graph1&gt; | &lt;http://test1.org/i1&gt; | &lt;http://test1.org/p1&gt; | &lt;http://test1.org/i2&gt; |
|                                 |                             |                             |                             |

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
w BY ?item
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




### Find labels for persons without English label


```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT DISTINCT ?item ?item_non_en_label
WHERE {
    ## note the service address  
    SERVICE <https://query.wikidata.org/sparql>
        {
            ### find persons without english label
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
        
        MINUS {
            ?item rdfs:label ?itemLabel.
            FILTER(LANG(?itemLabel) = 'en')
            }
        }
        ### get labels for these persons
        ?item rdfs:label ?item_non_en_label                     
    }
}
LIMIT 10
```


### Insert non English labels 

The persons already exist in our graph, we only add their labels


```
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
        {
           ?item rdfs:label ?item_non_en_label.
           }
}
WHERE {
    ## note the service address  
    SERVICE <https://query.wikidata.org/sparql>
        {
            ### find persons without english label
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
        
        MINUS {
            ?item rdfs:label ?itemLabel.
            FILTER(LANG(?itemLabel) = 'en')
            }
        }
        ### get labels for these persons
        ?item rdfs:label ?item_non_en_label                     
    }
}
```

If you execute again the query to find persons without labels, the COUNT result will be zero.

But be aware you'll have a lot of extra names:

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT *
# SELECT (COUNT(*) AS ?number)
WHERE {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
    ?item  a wd:Q5.
    ?item rdfs:label ?label.
    FILTER(LANG(?label) !='en')
    }
}
LIMIT 20
```




### Add a label to the class "Person"

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

INSERT DATA {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
    {
        wd:Q5 rdfs:label "Person".
    }
}

```

### Add the "Gender" class

Inspect the genders: the number of different genders is seven

```

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT (COUNT(*) as ?n)
WHERE
   {
   SELECT DISTINCT ?gender
   WHERE {
      GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
         {
            ?s wdt:P21 ?gender.
         }
      }
   }
```



#### Insert the class 'gender' for all types of gender

Please note that strictly speaking Wikidata has no ontology, therefore no classes. We add this for our convenience


``` 

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

WITH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
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


#### Add the gender class label
```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

INSERT DATA {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
    {
        wd:Q48264 rdfs:label "Gender Identity".
    }
}

```





### Verify the available classes

The result should be Person and Gender.

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

select distinct ?class ?classLabel
where {

    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata> {
  ?s a ?class.
  ?class rdfs:label ?classLabel
  }
}
```


## Add gender labels


### Find gender labels

```
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

### Add gender labels

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

INSERT {
    GRAPH <https://historian.digital/astronomers/graphs-defs.html#wikidata>
    {?gen rdfs:label ?genLabel}
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
        ?gen rdfs:label ?genLabel
    FILTER(LANG(?genLabel) = 'en')
    }
}
```