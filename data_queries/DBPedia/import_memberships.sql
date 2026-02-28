/*
 * Inspecter le résultat de l'importation des appartenances 
 * aux organisations
 * 
 */

-- regrouper par type d'appartenance
SELECT da.membership_type, count(*) as number
FROM dbp_appartenance da 
GROUP BY da.membership_type ;


-- compter les organisations impliquées dans les appartenances
SELECT da.organisation, count(*) as number
FROM dbp_appartenance da 
GROUP BY da.organisation 
ORDER BY number DESC;




-- personnes qui étudient et travaillent dans la même organisation
SELECT p.label, da1.person, da1.organisation, da2.organisation 
from dbp_appartenance da1 
    JOIN dbp_appartenance da2 ON da1.person = da2.person 
    join person p on p.dbpedia_uri = da1.person 
where da1.membership_type = 'almaMater'
and da2.membership_type = 'institution'
and da1.organisation = da2.organisation 



-- create the table membership

CREATE TABLE membership (
pk_membership INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
label TEXT, 
membership_type text,
begin_date text, 
end_date text, 
definition TEXT, 
notes TEXT, 
import_metadata TEXT, 
fk_person INTEGER REFERENCES person (pk_person) MATCH SIMPLE, 
fk_organisation INTEGER REFERENCES organisation (pk_organisation) MATCH SIMPLE
);


-- décommenter pour exécuter
DELETE FROM membership  ;

/*
* Remettre la séquence à zéro
*/
UPDATE SQLITE_SEQUENCE 
SET seq = 0
WHERE name = 'membership';

VACUUM;


-- prepare data import: through joins, we take the primary keys in the respective tables
SELECT p.pk_person, o.pk_organisation, da.membership_type, 
p.label, da.person, da.organisation, o.label
from dbp_appartenance da
    join person p on p.dbpedia_uri = da.person 
    join organisation o  on o.dbpedia_uri = da.organisation
LIMIT 20;



-- import memberships
INSERT INTO membership (fk_person, fk_organisation, membership_type, import_metadata)
SELECT p.pk_person, o.pk_organisation, da.membership_type,
'Importé le 21 janvier 2026 depuis la table dbp_appartenance'
from dbp_appartenance da
    join person p on p.dbpedia_uri = da.person 
    join organisation o  on o.dbpedia_uri = da.organisation;


-- inspect data

SELECT *
FROM membership m 
LIMIT 10;

SELECT m.membership_type, count(*) as number
FROM membership m 
GROUP BY m.membership_type ;


-- join with both related tables
SELECT p.label, o.label, m.membership_type 
FROM membership m 
    JOIN person p on p.pk_person = m.fk_person 
    JOIN organisation o on o.pk_organisation = m.fk_organisation  ;




--  personnes qui étudient et travaillent dans la même organisation
SELECT p.label, o.label 
FROM membership m 
    JOIN person p on p.pk_person = m.fk_person 
    JOIN membership m1 on m1.fk_person = m.fk_person 
    JOIN organisation o on o.pk_organisation = m.fk_organisation
WHERE m.membership_type = 'almaMater'
AND m1.membership_type = 'institution'
AND m.fk_organisation = m1.fk_organisation;

