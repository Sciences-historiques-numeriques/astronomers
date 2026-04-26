
select *
from ACM_kmeans_c21
where cluster= 17
order by gender, periodsActivity;



select cluster, periodsActivity, count(*) as num
from ACM_kmeans_c15
group by cluster, periodsActivity
order by cluster, num desc;


select cluster, periodsActivity, count(*) as num
from ACM_kmeans_c15
group by cluster, periodsActivity
order by cluster, num desc;

with tw1 as (select cluster, periodsActivity, count(*) as num
from ACM_kmeans_c15
group by cluster, periodsActivity
)
select distinct tw1.cluster, tw1.periodsActivity, num
from tw1
	join (
	SELECT cluster, max(num) as mn
	from tw1
	group by cluster) tmn
	on tmn.mn=tw1.num and tmn.cluster = tw1.cluster;
	
	
	
	
SELECT akc.person_uri, akc.cluster cluster_kmean, ckc.cluster cluster_kmode
from ACM_kmeans_c21 akc, clusters_kmodes_c21 ckc 
where akc.person_uri = ckc.person_uri
order by cluster_kmean, cluster_kmode ;

SELECT akc.person_uri, akc.coded_country, akc.gender, akc.coded_employer, akc.occupation_sec1, akc.cluster cluster_kmean, ckc.cluster cluster_kmode
from ACM_kmeans_c21 akc, clusters_kmodes_c21 ckc 
where akc.person_uri = ckc.person_uri
and akc.cluster = 2
order by cluster_kmean, cluster_kmode ;


/*
 * K-modes
 */

SELECT *
FROM clusters_kmodes_c15 ckc 
where ckc.cluster = 1
order by ckc.gender, ckc.periodsActivity desc ;


SELECT ckc.cluster, ckc.periodsActivity, count(*) as num
FROM clusters_kmodes_c15 ckc 
group by ckc.cluster, ckc.periodsActivity 
order by ckc.cluster, num desc ;


SELECT ckc.cluster, ckc.periodsActivity, count(*) as num
FROM clusters_kmodes_c8 ckc 
group by ckc.cluster, ckc.periodsActivity 
order by ckc.cluster, num desc ;