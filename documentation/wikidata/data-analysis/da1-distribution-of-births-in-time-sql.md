# Distribution of births and genders in time

## Prepare the data for the analysis


The data is stored in the *data_analysis.db* SQlite database.

Cf. [this SQL file](da1-import-population.sql) for the queries regarding the identification of the population with their names, birth years and genders, and cleaning up of the data.


Execute the following SQL query in DBeaver:

```sql
SELECT wikidata_uri, label, birth_year, gender
FROM person
WHERE length(gender) > 1
ORDER BY wikidata_uri ASC;
```

Then export the data from DBeaver as a CSV file and store it in view of the analysis in this file: */wikidata_exploration/da_data/da1-birth-date-gender.csv* . It should be *visible* (easily accessible) from the analysis Python notebook
