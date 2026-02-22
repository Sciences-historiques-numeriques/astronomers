

Information disponible dans Wikidata concernant la population étudiée.


## Documentation concernant les requêtes SPARQL effectuées dans Wikidata

* Official SPARQL Endpoint: https://query.wikidata.org
* [QLever Wikidata](https://qlever.dev/wikidata)
  * This is an alternative experimental Wikidata Query service which is much faster (because it uses the [QLever triplestore technology](https://github.com/ad-freiburg/qlever)) but the data is not necessarily up to date. 
 
&nbsp;

* [SPARQL query service/queries](https://www.wikidata.org/wiki/Wikidata:SPARQL_query_service/queries): documentation.
* [Structure of statements in Wikidata](https://www.wikidata.org/wiki/Help:Statements)
* Query builder: https://query.wikidata.org/querybuilder/?uselang=en
* [Wikidata Dates](https://www.wikidata.org/wiki/Help:Dates)

&nbsp;

* [Wikidata SPARQL Tutorial](https://www.wikidata.org/wiki/Wikidata:SPARQL_tutorial)
* [W3C SPARQL Standard (and tutorial)](https://www.w3.org/TR/sparql11-query/)



 

&nbsp;




## Inspection des notices

On choisit quelques personnes et on inspecte leurs notices dans Wikidata afin d'observer quelles propriétés permettent de retrouver la population.

Par exemple:

* [Johannes Kepler](https://m.wikidata.org/wiki/Q8963)
* [Werner Heisenberg](https://m.wikidata.org/wiki/Q40904)


On retient quelques propriétés qui permettent de retrouver toute la population:
* [occupation](https://m.wikidata.org/wiki/Property:P106)
* [field of work](https://m.wikidata.org/wiki/Property:P101)



## On effectue des requêtes pour vérifier quels effectifs sont disponibles et de qui il s'agit


### Effectifs concernant 'occupation' et/ou 'field of work'

Effectifs relevés au 16 février 2026.

```
SELECT (COUNT(*) as ?eff)
WHERE {
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

### Combiner 'occupation' avec 'field of work'

#### Astronomes

14327 le le 16 février 2026

```
SELECT (COUNT(*) as ?eff)
WHERE {
    ?item wdt:P31 wd:Q5;  # Any instance of a human.
    {?item wdt:P106 wd:Q11063}
    UNION
    {?item wdt:P101 wd:Q333}            
}  
 ```

#### Physiciens

41629 le le 16 février 2026

```
SELECT (COUNT(*) as ?eff)
WHERE {
    ?item wdt:P31 wd:Q5;  # Any instance of a human.
    {?item wdt:P106 wd:Q169470}
    UNION
    {?item wdt:P101 wd:Q413}            
}  
 ```


#### Les deux



55956 le le 16 février 2026.

Mais attention: en fait c'est l'addition des deux, cf. ci-dessous

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


### Nombre effectif de personnes

48094 le le 16 février 2026.

There is an overlap of approximately 7,800 individuals who are both astronomers and physicists.

Please note that SPARQL operates in a layered manner: the innermost layer is executed first and the result set is sent to the next layer up.

```
SELECT (COUNT(*) as ?eff)
WHERE {
    ### subquery adding the distinct clause
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
 ```

### Add a filter on the birth year

32866 on February 21st

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



### Les individus


```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?item ?itemLabel ?year
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
        FILTER(xsd:integer(?year) > 1780 && xsd:integer(?year) < 1981)# Any instance of a human.
    
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



### Persons filtered by birth year

Par exemple ici les astronomes et physiciens du 19e et 20e siècles 


```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

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
ORDER BY ?item            
LIMIT 20
```
NB: il peut y avoir des doublons si les dates de naissance sont multiples. La clause DISTINCT permet d'enlever les doublons il faut toutefois enlever la variable *?birthDate* de la sortie et laisser seulement l'année




## Lister les propriétés disponibles avec effectifs


!!! filtrer par discipline et période et voir différentes propriétés

### Sortantes

Cf. [sur cette page](./Wikidata-liste-proprietes-population.md) les listes de propiétés qui résultent de cette requête
```
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT ?p ?propLabel ?eff
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
    ?prop wikibase:directClaim ?p .

    ?prop rdfs:label ?propLabel.
        FILTER(LANG(?propLabel) = 'en')
    }  
ORDER BY DESC(?eff) 
```

NB Noter qu'il peut y avoir des problèmes de time-out, la requête est trop longue et on a un message d'erreur.
<br/>
Dans ce cas il faut restreindre la période ou limiter le nombre de clauses UNION et décomposer la requête en différentes parties.

On exporte ensuite cette liste sous forme d'une _table HTML_ afin de documenter la suite des opérations. On ouvre la page HTML avec VS Code, on peut mettre en forme avec la commande (click droit) _format document_, puis on copie seulement la partie 'table' depuis la balise &lt;table&gt; jusqu'à &lt;/table&gt;, balises comprises, et on la colle dans un nouveau document Markdown, cf. [Wikidata-liste-proprietes-population.md](Wikidata-liste-proprietes-population.md)


On pourra prendre des notes concernant les opérations effectuées sur les différentes propriétés directement dans ce document et documenter ainsi les choix effectués.

## Add the subpopulation code

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

##  Same query but grouped


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



### Entrantes
```
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT ?p ?propLabel ?eff
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


## Exemple de requête concernant les appartenances à une organisation, avec dates optionnelles si connues


On doit dans cette requête sortir du cadre classique de la simple propriété 'member of' et passer à travers l'assertion, le *statement*. Un statement de _Wikidata_ apparait en quelques sortes comme une entité temporelle même si elle n'associe que deux entités principales, comme une propriété.

```
    SELECT DISTINCT ?item ?itemLabel ?birthYear ?statement ?organization ?organizationLabel 
                    ?startYear ?endYear  ?startTime ?endTime
    where {
            
        {?item wdt:P106 wd:Q11063}
                UNION
                {?item wdt:P101 wd:Q333}
            
        ?item wdt:P31 wd:Q5; # Any instance of a human.
                wdt:P569 ?birthDate;
                # member of
                p:P463 ?statement.
            ?statement ps:P463 ?organization.
        OPTIONAL {
                        ?statement pq:P580 ?startTime;
                        pq:P582 ?endTime.
            }
        
        BIND(REPLACE(str(?startTime), "(.*)([0-9]{4})(.*)", "$2") AS ?startYear)
        BIND(REPLACE(str(?endTime), "(.*)([0-9]{4})(.*)", "$2") AS ?endYear)
        
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?birthYear)
        FILTER(xsd:integer(?birthYear) > 1700 && xsd:integer(?birthYear) < 1801)
            
        SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
        }
    ORDER BY ?birthYear ?startYear
```

### Autre exemple

```
     SELECT DISTINCT ?item ?itemLabel ?birthYear ?statement ?organization ?organizationLabel 
                    ?startYear ?endYear  ?startTime ?endTime
    where {
            
        {?item wdt:P106 wd:Q11063}
                UNION
                {?item wdt:P101 wd:Q333}
            
        ?item wdt:P31 wd:Q5; # Any instance of a human.
                wdt:P569 ?birthDate;
                # member of
                # p:P463 ?statement.
                # ?statement ps:P463 ?organization.
                # educated at
                p:P69 ?statement.
                ?statement ps:P69 ?organization.
              # employer
                #p:P108 ?statement.
                #?statement ps:P108 ?organization.
      #  OPTIONAL
      {
                        ?statement pq:P580 ?startTime;
                        pq:P582 ?endTime.
            }
        
        BIND(REPLACE(str(?startTime), "(.*)([0-9]{4})(.*)", "$2") AS ?startYear)
        BIND(REPLACE(str(?endTime), "(.*)([0-9]{4})(.*)", "$2") AS ?endYear)
        
        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?birthYear)
        FILTER(xsd:integer(?birthYear) > 1800 && xsd:integer(?birthYear) < 1901)
            
        SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
        }
    ORDER BY ?item
    
```