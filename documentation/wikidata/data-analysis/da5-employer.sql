/*
 * As this challenge requires us to deal with categorical variables, 
 * we will prepare a set of organisational categories for our population here.
 * 
 */

-- inspect organisation classes
SELECT *
FROM import_organisations_classes ioc 
LIMIT 10;

-- count classes of imported organisations
-- only organisations, not persons are counted here
SELECT ioc.organisation_class_label, count(*)as num
FROM import_organisations_classes ioc 
GROUP BY ioc.organisation_class_label 
ORDER BY num DESC;



-- add manually two new columns of type 'text' to table: import_organisations_classes
-- standard_label, coded_class


-- trim and clean up data
UPDATE import_organisations_classes set standard_label = replace(trim(lower(organisation_class_label)), ' ', '-');


-- count again
SELECT ioc.standard_label, count(*)as num
FROM import_organisations_classes ioc 
GROUP BY ioc.standard_label 
ORDER BY num DESC;



-- count classes of organisations according to persons' occupations
-- here the number depends on occupations of persons
SELECT ioc.standard_label, count(*)as num
FROM import_person_employer ipe, import_organisations_classes ioc 
WHERE ioc.organisation_uri = ipe.employer_uri 
GROUP BY ioc.standard_label 
ORDER BY num DESC;




/*
 * Code organisations
 * 
 * The aim is to group items into similar categories 
 * and avoid having too many different ones.
 * 
 */

-- test the classifiation
SELECT standard_label,
CASE
	WHEN standard_label LIKE '%univers%'
	THEN 'university'
	WHEN standard_label LIKE '%college%'
	THEN 'university'
	WHEN standard_label LIKE '%publisher%'
	THEN 'publisher'
	WHEN standard_label LIKE '%academy%'
	THEN 'academy'
	-- see beelow
	ELSE NULL
END code, ioc.coded_class 
FROM import_organisations_classes ioc
limit 1000;



-- carry out the classification
UPDATE import_organisations_classes SET coded_class =
CASE
	WHEN standard_label LIKE '%univers%'
	THEN 'university'
	WHEN standard_label LIKE '%faculty%'
	THEN 'university'
	WHEN standard_label LIKE '%college%'
	THEN 'college'
	WHEN standard_label LIKE '%school%'
	THEN 'school'
	WHEN standard_label LIKE '%école-normale-supérieure%'
	THEN 'grande-école'
	WHEN standard_label LIKE '%polytechn%'
	THEN 'grande-école'
	WHEN standard_label LIKE '%grand-établissement%'
	THEN 'grande-école'
	WHEN standard_label LIKE '%grande-école%'
	THEN 'grande-école'
	WHEN standard_label LIKE '%facility%'
	THEN 'facility'
	WHEN standard_label LIKE '%campus%'
	THEN 'facility'
	WHEN standard_label LIKE '%building%'
	THEN 'facility'
	WHEN standard_label LIKE '%observator%'
	THEN 'observatory'
	WHEN standard_label LIKE '%publish%'
	THEN 'publisher'
	WHEN standard_label LIKE '%manufact%'
	THEN 'enterprise'	
	WHEN standard_label LIKE '%enterpr%'
	THEN 'enterprise'	
	WHEN standard_label LIKE '%business%'
	THEN 'enterprise'
	WHEN standard_label LIKE '%compan%'
	THEN 'enterprise'
	WHEN standard_label LIKE '%corpor%'
	THEN 'enterprise'
	WHEN standard_label LIKE '%education%'
	THEN 'education'
	WHEN standard_label LIKE '%center%'
	THEN 'center'
	WHEN standard_label LIKE '%archives%'
	THEN 'GLAM'	
	WHEN standard_label LIKE '%historic%'
	THEN 'GLAM'	
	WHEN standard_label LIKE '%tourist%'
	THEN 'GLAM'	
	WHEN standard_label LIKE '%museum%'
	THEN 'GLAM'
	WHEN standard_label LIKE '%planetarium%'
	THEN 'GLAM'
	WHEN standard_label LIKE '%architectural-landmark%'
	THEN 'GLAM'	
	WHEN standard_label LIKE '%librar%'
	THEN 'GLAM'		
	WHEN standard_label LIKE '%organiz%'
	THEN 'organization'
	WHEN standard_label LIKE '%umr%'
	THEN 'institute'
	WHEN standard_label LIKE '%institute%'
	THEN 'institute'
	WHEN standard_label LIKE '%institutio%'
	THEN 'institution'
	WHEN standard_label LIKE '%laborat%'
	THEN 'laboratory'
	WHEN standard_label LIKE '%academ%'
	THEN 'academy'
	WHEN standard_label LIKE '%societ%'
	THEN 'academy'
	WHEN standard_label LIKE '%agency%'
	THEN 'agency'
	WHEN standard_label LIKE '%internet%'
	THEN 'agency'
	WHEN standard_label LIKE '%research%'
	THEN 'institute'
	ELSE standard_label
END;


--- count coded classes of organisations as associated to persons

--> If some dispersed or recurrent categories appear, they can be added to the UPDATE query above.

SELECT ioc.coded_class, count(*)as num
FROM import_person_employer ipe, import_organisations_classes ioc 
WHERE ioc.organisation_uri = ipe.employer_uri 
--and ioc.coded_class like '%build%'
GROUP BY ioc.coded_class 
ORDER BY num DESC;
ORDER BY coded_class;


-- inspect organisations and classes
SELECT ipe.person_uri, io.organisation_label, ioc.coded_class
FROM import_person_employer ipe,
	import_organisations io, 
	import_organisations_classes ioc 
WHERE ioc.organisation_uri = ipe.employer_uri 
AND io.organisation_uri = ipe.employer_uri
ORDER BY person_uri ASC;



/*
 * employer coded class per person
 * 
 * create a view to store the data
*/

DROP VIEW v_person_employer_class ;
CREATE VIEW v_person_employer_class AS 
WITH TW1 as (
SELECT ipe.person_uri, ioc.coded_class
FROM import_person_employer ipe,
	import_organisations_classes ioc 
WHERE ioc.organisation_uri = ipe.employer_uri 
ORDER BY ioc.coded_class ASC
)
SELECT person_uri, group_concat( distinct coded_class) employers_classes, 
		count(*) as num
FROM tw1
GROUP BY person_uri 
ORDER BY num DESC;

-- inspect
select *
from v_person_employer_class
limit 10;
offset 1000;


-- distribution of number of occupations per person
-- half with just one, the other from 2 to 23 different occupations
select num, count(*) as n
from v_person_employer_class
group by num;



select *
from v_person_employer_class
where num = 3
limit 10;
offset 1000;



/*
 * Add two columns to the person_features table
 */

ALTER TABLE person_features ADD COLUMN employer_1 TEXT ;

ALTER TABLE person_features ADD COLUMN employer_2 TEXT ;



SELECT ipe.person_uri, ioc.coded_class
FROM import_person_employer ipe,
	import_organisations_classes ioc 
WHERE ioc.organisation_uri = ipe.employer_uri 
ORDER BY ioc.coded_class ASC
LIMIT 50;



-- take for the given person the one among its occupations 
-- the one that is the most frequent in ranking in the whole population

-- Step 1: Create a Temporary Table with Global Counts
-- Run this once. It calculates the rankings a single time.

DROP TABLE temp_employer_stats ;
CREATE TEMP TABLE temp_employer_stats AS
SELECT coded_class, COUNT(*) as global_count
FROM import_person_employer ipe,
	import_organisations_classes ioc 
WHERE ioc.organisation_uri = ipe.employer_uri 
GROUP BY coded_class
ORDER BY ioc.coded_class ASC;

--verify content
SELECT *
FROM temp_employer_stats
--where coded_class like '%research%'
order by global_count DESC
limit 100;


-- Create indexes to speed up the joins

-- Optional: Create an index to speed up the JOIN later
CREATE INDEX IF NOT EXISTS idx_temp_coded_class ON temp_employer_stats(coded_class);

-- Ensure this index exists to speed up the lookup by person_uri
CREATE INDEX IF NOT EXISTS idx_import_person_employer ON import_person_employer(person_uri);

-- Ensure this index exists to speed up the join on occupation_label
CREATE INDEX IF NOT EXISTS idx_import_coded_class ON import_organisations_classes(coded_class);




/*
 * First employer: employer_1 
 */

UPDATE person_features
SET employer_1 = NULL;

-- update occupation_sec1
-- set per person the occupation value
-- that the person has and is the most frequent in the whole population
UPDATE person_features AS pf
SET employer_1 = (
    SELECT ioc.coded_class
    FROM import_person_employer AS ipe
    JOIN import_organisations_classes ioc ON ioc.organisation_uri = ipe.employer_uri 
    JOIN temp_employer_stats AS stats 
      ON ioc.coded_class = stats.coded_class
    WHERE ipe.person_uri = pf.person_uri
    --AND ioc.coded_class != pf.employer_1
    ORDER BY stats.global_count DESC, ioc.coded_class ASC
    LIMIT 1
)
WHERE 
EXISTS (
    SELECT 1 
    FROM import_person_employer AS ipe
    JOIN import_organisations_classes ioc ON ioc.organisation_uri = ipe.employer_uri 
    JOIN temp_employer_stats AS stats 
      ON ioc.coded_class = stats.coded_class
    WHERE ipe.person_uri = pf.person_uri
);


--verify inspect employer_1
select employer_1 , count(*) as num
from person_features
group by employer_1
order by num desc;




-- count available information
SELECT code_o, COUNT(*) num
FROM  (
SELECT 
	CASE 
		WHEN employer_1 IS NULL
		THEN 'na'
		ELSE 'val'
	END as code_o
	FROM person_features
	)
GROUP BY code_o	;



SELECT code_o, COUNT(*) num
FROM  (
SELECT 
	CASE 
		WHEN per_emp.person_uri IS NULL
		THEN 'na'
		ELSE 'value'
	END as code_o
	FROM person p 
		LEFT join (select distinct person_uri 
				from import_person_employer ipe ) as per_emp
		ON p.wikidata_uri  = per_emp.person_uri
	)
GROUP BY code_o	;


DROP TABLE temp_employer_1 ;
CREATE TEMP TABLE temp_employer_1 AS
select employer_1 , count(*) as num
from person_features
group by employer_1
order by num desc;


--verify inspect employer_1
select employer_1 , count(*) as num
from person_features
group by employer_1
order by num desc;


-- inspect employer where number less than 30
select *
from person_features pf
join temp_employer_1 te1 on pf.employer_1 = te1.employer_1
where te1.num < 30
limit 10;

-- code small numbers with category: 'other'
UPDATE person_features
SET employer_1 = 'other'
WHERE employer_1 IN (
    SELECT employer_1
    FROM temp_employer_1
    WHERE num < 30
);




/*
 * Second employer: employer_2
 */

UPDATE person_features
SET employer_2 = NULL;

-- update employer_2
-- set per person the employer value (excluding 'university')
-- that the person has and is the most frequent in the whole population
UPDATE person_features AS pf
SET employer_2 = (
    SELECT ioc.coded_class
    FROM import_person_employer AS ipe
    JOIN import_organisations_classes ioc ON ioc.organisation_uri = ipe.employer_uri 
    JOIN temp_employer_stats AS stats 
      ON ioc.coded_class = stats.coded_class
    WHERE ipe.person_uri = pf.person_uri
    -- we take again here all coded classes, just not univerisities
    AND ioc.coded_class NOT IN ('university', 'former-entity')   --pf.employer_1
    ORDER BY stats.global_count DESC, ioc.coded_class ASC
    LIMIT 1
)
WHERE 
EXISTS (
    SELECT 1 
    FROM import_person_employer AS ipe
    JOIN import_organisations_classes ioc ON ioc.organisation_uri = ipe.employer_uri 
    JOIN temp_employer_stats AS stats 
      ON ioc.coded_class = stats.coded_class
    WHERE ipe.person_uri = pf.person_uri
);


--verify update and inspect employer_2
select employer_2 , count(*) as num
from person_features
group by employer_2
order by num desc;


-- count inserted values
SELECT code_o, COUNT(*) num
FROM  (
SELECT 
	CASE 
		WHEN employer_2 IS NULL
		THEN 'na'
		ELSE 'val'
	END as code_o
	FROM person_features
	)
GROUP BY code_o	;


DROP TABLE temp_employer_2 ;
CREATE TEMP TABLE temp_employer_2 AS
select employer_2 , count(*) as num
from person_features
group by employer_2
order by num desc;


-- inspect employer where number less than 50
select *
from person_features pf
join temp_employer_2 te2 on pf.employer_2 = te2.employer_2
where te2.num < 15
limit 10;

-- code small numbers with category: 'other'
UPDATE person_features
SET employer_2 = 'other'
WHERE employer_2 IN (
    SELECT employer_2
    FROM temp_employer_2
    WHERE num < 15
);


/*
 * Explore coded occupations
 */

select *
from person_features
limit 100;


select employer_2 , count(*) as num
from person_features
group by employer_2
order by num desc;


select occupation_sec1, employer_2 , count(*) as num
from person_features
group by employer_2,occupation_sec1
order by num desc;

select employer_1, employer_2, count(*) as num
from person_features
where employer_1 = 'university'
group by employer_1,employer_2
order by num desc;


/*
 * Add finally university where no other employer available,
 * or as a prefix if university and another employer
 */


select 
  CASE 
  	WHEN employer_1 = 'university' AND employer_2 is null
  	THEN 'university'
  	WHEN employer_1 = 'university' AND employer_2 is not null
  	THEN 'univ_' || employer_2
	ELSE employer_2
  END coded_employer,
employer_1, employer_2, count(*) as num
from person_features
where employer_1 = 'university'
OR employer_2 is not null
group by coded_employer, employer_1,employer_2
order by num desc;

/*
 * Add column coded_employer to the person_features table
 */

ALTER TABLE person_features ADD COLUMN coded_employer TEXT ;

update person_features SET coded_employer = CASE 
  	WHEN employer_1 = 'university' AND employer_2 is null
  	THEN 'university'
  	--WHEN employer_1 = 'university' AND employer_2 is not null
  	--THEN 'univ_' || employer_2
	ELSE employer_2
  END 
where employer_1 = 'university'
OR employer_2 is not null;



select coded_employer, count(*) as num
from person_features
group by coded_employer 
order by num desc;


/* 
 * final query for export dans analysis
 * 
 * We take all the persons that have a secondary occupation
 * or a coded employer class.
 *
 * We also add the coded main occupation, i.e. also the main discipline: astronomy, physics 
 *
 * This is a relevant heuristic choice that must be stated clearly,
 * and revised if needed.
 *  
 * Result: da5_persons_features.csv
 * 
 */


select *
from person_features 
WHERE occupation_sec1 != 'NA'
AND coded_employer is not NULL
limit 10;

-- 10900 persons
select COUNT(*) as num
from person_features 
WHERE occupation_sec1 != 'NA'
AND occupation_main != 'NA'
AND coded_employer is not NULL;


select occupation_sec1, COUNT(*) as num
from person_features 
WHERE occupation_main == 'NA'
group by occupation_sec1 
order by num desc;



-- final query to be exported to file: da5-persons-features.csv
SELECT pk_person_features, person_uri, occupation_main, occupation_sec1, coded_employer
from person_features 
WHERE occupation_sec1 != 'NA'
AND occupation_main != 'NA'
AND coded_employer is not NULL;
limit 100;


