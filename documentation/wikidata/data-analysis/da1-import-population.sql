
-- explore first rows
SELECT *
FROM import_person
LIMIT 10;


-- observe if a person has many rows
SELECT person_uri, COUNT(*) as num
FROM import_person
GROUP BY person_uri
ORDER BY num DESC
LIMIT 10;



-- Create person table
CREATE TABLE person (pk_person INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
label TEXT,
birth_year INTEGER,
gender TEXT,
definition TEXT,
notes TEXT,
dbpedia_uri TEXT,
wikidata_uri TEXT);

--DROP INDEX idx_person;
CREATE UNIQUE INDEX idx_person ON person(wikidata_uri);


/*
 * !!! After creating a new table refresh the connection 
 * to the database or close and reopen it 
 * in order to see the new table
 */


-- prepare data import from the import table
SELECT DISTINCT person_uri , MIN("year"), MIN(gender_label)
FROM import_person
GROUP BY person_uri
LIMIT 10;

-- import the data to the person table
INSERT INTO person (wikidata_uri, birth_year, gender)
SELECT DISTINCT person_uri , MIN("year"), MIN(gender_label)
FROM import_person
GROUP BY person_uri;


-- inspect in DBeaver GUI or here
SELECT pk_person, birth_year, gender, wikidata_uri 
FROM person
LIMIT 10;


-- number of unique persons
SELECT COUNT(*)
FROM person;

-- test if really unique
SELECT COUNT(*) num, wikidata_uri 
FROM person
group by wikidata_uri 
having COUNT (*) > 1
order by num desc;

-- group by gender
SELECT gender, count(*) as num
FROM person
GROUP BY gender
ORDER BY num DESC;



/*
 * LABELS
 */

SELECT *
FROM person_label
LIMIT 10;

--DROP INDEX idx_person_label;
CREATE UNIQUE INDEX idx_person_label ON person_label(person_uri, person_label);


-- no person with two labels
SELECT COUNT(*), person_uri
FROM person_label
GROUP BY person_uri 
having count(*) > 1;

-- persons without label
SELECT COUNT(*)
FROM person p 
   LEFT JOIN person_label pl 
   		ON pl.person_uri = p.wikidata_uri 
WHERE pl.person_label IS NULL;


-- add the labels where they exist
UPDATE person SET label = pl.person_label
FROM person_label pl 
WHERE pl.person_uri = wikidata_uri
AND pl.person_label IS NOT NULL;


-- inspect persons
SELECT *
FROM person 
LIMIT 10;

-- sans label
SELECT COUNT(*)
FROM person 
WHERE label IS NULL;



/*
 * Data analysis
 */

-- query for analysis of birth date and gender

SELECT wikidata_uri, label, birth_year, gender
FROM person
WHERE length(gender) > 1
--ORDER BY birth_year DESC
ORDER BY gender ASC
--LIMIT 10
;
