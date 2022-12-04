# Base de données générique

[version provisoire en construction]

Cette base de données reproduit la logique du RDF autour de deux classes principales: instance (_instance_) et assertion (_statement_).

La sémantique des instances de ces deux classes est définie en référence aux classes _class_ et _property_ donc la fonction est la même que les respectives entités dans le schéma RDFS, c'est-à-dire fournir un modèle.

## Factoïds, infomation factuelle

La finalité de la collecte d'information est de disposer d'information factuelle agrégée en évitant la redondance.

La pratique proposée est de confiner dans la mesure du possible la redondance aux assertions et de viser l'unicité des instances.