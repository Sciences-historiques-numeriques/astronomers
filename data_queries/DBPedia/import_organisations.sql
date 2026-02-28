

-- créer, si elle n'existe pas, la table des organisations

CREATE TABLE organisation (pk_organisation INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
label TEXT,
definition TEXT,
notes TEXT,
import_metadata TEXT,
dbpedia_uri TEXT,
wikidata_uri TEXT);



/*
Vérifier l'absence de doublons
*/ 


-- si le résultat est vide (pas de lignes) il n'y a pas de doublons
SELECT organisation, count(*), group_concat(lp.label)
FROM dbp_organisations_avec_noms lp 
GROUP BY organisation
HAVING COUNT(*) > 1 ;

-- chercher les doublons et éliminer à la main les lignes qui ne conviennent pas
-- pour ce faire il faut ajouter une clé primaire ce qui est trop complexe
-- procéder donc comme indiqué ci-dessous
SELECT *
FROM dbp_organisations_avec_noms doan 
WHERE doan.organisation IN (SELECT organisation
	FROM dbp_organisations_avec_noms lp 
	GROUP BY organisation
	HAVING COUNT(*) > 1 
	)
ORDER BY organisation;	


-- préparer l'import ne choisissant seulement un label par entité
SELECT min(label), organisation,
"Importé le 21 janvier 2026 depuis le résultat d'une requête SPARQL sur DBPedia, 
cf. table dbp_organisations_avec_noms"
FROM dbp_organisations_avec_noms
GROUP BY organisation ; 

-- vider si nécessaire la table organisations

-- décommenter pour exécuter
DELETE FROM organisation ;

/*
* Remettre la séquence à zéro
*/
UPDATE SQLITE_SEQUENCE 
SET seq = 0
WHERE name = 'organisation';

VACUUM;




INSERT INTO organisation (label, dbpedia_uri, import_metadata)
SELECT min(label), organisation,
"Importé le 21 janvier 2026 depuis le résultat d'une requête SPARQL sur DBPedia, 
cf. table dbp_organisations_avec_noms"
FROM dbp_organisations_avec_noms
GROUP BY organisation ;


-- vérifier qu'il n'y a pas de doublons
SELECT dbpedia_uri, count(*), group_concat(label)
FROM organisation
GROUP BY dbpedia_uri 
HAVING COUNT(*) > 1 ;