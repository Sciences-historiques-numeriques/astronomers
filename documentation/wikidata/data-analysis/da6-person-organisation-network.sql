

-- inspect the table

SELECT *
FROM import_person_organisations 
LIMIT 10;

-- count rows
SELECT count(*) as num
FROM import_person_organisations ioc ;


-- number of relations

SELECT relationship, count(*) as num
FROM import_person_organisations 
GROUP BY relationship
ORDER BY num DESC;


/*
 * Organisations
 */


SELECT *
FROM import_organisations 
LIMIT 10;

-- count rows
SELECT count(*) as num
FROM import_organisations;

-- count by country (beware: several historical countries !)
SELECT country_label, count(*) as num
FROM import_organisations 
GROUP BY country_label
ORDER BY num DESC;



/*
*  Relations with persons and organisations
*/
DROP VIEW v_person_organisation_relation;

CREATE VIEW v_person_organisation_relation AS
SELECT DISTINCT  ipo.person_uri, io.organisation_uri, io.organisation_label, ipo.relationship
FROM import_person_organisations ipo
	JOIN person p ON p.wikidata_uri = ipo.person_uri 
	JOIN import_organisations io ON io.organisation_uri = ipo.organisation_uri;



/*
 * Inspect and do different checks
 */


SELECT *
FROM v_person_organisation_relation
LIMIT 10;

SELECT COUNT(*)
FROM v_person_organisation_relation;


-- check not unique relations : none, ok
SELECT person_uri, organisation_uri,relationship
FROM v_person_organisation_relation
GROUP BY person_uri, organisation_uri,relationship 
HAVING COUNT(*) > 1;

-- check labels
SELECT organisation_label, count(*) as num
FROM v_person_organisation_relation
where length(organisation_label) < 3
GROUP BY organisation_label
order by num desc;


/*
 * Final query to export CSV data:
 * 
 * esport the data to file 'da_data/da6-persons-organisations-relations.csv'
 * 
*/

SELECT *
FROM v_person_organisation_relation;