## Explore Wikidata

In this notebook, we refine and document the main requests available on the page [Exploration of Wikidata](../documentation/wikidata/Wikidata-exploration.md) 


When you prepare the queries, you can execute them on the Wikidata SPARQL endpoint, and then document and execute them in this notebook.
### Explore occupations and fields of work

```sparql
### List 'n' more frequent occupations

PREFIX wd: <http://www.wikidata.org/entity/>


SELECT ?occupation ?occupationLabel ?n
WHERE {

    {
    SELECT ?occupation (COUNT(*) as ?n)
    WHERE {
        ?item wdt:P106 ?occupation.
        }
    GROUP BY ?occupation 
    ORDER BY DESC(?n)

    #OFFSET 20
    LIMIT 20
    }

    SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
    
    }
    ORDER BY DESC(?n)


```

```sparql
### List more frequent occupations

PREFIX wd: <http://www.wikidata.org/entity/>

SELECT ?field ?fieldLabel ?n
WHERE {

    {
    SELECT ?field (COUNT(*) as ?n)
    WHERE {
        ?item wdt:P101 ?field.
        }
    GROUP BY ?field 
    ORDER BY DESC(?n)

    #OFFSET 20
    LIMIT 20
    }

    SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
    
    }
    ORDER BY DESC(?n)


```
