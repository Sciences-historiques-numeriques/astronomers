## Get the most frequent occupations

* If your population is in great number, use the [QLever SPARQL Endpoint](https://qlever.dev/wikidata)
* In the case of this population, we observe that the main occupations are the same that the ones used to define the population. The information appears to be less relevant to answer research questions.

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT ?occupation ?occupationLabel (COUNT(*) as ?eff)
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
	
      ?item wdt:P106 ?occupation.
        ?occupation rdfs:label ?occupationLabel.
        FILTER(LANG(?occupationLabel) = 'en')
}  
GROUP BY ?occupation ?occupationLabel 
ORDER BY DESC(?eff)
```


