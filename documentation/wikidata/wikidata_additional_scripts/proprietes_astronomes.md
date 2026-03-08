# Propriétés de la population des astronomes depuis Wikidata vers la base Fuseki locale

Liste des propriétés sortantes et entrantes de la population.

On exécute ces requêtes sur le point d'accès SPARQL de Wikidata: https://query.wikidata.org et on exporte les résultats au format de table HTML, puis on les colle ci-dessous.



## Liste des propriétés sortantes

### Requête

    SELECT ?p ?propLabel ?eff ('    ' as ?commentaire)
    WHERE {
    {
    SELECT ?p  (count(*) as ?eff) {
      SELECT DISTINCT ?item  ?p ?o
    WHERE {
        {?item wdt:P106 wd:Q11063}
        UNION
        {?item wdt:P101 wd:Q333}    
        ?item wdt:P31 wd:Q5.
        ?item  ?p ?o.

        }
      }
    GROUP BY ?p 
    

        }
    ?prop wikibase:directClaim ?p .
    FILTER ( ?eff > 4)
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } 

    }  
    ORDER BY DESC(?eff) 



### Liste

<table>
<thead>
    <tr>
        <th>p</th>
        <th>propLabel</th>
        <th>eff</th>
        <th>commentaire</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P106</td>
        <td>occupation</td>
        <td>23224</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P31</td>
        <td>instance of</td>
        <td>10764</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P735</td>
        <td>given name</td>
        <td>10652</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P21</td>
        <td>sex or gender</td>
        <td>10515</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P569</td>
        <td>date of birth</td>
        <td>8941</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P27</td>
        <td>country of citizenship</td>
        <td>8606</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P214</td>
        <td>VIAF ID</td>
        <td>8216</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P69</td>
        <td>educated at</td>
        <td>7963</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P108</td>
        <td>employer</td>
        <td>7858</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P101</td>
        <td>field of work</td>
        <td>7191</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P734</td>
        <td>family name</td>
        <td>7070</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1343</td>
        <td>described by source</td>
        <td>6829</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P166</td>
        <td>award received</td>
        <td>6518</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1412</td>
        <td>languages spoken, written or signed</td>
        <td>6323</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P463</td>
        <td>member of</td>
        <td>6233</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P19</td>
        <td>place of birth</td>
        <td>6222</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P570</td>
        <td>date of death</td>
        <td>6057</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P213</td>
        <td>ISNI</td>
        <td>5603</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10832</td>
        <td>WorldCat Entities ID</td>
        <td>4800</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P227</td>
        <td>GND ID</td>
        <td>4551</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P269</td>
        <td>IdRef ID</td>
        <td>4440</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P244</td>
        <td>Library of Congress authority ID</td>
        <td>4391</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P20</td>
        <td>place of death</td>
        <td>3926</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P646</td>
        <td>Freebase ID</td>
        <td>3879</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2671</td>
        <td>Google Knowledge Graph ID</td>
        <td>3310</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P185</td>
        <td>doctoral student</td>
        <td>3034</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1006</td>
        <td>Nationale Thesaurus voor Auteursnamen ID</td>
        <td>2979</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P18</td>
        <td>image</td>
        <td>2906</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1207</td>
        <td>NUKAT ID</td>
        <td>2746</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P373</td>
        <td>Commons category</td>
        <td>2538</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P268</td>
        <td>Bibliothèque nationale de France ID</td>
        <td>2380</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P691</td>
        <td>NL CR AUT ID</td>
        <td>2380</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1871</td>
        <td>CERL Thesaurus ID</td>
        <td>2370</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7902</td>
        <td>Deutsche Biographie (GND) ID</td>
        <td>2305</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8189</td>
        <td>National Library of Israel J9U ID</td>
        <td>2260</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8880</td>
        <td>AstroGen ID</td>
        <td>2259</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3368</td>
        <td>Prabook ID</td>
        <td>2081</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1559</td>
        <td>name in native language</td>
        <td>1848</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P496</td>
        <td>ORCID iD</td>
        <td>1783</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6104</td>
        <td>maintained by WikiProject</td>
        <td>1706</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1556</td>
        <td>zbMATH author ID</td>
        <td>1692</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2163</td>
        <td>FAST ID</td>
        <td>1668</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P184</td>
        <td>doctoral advisor</td>
        <td>1650</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9467</td>
        <td>IAU member ID</td>
        <td>1589</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P648</td>
        <td>Open Library ID</td>
        <td>1557</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1015</td>
        <td>NORAF ID</td>
        <td>1521</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7293</td>
        <td>PLWABN ID</td>
        <td>1464</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3065</td>
        <td>RERO ID (obsolete)</td>
        <td>1248</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P271</td>
        <td>NACSIS-CAT author ID</td>
        <td>1243</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11496</td>
        <td>CiNii Research ID</td>
        <td>1234</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9626</td>
        <td>Biographical Encyclopedia of Astronomers ID</td>
        <td>1228</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6178</td>
        <td>Dimensions author ID</td>
        <td>1172</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P549</td>
        <td>Mathematics Genealogy Project ID</td>
        <td>1160</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P937</td>
        <td>work location</td>
        <td>1159</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P39</td>
        <td>position held</td>
        <td>1112</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P103</td>
        <td>native language</td>
        <td>1095</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3430</td>
        <td>SNAC ARK ID</td>
        <td>1060</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3987</td>
        <td>SHARE Catalogue author ID</td>
        <td>1042</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8947</td>
        <td>Museo Galileo authority ID</td>
        <td>1015</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P40</td>
        <td>child</td>
        <td>978</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P800</td>
        <td>notable work</td>
        <td>960</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1153</td>
        <td>Scopus author ID</td>
        <td>928</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P396</td>
        <td>SBN author ID</td>
        <td>921</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8034</td>
        <td>Vatican Library VcBA ID</td>
        <td>919</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7859</td>
        <td>WorldCat Identities ID (superseded)</td>
        <td>903</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8179</td>
        <td>Canadiana Name Authority ID</td>
        <td>899</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P512</td>
        <td>academic degree</td>
        <td>867</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11249</td>
        <td>KBR person ID</td>
        <td>837</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2381</td>
        <td>Academic Tree ID</td>
        <td>827</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2600</td>
        <td>Geni.com profile ID</td>
        <td>814</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P950</td>
        <td>National Library of Spain ID</td>
        <td>789</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12458</td>
        <td>Parsifal cluster ID</td>
        <td>786</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P119</td>
        <td>place of burial</td>
        <td>772</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3762</td>
        <td>openMLOL author ID</td>
        <td>756</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P140</td>
        <td>religion or worldview</td>
        <td>718</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1280</td>
        <td>CONOR.SI ID</td>
        <td>714</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2930</td>
        <td>INSPIRE-HEP author ID</td>
        <td>707</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1315</td>
        <td>NLA Trove people ID</td>
        <td>682</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1417</td>
        <td>Encyclopædia Britannica Online ID</td>
        <td>682</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P802</td>
        <td>student</td>
        <td>667</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P409</td>
        <td>Libraries Australia ID</td>
        <td>659</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4955</td>
        <td>MR Author ID</td>
        <td>645</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6886</td>
        <td>writing language</td>
        <td>642</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P22</td>
        <td>father</td>
        <td>637</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5587</td>
        <td>Libris-URI</td>
        <td>628</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P906</td>
        <td>SELIBR ID</td>
        <td>623</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8168</td>
        <td>FactGrid item ID</td>
        <td>621</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P856</td>
        <td>official website</td>
        <td>606</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1066</td>
        <td>student of</td>
        <td>598</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1017</td>
        <td>Vatican Library ID (former scheme)</td>
        <td>591</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7763</td>
        <td>copyright status as a creator</td>
        <td>574</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5008</td>
        <td>on focus list of Wikimedia project</td>
        <td>562</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2949</td>
        <td>WikiTree person ID</td>
        <td>544</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6821</td>
        <td>Uppsala University Alvin ID</td>
        <td>542</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P551</td>
        <td>residence</td>
        <td>527</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3373</td>
        <td>sibling</td>
        <td>519</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1889</td>
        <td>different from</td>
        <td>505</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P26</td>
        <td>spouse</td>
        <td>502</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1005</td>
        <td>Portuguese National Library author ID</td>
        <td>498</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10553</td>
        <td>IxTheo authority ID</td>
        <td>488</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P973</td>
        <td>described at URL</td>
        <td>485</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9984</td>
        <td>CANTIC ID</td>
        <td>473</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1477</td>
        <td>birth name</td>
        <td>467</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11686</td>
        <td>University of Barcelona authority ID</td>
        <td>456</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3348</td>
        <td>National Library of Greece ID</td>
        <td>453</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P949</td>
        <td>National Library of Israel ID (old)</td>
        <td>451</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5019</td>
        <td>Brockhaus Enzyklopädie online ID</td>
        <td>448</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1960</td>
        <td>Google Scholar author ID</td>
        <td>446</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1695</td>
        <td>NLP ID (old)</td>
        <td>444</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7305</td>
        <td>Online PWN Encyclopedia ID</td>
        <td>442</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P349</td>
        <td>NDL Authority ID</td>
        <td>435</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1415</td>
        <td>Oxford Dictionary of National Biography ID</td>
        <td>430</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1296</td>
        <td>Gran Enciclopèdia Catalana ID (former scheme)</td>
        <td>427</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12385</td>
        <td>Gran Enciclopèdia Catalana ID</td>
        <td>426</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1563</td>
        <td>MacTutor biography ID</td>
        <td>412</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4342</td>
        <td>Store norske leksikon ID</td>
        <td>408</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12582</td>
        <td>Oxford Reference overview ID</td>
        <td>398</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7699</td>
        <td>National Library of Lithuania ID</td>
        <td>390</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3222</td>
        <td>NE.se ID</td>
        <td>387</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8826</td>
        <td>edition humboldt digital ID</td>
        <td>384</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7982</td>
        <td>Hrvatska enciklopedija ID</td>
        <td>379</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10480</td>
        <td>symogih.org ID</td>
        <td>371</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P535</td>
        <td>Find a Grave memorial ID</td>
        <td>368</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1273</td>
        <td>CANTIC ID (former scheme)</td>
        <td>362</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5034</td>
        <td>National Library of Korea ID</td>
        <td>355</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1580</td>
        <td>University of Barcelona authority ID (former scheme)</td>
        <td>351</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3365</td>
        <td>Treccani ID</td>
        <td>350</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7865</td>
        <td>CoBiS author ID</td>
        <td>343</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6379</td>
        <td>has works in the collection</td>
        <td>340</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9037</td>
        <td>BHCL UUID</td>
        <td>338</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8313</td>
        <td>Den Store Danske ID</td>
        <td>324</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6706</td>
        <td>De Agostini ID</td>
        <td>318</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3029</td>
        <td>UK National Archives ID</td>
        <td>311</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1802</td>
        <td>Early Modern Letters Online person ID</td>
        <td>309</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12597</td>
        <td>museum-digital person ID</td>
        <td>306</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1368</td>
        <td>National Library of Latvia ID</td>
        <td>303</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1263</td>
        <td>NNDB people ID</td>
        <td>301</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10565</td>
        <td>Encyclopedia of China (Third Edition) ID</td>
        <td>289</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P910</td>
        <td>topic's main category</td>
        <td>285</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1053</td>
        <td>ResearcherID</td>
        <td>276</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1375</td>
        <td>NSK ID</td>
        <td>269</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P509</td>
        <td>cause of death</td>
        <td>267</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5380</td>
        <td>National Academy of Sciences member ID</td>
        <td>263</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2038</td>
        <td>ResearchGate profile ID</td>
        <td>261</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9756</td>
        <td>Schoenberg Database of Manuscripts name ID</td>
        <td>258</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3219</td>
        <td>Encyclopædia Universalis ID</td>
        <td>256</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P611</td>
        <td>religious order</td>
        <td>250</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2383</td>
        <td>CTHS person ID</td>
        <td>248</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P25</td>
        <td>mother</td>
        <td>242</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10227</td>
        <td>National Library of Ireland ID</td>
        <td>241</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4223</td>
        <td>Treccani's Enciclopedia Italiana ID</td>
        <td>236</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1472</td>
        <td>Commons Creator page</td>
        <td>235</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2002</td>
        <td>X username</td>
        <td>235</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1814</td>
        <td>name in kana</td>
        <td>226</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8795</td>
        <td>Diamond Catalogue ID for persons and organisations</td>
        <td>226</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8349</td>
        <td>Proleksis enciklopedija ID</td>
        <td>225</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9160</td>
        <td>Biographical Dictionary of the Czech Lands ID</td>
        <td>225</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9223</td>
        <td>Provenio UUID</td>
        <td>225</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1196</td>
        <td>manner of death</td>
        <td>223</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6385</td>
        <td>Krugosvet article</td>
        <td>222</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5739</td>
        <td>Pontificia Università della Santa Croce ID</td>
        <td>220</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10242</td>
        <td>Lur Encyclopedic Dictionary ID</td>
        <td>220</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1711</td>
        <td>British Museum person or institution ID</td>
        <td>215</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1986</td>
        <td>Treccani's Biographical Dictionary of Italian People ID</td>
        <td>215</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7666</td>
        <td>Visuotinė lietuvių enciklopedija ID</td>
        <td>212</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5361</td>
        <td>BNB person ID</td>
        <td>211</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4081</td>
        <td>BHL creator ID</td>
        <td>207</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5731</td>
        <td>Angelicum ID</td>
        <td>205</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2924</td>
        <td>Great Russian Encyclopedia Online ID (old version)</td>
        <td>203</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P737</td>
        <td>influenced by</td>
        <td>196</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1442</td>
        <td>image of grave</td>
        <td>196</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6634</td>
        <td>LinkedIn personal profile ID</td>
        <td>195</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3630</td>
        <td>Babelio author ID</td>
        <td>189</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7029</td>
        <td>National Library of Russia ID</td>
        <td>188</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9097</td>
        <td>American Academy in Rome ID</td>
        <td>187</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9918</td>
        <td>Kallías ID</td>
        <td>187</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8612</td>
        <td>past Fellow of the Royal Society ID</td>
        <td>185</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7369</td>
        <td>National Library of Chile ID</td>
        <td>183</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1816</td>
        <td>National Portrait Gallery (London) person ID</td>
        <td>182</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11514</td>
        <td>Great Russian Encyclopedia portal ID</td>
        <td>182</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4619</td>
        <td>National Library of Brazil ID</td>
        <td>181</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6844</td>
        <td>abART person ID</td>
        <td>180</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9507</td>
        <td>NBM authority ID</td>
        <td>176</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8687</td>
        <td>social media followers</td>
        <td>172</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P109</td>
        <td>signature</td>
        <td>170</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10141</td>
        <td>Academy of Athens authority ID</td>
        <td>169</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6394</td>
        <td>ELNET ID</td>
        <td>168</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10299</td>
        <td>Leopoldina member ID (new)</td>
        <td>167</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2799</td>
        <td>BVMC person ID</td>
        <td>166</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P935</td>
        <td>Commons gallery</td>
        <td>165</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10861</td>
        <td>Springer Nature person ID</td>
        <td>164</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3413</td>
        <td>Leopoldina member ID (superseded)</td>
        <td>163</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4823</td>
        <td>American National Biography ID</td>
        <td>163</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1038</td>
        <td>relative</td>
        <td>156</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1233</td>
        <td>Internet Speculative Fiction Database author ID</td>
        <td>156</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6702</td>
        <td>Shanghai Library person ID</td>
        <td>156</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9943</td>
        <td>Hill Museum &amp; Manuscript Library ID</td>
        <td>156</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9282</td>
        <td>Catalogue of the Capitular Library of Verona author ID</td>
        <td>152</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6023</td>
        <td>ResearchGate contributions ID</td>
        <td>150</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P607</td>
        <td>conflict</td>
        <td>149</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P485</td>
        <td>archives at</td>
        <td>147</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P723</td>
        <td>Digitale Bibliotheek voor de Nederlandse Letteren author ID</td>
        <td>144</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8496</td>
        <td>Archive Site Trinity College Cambridge ID</td>
        <td>144</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8914</td>
        <td>ZOBODAT person ID</td>
        <td>144</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P345</td>
        <td>IMDb ID</td>
        <td>142</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1782</td>
        <td>courtesy name</td>
        <td>141</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2650</td>
        <td>interested in</td>
        <td>141</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8750</td>
        <td>Unione Romana Biblioteche Scientifiche ID</td>
        <td>140</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P102</td>
        <td>member of political party</td>
        <td>139</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1938</td>
        <td>Project Gutenberg author ID</td>
        <td>139</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8081</td>
        <td>WBIS ID</td>
        <td>138</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P497</td>
        <td>CBDB ID</td>
        <td>137</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8172</td>
        <td>Sejm-Wielki.pl profile ID</td>
        <td>135</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3124</td>
        <td>Polish scientist ID (deprecated)</td>
        <td>134</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3154</td>
        <td>Runeberg author ID</td>
        <td>129</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3241</td>
        <td>Catholic Encyclopedia ID</td>
        <td>129</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3417</td>
        <td>Quora topic ID</td>
        <td>129</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7131</td>
        <td>Bureau des longitudes ID</td>
        <td>129</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7986</td>
        <td>Mirabile author ID</td>
        <td>128</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P742</td>
        <td>pseudonym</td>
        <td>127</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3280</td>
        <td>BAnQ authority ID</td>
        <td>127</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P410</td>
        <td>military rank</td>
        <td>126</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1317</td>
        <td>floruit</td>
        <td>124</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8851</td>
        <td>CONOR.SR ID</td>
        <td>124</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8941</td>
        <td>The Galileo Project ID</td>
        <td>124</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P803</td>
        <td>professorship</td>
        <td>123</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5375</td>
        <td>BIU Santé person ID</td>
        <td>123</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9081</td>
        <td>SEARCH on line catalogue ID</td>
        <td>123</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P245</td>
        <td>Union List of Artist Names ID</td>
        <td>122</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6594</td>
        <td>Guggenheim fellows ID</td>
        <td>122</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1416</td>
        <td>affiliation</td>
        <td>121</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8849</td>
        <td>CONOR.BG ID</td>
        <td>121</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2963</td>
        <td>Goodreads author ID</td>
        <td>119</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4629</td>
        <td>Online Books Page author ID</td>
        <td>119</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9495</td>
        <td>National Historical Museums of Sweden ID</td>
        <td>118</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P640</td>
        <td>Léonore ID</td>
        <td>117</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P651</td>
        <td>Biografisch Portaal van Nederland ID</td>
        <td>116</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10033</td>
        <td>Biografija.ru ID</td>
        <td>115</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5492</td>
        <td>EDIT16 catalogue author ID</td>
        <td>114</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2031</td>
        <td>work period (start)</td>
        <td>113</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1185</td>
        <td>Rodovid ID</td>
        <td>111</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2734</td>
        <td>Unz Review author ID</td>
        <td>111</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9371</td>
        <td>FranceArchives agent ID</td>
        <td>111</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3973</td>
        <td>PIM authority ID</td>
        <td>110</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6194</td>
        <td>Austrian Biographical Encyclopedia ID</td>
        <td>110</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1344</td>
        <td>participant in</td>
        <td>109</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1819</td>
        <td>genealogics.org person ID</td>
        <td>109</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2349</td>
        <td>Stuttgart Database of Scientific Illustrators ID</td>
        <td>108</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4459</td>
        <td>Spanish Biographical Dictionary ID</td>
        <td>107</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7704</td>
        <td>Europeana entity</td>
        <td>106</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11152</td>
        <td>Léonore Web ID</td>
        <td>106</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9017</td>
        <td>Medieval Manuscripts in Oxford Libraries person ID</td>
        <td>105</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3429</td>
        <td>Electronic Enlightenment ID</td>
        <td>104</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8902</td>
        <td>Archives at Yale agent ID</td>
        <td>103</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10864</td>
        <td>Bibale ID</td>
        <td>102</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8980</td>
        <td>KANTO ID</td>
        <td>101</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9044</td>
        <td>GEPRIS Historisch person ID</td>
        <td>98</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11252</td>
        <td>Trismegistos author ID</td>
        <td>97</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P53</td>
        <td>family</td>
        <td>96</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4638</td>
        <td>The Peerage person ID</td>
        <td>95</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1309</td>
        <td>EGAXA ID</td>
        <td>94</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3360</td>
        <td>Nobel Prize People Nomination ID</td>
        <td>94</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4432</td>
        <td>AKL Online artist ID</td>
        <td>94</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1890</td>
        <td>CCAB ID</td>
        <td>93</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2977</td>
        <td>LBT person ID</td>
        <td>93</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7400</td>
        <td>LibraryThing author ID</td>
        <td>93</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9807</td>
        <td>SNK ID</td>
        <td>93</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1026</td>
        <td>academic thesis</td>
        <td>92</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2032</td>
        <td>work period (end)</td>
        <td>92</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4252</td>
        <td>All-Russian Mathematical Portal ID</td>
        <td>92</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9247</td>
        <td>Pontifical University of Salamanca ID</td>
        <td>92</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9613</td>
        <td>ctext data entity ID</td>
        <td>92</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P241</td>
        <td>military branch</td>
        <td>91</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8153</td>
        <td>Accademia delle Scienze di Torino ID</td>
        <td>91</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P66</td>
        <td>ancestral home</td>
        <td>90</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3829</td>
        <td>Publons author ID</td>
        <td>90</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7993</td>
        <td>Treccani's Dizionario di Filosofia ID</td>
        <td>89</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1150</td>
        <td>Regensburg Classification</td>
        <td>88</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12483</td>
        <td>PMB – Personen der Moderne Basis person ID</td>
        <td>88</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1260</td>
        <td>Swedish Open Cultural Heritage URI</td>
        <td>87</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12749</td>
        <td>SNARC ID</td>
        <td>86</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1463</td>
        <td>Post-Reformation Digital Library author ID</td>
        <td>85</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3919</td>
        <td>contributed to creative work</td>
        <td>85</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P434</td>
        <td>MusicBrainz artist ID</td>
        <td>83</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2607</td>
        <td>BookBrainz author ID</td>
        <td>83</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5063</td>
        <td>Interlingual Index ID</td>
        <td>83</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P650</td>
        <td>RKDartists ID</td>
        <td>82</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3342</td>
        <td>significant person</td>
        <td>82</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4491</td>
        <td>Isidore scholar ID</td>
        <td>81</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1430</td>
        <td>Open Plaques subject ID</td>
        <td>80</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8945</td>
        <td>Museo Galileo biography ID</td>
        <td>80</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9621</td>
        <td>Treccani's Enciclopedia della Matematica ID</td>
        <td>80</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12800</td>
        <td>Vikidia article ID</td>
        <td>80</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P97</td>
        <td>noble title</td>
        <td>79</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2401</td>
        <td>Six Degrees of Francis Bacon ID</td>
        <td>79</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8636</td>
        <td>McClintock and Strong Biblical Cyclopedia ID</td>
        <td>79</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9322</td>
        <td>SVKKL authority ID</td>
        <td>79</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10252</td>
        <td>Digital Mechanism and Gear Library ID</td>
        <td>79</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2889</td>
        <td>FamilySearch person ID</td>
        <td>78</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8214</td>
        <td>curriculum vitae URL</td>
        <td>77</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1599</td>
        <td>Cambridge Alumni Database ID</td>
        <td>76</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1801</td>
        <td>plaque image</td>
        <td>76</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4228</td>
        <td>Encyclopedia of Australian Science ID</td>
        <td>76</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1787</td>
        <td>art name</td>
        <td>75</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2456</td>
        <td>DBLP author ID</td>
        <td>75</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4012</td>
        <td>Semantic Scholar author ID</td>
        <td>75</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7142</td>
        <td>Poincaré Papers person ID</td>
        <td>75</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10297</td>
        <td>Google Arts &amp; Culture entity ID</td>
        <td>75</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6781</td>
        <td>ProofWiki ID</td>
        <td>74</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P863</td>
        <td>InPhO ID</td>
        <td>73</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2732</td>
        <td>Persée author ID</td>
        <td>73</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3576</td>
        <td>TLG author ID</td>
        <td>71</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5909</td>
        <td>HKCAN ID</td>
        <td>71</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7842</td>
        <td>Vienna History Wiki ID</td>
        <td>71</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P902</td>
        <td>HDS ID</td>
        <td>70</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2750</td>
        <td>Photographers’ Identities Catalog ID</td>
        <td>70</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2886</td>
        <td>Shakeosphere person ID</td>
        <td>70</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6058</td>
        <td>Larousse ID</td>
        <td>70</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1617</td>
        <td>BBC Things ID</td>
        <td>69</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5463</td>
        <td>AE member ID</td>
        <td>69</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7314</td>
        <td>TDV İslam Ansiklopedisi ID</td>
        <td>68</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1411</td>
        <td>nominated for</td>
        <td>66</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5370</td>
        <td>Entomologists of the World ID</td>
        <td>66</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6551</td>
        <td>Physics History Network ID</td>
        <td>66</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7744</td>
        <td>Mille Anni di Scienza in Italia ID</td>
        <td>66</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8069</td>
        <td>ToposText person ID</td>
        <td>65</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8094</td>
        <td>GeneaStar person ID</td>
        <td>65</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P135</td>
        <td>movement</td>
        <td>64</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2070</td>
        <td>Fellow of the Royal Society ID</td>
        <td>64</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3217</td>
        <td>Dictionary of Swedish National Biography ID</td>
        <td>63</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6878</td>
        <td>Erik Amburger database ID</td>
        <td>63</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8998</td>
        <td>Magyar életrajzi lexikon ID</td>
        <td>63</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1299</td>
        <td>depicted by</td>
        <td>62</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2454</td>
        <td>KNAW past member ID</td>
        <td>62</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6831</td>
        <td>Pinakes author ID</td>
        <td>62</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1741</td>
        <td>GTAA ID</td>
        <td>61</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3782</td>
        <td>Artnet artist ID</td>
        <td>61</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3846</td>
        <td>DBC author ID</td>
        <td>61</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8122</td>
        <td>DLL Catalog author ID</td>
        <td>61</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9058</td>
        <td>Fichier des personnes décédées ID (matchID)</td>
        <td>61</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9171</td>
        <td>RILM ID</td>
        <td>61</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1899</td>
        <td>LibriVox author ID</td>
        <td>60</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8814</td>
        <td>WordNet 3.1 Synset ID</td>
        <td>60</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9114</td>
        <td>Mathematica Italiana person ID</td>
        <td>60</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2013</td>
        <td>Facebook username</td>
        <td>59</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6683</td>
        <td>Alexander Turnbull Library ID</td>
        <td>59</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2966</td>
        <td>National Library of Wales Authority ID</td>
        <td>58</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8065</td>
        <td>CIRIS author ID</td>
        <td>58</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8446</td>
        <td>Gateway to Research person ID</td>
        <td>58</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2798</td>
        <td>Loop ID</td>
        <td>56</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2861</td>
        <td>Leidse Hoogleraren ID</td>
        <td>56</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6264</td>
        <td>Harvard Index of Botanists ID</td>
        <td>56</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1284</td>
        <td>Munzinger person ID</td>
        <td>55</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2037</td>
        <td>GitHub username</td>
        <td>55</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1607</td>
        <td>Dialnet author ID</td>
        <td>54</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6235</td>
        <td>Académie royale de Belgique member ID</td>
        <td>54</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8207</td>
        <td>The Conversation author ID</td>
        <td>54</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2348</td>
        <td>time period</td>
        <td>53</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5504</td>
        <td>RISM ID</td>
        <td>53</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3074</td>
        <td>Grace's Guide ID</td>
        <td>52</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5357</td>
        <td>Encyclopedia of Science Fiction ID</td>
        <td>52</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2268</td>
        <td>Musée d'Orsay artist ID</td>
        <td>51</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5441</td>
        <td>Encyclopaedia Herder person ID</td>
        <td>51</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8547</td>
        <td>BHF author ID</td>
        <td>51</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9164</td>
        <td>Svenska Institutet i Rom ID</td>
        <td>51</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1449</td>
        <td>nickname</td>
        <td>50</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1950</td>
        <td>second family name in Spanish name</td>
        <td>50</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1953</td>
        <td>Discogs artist ID</td>
        <td>50</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9179</td>
        <td>Biblioteca Iglesia Nacional Española en Roma ID</td>
        <td>50</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10536</td>
        <td>RSPA ancient author ID</td>
        <td>50</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7444</td>
        <td>Rijksmuseum Research Library authority ID</td>
        <td>49</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7700</td>
        <td>Slovak National Library (VIAF) ID</td>
        <td>49</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11156</td>
        <td>MMB ID</td>
        <td>49</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3807</td>
        <td>S2A3 Biographical Database ID</td>
        <td>48</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5243</td>
        <td>Canal-U person ID</td>
        <td>48</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6705</td>
        <td>Academia Sinica authority ID</td>
        <td>48</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6829</td>
        <td>Dictionary of Irish Biography ID</td>
        <td>48</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4431</td>
        <td>Google Doodle</td>
        <td>47</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6327</td>
        <td>Goodreads character ID</td>
        <td>47</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7041</td>
        <td>Perseus author ID</td>
        <td>47</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11182</td>
        <td>UOM ID</td>
        <td>47</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4613</td>
        <td>Encyclopedia of Modern Ukraine ID</td>
        <td>46</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8591</td>
        <td>Grove Music Online ID</td>
        <td>46</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9653</td>
        <td>Bod-Inc Online author ID</td>
        <td>46</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10302</td>
        <td>Film.ru person ID</td>
        <td>46</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P172</td>
        <td>ethnic group</td>
        <td>45</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P641</td>
        <td>sport</td>
        <td>45</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P951</td>
        <td>NSZL (VIAF) ID</td>
        <td>44</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2188</td>
        <td>BiblioNet author ID</td>
        <td>44</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3133</td>
        <td>NSZL name authority ID</td>
        <td>44</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9661</td>
        <td>EBAF authority ID</td>
        <td>44</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10780</td>
        <td>Radio France person ID</td>
        <td>44</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4985</td>
        <td>TMDB person ID</td>
        <td>43</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5821</td>
        <td>ArhivX LOD</td>
        <td>43</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8341</td>
        <td>Dansk Biografisk Leksikon ID</td>
        <td>43</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9106</td>
        <td>Oxford Classical Dictionary ID</td>
        <td>43</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10013</td>
        <td>SNSF person ID</td>
        <td>43</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4359</td>
        <td>gravsted.dk ID</td>
        <td>42</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1971</td>
        <td>number of children</td>
        <td>41</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3847</td>
        <td>Open Library subject ID</td>
        <td>41</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4033</td>
        <td>Mastodon address</td>
        <td>41</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4212</td>
        <td>PACTOLS thesaurus ID</td>
        <td>41</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7578</td>
        <td>DUC ID</td>
        <td>41</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7929</td>
        <td>Roglo person ID</td>
        <td>41</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9563</td>
        <td>Encyclopedia of Renaissance Philosophy ID</td>
        <td>41</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P136</td>
        <td>genre</td>
        <td>40</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7502</td>
        <td>Golden ID</td>
        <td>40</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P94</td>
        <td>coat of arms image</td>
        <td>39</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P511</td>
        <td>honorific prefix</td>
        <td>39</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3965</td>
        <td>Bridgeman artist ID</td>
        <td>39</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8953</td>
        <td>Students of Prague Universities ID</td>
        <td>39</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1225</td>
        <td>U.S. National Archives Identifier</td>
        <td>38</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2021</td>
        <td>Erdős number</td>
        <td>38</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5905</td>
        <td>Comic Vine ID</td>
        <td>38</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9534</td>
        <td>Biblioteche della Custodia di Terra Santa a Gerusalemme ID</td>
        <td>38</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9743</td>
        <td>Podchaser creator ID</td>
        <td>38</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P428</td>
        <td>botanist author abbreviation</td>
        <td>37</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P586</td>
        <td>IPNI author ID</td>
        <td>37</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P866</td>
        <td>Perlentaucher ID</td>
        <td>37</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1213</td>
        <td>NLC authorities</td>
        <td>37</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2016</td>
        <td>Catalogus Professorum Academiae Groninganae ID</td>
        <td>37</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2450</td>
        <td>Encyclopædia Britannica contributor ID</td>
        <td>37</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2915</td>
        <td>ECARTICO person ID</td>
        <td>37</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3946</td>
        <td>Dictionary Grierson ID</td>
        <td>37</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4927</td>
        <td>Invaluable.com person ID</td>
        <td>37</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7449</td>
        <td>NARCIS researcher ID</td>
        <td>37</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7935</td>
        <td>Corpus Corporum author ID</td>
        <td>37</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9159</td>
        <td>People Australia ID</td>
        <td>37</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1422</td>
        <td>Sandrart.net person ID</td>
        <td>36</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2003</td>
        <td>Instagram username</td>
        <td>36</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2843</td>
        <td>Benezit ID</td>
        <td>36</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4215</td>
        <td>nLab ID</td>
        <td>36</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8130</td>
        <td>Internetowy Polski Słownik Biograficzny ID</td>
        <td>36</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9541</td>
        <td>MacArthur Fellows Program ID</td>
        <td>36</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9536</td>
        <td>SAIA authority ID</td>
        <td>36</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3602</td>
        <td>candidacy in election</td>
        <td>35</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4285</td>
        <td>Theses.fr person ID</td>
        <td>35</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4872</td>
        <td>GEPRIS person ID</td>
        <td>35</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5002</td>
        <td>Orthodox Encyclopedia ID</td>
        <td>35</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9251</td>
        <td>Cyprus University of Technology ID</td>
        <td>35</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1907</td>
        <td>Australian Dictionary of Biography ID</td>
        <td>34</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3123</td>
        <td>Stanford Encyclopedia of Philosophy ID</td>
        <td>34</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9594</td>
        <td>Bodleian Archives &amp; Manuscripts person ID</td>
        <td>34</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12098</td>
        <td>Kinobox person ID</td>
        <td>34</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8590</td>
        <td>Jewish Encyclopedia ID</td>
        <td>33</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12614</td>
        <td>az.lib.ru author ID</td>
        <td>33</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P443</td>
        <td>pronunciation audio</td>
        <td>32</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1050</td>
        <td>medical condition</td>
        <td>32</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2180</td>
        <td>Kansallisbiografia ID</td>
        <td>32</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2611</td>
        <td>TED speaker ID</td>
        <td>32</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3788</td>
        <td>BNMM authority ID</td>
        <td>32</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4159</td>
        <td>WeRelate person ID</td>
        <td>32</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7208</td>
        <td>Liber Liber author ID</td>
        <td>32</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8238</td>
        <td>Bibliography of the History of Slovakia ID</td>
        <td>32</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8406</td>
        <td>Grove Art Online ID</td>
        <td>32</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9324</td>
        <td>BiographySampo person ID</td>
        <td>32</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P945</td>
        <td>allegiance</td>
        <td>31</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1248</td>
        <td>KulturNav-ID</td>
        <td>31</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3051</td>
        <td>Kindred Britain ID</td>
        <td>31</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3388</td>
        <td>LittleSis people ID</td>
        <td>31</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4789</td>
        <td>Who's Who UK ID</td>
        <td>31</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4854</td>
        <td>Uppslagsverket Finland ID</td>
        <td>31</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5617</td>
        <td>Evene ID</td>
        <td>31</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6698</td>
        <td>Japan Search name ID</td>
        <td>31</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9545</td>
        <td>Encyclopedia of China (Second Edition) ID</td>
        <td>31</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11870</td>
        <td>The Literary Encyclopedia person ID</td>
        <td>31</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P793</td>
        <td>significant event</td>
        <td>30</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2561</td>
        <td>name</td>
        <td>30</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4124</td>
        <td>Who's Who in France biography ID</td>
        <td>30</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4293</td>
        <td>PM20 folder ID</td>
        <td>30</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4819</td>
        <td>Swedish Portrait Archive ID</td>
        <td>30</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4862</td>
        <td>Amazon author ID</td>
        <td>30</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6231</td>
        <td>BDELIS ID</td>
        <td>30</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6907</td>
        <td>BVLarramendi ID</td>
        <td>30</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7349</td>
        <td>Gazetteer for Scotland person ID</td>
        <td>30</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7847</td>
        <td>DigitaltMuseum ID</td>
        <td>30</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8413</td>
        <td>academic appointment</td>
        <td>30</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P450</td>
        <td>astronaut mission</td>
        <td>29</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1254</td>
        <td>Slovenska biografija ID</td>
        <td>29</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2018</td>
        <td>Teuchos ID</td>
        <td>29</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3569</td>
        <td>Cultureel Woordenboek ID</td>
        <td>29</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9640</td>
        <td>PAS member ID</td>
        <td>29</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9802</td>
        <td>Penguin Random House author ID</td>
        <td>29</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1670</td>
        <td>Canadiana Authorities ID (former scheme)</td>
        <td>28</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4553</td>
        <td>RA Collections ID</td>
        <td>28</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4666</td>
        <td>CineMagia person ID</td>
        <td>28</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4808</td>
        <td>Royal Academy new identifier</td>
        <td>28</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5570</td>
        <td>NooSFere author ID</td>
        <td>28</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10879</td>
        <td>Hamburger Professorinnen- und Professorenkatalog ID</td>
        <td>28</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P361</td>
        <td>part of</td>
        <td>27</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1303</td>
        <td>instrument</td>
        <td>27</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2868</td>
        <td>subject has role</td>
        <td>27</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5323</td>
        <td>attested in</td>
        <td>27</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6578</td>
        <td>MutualArt artist ID</td>
        <td>27</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8024</td>
        <td>Nobel Laureate API ID</td>
        <td>27</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8440</td>
        <td>Personendatenbank Germania Sacra ID</td>
        <td>27</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10782</td>
        <td>Encyclopedia of Medieval Philosophy ID</td>
        <td>27</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10886</td>
        <td>Austria-Forum person ID</td>
        <td>27</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11597</td>
        <td>Padua Research Archive author ID</td>
        <td>27</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12086</td>
        <td>WikiKids ID</td>
        <td>27</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P947</td>
        <td>RSL ID (person)</td>
        <td>26</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1598</td>
        <td>consecrator</td>
        <td>26</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2252</td>
        <td>National Gallery of Art artist ID</td>
        <td>26</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2538</td>
        <td>Nationalmuseum Sweden ID</td>
        <td>26</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3544</td>
        <td>Te Papa agent ID</td>
        <td>26</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4200</td>
        <td>Christie's creator ID</td>
        <td>26</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6234</td>
        <td>Biographie nationale de Belgique ID</td>
        <td>26</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10887</td>
        <td>Base Budé person ID</td>
        <td>26</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1786</td>
        <td>posthumous name</td>
        <td>25</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4839</td>
        <td>Wolfram Language entity code</td>
        <td>25</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6722</td>
        <td>FemBio ID</td>
        <td>25</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6802</td>
        <td>related image</td>
        <td>25</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7796</td>
        <td>BeWeb person ID</td>
        <td>25</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9761</td>
        <td>IRIS SNS author ID</td>
        <td>25</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9776</td>
        <td>e-Rad researcher number</td>
        <td>25</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11239</td>
        <td>DFK Paris person ID</td>
        <td>25</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P270</td>
        <td>CALIS ID</td>
        <td>24</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1830</td>
        <td>owner of</td>
        <td>24</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2191</td>
        <td>Vegetti Catalog of Fantastic Literature NILF ID</td>
        <td>24</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2862</td>
        <td>Catalogus Professorum Academiae Rheno-Traiectinae ID</td>
        <td>24</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3126</td>
        <td>ALCUIN philosopher ID</td>
        <td>24</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5462</td>
        <td>RHE professor ID</td>
        <td>24</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6412</td>
        <td>Gran Enciclopèdia de la Música ID</td>
        <td>24</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6944</td>
        <td>Bionomia ID</td>
        <td>24</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10058</td>
        <td>IRIS UNIBO author ID</td>
        <td>24</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11003</td>
        <td>Scinapse author ID</td>
        <td>24</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11180</td>
        <td>Central Library of Volos authority ID</td>
        <td>24</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1327</td>
        <td>partner in business or sport</td>
        <td>23</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5029</td>
        <td>Researchmap ID</td>
        <td>23</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6582</td>
        <td>Dutch Instrument Makers ID</td>
        <td>23</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7545</td>
        <td>askArt person ID</td>
        <td>23</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7783</td>
        <td>J-GLOBAL ID</td>
        <td>23</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9493</td>
        <td>artist files at</td>
        <td>23</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9603</td>
        <td>Scholasticon person ID</td>
        <td>23</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10882</td>
        <td>Met Constituent ID</td>
        <td>23</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P839</td>
        <td>IMSLP ID</td>
        <td>22</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2342</td>
        <td>AGORHA person/institution ID</td>
        <td>22</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2605</td>
        <td>ČSFD person ID</td>
        <td>22</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5306</td>
        <td>LONSEA ID</td>
        <td>22</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6282</td>
        <td>French Academy of Sciences member ID</td>
        <td>22</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1977</td>
        <td>Les Archives du spectacle person ID</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2042</td>
        <td>Artsy artist ID</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2080</td>
        <td>AcademiaNet ID</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5421</td>
        <td>Trading Card Database person ID</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5508</td>
        <td>archINFORM person/group ID</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5715</td>
        <td>Academia.edu profile URL</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5882</td>
        <td>Muziekweb performer ID</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6366</td>
        <td>Microsoft Academic ID</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6479</td>
        <td>IEEE Xplore author ID</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6815</td>
        <td>University of Amsterdam Album Academicum ID</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9152</td>
        <td>CollectieGelderland creator ID</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10632</td>
        <td>OpenSanctions ID</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10757</td>
        <td>Personality Database profile ID</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12439</td>
        <td>civil rank</td>
        <td>21</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2397</td>
        <td>YouTube channel ID</td>
        <td>20</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8116</td>
        <td>Encyclopedia of Brno History person ID</td>
        <td>20</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8317</td>
        <td>Philadelphia Museum of Art entity ID</td>
        <td>20</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8589</td>
        <td>Carl-Maria-von-Weber-Gesamtausgabe ID</td>
        <td>20</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8885</td>
        <td>Namuwiki ID</td>
        <td>20</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9000</td>
        <td>World History Encyclopedia ID</td>
        <td>20</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10660</td>
        <td>C-SPAN person numeric ID</td>
        <td>20</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P865</td>
        <td>BMLO ID</td>
        <td>19</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2632</td>
        <td>place of detention</td>
        <td>19</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3900</td>
        <td>CONICET person ID</td>
        <td>19</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4759</td>
        <td>Luminous-Lint ID</td>
        <td>19</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6302</td>
        <td>Dictionnaire de spiritualité ID</td>
        <td>19</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6873</td>
        <td>IntraText author ID</td>
        <td>19</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8861</td>
        <td>FINA Wiki ID</td>
        <td>19</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9049</td>
        <td>ICCD agent ID</td>
        <td>19</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12435</td>
        <td>Shamela author ID</td>
        <td>19</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P989</td>
        <td>spoken text audio</td>
        <td>18</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3409</td>
        <td>Catalogus Professorum Lipsiensis ID</td>
        <td>18</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5080</td>
        <td>Norsk biografisk leksikon ID</td>
        <td>18</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6037</td>
        <td>ProsopoMaths ID</td>
        <td>18</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6556</td>
        <td>SICRIS researcher ID</td>
        <td>18</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6988</td>
        <td>Hungarian National Namespace person ID (old)</td>
        <td>18</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7026</td>
        <td>Lebanese National Library ID</td>
        <td>18</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8833</td>
        <td>Union Catalog of Armenian Libraries authority ID</td>
        <td>18</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8982</td>
        <td>Pontificio Istituto di Archeologia Cristiana ID</td>
        <td>18</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10307</td>
        <td>CYT/CCS</td>
        <td>18</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P859</td>
        <td>sponsor</td>
        <td>17</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P968</td>
        <td>email address</td>
        <td>17</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1047</td>
        <td>Catholic Hierarchy person ID</td>
        <td>17</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3716</td>
        <td>social classification</td>
        <td>17</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7758</td>
        <td>SPIE profile ID</td>
        <td>17</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8017</td>
        <td>generational suffix</td>
        <td>17</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8568</td>
        <td>Jewish Virtual Library ID</td>
        <td>17</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8832</td>
        <td>PAN member</td>
        <td>17</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8944</td>
        <td>Archivio dei possessori ID</td>
        <td>17</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11041</td>
        <td>kulturstiftung.org person ID</td>
        <td>17</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11185</td>
        <td>Levadia Library ID</td>
        <td>17</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1473</td>
        <td>BLPL author ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1614</td>
        <td>History of Parliament ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2190</td>
        <td>C-SPAN person ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2492</td>
        <td>MTMT author ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3218</td>
        <td>Auñamendi ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3411</td>
        <td>Saxon Academy of Sciences member ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4549</td>
        <td>ARLIMA ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6404</td>
        <td>Treccani's Dizionario di Storia ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6734</td>
        <td>Archaeology Data Service person ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7024</td>
        <td>Flemish Public Libraries ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7038</td>
        <td>Documenta Catholica Omnia author ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7893</td>
        <td>CIÊNCIAVITAE ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9163</td>
        <td>Obrazi slovenskih pokrajin ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11155</td>
        <td>Municipal Library of Trikala ID</td>
        <td>16</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P701</td>
        <td>Dodis ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1367</td>
        <td>Art UK artist ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2273</td>
        <td>HAdW member ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2533</td>
        <td>WomenWriters ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2753</td>
        <td>Dictionary of Canadian Biography ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4104</td>
        <td>Carnegie Hall agent ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5297</td>
        <td>Companies House officer ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5395</td>
        <td>Canadian Encyclopedia article ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6868</td>
        <td>Hoopla artist ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8163</td>
        <td>Diels-Kranz ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8669</td>
        <td>Encyclopaedia Beliana ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10018</td>
        <td>George Eastman Museum people ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10844</td>
        <td>Teresianum authority ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11621</td>
        <td>Hungarian National Namespace person ID (new)</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12386</td>
        <td>Dansk Forfatterleksikon ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12697</td>
        <td>RAG ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12869</td>
        <td>LAGL author ID</td>
        <td>15</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P460</td>
        <td>said to be the same as</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1636</td>
        <td>date of baptism</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1710</td>
        <td>Sächsische Biografie (GND) ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1807</td>
        <td>Great Aragonese Encyclopedia ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2581</td>
        <td>BabelNet ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2745</td>
        <td>Dictionary of New Zealand Biography ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3226</td>
        <td>HAS member ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3553</td>
        <td>Zhihu topic ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5088</td>
        <td>Internet Encyclopedia of Philosophy ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5552</td>
        <td>CNRS Talent page</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5695</td>
        <td>Bibliopoche author ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7613</td>
        <td>Biblioteche dei filosofi ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7726</td>
        <td>PlanetMath ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7848</td>
        <td>Frick Art Reference Library Artist File ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8975</td>
        <td>Manus Online author ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9564</td>
        <td>Biographical Dictionary of Chinese Christianity ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10554</td>
        <td>BillionGraves grave ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12040</td>
        <td>J. Paul Getty Museum agent ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12780</td>
        <td>Korrespondenzen der Frühromantik person ID</td>
        <td>14</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1187</td>
        <td>Dharma Drum Institute of Liberal Arts person ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1576</td>
        <td>lifestyle</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2418</td>
        <td>Structurae person ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2888</td>
        <td>exact match</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3235</td>
        <td>PhilPapers topic</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3595</td>
        <td>Biografiskt Lexikon för Finland ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4936</td>
        <td>SFMOMA artist ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5632</td>
        <td>Persons of Indian Studies ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6715</td>
        <td>SIUSA archive producer person ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6764</td>
        <td>V&amp;A person ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6925</td>
        <td>Musicalics composer ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7928</td>
        <td>BioLexSOE ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7941</td>
        <td>Biografisch Woordenboek van Nederland: 1880-2000 ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8051</td>
        <td>Geschichtsquellen des deutschen Mittelalters author ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8223</td>
        <td>K-Scholar ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9522</td>
        <td>Biblioteca di Santa Sabina ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10700</td>
        <td>Parcours de vies dans la Royale ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10713</td>
        <td>Biografiskt Lexikon för Finland ID (urn.fi)</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10881</td>
        <td>Kieler Gelehrtenverzeichnis ID</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11146</td>
        <td>collection items at</td>
        <td>13</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1438</td>
        <td>Jewish Encyclopedia ID (Russian)</td>
        <td>12</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2029</td>
        <td>Dictionary of Ulster Biography ID</td>
        <td>12</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2873</td>
        <td>time in space</td>
        <td>12</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3021</td>
        <td>Iranica ID</td>
        <td>12</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4590</td>
        <td>Atomic Heritage Foundation ID</td>
        <td>12</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5056</td>
        <td>patronym or matronym for this person</td>
        <td>12</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6900</td>
        <td>NicoNicoPedia ID</td>
        <td>12</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7711</td>
        <td>Joconde author ID</td>
        <td>12</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7753</td>
        <td>Projekt Gutenberg-DE author ID</td>
        <td>12</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9502</td>
        <td>Digital DISCI ID</td>
        <td>12</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9862</td>
        <td>Encyclopaedia of Islam (second edition) ID</td>
        <td>12</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11158</td>
        <td>Dimitri and Aliki Perrotis Central Library ID</td>
        <td>12</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1424</td>
        <td>topic's main template</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4574</td>
        <td>Norwegian historical register of persons ID</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4585</td>
        <td>Accademia della Crusca ID</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5101</td>
        <td>Swedish Literature Bank Author ID</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5489</td>
        <td>artist-info artist ID</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6275</td>
        <td>copyright representative</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6424</td>
        <td>affiliation string</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7445</td>
        <td>Basis Wien person ID</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7507</td>
        <td>Ben Yehuda author ID</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8219</td>
        <td>ASUT ID</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8899</td>
        <td>Swedish National Library Arken ID</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9105</td>
        <td>Dictionnaire des journalistes ID</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9511</td>
        <td>am.hayazg.info ID</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10069</td>
        <td>Tabakalera ID</td>
        <td>11</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P553</td>
        <td>website account on</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1045</td>
        <td>Sycomore ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1048</td>
        <td>NCL ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1441</td>
        <td>present in work</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2953</td>
        <td>Estonian Research Portal person ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3603</td>
        <td>Minneapolis Institute of Art constituent ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4174</td>
        <td>Wikimedia username</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4389</td>
        <td>Science Museum people ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4539</td>
        <td>Collective Biographies of Women ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4621</td>
        <td>Württembergische Kirchengeschichte person ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4717</td>
        <td>Académie française member ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5021</td>
        <td>assessment</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6482</td>
        <td>Image Archive, Herder Institute</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7039</td>
        <td>National Library of Iceland ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7042</td>
        <td>The Latin Library author ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8079</td>
        <td>elibrary.ru person ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8581</td>
        <td>Hrvatski biografski leksikon ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8705</td>
        <td>Artist ID of the Department of Prints and Drawings of the Louvre</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9307</td>
        <td>Fancyclopedia 3 ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9579</td>
        <td>vedidk ID</td>
        <td>10</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1321</td>
        <td>place of origin (Switzerland)</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1341</td>
        <td>Italian Chamber of Deputies dati ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1581</td>
        <td>official blog URL</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1813</td>
        <td>short name</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2174</td>
        <td>Museum of Modern Art artist ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3299</td>
        <td>student register of the University of Helsinki ID (1640–1852)</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3410</td>
        <td>Clergy of the Church of England database ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3835</td>
        <td>Mendeley person ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3954</td>
        <td>Senate of the Kingdom of Italy ID (obsolete)</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4169</td>
        <td>YCBA agent ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4343</td>
        <td>WBPLN author ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4602</td>
        <td>date of burial or cremation</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5714</td>
        <td>Tor.com author ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5776</td>
        <td>Arnet Miner author ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6262</td>
        <td>Fandom article ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7203</td>
        <td>Dizionario biografico dei Friulani ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7311</td>
        <td>Aozora Bunko author ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7433</td>
        <td>FantLab author ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7671</td>
        <td>Semion author ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7775</td>
        <td>RationalWiki ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8085</td>
        <td>Curran Index contributor ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8080</td>
        <td>Ökumenisches Heiligenlexikon ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8234</td>
        <td>LiederNet author ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8334</td>
        <td>MuseScore artist ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8951</td>
        <td>Order of Canada recipient ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9226</td>
        <td>ARAE ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9475</td>
        <td>Encyclopedia of Korean Culture ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9678</td>
        <td>Franciscan Center of Christian Oriental Studies ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9720</td>
        <td>fotoCH photographer ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12520</td>
        <td>Italian Senate (1848-1943) ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12858</td>
        <td>UNIBO professor ID</td>
        <td>9</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P451</td>
        <td>unmarried partner</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P237</td>
        <td>coat of arms</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P812</td>
        <td>academic major</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P864</td>
        <td>ACM Digital Library author ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1142</td>
        <td>political ideology</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1648</td>
        <td>Dictionary of Welsh Biography ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2558</td>
        <td>autores.uy ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2604</td>
        <td>Kinopoisk person ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2943</td>
        <td>warheroes.ru ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3887</td>
        <td>KVAB member ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3956</td>
        <td>National Academy of Medicine (France) member ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4992</td>
        <td>DBA ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5273</td>
        <td>Nelson-Atkins Museum of Art person ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5613</td>
        <td>Bibliothèque de la Pléiade ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6005</td>
        <td>Muck Rack journalist ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6060</td>
        <td>MoEML ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6553</td>
        <td>personal pronoun</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6573</td>
        <td>Klexikon article ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6583</td>
        <td>Lucerna person ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7663</td>
        <td>Scienza a due voci ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8418</td>
        <td>Oberwolfach mathematician ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8432</td>
        <td>Österreichisches Musiklexikon Online ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8603</td>
        <td>Istrapedia ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8854</td>
        <td>Salzburgwiki ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9232</td>
        <td>Obituaries Australia ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9723</td>
        <td>20th Century Chinese Biographical Database ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9879</td>
        <td>Encyclopaedia of Islam (third edition) ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9913</td>
        <td>FLORE author ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10021</td>
        <td>UAE University Libraries ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10059</td>
        <td>Philosophica ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10314</td>
        <td>Archivio Biografico Comunale (Palermo) ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10376</td>
        <td>ScienceDirect topic ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10707</td>
        <td>AccessScience ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10849</td>
        <td>Beamish peerage database person ID</td>
        <td>8</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P841</td>
        <td>feast day</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2015</td>
        <td>Hansard (1803–2005) ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2639</td>
        <td>Filmportal ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2959</td>
        <td>permanent duplicated item</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3325</td>
        <td>student register of the University of Helsinki ID (1853–1899)</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3710</td>
        <td>Jewish Encyclopedia Daat ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3794</td>
        <td>Dictionary of Sydney ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4457</td>
        <td>DAHR artist ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4594</td>
        <td>arXiv author ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4991</td>
        <td>Biographical Dictionary of Georgia ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5320</td>
        <td>IUF member ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5541</td>
        <td>Paris Faculty of Science professor ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6488</td>
        <td>Enciclopedia delle donne ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7168</td>
        <td>FGrHist ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7212</td>
        <td>LyricsTranslate ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7908</td>
        <td>Clavis Clavium ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8309</td>
        <td>Yle topic ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8324</td>
        <td>funder</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8728</td>
        <td>Nachlässe in Austria ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9062</td>
        <td>BABEL author ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9651</td>
        <td>Book Owners Online person ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9686</td>
        <td>Classical Archives composer ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10011</td>
        <td>SISSA Digital Library author ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10017</td>
        <td>Treccani's Dizionario delle Scienze Fisiche ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10031</td>
        <td>Enciclopedia di Roma person ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10679</td>
        <td>Aldiwan poet ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10789</td>
        <td>Lithuania Minor Encyclopedia ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11120</td>
        <td>Rai Teche person ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11790</td>
        <td>Clavis Historicorum Antiquitatis Posterioris author ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11986</td>
        <td>Research.com ID</td>
        <td>7</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10</td>
        <td>video</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P411</td>
        <td>canonization status</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1035</td>
        <td>honorific suffix</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1399</td>
        <td>convicted of</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1532</td>
        <td>country for sport</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1818</td>
        <td>Kaiserhof ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1842</td>
        <td>Global Anabaptist Mennonite Encyclopedia Online ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1882</td>
        <td>Web Gallery of Art ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2030</td>
        <td>NASA biographical ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2171</td>
        <td>TheyWorkForYou ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2168</td>
        <td>Swedish Film Database person ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2298</td>
        <td>NSDAP membership number (1925–1945)</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2359</td>
        <td>Roman nomen gentilicium</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3307</td>
        <td>Galiciana authority ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3448</td>
        <td>stepparent</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3901</td>
        <td>ADAGP artist ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4361</td>
        <td>ExecutedToday ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4450</td>
        <td>HAL author ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4620</td>
        <td>Merkelstiftung person ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4663</td>
        <td>DACS ID (former)</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4928</td>
        <td>Ricorso author ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5025</td>
        <td>gens</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5212</td>
        <td>Armenian National Academy of Sciences ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5415</td>
        <td>Whonamedit? doctor ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5419</td>
        <td>NYRB contributor ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5647</td>
        <td>Baidu ScholarID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6173</td>
        <td>Bitraga author ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6300</td>
        <td>Hymnary author ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6735</td>
        <td>Watercolour World artist ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6828</td>
        <td>Czech parliament ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6872</td>
        <td>has written for</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6934</td>
        <td>Syriac Biographical Dictionary ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8408</td>
        <td>KBpedia ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8504</td>
        <td>Science Fiction Awards Database author ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8748</td>
        <td>Rheinland-Pfälzische Personendatenbank ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8805</td>
        <td>LIMIS person ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9113</td>
        <td>Patrinum ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9178</td>
        <td>Biblioteca Franco Serantini ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9352</td>
        <td>Portrait Archive ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9629</td>
        <td>Armeniapedia ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9885</td>
        <td>Bing entity ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9965</td>
        <td>Musik-Sammler.de artist ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10387</td>
        <td>Databazeknih.cz author ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10518</td>
        <td>ICCROM authority ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10535</td>
        <td>RSPA modern author ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10880</td>
        <td>Catalogus Professorum (TU Berlin) person ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11233</td>
        <td>SciSpace author ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11720</td>
        <td>IRInSubria author ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12615</td>
        <td>Hanslick Online person ID</td>
        <td>6</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P54</td>
        <td>member of sports team</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P91</td>
        <td>sexual orientation</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P598</td>
        <td>commander of (DEPRECATED)</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P990</td>
        <td>audio recording of the subject's spoken voice</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1149</td>
        <td>Library of Congress Classification</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1564</td>
        <td>At the Circulating Library ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1631</td>
        <td>China Vitae person ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1665</td>
        <td>Chessgames.com player ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P1795</td>
        <td>Smithsonian American Art Museum person/institution ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2019</td>
        <td>AllMovie person ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2358</td>
        <td>Roman praenomen</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2365</td>
        <td>Roman cognomen</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2372</td>
        <td>ODIS ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2432</td>
        <td>J. Paul Getty Museum agent DOR ID (old)</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2699</td>
        <td>URL</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2940</td>
        <td>Catalogus Professorum Rostochiensium ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P2941</td>
        <td>Munk's Roll ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3708</td>
        <td>PhDTree person ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P3997</td>
        <td>Bait La Zemer Ha-Ivri artist ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4471</td>
        <td>Rush Parliamentary Archive ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P4802</td>
        <td>BVPB authority ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5298</td>
        <td>Webb-site person ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5368</td>
        <td>National Gallery of Canada artist ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5491</td>
        <td>BD Gest' author ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5516</td>
        <td>Virtual Laboratory person ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5645</td>
        <td>Académie française award winner ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P5664</td>
        <td>Savoirs ENS ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6126</td>
        <td>Santiebeati ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6520</td>
        <td>Lokalhistoriewiki.no article ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6677</td>
        <td>OpenEdition Books author ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6723</td>
        <td>BlackPast.org ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6745</td>
        <td>Orlando author ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6902</td>
        <td>era name</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P6917</td>
        <td>Historical Archives of the European Union ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7084</td>
        <td>related category</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7388</td>
        <td>Great Encyclopedia of Navarre ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7769</td>
        <td>Australian National Maritime Museum person ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P7962</td>
        <td>Dictionnaire des femmes de l’ancienne France ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8044</td>
        <td>Frankfurter Personenlexikon ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8095</td>
        <td>Encyklopedia Solidarności ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8462</td>
        <td>Political Graveyard politician ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8696</td>
        <td>Directory of Belgian Photographers ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8759</td>
        <td>Polski Słownik Judaistyczny ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8848</td>
        <td>CONOR.AL ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8974</td>
        <td>SAPA ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P8995</td>
        <td>Lumières.Lausanne ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9039</td>
        <td>Studium Parisiense ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9300</td>
        <td>Terezín Memorial Database ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9299</td>
        <td>OsobnostiRegionu.cz ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9337</td>
        <td>Keratsini-Drapetsona libraries' catalogue authority ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9599</td>
        <td>Polo bibliografico della ricerca author ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9780</td>
        <td>The Women's Print History Project person ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9791</td>
        <td>ASEE person ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P9929</td>
        <td>madhhab</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10085</td>
        <td>biografiA ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10527</td>
        <td>documentation files at</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10706</td>
        <td>DACS ID (2022)</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P10799</td>
        <td>Heiligen.net ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11194</td>
        <td>Famous Birthdays ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P11835</td>
        <td>Numista ruling authority ID</td>
        <td>5</td>
        <td> </td>
    </tr>
    <tr>
        <td>http://www.wikidata.org/prop/direct/P12836</td>
        <td>Douban personage ID</td>
        <td>5</td>
        <td> </td>
    </tr>
</tbody>
</table>


