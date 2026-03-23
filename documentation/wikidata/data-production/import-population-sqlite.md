## Import the data into a Sqlite Database

&nbsp;

In this notebook we describe the steps needed to import the data into a Sqlite database, that we'll call *data_analysis.db* .

First we check the basic properties of the population: name, gender, year of birth.

All SPARQL QUERIES are to be executed on the Wikidata

#### sparql person : find and export your population

!!! All the variables in select must be like the ones in the example, no capitals !

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT DISTINCT (?item AS ?person_uri) ?year ?gender_label ?gender_uri 
WHERE {
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
            ?item wdt:P21 ?gender_uri.
            ?gender_uri rdfs:label ?gender_label.
            FILTER(LANG(?gender_label) = 'en')
        }

    }
ORDER BY ?item
```

#### Import the result into the database

* Create (if not existing a *data* directory in your GitHub repository at root level
* Create a sub-directory of the data directory called *wdt_csv_data*
* Add the *wdt_csv_data* directory to your .gitignore file to exclude it from versioning, with this syntax:
  /data/wdt_csv_data
* Download the CSV version of the SPARQL result and save it in the *wdt_csv_data* directory with the name **person_import.csv**
* Download and open the [Dbeaver software](https://dbeaver.io/)
* Create a new Sqlite database *data_analysis.db* in your data directory
* **Add this database to your .gitignore file**. It will not be versioned nor pushed:
   data/data_analysis.db
* Open your database in Dbeaver
* Right-click on Table > Import data
* Choose the person_import.csv that you just downladed from Wikidata
* Verify if the columns are correctly mapped, call the new table 'person_import' then create table ('proceed')
* Open the new 'person_import' table



### Inspect imported data


* Inspect the data in the table using the graphical user interface (GUI)
* Create a new text file called [*import-population-sqlite.sql*](import-population-sqlite.sql) on the side of this import file.
* Open the file in DBeaver, activate the connection to your data_analysis.db and follow the instructions in the file, and add your own queries.


## Import labels


### We first import the English labels

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT DISTINCT (?item AS ?person_uri) ?person_label
WHERE {
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
  
            ?item rdfs:label ?person_label.
            FILTER(LANG(?person_label) = 'en')
        }
ORDER BY ?item
```

* execute the SPARQL query
* export the result in a CSV file called 'data/wdt_csv_data/person_label_en_import.csv'
* import the CSV into the SQLITE database as you did above



### We then look for non-English labels for the missing ones

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>


SELECT DISTINCT (?item AS ?person_uri) (min(?person_label_al) as ?person_label )
#SELECT (COUNT(*) AS ?n)
WHERE {
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
        MINUS{?item rdfs:label ?person_label_en.
              FILTER(LANG(?person_label_en) = 'en')   }
       ?item rdfs:label ?person_label_al.
        }
GROUP BY ?item
```

* save the query result in a CSV file called 'data/wdt_csv_data/person_label_non_en_import.csv'
* import the CSV file into the same table as the English labels
  * select the person_label_en_import table, then menu import data, from CSV file, inspect the columns and data before import, do not select "Truncate the target table" and the data will be added at the bottom of the existing table

* inspect the new table with the scripts available in the file [*import-population-sqlite.sql*](import-population-sqlite.sql) 


## Export the data for the analysis of birth year and gender

* execute the SQL query at the bottom of the the file [*import-population-sqlite.sql*](import-population-sqlite.sql), export the result as CSV (button export data at the botton) than save the file *wikidata_exploration/da1_data/birth-date-gender.csv*