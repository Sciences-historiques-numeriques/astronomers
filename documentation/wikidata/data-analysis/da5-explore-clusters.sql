
select *
from ACM_kmeans_c21
where cluster= 17
order by gender, periodsActivity;


SELECT *
FROM clusters_kmodes ck 
WHERE ck.cluster = 2 ; -- 7;


SELECT gender, count(*) as num
FROM clusters_kmodes ck 
WHERE ck.cluster = 2 --0  --7
group by gender;

SELECT ck.coded_country , count(*) as num
FROM clusters_kmodes ck 
WHERE ck.cluster = 2 --0  --7
group by coded_country 
order by num desc;