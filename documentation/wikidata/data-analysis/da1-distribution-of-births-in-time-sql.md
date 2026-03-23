# Distribution of births and genders in time

## Prepare the data for the analysis


The data is stored in the *data_analysis.db* SQlite database.

Cf. [this SQL file](../data-production/import-population-sqlite.sql) for the queries regarding the identification of the population with their names, birth years and genders.


Execute the following SQL query in DBeaver:

```sql
SELECT wikidata_uri, label, birth_year, gender
FROM person
WHERE length(gender) > 1
ORDER BY wikidata_uri ASC;
```

Then export the data from DBeaver as a CSV file and store it in view of the analysis in this file: */wikidata_exploration/da1_data/birth-date-gender.csv* . It should be easily accessible from the analysis Python notebook
