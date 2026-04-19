
/*
* Explore occupations
*/

-- number of rows
SELECT count(*)
FROM import_occupations t ;


-- trim and clean up data
UPDATE import_occupations set occupation_label = replace(trim(lower(occupation_label)), ' ', '-');


-- number of people with an occupation
SELECT count(*)
FROM (
SELECT DISTINCT person_uri
FROM import_occupations t );

	
-- distribution of occupations
SELECT occupation_label, count(*) as num
FROM (
	SELECT DISTINCT person_uri, occupation_label
	FROM import_occupations)
GROUP BY occupation_label
order by num desc;		






/*
 * occupations per person
 * 
 * create a view to store the data
*/

DROP VIEW v_person_occupation ;
CREATE VIEW v_person_occupation AS 
WITH TW1 as (
SELECT DISTINCT person_uri, occupation_label
FROM import_occupations
order by occupation_label
)
SELECT person_uri, group_concat( distinct occupation_label) occupations, count(*) as num
FROM tw1
GROUP BY person_uri 
ORDER BY num DESC ;

-- inspect
select *
from v_person_occupation
limit 10;
offset 1000;


-- distribution of number of occupations per person
-- half with just one, the other from 2 to 23 different occupations
select num, count(*) as n
from v_person_occupation
group by num;





/*
* co-occurrences of occupations
*/
select occupations, count(*) as n
from v_person_occupation
where num = 2
--where num = 3
--where num = 3
group by occupations
order by n desc, occupations;





/*
 * Create a new table with additional persons features
 * one row per person
 */

DROP TABLE person_features ;
CREATE TABLE person_features (pk_person_features INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
person_uri TEXT,
occupation_main TEXT,
occupation_sec1 TEXT,
occupation_sec2 TEXT,
field_main TEXT,
field_sec1 TEXT,
field_sec2 TEXT,
fk_person INTEGER,
notes TEXT);

-- add column and create 1 to 1 relationship
--INSERT INTO person_features (person_uri, fk_person)
select wikidata_uri, pk_person 
from person ;




/* 
 * insert main occupation
 * 
 * note that the population was defined 
 * through occupations (physicists, atronomer) 
 * and fields (physics, astronomy)
 * 
 *
 */

-- explore the persons with just one occupation
SELECT vpo.occupations, count(*) as num
from v_person_occupation vpo 
where vpo.num = 1
group by occupations
order by num desc;




-- empty column if errors and restart
--UPDATE person_features
SET occupation_main = NULL;

/*
 * Treat first main occupations
 * 
 * note that this data was collected using occupations and fields
 * those that do not have an occupation as astronomer of physicist
 * have a correspondent field: astronomy or physics
 * 
 */

-- Astronomers

-- verify that per person only one row with value 'astronomer'
-- result must be empty
select io.person_uri
from import_occupations io 
where io.occupation_label = 'astronomer'
group by io.person_uri 
having count(*) > 1;


-- set the value astronomer if astronomer as occupation
update person_features
SET occupation_main = 'astronomer'
FROM import_occupations io 
WHERE io.person_uri = person_features.person_uri
AND io.occupation_label = 'astronomer';

-- Physicists


-- verify that per person only one row with value 'physicist'
-- result must be empty
select io.person_uri
from import_occupations io 
where io.occupation_label = 'physicist'
group by io.person_uri 
having count(*) > 1;


update person_features
SET occupation_main = 'physicist'
FROM import_occupations io 
WHERE io.person_uri = person_features.person_uri
-- do not delete the 'astronomer' already added values
AND person_features.occupation_main IS NULL
AND io.occupation_label = 'physicist';


-- NA : missing main occupation
-- only specific ones
update person_features
SET occupation_main = 'NA'
WHERE person_features.occupation_main IS NULL;





--verify import
select occupation_main, count(*) as num
from person_features
group by occupation_main;


-- secondary occupations
select io.occupation_label, count(*) as num
from person_features pf, import_occupations io 
where pf.person_uri = io.person_uri 
AND occupation_main = 'NA'
group by occupation_label
order by num desc;



-- take for the given person the one among its occupations 
-- the one that is the most frequent in ranking in the whole population

-- Step 1: Create a Temporary Table with Global Counts
-- Run this once. It calculates the rankings a single time.

DROP TABLE temp_global_stats ;
CREATE TEMP TABLE temp_global_stats AS
SELECT occupation_label, COUNT(*) as global_count
FROM import_occupations
-- we exclude the main occupations
WHERE occupation_label NOT IN ('physicist', 'astronomer')
GROUP BY occupation_label;


-- Create indexes to speed up the joins

-- Optional: Create an index to speed up the JOIN later
CREATE INDEX idx_stats_occupation ON temp_global_stats(occupation_label);

-- Ensure this index exists to speed up the lookup by person_uri
CREATE INDEX IF NOT EXISTS idx_import_person ON import_occupations(person_uri);

-- Ensure this index exists to speed up the join on occupation_label
CREATE INDEX IF NOT EXISTS idx_import_occ ON import_occupations(occupation_label);

--verify content
SELECT *
FROM temp_global_stats
order by global_count DESC
limit 20;

/*
 * First secondary occupation: occupation_sec1 
 */

--UPDATE person_features
SET occupation_sec1 = NULL;

-- update occupation_sec1
-- set per person the occupation value
-- that the person has and is the most frequent in the whole population
UPDATE person_features AS pf
SET occupation_sec1 = (
    SELECT o_inner.occupation_label
    FROM import_occupations AS o_inner
    JOIN temp_global_stats AS stats 
      ON o_inner.occupation_label = stats.occupation_label
    WHERE o_inner.person_uri = pf.person_uri
    AND o_inner.occupation_label != pf.occupation_main
    ORDER BY stats.global_count DESC, o_inner.occupation_label ASC
    LIMIT 1
)
WHERE 
EXISTS (
    SELECT 1 
    FROM import_occupations AS o_check
    JOIN temp_global_stats AS s_check 
      ON o_check.occupation_label = s_check.occupation_label
    WHERE o_check.person_uri = pf.person_uri
);



--verify update
select occupation_sec1, count(*) as num
from person_features
group by occupation_sec1
order by num desc;


UPDATE person_features
SET occupation_sec1 = 'NA'
WHERE occupation_sec1 IS NULL;


-- only half of the population has a secondary occupation
select occupation_sec1, count(*) as num
from person_features
group by occupation_sec1
order by num desc;



SELECT code_o, COUNT(*) num
FROM  (
SELECT 
	CASE 
		WHEN occupation_sec1 = 'NA'
		THEN 'na'
		ELSE 'val'
	END as code_o
	FROM person_features
	)
GROUP BY code_o	;


/*
 * Second secondary occupation: occupation_sec2 
 */

--UPDATE person_features
SET occupation_sec2 = NULL;

-- update occupation_sec2
UPDATE person_features AS pf
SET occupation_sec2 = (
    SELECT o_inner.occupation_label
    FROM import_occupations AS o_inner
    JOIN temp_global_stats AS stats 
      ON o_inner.occupation_label = stats.occupation_label
    WHERE o_inner.person_uri = pf.person_uri
    AND o_inner.occupation_label != pf.occupation_sec1
    AND o_inner.occupation_label != pf.occupation_main
    ORDER BY stats.global_count DESC, o_inner.occupation_label ASC
    LIMIT 1
)
WHERE 
EXISTS (
    SELECT 1 
    FROM import_occupations AS o_check
    JOIN temp_global_stats AS s_check 
      ON o_check.occupation_label = s_check.occupation_label
    WHERE o_check.person_uri = pf.person_uri
);


UPDATE person_features
SET occupation_sec2 = 'NA'
WHERE occupation_sec2 IS NULL;

--verify update: only a fifth has a secondary occupation
select occupation_sec2, count(*) as num
from person_features
group by occupation_sec2
order by num desc;

-- count
SELECT code_o, COUNT(*) num
FROM  (
SELECT 
	CASE 
		WHEN occupation_sec2 = 'NA'
		THEN 'na'
		ELSE 'val'
	END as code_o
	FROM person_features
	)
GROUP BY code_o	;




/*
 * Explore coded occupations
 */

select *
from person_features
limit 100;

--Explore the cooccurences in the two columns
select occupation_main, occupation_sec1, count(*) as num
from person_features
where occupation_main != 'NA'
group by occupation_main, occupation_sec1
order by num desc;


--Explore the cooccurences in the three columns
select occupation_main, occupation_sec1, occupation_sec2, count(*) as num
from person_features
where occupation_main != 'NA'
and occupation_sec1 != 'NA'
and occupation_sec2 != 'NA'
group by occupation_main, occupation_sec1, occupation_sec2
order by num desc;


-- > there would be a huge clean up work to be done
-- > we can try to use occupation_main, occupation_sec1 
-- where it is available


















/*
* Explore fields
*/

-- number of rows
SELECT count(*)
FROM import_fields t ;


-- trim
UPDATE import_fields set field_label = replace(trim(lower(field_label)), ' ', '-');



-- distribution of fields
SELECT field_label, count(*) as num
FROM (
	SELECT DISTINCT person_uri, field_label
	FROM import_fields)
GROUP BY field_label
order by num desc;		



-- number of people with a field:
-- a thirs of the population has a field
SELECT count(*)
FROM (
SELECT DISTINCT person_uri
FROM import_fields t );

	






/*
 * fields per person
*/

DROP VIEW v_person_field ;
CREATE VIEW v_person_field AS 
WITH TW1 as (
SELECT DISTINCT person_uri, field_label
FROM import_fields
order by field_label
)
SELECT person_uri, group_concat( distinct field_label) fields, count(*) as num
FROM tw1
GROUP BY person_uri 
ORDER BY num DESC ;

-- inspect
select *
from v_person_field
limit 10
offset 1000;


-- distribution of number of fields per person
select num, count(*) as n
from v_person_field
group by num;



-- distribution of fields other than basic ones
SELECT field_label, count(*) as num
FROM (
	SELECT DISTINCT person_uri, field_label
	FROM import_fields
	where field_label not in ('physics', 'astronomy')
)
GROUP BY field_label
order by num desc;	

-- > only a small subset of the population


/*
* fields analysis
*/
select fields, count(*) as n
from v_person_field
where num = 3
group by fields
order by n desc, fields;







/* 
 * insert main field
 * 
 * note that the population was defined 
 * through fields (physicists, atronomer) 
 * and fields (physics, astronomy)
 * 
 *
 */

-- explore
SELECT vpo.fields, count(*) as num
from v_person_field vpo 
where vpo.num = 1
group by fields
order by num desc;


-- to empty the column in case of errors
--UPDATE person_features
SET field_main = NULL;



-- Astronomers
update person_features
SET field_main = 'astronomy'
FROM import_fields io 
WHERE io.person_uri = person_features.person_uri
AND io.field_label = 'astronomy';

-- Physicists
update person_features
SET field_main = 'physics'
FROM import_fields io 
WHERE io.person_uri = person_features.person_uri
AND person_features.field_main IS NULL
AND io.field_label = 'physics';


--verify import
select field_main, count(*) as num
from person_features
group by field_main;


select io.field_label, count(*) as num
from person_features pf, import_fields io 
where pf.person_uri = io.person_uri 
AND field_main IS NULL
group by field_label
order by num desc;



-- take for the given person the one among its fields that is the most frequent in ranking in the whole population

-- Step 1: Create a Temporary Table with Global Counts
-- Run this once. It calculates the rankings a single time.

DROP TABLE temp_global_field_stats ;
CREATE TEMP TABLE temp_global_field_stats AS
SELECT field_label, COUNT(*) as global_count
FROM import_fields
WHERE field_label NOT IN ('physics', 'astronomy')
GROUP BY field_label;

-- Optional: Create an index to speed up the JOIN later
CREATE INDEX IF NOT EXISTS idx_stats_field ON temp_global_field_stats(field_label);

-- Ensure this index exists to speed up the lookup by person_uri
CREATE INDEX IF NOT EXISTS idx_import_person ON import_fields(person_uri);

-- Ensure this index exists to speed up the join on field_label
CREATE INDEX IF NOT EXISTS idx_import_occ ON import_fields(field_label);

-- optimization
CREATE INDEX IF NOT EXISTS idx_pf_field_main_null ON person_features(field_main);
CREATE INDEX IF NOT EXISTS idx_pf_person_uri_null ON person_features(person_uri);

--verify content
SELECT *
FROM temp_global_field_stats
order by global_count DESC
limit 20;

-- update field main
UPDATE person_features AS pf
SET field_main = (
    SELECT o_inner.field_label
    FROM import_fields AS o_inner
    JOIN temp_global_field_stats AS stats 
      ON o_inner.field_label = stats.field_label
    WHERE o_inner.person_uri = pf.person_uri
    ORDER BY stats.global_count DESC, o_inner.field_label ASC
    LIMIT 1
)
WHERE pf.field_main IS NULL
AND EXISTS (
    SELECT 1 
    FROM import_fields AS o_check
    JOIN temp_global_field_stats AS s_check 
      ON o_check.field_label = s_check.field_label
    WHERE o_check.person_uri = pf.person_uri
);


update person_features 
set field_main = 'NA'
where field_main is null;

--verify update
select field_main, count(*) as num
from person_features
group by field_main
order by num desc;





-- if wrong data
--UPDATE person_features
SET field_sec1 = NULL;

-- update field_sec1
UPDATE person_features AS pf
SET field_sec1 = (
    SELECT o_inner.field_label
    FROM import_fields AS o_inner
    JOIN temp_global_field_stats AS stats 
      ON o_inner.field_label = stats.field_label
    WHERE o_inner.person_uri = pf.person_uri
    AND o_inner.field_label != pf.field_main
    ORDER BY stats.global_count DESC, o_inner.field_label ASC
    LIMIT 1
)
WHERE 
EXISTS (
    SELECT 1 
    FROM import_fields AS o_check
    JOIN temp_global_field_stats AS s_check 
      ON o_check.field_label = s_check.field_label
    WHERE o_check.person_uri = pf.person_uri
);


update person_features 
set field_sec1 = 'NA'
where field_sec1 is null;


--verify update
select field_sec1, count(*) as num
from person_features
group by field_sec1
order by num desc;






-- update field_sec2
UPDATE person_features AS pf
SET field_sec2 = (
    SELECT o_inner.field_label
    FROM import_fields AS o_inner
    JOIN temp_global_field_stats AS stats 
      ON o_inner.field_label = stats.field_label
    WHERE o_inner.person_uri = pf.person_uri
    AND o_inner.field_label != pf.field_sec1
    AND o_inner.field_label != pf.field_main
    ORDER BY stats.global_count DESC, o_inner.field_label ASC
    LIMIT 1
)
WHERE 
EXISTS (
    SELECT 1 
    FROM import_fields AS o_check
    JOIN temp_global_field_stats AS s_check 
      ON o_check.field_label = s_check.field_label
    WHERE o_check.person_uri = pf.person_uri
);


update person_features 
set field_sec2 = 'NA'
where field_sec2 is null;


--verify update
select field_sec2, count(*) as num
from person_features
group by field_sec2
order by num desc;





/*
 * Explore coded fields
 */

select *
from person_features
limit 100;


--verify three fields
select field_main, field_sec1, field_sec2, count(*) as num
from person_features
group by field_main, field_sec1, field_sec2
order by num desc;


--Explore the cooccurences in the two columns
select field_main, field_sec1, count(*) as num
from person_features
where field_main != 'NA'
group by field_main, field_sec1
order by num desc;

--Explore the cooccurences in the two columns
select field_main, field_sec1, count(*) as num
from person_features
where field_main != 'NA'
and field_sec1 != 'NA'
group by field_main, field_sec1
order by num desc;


--Explore the cooccurences in the three columns
select field_main, field_sec1, field_sec2, count(*) as num
from person_features
where field_main != 'NA'
and field_sec1 != 'NA'
and field_sec2 != 'NA'
group by field_main, field_sec1, field_sec2
order by num desc;


-- > there would be a huge clean up work to be done
-- > we can try to use field_main, field_sec1 
-- where it is available




--Explore the cooccurences in the two columns
select field_main, field_sec1, count(*) as num
from person_features
where field_main != 'NA'
and field_sec1 != 'NA'
group by field_main, field_sec1
order by num desc;



SELECT code_o, COUNT(*) num
FROM  (
SELECT 
	CASE 
		WHEN field_sec1 = 'NA'
		THEN 'na'
		ELSE 'val'
	END as code_o
	FROM person_features
	)
GROUP BY code_o	;


--Explore the cooccurences in the two columns and add occupations
select field_main, field_sec1, occupation_main, occupation_sec1, count(*) as num
from person_features
where field_main != 'NA'
and field_sec1 != 'NA'
group by field_main, field_sec1, occupation_main, occupation_sec1
order by num desc;


-- CODED OCCUPATION : use this

SELECT 
CASE 
	when occupation_sec1 = 'NA' then occupation_main
	else occupation_sec1
END coded_occup, count(*) num
FROM person_features
group by coded_occup
order by num desc;





select field_main, field_sec1, occupation_main, occupation_sec1, count(*) as num
from person_features
where field_main != 'NA'
and field_sec1 != 'NA'
group by field_main, field_sec1, occupation_main, occupation_sec1
order by num desc;




select *
from person_features
limit 100
offset 1000;

select *
from person_features
where field_main = 'NA'
limit 100;





-- export to fils da4_
select *
from person_features;


