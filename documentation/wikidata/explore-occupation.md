## Get the most frequent occupations

* If your population is in great number, use the [QLever SPARQL Endpoint](https://qlever.dev/wikidata)
* In the case of this population, we observe that the main occupations are the same that the ones used to define the population. The information appears to be less relevant to answer research questions.

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?object ?objectLabel (COUNT(*) as ?eff)
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
	
        ### The property P106 associates occupations to persons
        # we call here the target variable ?object 
        # in order to more easily reuse the query. 
        # ?occupation would be also a good name for the variable
        ?item wdt:P106 ?object.
        ?object rdfs:label ?objectLabel.
        FILTER(LANG(?objectLabel) = 'en')
}  
GROUP BY ?object ?objectLabel 
ORDER BY DESC(?eff)
LIMIT 10
```

### Most frequent occupations

| object                                  | objectLabel        | eff   |
| --------------------------------------- | ------------------ | ----- |
| http://www.wikidata.org/entity/Q169470  | physicist          | 26091 |
| http://www.wikidata.org/entity/Q1622272 | university teacher | 8094  |
| http://www.wikidata.org/entity/Q11063   | astronomer         | 6804  |
| http://www.wikidata.org/entity/Q170790  | mathematician      | 2299  |
| http://www.wikidata.org/entity/Q1650915 | researcher         | 1403  |
| http://www.wikidata.org/entity/Q752129  | astrophysicist     | 1064  |
| http://www.wikidata.org/entity/Q81096   | engineer           | 1029  |
| http://www.wikidata.org/entity/Q593644  | chemist            | 951   |
| http://www.wikidata.org/entity/Q901     | scientist          | 869   |
| http://www.wikidata.org/entity/Q36180   | writer             | 868   |

