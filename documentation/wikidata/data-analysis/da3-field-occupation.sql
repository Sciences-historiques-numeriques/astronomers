
/*
* Explore occupations
*/

-- number of rows
SELECT count(*)
FROM import_occupations t ;




-- number of people
SELECT count(*)
FROM (
SELECT DISTINCT person_uri
FROM import_occupations t );

	

SELECT occupation, count(*) as num
FROM (
	SELECT DISTINCT person_uri, replace(trim(occupation_label), ' ', '-') as occupation
	FROM import_occupations)
GROUP BY occupation
order by num desc;		






/*
 * occupations per person
*/

CREATE VIEW v_person_occupation AS 
WITH TW1 as (
SELECT DISTINCT person_uri, replace(trim(occupation_label), ' ', '-') as occupation
FROM import_occupations
order by occupation
)
SELECT person_uri, group_concat(occupation) occupations, count(*) as num
FROM tw1
GROUP BY person_uri 
ORDER BY num DESC ;

-- inspect
select *
from v_person_occupation
limit 10;

-- distribution of number of occupations per person
select num, count(*) as n
from v_person_occupation
group by num;





/*
* occupations analysis
*/
select occupations, count(*) as n
from v_person_occupation
where num = 3
group by occupations
order by n desc, occupations;









/*
* Explore fields
*/

-- number of rows
SELECT count(*)
FROM import_fields t ;




-- number of people
SELECT count(*)
FROM (
SELECT DISTINCT person_uri
FROM import_fields t );













-- inspect content
SELECT *
FROM import_fields t 
LIMIT 20;

-- distribution of fields
SELECT t.field_uri, t.field_label, count(*) as num 
FROM import_fields t 
GROUP BY t.field_uri, t.field_label
ORDER BY num DESC;


SELECT field, count(*) as num
FROM (
	SELECT DISTINCT person_uri, replace(trim(field_label), ' ', '-') as field
	FROM import_fields)
GROUP BY field
order by num desc;	

-- distribution of fields classes
SELECT t.parent_class_uri, t.parent_class_label, count(*) as num 
FROM import_fields t 
GROUP BY t.parent_class_uri, t.parent_class_label
ORDER BY num DESC;



-- distribution of parent fields 
SELECT t.parent_field_uri, t.parent_field_label, count(*) as num 
FROM import_fields t 
WHERE t.field_uri NOT IN ('http://www.wikidata.org/entity/Q413', 'http://www.wikidata.org/entity/Q333')
GROUP BY t.parent_field_uri, t.parent_field_label
ORDER BY num DESC;


-- distribution of parent fields with fields
SELECT t.field_uri, t.field_label, t.parent_field_uri, t.parent_field_label, count(*) as num 
FROM import_fields t 
WHERE t.field_uri NOT IN ('http://www.wikidata.org/entity/Q413', 'http://www.wikidata.org/entity/Q333')
AND parent_field_label like '%physics%'
GROUP BY t.parent_field_uri, t.parent_field_label, t.field_uri, t.field_label
ORDER BY num DESC;



/*
 * Fields per person
*/

CREATE VIEW v_person_field AS 
WITH TW1 as (
SELECT DISTINCT person_uri, replace(trim(field_label), ' ', '-') as field
FROM import_fields
order by field
)
SELECT person_uri, group_concat(field) fields, count(*) as num
FROM tw1
GROUP BY person_uri 
ORDER BY num DESC ;

-- inspect
select *
from v_person_field
limit 10;

-- distribution of number of fields per person
select num, count(*) as n
from v_person_field
group by num;



/*
 * clusters of fields
 */


WITH RECURSIVE
-- Step 1: Gather fields per person as a sorted, comma-separated string
person_fields AS (
    SELECT 
        person_uri,
        GROUP_CONCAT(field, ',') AS fields_combo
    FROM (
        SELECT DISTINCT person_uri,  replace(trim(field_label), ' ', '-') as field
        FROM import_fields 
        ORDER BY person_uri, field
    )
    GROUP BY person_uri
),
-- Step 2: Create clusters based on identical field combinations
clusters AS (
    SELECT 
        fields_combo AS cluster_fields,
        COUNT(*) AS person_count,
        GROUP_CONCAT(person_uri) AS person_uris
    FROM person_fields
    GROUP BY fields_combo
)
-- Step 3: Output clusters with alphabetically ordered field combinations
SELECT 
    cluster_fields,
    person_count,
    person_uris
FROM clusters
ORDER BY person_count desc;



/*
* Fields analysis
*/
select fields, count(*) as n
from v_person_field
where num = 1
group by fields
order by n desc, fields;


