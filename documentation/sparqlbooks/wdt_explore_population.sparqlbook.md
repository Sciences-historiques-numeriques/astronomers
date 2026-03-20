## Explore Wikidata

In this notebook, we refine and document the main requests available on the page [Exploration of Wikidata](../documentation/wikidata/Wikidata-exploration.md) 


When you prepare the queries, you can execute them on the Wikidata SPARQL endpoint, and then document and execute them in this notebook.
### Inspect astronomers and related occupations

```sparql
   ## Count and inspect occupations and fields of work
   SELECT (COUNT(*) as ?eff)
    WHERE {
        ?item wdt:P31 wd:Q5;  # Any instance of a human.

            wdt:P106 wd:Q11063  # astronomer 10162
        
            # wdt:P101 wd:Q333  # astronomy 2161
            # wdt:P106 wd:Q169470 # physicist 32123
            #  wdt:P101 wd:Q413 # physics ~ 4000
            #  wdt:P106 wd:Q155647  # astrologer 1364
            #  wdt:P101 wd:Q34362 # astrology 241
            #  wdt:P106 wd:Q170790  # mathematician 39562
            #  wdt:P106 wd:Q901 # scientist 36117

    }  
    #LIMIT 10

```

```sparql
### Modern astronomers : born from 1751 onward
SELECT (count(*) as ?number)
WHERE {
    {?item wdt:P106 wd:Q11063}  # astronomer
    UNION
    {?item wdt:P101 wd:Q333}     # astronomy
    
    ?item wdt:P31 wd:Q5; # Any instance of a human.
            wdt:P569 ?birthDate.
    

    BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
    FILTER(xsd:integer(?year) > 1750 )
}
```

```sparql
### Modern astronomers and physicists
SELECT (count(*) as ?number)
WHERE {
    {?item wdt:P106 wd:Q11063}  # astronomer
    UNION
    {?item wdt:P101 wd:Q333}     # astronomy
    UNION
    {?item wdt:P106 wd:Q169470}  # physicist
    UNION
    {?item wdt:P101 wd:Q413}     # physics
    
    ?item wdt:P31 wd:Q5; # Any instance of a human.
            wdt:P569 ?birthDate.
    

    BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
    FILTER(xsd:integer(?year) > 1750  && xsd:integer(?year) < 1951 )
}
```
### Count how many properties are available for the considered population

Execute this query **directly on the Wikidata sparql-endpoint** and save the result to a CSV document that you will store in your project: [population properties list](../Wikidata/properties_20250309.csv)


Open your CSV file with a spreadsheet editor:
* Inspect the content of the results and look for relevant properties with regard to your research questions
* Observe all the links to other semantic web repositories, probably the sources of this information.
* You can transform this file to your preferred spreadsheet editor format (Calc, Excel, etc.) and take notes row per row in the spreadsheet.


```sparql
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?p ?propLabel ?eff
WHERE {
{
SELECT ?p  (count(*) as ?eff)
WHERE {
    {?item wdt:P106 wd:Q11063}  # astronomer
    UNION
    {?item wdt:P101 wd:Q333}     # astronomy
    UNION
    {?item wdt:P106 wd:Q169470}  # physicist
    UNION
    {?item wdt:P101 wd:Q413}     # physics   
    ?item wdt:P31 wd:Q5; # Any instance of a human.
            wdt:P569 ?birthDate.
    ?item  ?p ?o.

    BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
    ### Experiment with different time filters if too many values
    FILTER(xsd:integer(?year) > 1750  && xsd:integer(?year) < 1951)
    # FILTER(xsd:integer(?year) > 1850  && xsd:integer(?year) < 1951)

}
GROUP BY ?p 

    }

# get the original property (in the the statement construct)     
?prop wikibase:directClaim ?p .

SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 


}  
ORDER BY DESC(?eff)
# LIMIT 20
```
