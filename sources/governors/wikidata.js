const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = function () {
  return `SELECT DISTINCT ?province ?provinceLabel ?position ?positionLabel ?item ?name
         ?start ?source ?sourceDate (STRAFTER(STR(?held), '/statement/') AS ?psid)
  WHERE {
    ?province wdt:P31 wd:Q5098 ; wdt:P1313 ?position .
    MINUS { ?province wdt:P576 [] }
    OPTIONAL {
      ?item wdt:P31 wd:Q5 ; p:P39 ?held .
      OPTIONAL { ?item wdt:P569 ?dob }

      ?held ps:P39 ?position ; pq:P580 ?start .
      FILTER NOT EXISTS { ?held pq:P582 ?end }

      OPTIONAL {
        ?held prov:wasDerivedFrom ?ref .
        ?ref pr:P4656 ?source FILTER (STR(?source) = '${meta.source}') .
        OPTIONAL { ?ref pr:P1810 ?sourceName }
        OPTIONAL { ?ref pr:P1932 ?statedName }
        OPTIONAL { ?ref pr:P813  ?sourceDate }
      }
      OPTIONAL { ?item rdfs:label ?wdLabel FILTER(LANG(?wdLabel) = "id") }
      BIND(COALESCE(?sourceName, ?wdLabel) AS ?name)

      OPTIONAL { ?position rdfs:label ?posLabel FILTER(LANG(?posLabel) = "id") }
      BIND(COALESCE(?statedName, ?posLabel) AS ?positionLabel)
    }

    SERVICE wikibase:label { bd:serviceParam wikibase:language "id". }
  } # ${new Date().toISOString()}
  ORDER BY ?provinceLabel ?sourceDate`
}
