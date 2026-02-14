


```
PREFIX wd: <http://www.wikidata.org/entity/>


select ?p ?propLabel (count(*) as ?number)

   where {?s  wdt:P31 wd:Q5;
      p:P463 ?st1.
        ?st1 ?p ?o.
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 
  ?prop wikibase:directClaim ?p .
   }
group by ?p ?propLabel
order by desc(?number)

```

### Membership with role

```
PREFIX wd: <http://www.wikidata.org/entity/>


select ?s ?sLabel ?o1 ?o1Label ?o2 ?o2Label

   where {?s  wdt:P31 wd:Q5;
       # membership
      p:P463 ?st1.
        # organisation
        ?st1 ps:P463 ?o1;
        # role  
             pq:P2868 ?o2
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
   }
LIMIT 100
```


### Role with employer

```
PREFIX wd: <http://www.wikidata.org/entity/>


select ?s ?sLabel ?o1 ?o1Label ?o2 ?o2Label

   where {?s  wdt:P31 wd:Q5;
      # subject has role
      p:P2868 ?st1.
        ?st1 ps:P2868 ?o1;
        # employer
             pq:P108 ?o2
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
   }
LIMIT 100
```


### Role with organisation directed by the person

```
PREFIX wd: <http://www.wikidata.org/entity/>


select ?s ?sLabel ?o1 ?o1Label ?o2 ?o2Label

   where {?s  wdt:P31 wd:Q5;
      # subject has role
      p:P2868 ?st1.
        ?st1 ps:P2868 ?o1;
        # organisation directed by office or position
             pq:P2389 ?o2
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
   }
LIMIT 100
```