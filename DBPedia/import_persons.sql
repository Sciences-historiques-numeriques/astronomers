
/*
 * Inspecter la table issue de DBpedia
 */


-- si le résultat est vide (pas de lignes) il n'y a pas de doublons
SELECT person_uri
FROM dbp_liste_personnes lp 
GROUP BY person_uri
HAVING COUNT(*) > 1 ;


/*
 * Vider la table des personnes,
 * puis importer depuis la liste des personnes
 */


--DELETE FROM "person" ;

/*
* Remettre la séquence à zéro
*/
UPDATE SQLITE_SEQUENCE 
SET seq = 0
WHERE name ='person';

/* 
après avoir vidé la table exécuter une instruction vacuum afin de vider la mémoire
*/
VACUUM;



-- importer les personnes
INSERT INTO person (birth_year, dbpedia_uri, label, import_metadata)
SELECT birthYear, person_uri, persname, "Importé le 22 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, cf. astronomers/DBpedia_importer_dans_base_personnelle"
FROM dbp_liste_personnes lp ;   

-- en cas de doublons
-- prendre seulement le nom et années de naissance les plus grands
-- pour les personnes concernées
INSERT INTO person (birth_year, dbpedia_uri, label, import_metadata)
SELECT max(birthYear), person_uri, max(persname), "Importé le 22 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, cf. astronomers/DBpedia_importer_dans_base_personnelle"
FROM dbp_liste_personnes lp
GROUP BY person_uri   ; 



/*
 * Inspection des données importées
 */

SELECT *
FROM person p 
LIMIT 10;



/* 
 * Exploration:
 * 
 * distribution des années de naissance
 *
 */


SELECT max(birth_year)
FROM person;

-- coder par périodes de 50 ans puis de 30 ans
SELECT 
	CASE 
		WHEN birth_year > 1770 AND birth_year < 1801
		THEN '1771_1800'
		WHEN birth_year > 1800 AND birth_year < 1831
		THEN '1801_1830'
		WHEN birth_year > 1830 AND birth_year < 1861
		THEN '1831_1860'
		WHEN birth_year > 1860 AND birth_year < 1891
		THEN '1831_1890'
		WHEN birth_year > 1890 AND birth_year < 1921
		THEN '1891_1920'
		WHEN birth_year > 1920 AND birth_year < 1951
		THEN '1921-1950'
		WHEN birth_year > 1950 
		THEN '1951-'
	end epoque
FROM person ;


-- compter les naissances par époque
WITH tw1 AS (
SELECT 
	CASE 
		WHEN birth_year > 1770 AND birth_year < 1801
		THEN '1771_1800'
		WHEN birth_year > 1800 AND birth_year < 1831
		THEN '1801_1830'
		WHEN birth_year > 1830 AND birth_year < 1861
		THEN '1831_1860'
		WHEN birth_year > 1860 AND birth_year < 1891
		THEN '1831_1890'
		WHEN birth_year > 1890 AND birth_year < 1921
		THEN '1891_1920'
		WHEN birth_year > 1920 AND birth_year < 1951
		THEN '1921-1950'
		WHEN birth_year > 1950 
		THEN '1951-'
	end epoque
FROM person)
SELECT epoque, COUNT(*) AS effectif
FROM tw1
GROUP BY epoque;
