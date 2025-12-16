
---- créer la table pour les données de la requête
-- du fichier DBpedia/linked_resources/IdRef_and_SUDOC.md


CREATE TABLE idref_books (
	dbp_uri NVARCHAR(64),
	idref_uri NVARCHAR(50),
	idrefpersonlabel VARCHAR(50),
	book_date INTEGER,
	biblioref VARCHAR(512),
	bookuri NVARCHAR(50),
	person NVARCHAR(64),
	idrefperson NVARCHAR(50),
	personauthor NVARCHAR(50),
	personauthorlabel VARCHAR(128),
	book_uri NVARCHAR(50),
	pk_idref_books INTEGER PRIMARY KEY AUTOINCREMENT
);


DELETE FROM idref_books;

/*
* Remettre la séquence à zéro
*/
UPDATE SQLITE_SEQUENCE 
SET seq = 0
WHERE name ='idref_books';

/* 
après avoir vidé la table exécuter une instruction vacuum afin de vider la mémoire
*/
VACUUM;


/*
 * Importation des données via l'interface graphique DBeaver, 
 * puis exploration ici
 */


select *
from idref_books ib
limit 10;


-- extraire les titres
select ib.pk_idref_books, SUBSTR(ib.biblioref, 1, INSTR(ib.biblioref, '/') - 1) AS title
FROM idref_books ib 
limit 20;


-- ajouter une colonne titre
UPDATE idref_books SET title = TRIM(SUBSTR(biblioref, 1, INSTR(biblioref, '/') - 1));



/*
 * Décomposer les références bibliographiques
 */


--- inspection de la première partie de la reuête: extraire le premier token
-- traitement des cas sans ' ' pour éviter la boule infinie du récursif
SELECT
    pk_idref_books, book_date,
    CASE 
	    WHEN (INSTR(title, ' ')) > 0 THEN SUBSTR(title , 1, INSTR(title , ' ') - 1)
		ELSE
			title
	END part,
	CASE 
	    WHEN INSTR(title, ' ') > 0 THEN SUBSTR(title , INSTR(title , ' ') + 1)
		ELSE
			''
	END remainder
FROM idref_books ;


-- en ajoutant la récursivité
WITH RECURSIVE splitter AS (
	SELECT
    pk_idref_books, book_date,
    1 as pk_token,
    CASE 
	    WHEN (INSTR(title, ' ')) > 0 THEN SUBSTR(title , 1, INSTR(title , ' ') - 1)
		ELSE
			title
	END part,
	CASE 
	    WHEN INSTR(title, ' ') > 0 THEN SUBSTR(title , INSTR(title , ' ') + 1)
		ELSE
			''
	END remainder
	FROM idref_books 
    UNION ALL
		SELECT
		    pk_idref_books, book_date,
		    pk_token + 1 AS pk_token,
		    CASE 
	    WHEN (INSTR(remainder, ' ')) > 0 THEN SUBSTR(remainder , 1, INSTR(remainder , ' ') - 1)
		ELSE
			remainder
	END part,
	CASE 
	    WHEN INSTR(remainder, ' ') > 0 THEN SUBSTR(remainder , INSTR(remainder , ' ') + 1)
		ELSE
			''
	END remainder
		FROM
        splitter
    WHERE
        remainder != ''
)
SELECT
    pk_idref_books, book_date, pk_token, TRIM(part) as token, remainder
FROM
    splitter
order by pk_idref_books ;


-- créer une vue avec ces données
DROP VIEW v_biblioref_split;
CREATE VIEW v_biblioref_split AS 
 WITH RECURSIVE splitter AS (
	SELECT
    pk_idref_books, book_date,
    1 as pk_token,
    CASE 
	    WHEN (INSTR(title, ' ')) > 0 THEN SUBSTR(title , 1, INSTR(title , ' ') - 1)
		ELSE
			title
	END part,
	CASE 
	    WHEN INSTR(title, ' ') > 0 THEN SUBSTR(title , INSTR(title , ' ') + 1)
		ELSE
			''
	END remainder
	FROM idref_books 
    UNION ALL
		SELECT
		    pk_idref_books, book_date,
		    pk_token + 1 AS pk_token,
		    CASE 
	    WHEN (INSTR(remainder, ' ')) > 0 THEN SUBSTR(remainder , 1, INSTR(remainder , ' ') - 1)
		ELSE
			remainder
	END part,
	CASE 
	    WHEN INSTR(remainder, ' ') > 0 THEN SUBSTR(remainder , INSTR(remainder , ' ') + 1)
		ELSE
			''
	END remainder
		FROM
        splitter
    WHERE
        remainder != ''
)
SELECT
    pk_idref_books, book_date, pk_token, TRIM(part) as token
FROM
    splitter
order by pk_idref_books, pk_token;


-- inspect view
SELECT * FROM v_biblioref_split vbs 
limit 50;
	




-- Compter les tokens courts
SELECT token, count(*) as number
FROM v_biblioref_split
WHERE length(token) < 4
GROUP BY  token0
ORDER BY number desc;



/*
 * Token les plus fréquents
 */

-- Compter les mots le plus fréquents 
-- de 4 caractères et plus
WITH tw1 AS  (
SELECT pk_idref_books, book_date, token 
FROM v_biblioref_split
WHERE length(token) > 3
AND token not in ('The', 'with', 'from', 'dans', 
		'Die', 'über', 'pour', 'della')
)
SELECT token, count(*) as number, min(book_date) min_date, max(book_date) max_date
FROM tw1
GROUP BY token;
ORDER BY number desc;


-- inspecter les fréquences des mots en fonction des périodes
WITH tw1 AS  (
SELECT pk_idref_books, book_date, token 
FROM v_biblioref_split
WHERE length(token) > 3
AND token not in ('The', 'with', 'from', 'dans', 
		'Die', 'über', 'pour', 'della')
)
SELECT token, count(*) as number, min(book_date) min_date, max(book_date) max_date
FROM tw1
GROUP BY token
HAVING COUNT(*) > 5
ORDER BY max_date;


/*
 * Recomposer les titres
 */

CREATE VIEW v_simplified_titles AS
WITH tw1 AS  (
SELECT pk_idref_books, book_date, token 
FROM v_biblioref_split
WHERE length(token) > 3
AND token not in ('The', 'with', 'from', 'dans', 
		'Die', 'über', 'pour', 'della')
)
select pk_idref_books, book_date, group_concat(token, ' ') simplified_title
from tw1
group by pk_idref_books, book_date;

SELECT *
from v_simplified_titles;



/*
 * Préparation de chunks de deux mots
 */

WITH tw1 AS  (
SELECT pk_idref_books, pk_token, book_date, TRIM(token, ',') as token
FROM v_biblioref_split
WHERE length(token) > 3
AND token not in ('The', 'with', 'from', 'dans', 
		'Die', 'über', 'pour', 'della')
ORDER BY pk_idref_books, pk_token
)
SELECT *
FROM tw1
LIMIT 50;



-- chunks de deux mots
WITH tw1 AS  (
SELECT pk_idref_books, pk_token, book_date, TRIM(token, ',') as token
FROM v_biblioref_split
WHERE length(token) > 3
-- auteurs et non rééditions
AND book_date > 1800
AND token not in ('The', 'with', 'from', 'dans', 
		'Die', 'über', 'pour', 'della')
ORDER BY pk_idref_books, pk_token
),
tw2 as (
select pk_idref_books, book_date, group_concat(token, ' ') simplified_title
from tw1
group by pk_idref_books, book_date
	),
	tw3 AS (
select t1.pk_idref_books, t1.book_date, t1.pk_token tok1, t2.pk_token tok2, 
(t2.pk_token-t1.pk_token) as diff,
t1.token || ' ' || t2.token AS chunk, tw2.simplified_title
FROM tw1 t1, tw1 t2, tw2
WHERE t1.pk_idref_books = t2.pk_idref_books 
AND tw2.pk_idref_books = t1.pk_idref_books
AND NOT(t1.token LIKE '%;')
AND t1.pk_token < t2.pk_token
), tw4 AS (
SELECT pk_idref_books, tok1, min(tok2) tok2
FROM tw3
GROUP BY pk_idref_books, tok1)
SELECT tw3.*
FROM tw3, tw4 
where tw3.pk_idref_books = tw4.pk_idref_books 
and tw3.tok1 = tw4.tok1 
and tw3.tok2 = tw4.tok2;


DROP VIEW v_chunks ;
CREATE VIEW v_chunks AS
WITH tw1 AS  (
SELECT pk_idref_books, pk_token, book_date, TRIM(token, ',') as token
FROM v_biblioref_split
WHERE length(token) > 3
-- auteurs et non rééditions
AND book_date > 1800
AND token not in ('The', 'with', 'from', 'dans', 
		'Die', 'über', 'pour', 'della')
ORDER BY pk_idref_books, pk_token
),
tw2 as (
select pk_idref_books, book_date, group_concat(token, ' ') simplified_title
from tw1
group by pk_idref_books, book_date
	),
	tw3 AS (
select t1.pk_idref_books, t1.book_date, t1.pk_token tok1, t2.pk_token tok2, 
(t2.pk_token-t1.pk_token) as diff,
t1.token || ' ' || t2.token AS chunk, tw2.simplified_title
FROM tw1 t1, tw1 t2, tw2
WHERE t1.pk_idref_books = t2.pk_idref_books 
AND tw2.pk_idref_books = t1.pk_idref_books
AND NOT(t1.token LIKE '%;')
AND t1.pk_token < t2.pk_token
), tw4 AS (
SELECT pk_idref_books, tok1, min(tok2) tok2
FROM tw3
GROUP BY pk_idref_books, tok1)
SELECT tw3.*
FROM tw3, tw4 
where tw3.pk_idref_books = tw4.pk_idref_books 
and tw3.tok1 = tw4.tok1 
and tw3.tok2 = tw4.tok2;


-- inspecter la vue
SELECT chunk, count(*) as number, min(book_date) min_date, max(book_date) max_date
FROM v_chunks vc  
GROUP BY chunk
--HAVING max_date < 1901
HAVING min_date > 1900
--AND max_date < 1961
--AND min_date > 
--ORDER BY min_date, number desc;
ORDER BY "number" desc;

SELECT min(book_date) min_date, max(book_date) max_date
FROM v_chunks vc ;

SELECT *
FROM v_chunks vc 
ORDER BY book_date 
LIMIT 100;


/*
 * From clusters
 */


SELECT class, count(*) as eff, min(book_date) min_date, max(book_date) max_date
FROM book_titles_clusters
GROUP BY class;

SELECT *
FROM book_titles_clusters
WHERE class = 0
limit 100;


/*
 * Classes:
 * 0 -- theory
 * 2 -- l'univers
 * 
 */

SELECT *
FROM book_titles_clustered btc 
limit 10;

SELECT cluster, count(*) as eff, min(book_date) min_date, max(book_date) max_date
FROM book_titles_clustered btc 
GROUP BY cluster;















----------------------

with epoque as (
select 
	case 
		when date_naiss > 750 AND Date_naiss < 1401
		then '01-moyen-age'
		when date_naiss > 1400 AND Date_naiss < 1551
		then '02-renaissance'
		when date_naiss > 1550 AND Date_naiss < 1771
		then '03-ancien-regime'
		when date_naiss > 1770 AND Date_naiss < 1881
		then '04-19-siecle'
		when date_naiss > 1880 AND Date_naiss < 1951
		then '05-20-siecle'
		when date_naiss > 1950 
		then '06-epoque-contemporaine'
	end epoque
FROM "20170907_persovd" p 
where Date_naiss > 750
and Date_naiss < 2010)
select epoque, count(*) as number
from epoque 
group by epoque;
