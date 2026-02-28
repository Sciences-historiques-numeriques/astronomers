/*
* Based on imported data from DBpedia -> IdRef (through Wikidata)
*/


select *
from idref_coauthors ic 
limit 10;


select distinct ic1.person, ic1.idrefpersonlabel, 
	ic2.idrefpersonlabel,
     ic2.book_date, ic2.book_uri ,
     ic2.person 
from idref_coauthors ic1, idref_coauthors ic2
where ic1.idrefperson = ic2.coauthor_uri 
order by ic1.idrefpersonlabel, ic2.coauthor_label ;