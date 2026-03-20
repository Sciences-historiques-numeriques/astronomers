# Import employers / merberships / educational organizations


In this notebook we import three kind of relationships of our population to organisations: organisations where they are educated, employed and members 

```sparql
### Number of persons 
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5.}
}

```

```sparql
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT ?s ?label ?birthYear
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?s a wd:Q5;
            rdfs:label ?label;
            wdt:P569 ?birthYear}
}
ORDER BY ?s
LIMIT 3

```
## Memberships 

```sparql
## Explore memberships

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?item ?birthYear ?organisation ?organisationLabel 
WHERE
    {
         GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
   
        ## Find the persons in the imported graph
        {SELECT ?item ?birthYear
        WHERE 
                {?item a wd:Q5;
                    wdt:P569 ?birthYear}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        #OFFSET 20000
       LIMIT 100

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # member of
                ?item wdt:P463 ?organisation.
                BIND (?organisationLabel as ?organisationLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
ORDER BY ?item ?organisation
limit 20

```

```sparql
## Group and count

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?organisation ?organisationLabel (COUNT(*) as ?n)
WHERE
    {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>

        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        #OFFSET 20000
       LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # member of
                ?item wdt:P463 ?organisation.
                BIND (?organisationLabel as ?organisationLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
GROUP BY ?organisation ?organisationLabel
ORDER BY DESC(?n)
LIMIT 5

```

```sparql
### Are some persons at the same time members and employees of the same organisation?
# Very few cases  

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?item ?itemLabel  ?organisation ?organisationLabel (COUNT(*) as ?n)
WHERE
    {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>

        ## Find the persons in the imported graph
        {SELECT ?item ?itemLabel
        WHERE 
                {?item a wd:Q5;
                      rdfs:label ?itemLabel}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        #OFFSET 20000
       LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # member of
                ?item wdt:P463 ?organisation.
                # employer
                ?item wdt:P108 ?organisation.
                BIND (?organisationLabel as ?organisationLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
GROUP BY ?item ?itemLabel ?organisation ?organisationLabel
ORDER BY DESC(?n)
LIMIT 20

```
### Employer

```sparql
## Group and count

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?organisation ?organisationLabel (COUNT(*) as ?n)
WHERE
    {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>

        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        #OFFSET 20000
       LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # employer
                ?item wdt:P108 ?organisation.
                BIND (?organisationLabel as ?organisationLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
GROUP BY ?organisation ?organisationLabel
ORDER BY DESC(?n)
LIMIT 5

```
### Import data: employer

```sparql
### Prepare the data to be imported
# With LIMIT clause 
## Apparently labels are not repeated if already available
# We therefore car integrate them directly in the INSERT below

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

CONSTRUCT {?item wdt:P108 ?organisation.
            ?organisation rdfs:label ?organisationLabel}
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        #OFFSET 20000
        LIMIT 10

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # employer
                ?item wdt:P108 ?organisation.
                BIND (?organisationLabel as ?organisationLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
```

```sparql
### This insert query has to be carried out directly on the Allegrograph server
## Also, you have to carry it out in three steps. The accepted limit by Wikidata 
## of instances in a variable ('item' in our case) appears to be 10000.
## You therefore have to have three steps for a population of around 23000 persons  


PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {?item wdt:P108 ?organisation.
         ?organisation rdfs:label ?organisationLabel}
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        #OFFSET 10000
        #OFFSET 20000
        OFFSET 30000
        LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # employer
                ?item wdt:P108 ?organisation.
                BIND (?organisationLabel as ?organisationLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }        
```
#### Inspect imported information

```sparql
### Basic query about number of persons per employers

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?organisation ?organisationLabel (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item wdt:P108 ?organisation.
         ?organisation rdfs:label ?organisationLabel
         }    
          
}
GROUP BY ?organisation ?organisationLabel 
ORDER BY DESC(?n)
LIMIT 5

```

```sparql
### Number of organisations

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT (COUNT(*) as ?n)
WHERE {
        SELECT DISTINCT ?organisation ?organisationLabel 
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item wdt:P108 ?organisation.
         ?organisation rdfs:label ?organisationLabel
         }    
          
    }

}

```

```sparql
### Insert the label of the property
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {wdt:P108 rdfs:label 'has employer'.}
}
```
### Import data: membership

```sparql
### Prepare the data to be imported
# With LIMIT clause 
## Apparently labels are not repeated if already available
# We therefore car integrate them directly in the INSERT below

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

CONSTRUCT {?item wdt:P463 ?organisation.
            ?organisation rdfs:label ?organisationLabel}
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        #OFFSET 20000
        LIMIT 10

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # member of
                ?item wdt:P463 ?organisation.
                BIND (?organisationLabel as ?organisationLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
```

```sparql
### This insert query has to be carried out directly on the Allegrograph server
## Also, you have to carry it out in three steps. The accepted limit by Wikidata 
## of instances in a variable ('item' in our case) appears to be 10000.
## You therefore have to have three steps for a population of around 23000 persons  


PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {?item wdt:P463 ?organisation.
         ?organisation rdfs:label ?organisationLabel}
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        #OFFSET 10000
        #OFFSET 20000
        OFFSET 30000
        LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # member of
                ?item wdt:P463 ?organisation.
                BIND (?organisationLabel as ?organisationLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }        
```
#### Inspect imported information

```sparql
### Basic query about number of persons per employers

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?organisation ?organisationLabel (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item wdt:P463 ?organisation.
         ?organisation rdfs:label ?organisationLabel
         }    
          
}
GROUP BY ?organisation ?organisationLabel 
ORDER BY DESC(?n)
LIMIT 5

```

```sparql
### Number of organisations

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT (COUNT(*) as ?n)
WHERE {
        SELECT DISTINCT ?organisation ?organisationLabel 
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item wdt:P463 ?organisation.
         ?organisation rdfs:label ?organisationLabel
         }    
          
    }

}

```

```sparql
### Insert the label of the property
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {wdt:P463 rdfs:label 'is member of'.}
}
```

```sparql

```
### Import data: educated at

```sparql
### Prepare the data to be imported
# With LIMIT clause 
## Apparently labels are not repeated if already available
# We therefore car integrate them directly in the INSERT below

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

CONSTRUCT {?item wdt:P69 ?organisation.
            ?organisation rdfs:label ?organisationLabel}
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        #OFFSET 20000
        LIMIT 10

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # educated at
                ?item wdt:P69 ?organisation.
                BIND (?organisationLabel as ?organisationLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
```

```sparql
### This insert query has to be carried out directly on the Allegrograph server
## Also, you have to carry it out in three steps. The accepted limit by Wikidata 
## of instances in a variable ('item' in our case) appears to be 10000.
## You therefore have to have three steps for a population of around 23000 persons  


PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {?item wdt:P69 ?organisation.
         ?organisation rdfs:label ?organisationLabel}
WHERE
    {
        ## Find the persons in the imported graph
        {SELECT ?item
        WHERE 
                {?item a wd:Q5.}
        ORDER BY ?item      
        #OFFSET 10000
        #OFFSET 20000
        OFFSET 30000
        LIMIT 10000

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                # educated at
                ?item wdt:P69 ?organisation.
                BIND (?organisationLabel as ?organisationLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }        
```
#### Inspect imported information

```sparql
### Basic query about number of persons per employers

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?organisation ?organisationLabel (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item wdt:P69 ?organisation.
         ?organisation rdfs:label ?organisationLabel
         }    
          
}
GROUP BY ?organisation ?organisationLabel 
ORDER BY DESC(?n)
LIMIT 5

```

```sparql
### Number of organisations

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT (COUNT(*) as ?n)
WHERE {
        SELECT DISTINCT ?organisation ?organisationLabel 
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item wdt:P69 ?organisation.
         ?organisation rdfs:label ?organisationLabel
         }    
          
    }

}

```

```sparql
### Insert the label of the property
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {wdt:P69 rdfs:label 'was educated at'.}
}
```

```sparql

```
### Add the Group class and inspect the Wikidata properties of organisations
    
Wikidata does not provide a suitable class, we therefore use the CIDOC CRM E74 Group class which comprises all kinds of organisations:

http://www.cidoc-crm.org/cidoc-crm/E74_Group


With the queries [in this sparqlbook](wdt_available_information.sparqlbook) you can inspect the available information in the whole repository

```sparql
###  Inspect the organisations:
# number of different organisations

PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

SELECT (COUNT(*) as ?n)
WHERE
   {
   SELECT DISTINCT ?organisation
   WHERE {
      GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
         {
            ?s wdt:P108|wdt:P463|wdt:P69 ?organisation.
         }
      }
   }
```

```sparql
### Insert the class 'occupation' for all the occupations
# Please note that strictly speaking Wikidata has no ontology,
# therefore no classes. We add this for our convenience

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {
   ?organisation rdf:type <http://www.cidoc-crm.org/cidoc-crm/E74_Group>.
}
WHERE
   {
   SELECT DISTINCT ?organisation
   WHERE {
         {
            ?s wdt:P108|wdt:P463|wdt:P69 ?organisation.
         }
      }
   }
```

```sparql
### Ajouter le label pour le concept Occupation

PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

INSERT DATA {
GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
    {    <http://www.cidoc-crm.org/cidoc-crm/E74_Group> rdfs:label "Organisation".
    }    
}


```

```sparql

```
#### Inspect the available information in Wikidata



```sparql
### Number of organisations

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>

SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item rdf:type crm:E74_Group.
        OPTIONAL {?item rdfs:label ?itemLabel}    
          }
}

```

```sparql
### Basic query about persons' occupation

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>

SELECT (COUNT(*) as ?n)
WHERE {
    GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item rdf:type crm:E74_Group.
        OPTIONAL {?item rdfs:label ?itemLabel}    
          }
}

```

```sparql
### Wikidata properties of the first 3000 organisations

# cf. the file: Wikidata/wdt_organisations_properties_20250502.csv

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>

SELECT ?p ?propLabel ?n
WHERE {
        {
            SELECT ?p (COUNT(*) as ?n)
            WHERE {
                {SELECT DISTINCT ?item
                WHERE {
                        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
                    {?item rdf:type crm:E74_Group }        
                }
                LIMIT 3000
                }

            ## 
                    SERVICE <https://query.wikidata.org/sparql>
                        {
                            
                            ?item ?p ?o.
                        }
            }

            GROUP BY ?p
        }

        SERVICE <https://query.wikidata.org/sparql> {
            # get the original property (in the the statement construct)     
            ?prop wikibase:directClaim ?p .
            BIND (?propLabel AS ?propLabel)
            SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }

 
}
ORDER BY DESC(?n)
LIMIT 100
```
#### Import countries of the organisations

```sparql
### Countries of the first 3000 organisations

# 

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>


SELECT ?country ?countryLabel (COUNT(*) as ?n)
WHERE {
    {SELECT DISTINCT ?item
    WHERE {
            GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item rdf:type crm:E74_Group }        
    }
    LIMIT 3000
    }

## 
    SERVICE <https://query.wikidata.org/sparql>
        {
            
            ?item wdt:P17 ?country.
            BIND(?countryLabel as ?countryLabel)
            SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }

        }
}

GROUP BY ?country ?countryLabel
ORDER BY DESC(?n)
LIMIT 30
```

```sparql
### Prepare and inspect the data to be imported


PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>


CONSTRUCT {?item wdt:P17 ?country.
                  ?country a wd:Q6256;
            rdfs:label ?countryLabel}
WHERE
    {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>

        ## Find the organisations in the imported graph
        {SELECT ?item
        WHERE 
                {?item a  crm:E74_Group .}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        LIMIT 10

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ?item wdt:P17 ?country.
                BIND (?countryLabel as ?countryLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
```

```sparql
### Prepare and inspect the data to be imported


PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>


WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {?item wdt:P17 ?country.
        ?country a wd:Q6256;
            rdfs:label ?countryLabel}
WHERE
    {
        ## Find the organisations in the imported graph
        {SELECT ?item
        WHERE 
                {?item a  crm:E74_Group .}
        ORDER BY ?item      
        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
            {
                ?item wdt:P17 ?country.
                BIND (?countryLabel as ?countryLabel)
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
            }
                
        }
```

```sparql
### Insert the label of the property
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {wdt:P17 rdfs:label 'has organisation country'.}
}
```
#### Import _instance of_ of the organisations

```sparql
### _instance of_ of the first 3000 organisations

# 

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>


SELECT ?groupType ?groupTypeLabel (COUNT(*) as ?n)
WHERE {
    {SELECT DISTINCT ?item
    WHERE {
            GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item rdf:type crm:E74_Group }        
    }
    LIMIT 3000
    }

## 
    SERVICE <https://query.wikidata.org/sparql>
        {
            
            ?item wdt:P31 ?groupType.
            BIND(?groupTypeLabel as ?groupTypeLabel)
            SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }

        }
}

GROUP BY ?groupType ?groupTypeLabel
ORDER BY DESC(?n)
LIMIT 30
```

```sparql
### Prepare and inspect the data to be imported


PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>
PREFIX crm-sup: <https://sdhss.org/ontology/crm-supplement/>


CONSTRUCT {
            ?item wdt:P31 ?groupType.
            ?groupType a crm-sup:C9;
                    rdfs:label ?groupTypeLabel
            }
WHERE
    {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>

        ## Find the organisations in the imported graph
        {SELECT ?item
        WHERE 
                {?item a  crm:E74_Group .}
        ORDER BY ?item      
        OFFSET 0
        #OFFSET 10000
        LIMIT 10

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
             {
            
            ?item wdt:P31 ?groupType.
            BIND(?groupTypeLabel as ?groupTypeLabel)
            SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }

        }
                
        }
```

```sparql
### Prepare and inspect the data to be imported


# Group Type
# https://sdhss.org/ontology/crm-supplement/C9


PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>
PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>
PREFIX crm-sup: <https://sdhss.org/ontology/crm-supplement/>


WITH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
INSERT {
            ?item wdt:P31 ?groupType.
            ?groupType a crm-sup:C9;
                rdfs:label ?groupTypeLabel
            }
WHERE
    {
        
        ## Find the organisations in the imported graph
        {SELECT ?item
        WHERE 
                {?item a  crm:E74_Group .}
        ORDER BY ?item      

        }
        ## 
        SERVICE <https://query.wikidata.org/sparql>
             {
            
            ?item wdt:P31 ?groupType.
            BIND(?groupTypeLabel as ?groupTypeLabel)
            SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }

        }
                
        }
```

```sparql
### Insert the label of the property
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {wdt:P31 rdfs:label 'instance of'.}
}
```

```sparql
### Insert the label of the Group Type class
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX crm-sup: <https://sdhss.org/ontology/crm-supplement/>


INSERT DATA {
  GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
  {crm-sup:C9 rdfs:label 'Group Type'.}
}
```
#### Geogr. coordinates

```sparql
### Locations of the first 30 organisations

# 

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>


SELECT ?item ?coordinates
WHERE {
    {SELECT DISTINCT ?item
    WHERE {
            GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {?item rdf:type crm:E74_Group }        
    }
    LIMIT 30
    }

## 
    SERVICE <https://query.wikidata.org/sparql>
        {
            
            ?item wdt:P625 ?coordinates.

        }
}
LIMIT 30
```

```sparql

```
### Prepare queries for data analysis in the Python noteboks

```sparql
### Prepare the data

# 

PREFIX franzOption_defaultDatasetBehavior: <franz:rdf>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX bd: <http://www.bigdata.com/rdf#>


SELECT ?person (MIN(?pLabel) AS ?personLabel)
        (MIN(?birthYear) AS ?birthYear)
        ?relationship 
        ?organisation (MIN(?oLabel) AS ?organisationLabel)
        (COUNT(*) as ?n) 
        (GROUP_CONCAT(DISTINCT ?groupTypeLabel; separator=" | ") AS ?groupTypes) 
        #(GROUP_CONCAT(DISTINCT ?countryLabel; separator=" | ") AS ?countries) 

WHERE {
        GRAPH <https://github.com/Sciences-historiques-numeriques/astronomers/blob/main/graphs/wikidata-imported-data.md>
        {
        {?person a wd:Q5;
           rdfs:label ?pLabel;
           wdt:P569 ?birthYear.
        }


        {?person wdt:P108 ?organisation.
        BIND('employment' AS ?relationship)
        }   
        UNION
        {?person wdt:P463 ?organisation.
        BIND('membership' AS ?relationship)
        }   
        UNION
        {?person wdt:P69 ?organisation.
        BIND('education' AS ?relationship)
        }  
        ?organisation rdfs:label ?oLabel;
                 wdt:P31 ?groupType.
        ?groupType rdfs:label ?groupTypeLabel         
        
        # OPTIONAL {
        #    ?organisation wdt:P17 ?country.
        #    ?country rdfs:label ?countryLabel.
        # }

         }        



    }

GROUP BY ?person ?relationship ?organisation   
ORDER by ?person 
LIMIT 30
    
```
