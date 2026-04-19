## Inspect the most frequent fields of work

* In the case of this population, we observe that although the main fields of work are physics and astronomy, there are many other fiels and it would be interesting to inspect specificities related to them.

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
        SELECT DISTINCT ?person_uri
        WHERE {
        ?person_uri wdt:P31 wd:Q5; 
              wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?person_uri wdt:P106 wd:Q11063}
            UNION
            {?person_uri wdt:P101 wd:Q333} 
            UNION
            {?person_uri wdt:P106 wd:Q169470}
            UNION
            {?person_uri wdt:P101 wd:Q413}  
            }
        } 
	
        ### The property P101 associates fields of work to persons
        ?person_uri wdt:P101 ?object.
        ?object rdfs:label ?objectLabel.
        FILTER(LANG(?objectLabel) = 'en')
}  
GROUP BY ?object ?objectLabel 
ORDER BY DESC(?eff)
LIMIT 100
```




### Most frequent fields of work

| object                                    | objectLabel                       | eff  |
| ----------------------------------------- | --------------------------------- | ---- |
| http://www.wikidata.org/entity/Q413       | physics                           | 4346 |
| http://www.wikidata.org/entity/Q333       | astronomy                         | 1684 |
| http://www.wikidata.org/entity/Q395       | mathematics                       | 880  |
| http://www.wikidata.org/entity/Q18362     | theoretical physics               | 760  |
| http://www.wikidata.org/entity/Q37547     | astrophysics                      | 668  |
| http://www.wikidata.org/entity/Q81197     | nuclear physics                   | 489  |
| http://www.wikidata.org/entity/Q18334     | particle physics                  | 317  |
| http://www.wikidata.org/entity/Q2329      | chemistry                         | 236  |
| http://www.wikidata.org/entity/Q14620     | optics                            | 226  |
| http://www.wikidata.org/entity/Q156495    | mathematical physics              | 225  |
| http://www.wikidata.org/entity/Q715396    | solid-state physics               | 224  |
| http://www.wikidata.org/entity/Q214781    | condensed matter physics          | 183  |
| http://www.wikidata.org/entity/Q41217     | mechanics                         | 183  |
| http://www.wikidata.org/entity/Q18366     | experimental physics              | 171  |
| http://www.wikidata.org/entity/Q11372     | physical chemistry                | 164  |
| http://www.wikidata.org/entity/Q944       | quantum mechanics                 | 164  |
| http://www.wikidata.org/entity/Q338       | cosmology                         | 155  |
| http://www.wikidata.org/entity/Q5615097   | plasma physics                    | 154  |
| http://www.wikidata.org/entity/Q43035     | electrical engineering            | 153  |
| http://www.wikidata.org/entity/Q169470    | physicist                         | 143  |
| http://www.wikidata.org/entity/Q7100      | biophysics                        | 134  |
| http://www.wikidata.org/entity/Q1144457   | quantum physics                   | 132  |
| http://www.wikidata.org/entity/Q46255     | geophysics                        | 126  |
| http://www.wikidata.org/entity/Q483666    | spectroscopy                      | 116  |
| http://www.wikidata.org/entity/Q25261     | meteorology                       | 108  |
| http://www.wikidata.org/entity/Q5891      | philosophy                        | 102  |
| http://www.wikidata.org/entity/Q26383     | atomic physics                    | 100  |

&nbsp;

### Query to get the data and import them into the database

```sparql

PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT DISTINCT ?person_uri ?field_uri ?field_label
WHERE
    {
    ### subquery adding the distinct clause
        {
        SELECT DISTINCT ?person_uri
        WHERE {
        ?person_uri wdt:P31 wd:Q5; 
              wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?person_uri wdt:P106 wd:Q11063}
            UNION
            {?person_uri wdt:P101 wd:Q333} 
            UNION
            {?person_uri wdt:P106 wd:Q169470}
            UNION
            {?person_uri wdt:P101 wd:Q413} 
            }
        } 
        ### The property P101 associates fields of work to persons
        ?person_uri wdt:P101 ?field_uri.
        ?field_uri rdfs:label ?field_label.
        FILTER(LANG(?field_label) = 'en')
}  
LIMIT 100

```



#### Experimental : DO NOT USE
```sparql

PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT DISTINCT ?person_uri ?field ?fieldLabel ?parentField ?parentFieldLabel ?parentClass ?parentClassLabel
WHERE
    {
    ### subquery adding the distinct clause
        {
        SELECT DISTINCT ?person_uri
        WHERE {
        ?person_uri wdt:P31 wd:Q5; 
              wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?person_uri wdt:P106 wd:Q11063}
            UNION
            {?person_uri wdt:P101 wd:Q333} 
            UNION
            {?person_uri wdt:P106 wd:Q169470}
            UNION
            {?person_uri wdt:P101 wd:Q413} 
            }
        } 
        ### The property P101 associates fields of work to persons
        ?person_uri wdt:P101 ?field.
        ?field rdfs:label ?fieldLabel.
        FILTER(LANG(?fieldLabel) = 'en')
        OPTIONAL {
                # is instance of
                ?field wdt:P31 ?parentClass.
                        ?parentClass rdfs:label ?parentClassLabel.
                FILTER(LANG(?parentClassLabel) = 'en')
            }
        OPTIONAL {
                # is subclass of
                ?field wdt:P279 ?parentField.
                        ?parentField rdfs:label ?parentFieldLabel.
                FILTER(LANG(?parentFieldLabel) = 'en')
            }  
}  
# LIMIT 100

```




### Create a new table

* Download the result of this query as a CSV file
* Import it as a new table into the SQLite database
  * rename the column names during the import process 
* Inspect the imported data using the SQL scripts in the file [] 




## Occupations

```sparql
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?person_uri ?occupation_label ?occupation_uri
WHERE
    {
    ### subquery adding the distinct clause
        {
        SELECT DISTINCT ?person_uri
        WHERE {
        ?person_uri wdt:P31 wd:Q5; 
              wdt:P569 ?birthDate.
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?year)
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
            {?person_uri wdt:P106 wd:Q11063}
            UNION
            {?person_uri wdt:P101 wd:Q333} 
            UNION
            {?person_uri wdt:P106 wd:Q169470}
            UNION
            {?person_uri wdt:P101 wd:Q413}  
            }
        } 
	
        ### The property P106 associates occupations to persons
        ?person_uri wdt:P106 ?occupation_uri.
        ?occupation_uri rdfs:label ?occupation_label.
        FILTER(LANG(?occupation_label) = 'en')
}  
ORDER BY ?person_uri ?occupation_uri
LIMIT 10
```