## Documentation about SPARQL queries performed in Wikidata

### SPARQL endpoints

* Official SPARQL Endpoint: https://query.wikidata.org
* [QLever Wikidata](https://qlever.dev/wikidata)
  * This is an alternative Wikidata Query service which is much faster (because it uses the [QLever triplestore technology](https://github.com/ad-freiburg/qlever)) but the data is not necessarily up to date.

### Documentation about Queries in Wikidata

* [SPARQL query service/queries](https://www.wikidata.org/wiki/Wikidata:SPARQL_query_service/queries): documentation.
* Library Carpentry Wikidata: [Introduction to querying](https://librarycarpentry.github.io/lc-wikidata/05-intro_to_querying.html#top)
* [Structure of statements in Wikidata](https://www.wikidata.org/wiki/Help:Statements)
* Query builder: https://query.wikidata.org/querybuilder/?uselang=en
* [Wikidata Dates](https://www.wikidata.org/wiki/Help:Dates)

### SPARQL Tutorial and Standard (with examples)

* [Wikidata SPARQL Tutorial](https://www.wikidata.org/wiki/Wikidata:SPARQL_tutorial)
* [W3C SPARQL Standard (and tutorial)](https://www.w3.org/TR/sparql11-query/)

&nbsp;

## Inspection of available information

The objective of this stage of the workflow is to analyse the available information to answer our research questions about the population in our prosopography.

To begin with, we select a few people from the population chosen for the research and inspect their entries in Wikidata. This allows us to identify the properties that will enable us to find the population and determine what information is available.

* [Victor Ambartsumian](http://www.wikidata.org/entity/Q164396)
  * On this page or 'card' we can inspect the RDF triples available about this person in the Wikidata knowledge graph
  * Carefullyl inspect the properties ‘employer’ and ‘position held’
    * Cf. the ['card' of the same person in DBpedia](https://dbpedia.org/resource/Viktor_Ambartsumian)
    * Note the difference between a property-centered ontology and an assertion-centered ontology, which de facto contains implicit temporalities.
* [Werner Heisenberg](http://www.wikidata.org/entity/Q40904)

### URI vs URL

* URL -> https://www.wikidata.org/wiki/Q164396
* URI -> &lt;http://www.wikidata.org/entity/Q164396&gt;

**Dereferencing** is the technical mechanism that allows to insert a **URI** in the browser and be redirected to the **URL** of the page where the entity is described (if it exists). In the case of Wikidata and our population, it is the 'card' about the persons, with all the triples (in fact *statements*) presented in a readable form.

## Querying Wikidata to find the population

For astronomers and physicists, the following properties appear to be an effective way of identifying the population::

* [occupation](https://m.wikidata.org/wiki/Property:P106)
* [field of work](https://m.wikidata.org/wiki/Property:P101)

### Number of persons with 'occupation' et/ou 'field of work' in astronomy and physics

Figures as of February 16, 2026.

```
SELECT (COUNT(*) as ?eff)
WHERE {

    ## we use this clause in order to get only humans and not
    ## pages or any other entity wrongly associated to the occupation or field of work

    ?item wdt:P31 wd:Q5;  # Any instance of a human.
  
          wdt:P106 wd:Q11063  # astronomer 11750
  
    # wdt:P101 wd:Q333  # astronomy 2161
    # wdt:P106 wd:Q169470 # physicist 36002
    #  wdt:P101 wd:Q413 # physics ~ 5625

    ### autres sujets
    #  wdt:P106 wd:Q155647  # astrologer 1364
    #  wdt:P101 wd:Q34362 # astrology 241
    #  wdt:P106 wd:Q170790  # mathematician 39562
    #  wdt:P106 wd:Q901 # scientist 36117

}  
```

### Combine 'occupation' with 'field of work'

We use here the **UNION** clause which allows to express an **OR** condition and merge two populations.

#### Astronomers

14327 as of February 16, 2026.

```
SELECT (COUNT(*) as ?eff)
WHERE {
    ?item wdt:P31 wd:Q5.
    {?item wdt:P106 wd:Q11063}
    UNION
    {?item wdt:P101 wd:Q333}  
}  
```

#### Physicians

41629 as of February 16, 2026.

```
SELECT (COUNT(*) as ?eff)
WHERE {
    ?item wdt:P31 wd:Q5;  # Any instance of a human.
    {?item wdt:P106 wd:Q169470}
    UNION
    {?item wdt:P101 wd:Q413}  
}  
```

#### Both sup-populations

55956 as of February 16, 2026.

But be careful: it's actually the sum of the two, so a person could appear more then once.

```
SELECT (COUNT(*) as ?eff)
WHERE {
    ?item wdt:P31 wd:Q5;  # Any instance of a human.

    {?item wdt:P106 wd:Q11063}
    UNION
    {?item wdt:P101 wd:Q333} 
    UNION
    {?item wdt:P106 wd:Q169470}
    UNION
    {?item wdt:P101 wd:Q413}  
}  
```

### Actual number of people

48094 las of February 16, 2026.

There is an overlap of approximately 7,800 individuals who are both astronomers and physicists.

Please note that **SPARQL operates in a layered manner**: the innermost layer is executed first and the result set is then sent to the next layer up.

```
SELECT (COUNT(*) as ?eff)
WHERE {
    ### subquery adding the distinct clause
    {
        SELECT DISTINCT ?item
        WHERE {
        ?item wdt:P31 wd:Q5;  # Any instance of a human.
        {?item wdt:P106 wd:Q11063}
        UNION
        {?item wdt:P101 wd:Q333} 
        UNION
        {?item wdt:P106 wd:Q169470}
        UNION
        {?item wdt:P101 wd:Q413}  
        }
    }
}  
```

### Add a filter on the birth year

32866 on February 21st 2026

```
SELECT (COUNT(*) as ?eff)
WHERE
    {
    ### subquery adding the distinct clause
        {
        SELECT DISTINCT ?item
        WHERE {
        ?item wdt:P31 wd:Q5; 
              wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?item wdt:P106 wd:Q11063}
            UNION
            {?item wdt:P101 wd:Q333} 
            UNION
            {?item wdt:P106 wd:Q169470}
            UNION
            {?item wdt:P101 wd:Q413}  
            }
        }  
    }  
```

### Inspect individuals

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT DISTINCT ?item ?itemLabel ?year
WHERE {
    {
  
        {?item wdt:P106 wd:Q11063}
        UNION
        {?item wdt:P101 wd:Q333} 
        UNION
        {?item wdt:P106 wd:Q169470}
        UNION
        {?item wdt:P101 wd:Q413} 
    }  
    ?item wdt:P31 wd:Q5;  # Any instance of a human.
            wdt:P569 ?birthDate.
  BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)
  
    ### Two ways of getting labels
    # SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }

    ## This is useful for query from external tool
    ?item rdfs:label ?itemLabel.
    FILTER(LANG(?itemLabel) = 'en')
    }  
LIMIT 100
```

### Count population with English labels

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT (COUNT(*) as ?eff)
WHERE
    {
    ### subquery adding the distinct clause
        {
        SELECT DISTINCT ?item ?itemLabel ?year
        WHERE {
        ?item wdt:P31 wd:Q5; 
              wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?item wdt:P106 wd:Q11063}
            UNION
            {?item wdt:P101 wd:Q333} 
            UNION
            {?item wdt:P106 wd:Q169470}
            UNION
            {?item wdt:P101 wd:Q413}  
        ?item rdfs:label ?itemLabel.
        FILTER(LANG(?itemLabel) = 'en')
            }
        }  
    }  
```

### Number of individuals without English label

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT (COUNT(*) as ?eff)
WHERE
    {
    ### sous requête qui ajoute la clause distinct
        {
        SELECT DISTINCT ?item ?itemLabel ?year
        WHERE {
        ?item wdt:P31 wd:Q5; 
              wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?item wdt:P106 wd:Q11063}
            UNION
            {?item wdt:P101 wd:Q333} 
            UNION
            {?item wdt:P106 wd:Q169470}
            UNION
            {?item wdt:P101 wd:Q413}  
        MINUS {?item rdfs:label ?itemLabel.
            FILTER(LANG(?itemLabel) = 'en')
            }
            }
        }  
    }  
```

### Individuals without English label

Inspect individuals' cards and observe their properties

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT ?item ?year (group_concat(?iso_lang ; separator = ',') as ?langs) (max(?itemLabel) as ?maxLabel)
WHERE
    { 
       { SELECT DISTINCT ?item ?year
        WHERE {
        ?item wdt:P31 wd:Q5; 
              wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?item wdt:P106 wd:Q11063}
            UNION
            {?item wdt:P101 wd:Q333} 
            UNION
            {?item wdt:P106 wd:Q169470}
            UNION
            {?item wdt:P101 wd:Q413}  
        MINUS {?item rdfs:label ?itemLabel.
            FILTER(LANG(?itemLabel) = 'en')
            }
            }
        }  
  
        ?item rdfs:label ?itemLabel. 
		BIND(LANG(?itemLabel) as ?iso_lang)
  
       }
	   GROUP BY ?item ?year
	   ORDER BY ?item
	   LIMIT 100
```

## List the available properties and their numbers.

### Outgoing

Cf. [on this page](./Wikidata-liste-proprietes-population.md) the list of properties resulting from this query.

```
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT ?p ?propLabel ?eff ('' as ?notes)
WHERE {
{
    SELECT DISTINCT  ?p  (count(*) as ?eff)
    WHERE {
        ?item wdt:P31 wd:Q5; 
             wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?item wdt:P106 wd:Q11063}
            UNION
            {?item wdt:P101 wd:Q333} 
            UNION
            {?item wdt:P106 wd:Q169470}
            UNION
            {?item wdt:P101 wd:Q413}.
			?item ?p ?o.
        }
		GROUP BY ?p
    }

    ## we need this construct to get the label of the property
    ## properties are also entities in Wikidata,
    ## but only in the entities' namespace

    ?prop wikibase:directClaim ?p .
    ?prop rdfs:label ?propLabel.
    FILTER(LANG(?propLabel) = 'en')
    }  
ORDER BY DESC(?eff) 
```

**NB**. Please note that timeout issues may occur when executing the query on the Wikidata SPARQL endpoint. This is because the query takes too long to process and an error message appears.
&nbsp;
In this case, you must restrict the period of time considered or limit the number of UNION clauses and break the query down into different parts.

Or you can switch to the QLever SPARQL Endpoint (cf. above) that normally works fine.

This list is then exported and transformed to a table in order to document the sequence of operations. This is done as follows:

* execute the query then download the result in csv format into your projet's repository. Cf. the file in this directory: data_queries/Wikidata/wdt_population_outgoing_properties_20260302.csv
* open the CSV in VSCode as text and convert it to a Markdown Table using the plugin 'CSV to Markdown Table (phoihos)'
* copy the whole table and paste it a new Markdown document, cf. [Wikidata-liste-proprietes-population.md](Wikidata-liste-proprietes-population.md)
* close the CSV file

In the column 'notes' of the property table you can add links to the pages where you document the treatement of the corresponding information.

### Incoming

```
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT ?p ?propLabel ?eff  ('' as ?notes)
WHERE {
{
    SELECT DISTINCT  ?p  (count(*) as ?eff)
    WHERE {
        ?item wdt:P31 wd:Q5; 
             wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?item wdt:P106 wd:Q11063}
            UNION
            {?item wdt:P101 wd:Q333} 
            UNION
            {?item wdt:P106 wd:Q169470}
            UNION
            {?item wdt:P101 wd:Q413}.

            ## inversed triple
			?s ?p ?item.
        }
		GROUP BY ?p
    }
    ?prop wikibase:directClaim ?p .

    ?prop rdfs:label ?propLabel.
        FILTER(LANG(?propLabel) = 'en')
    }  
ORDER BY DESC(?eff) 
```

Relevant incoming properties:


| p                                         | propLabel              | eff     | notes |
| ------------------------------------------- | ------------------------ | --------- | ------- |
| http://www.wikidata.org/prop/direct/P50   | author                 | 1012032 |       |
| http://www.wikidata.org/prop/direct/P61   | discoverer or inventor | 83956   |       |
| http://www.wikidata.org/prop/direct/P184  | doctoral advisor       | 25018   |       |
| http://www.wikidata.org/prop/direct/P138  | named after            | 18336   |       |
| http://www.wikidata.org/prop/direct/P921  | main subject           | 8428    |       |
| http://www.wikidata.org/prop/direct/P185  | doctoral student       | 7617    |       |
| http://www.wikidata.org/prop/direct/P40   | child                  | 3218    |       |
| http://www.wikidata.org/prop/direct/P22   | father                 | 2835    |       |
| http://www.wikidata.org/prop/direct/P1346 | winner                 | 2644    |       |
| http://www.wikidata.org/prop/direct/P26   | spouse                 | 2120    |       |
| http://www.wikidata.org/prop/direct/P1066 | student of             | 2035    |       |
| http://www.wikidata.org/prop/direct/P3373 | sibling                | 1982    |       |
| http://www.wikidata.org/prop/direct/P1889 | different from         | 1618    |       |
| http://www.wikidata.org/prop/direct/P802  | student                | 1375    |       |

This is just a portion of the resulting downloaded CSV. If you have more you should also create a dedicated page for the incoming properties.

## Define subpopulations (optional)

More complex query that adds a code to both parts of the populations, astronomers and physicists.

Only use if relevant for your project.

### Add the subpopulation code

```
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT ?p ?propLabel ?eff ?itemType
WHERE {
{
    SELECT DISTINCT  ?p  (count(*) as ?eff) ?itemType
    WHERE {
        ?item wdt:P31 wd:Q5; 
             wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?item wdt:P106 wd:Q11063.
			BIND ('astronomer' as ?itemType)}
            UNION
            {?item wdt:P101 wd:Q333.
			BIND ('astronomer' as ?itemType).} 
            UNION
            {?item wdt:P106 wd:Q169470.
			BIND ('physicist' as ?itemType)}
            UNION
            {?item wdt:P101 wd:Q413.
			BIND ('physicist' as ?itemType)}
			.
			?item ?p ?o.
        }
		GROUP BY ?p ?itemType
        ## limit to more frequent properties
		HAVING(?eff >= 100)
    }
    ?prop wikibase:directClaim ?p .

    ?prop rdfs:label ?propLabel.
        FILTER(LANG(?propLabel) = 'en')
    }  
ORDER BY ?propLabel ?itemType 
```

## Same query but grouped

```
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?p ?propLabel (max(?eff) as ?max_eff) 
(group_concat(concat(str(?eff), ' ', ?itemType); separator=" | ") as ?eff_type)
WHERE {


SELECT ?p ?propLabel ?eff ?itemType
WHERE {
{
    SELECT DISTINCT  ?p  (count(*) as ?eff) ?itemType
    WHERE {
        ?item wdt:P31 wd:Q5; 
             wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?item wdt:P106 wd:Q11063.
			BIND ('astronomer' as ?itemType)}
            UNION
            {?item wdt:P101 wd:Q333.
			BIND ('astronomer' as ?itemType).} 
            UNION
            {?item wdt:P106 wd:Q169470.
			BIND ('physicist' as ?itemType)}
            UNION
            {?item wdt:P101 wd:Q413.
			BIND ('physicist' as ?itemType)}
			.
			?item ?p ?o.
        }
		GROUP BY ?p ?itemType
		HAVING(?eff >= 100)
    }
    ?prop wikibase:directClaim ?p .

    ?prop rdfs:label ?propLabel.
        FILTER(LANG(?propLabel) = 'en')
    }  
	}
	GROUP BY ?p ?propLabel
     ORDER BY desc(?max_eff)

```
