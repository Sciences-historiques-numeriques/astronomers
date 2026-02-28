

SELECT *
FROM sparql_person sp 
limit 10;


-- compter les personnes (?)
SELECT count(*)
FROM sparql_person sp ;


-- doublons ? Non !
SELECT sp.person, count(*)
FROM sparql_person sp 
group by person 
having count(*) > 1;


INSERT INTO person (person_orig_uri, name, birth_year  )
SELECT sp.person, sp.persName, sp.birthYear 
FROM  sparql_person sp ;


with epoque as (
select 
	case 
		when birth_year > 1770 AND birth_year < 1821
		then '1771-1820'
		when birth_year > 1820 AND birth_year < 1871
		then '1821-1870'
		when birth_year > 1870 AND birth_year < 1921
		then '1871-1920'
		when birth_year > 1920 AND birth_year < 1971
		then '1921-1970'
		when birth_year > 1970 
		then '1971-'
	end epoque
FROM person p 
)
select epoque, count(*) as number
from epoque 
group by epoque;