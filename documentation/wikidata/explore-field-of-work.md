## Get the most frequent fields of work

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
	
        ### The property P101 associates fields of work to persons
        ?item wdt:P101 ?object.
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
| http://www.wikidata.org/entity/Q201486    | history of science                | 99   |
| http://www.wikidata.org/entity/Q373065    | applied physics                   | 97   |
| http://www.wikidata.org/entity/Q54505     | quantum field theory              | 91   |
| http://www.wikidata.org/entity/Q33521     | applied mathematics               | 90   |
| http://www.wikidata.org/entity/Q677916    | statistical physics               | 81   |
| http://www.wikidata.org/entity/Q290578    | radiophysics                      | 77   |
| http://www.wikidata.org/entity/Q4027615   | informatics                       | 75   |
| http://www.wikidata.org/entity/Q995600    | popular science                   | 75   |
| http://www.wikidata.org/entity/Q8087      | geometry                          | 74   |
| http://www.wikidata.org/entity/Q12016129  | hydrodynamics                     | 72   |
| http://www.wikidata.org/entity/Q11473     | thermodynamics                    | 72   |
| http://www.wikidata.org/entity/Q11468     | nanotechnology                    | 69   |
| http://www.wikidata.org/entity/Q3294789   | magnetism                         | 69   |
| http://www.wikidata.org/entity/Q7754      | mathematical analysis             | 68   |
| http://www.wikidata.org/entity/Q7922      | pedagogy                          | 66   |
| http://www.wikidata.org/entity/Q11650     | electronics                       | 65   |
| http://www.wikidata.org/entity/Q82811     | acoustics                         | 63   |
| http://www.wikidata.org/entity/Q43514     | theory of relativity              | 61   |
| http://www.wikidata.org/entity/Q131089    | geodesy                           | 60   |
| http://www.wikidata.org/entity/Q3968      | algebra                           | 60   |
| http://www.wikidata.org/entity/Q8434      | education                         | 59   |
| http://www.wikidata.org/entity/Q11190     | medicine                          | 58   |
| http://www.wikidata.org/entity/Q7163      | politics                          | 58   |
| http://www.wikidata.org/entity/Q21198     | computer science                  | 55   |
| http://www.wikidata.org/entity/Q4306      | radio astronomy                   | 54   |
| http://www.wikidata.org/entity/Q11456     | semiconductor                     | 53   |
| http://www.wikidata.org/entity/Q1120908   | medical physics                   | 51   |
| http://www.wikidata.org/entity/Q160398    | crystallography                   | 51   |
| http://www.wikidata.org/entity/Q104499    | planetary science                 | 50   |
| http://www.wikidata.org/entity/Q489328    | molecular physics                 | 50   |
| http://www.wikidata.org/entity/Q228736    | materials science                 | 49   |
| http://www.wikidata.org/entity/Q3194786   | quantum theory                    | 49   |
| http://www.wikidata.org/entity/Q735602    | quantum optics                    | 49   |
| http://www.wikidata.org/entity/Q188715    | statistical mechanics             | 48   |
| http://www.wikidata.org/entity/Q350265    | high energy physics               | 48   |
| http://www.wikidata.org/entity/Q59115     | philosophy of science             | 48   |
| http://www.wikidata.org/entity/Q7991      | natural science                   | 48   |
| http://www.wikidata.org/entity/Q1069      | geology                           | 47   |
| http://www.wikidata.org/entity/Q11273602  | astronomical observation          | 47   |
| http://www.wikidata.org/entity/Q184274    | celestial mechanics               | 47   |
| http://www.wikidata.org/entity/Q172145    | fluid mechanics                   | 47   |
| http://www.wikidata.org/entity/Q467054    | photonics                         | 47   |
| http://www.wikidata.org/entity/Q101333    | mechanical engineering            | 46   |
| http://www.wikidata.org/entity/Q2001702   | chemical physics                  | 44   |
| http://www.wikidata.org/entity/Q5334416   | atmospheric physics               | 44   |
| http://www.wikidata.org/entity/Q3456979   | polymer science                   | 44   |
| http://www.wikidata.org/entity/Q11406     | electromagnetism                  | 43   |
| http://www.wikidata.org/entity/Q212881    | history of physics                | 43   |
| http://www.wikidata.org/entity/Q420       | biology                           | 43   |
| http://www.wikidata.org/entity/Q193091    | optoelectronics                   | 42   |
| http://www.wikidata.org/entity/Q38867     | laser                             | 41   |
| http://www.wikidata.org/entity/Q113209507 | creative and professional writing | 39   |
| http://www.wikidata.org/entity/Q1710723   | materials engineering             | 38   |
| http://www.wikidata.org/entity/Q4252992   | laser science                     | 38   |
| http://www.wikidata.org/entity/Q1437042   | superstring theory                | 37   |
| http://www.wikidata.org/entity/Q124131    | superconductivity                 | 37   |
| http://www.wikidata.org/entity/Q8424      | aerodynamics                      | 37   |
| http://www.wikidata.org/entity/Q34178     | theology                          | 36   |
| http://www.wikidata.org/entity/Q619452    | thermal physics                   | 36   |
| http://www.wikidata.org/entity/Q11547     | cosmic radiation                  | 35   |
| http://www.wikidata.org/entity/Q4483523   | semiconductor physics             | 35   |
| http://www.wikidata.org/entity/Q52139     | climatology                       | 35   |
| http://www.wikidata.org/entity/Q756033    | nonlinear optics                  | 35   |
| http://www.wikidata.org/entity/Q11633     | photography                       | 34   |
| http://www.wikidata.org/entity/Q216320    | fluid dynamics                    | 34   |
| http://www.wikidata.org/entity/Q2989675   | quantum electronics               | 34   |
| http://www.wikidata.org/entity/Q5862903   | probability theory                | 34   |
| http://www.wikidata.org/entity/Q909554    | computational physics             | 34   |
| http://www.wikidata.org/entity/Q11660     | artificial intelligence           | 33   |
| http://www.wikidata.org/entity/Q11452     | general relativity                | 33   |
| http://www.wikidata.org/entity/Q11412     | gravity                           | 32   |
| http://www.wikidata.org/entity/Q188444    | differential geometry             | 32   |
| http://www.wikidata.org/entity/Q908692    | cryophysics                       | 32   |


