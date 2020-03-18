
CALL apoc.periodic.iterate(
    'MATCH (e:Event) WHERE e.persons IS NOT NULL RETURN e',
    'UNWIND apoc.coll.toSet(e.persons) as person MERGE (p:Person { name: person }) CREATE (e)-[:PERSON]->(p) SET e.persons = null',
    { batchSize: 20000, parallel: false });

CALL apoc.periodic.iterate(
    'MATCH (e:Event) WHERE e.themes IS NOT NULL RETURN e',
    'UNWIND apoc.coll.toSet(e.themes) as theme MERGE (t:Theme { name: theme }) CREATE (e)-[:THEME]->(t) SET e.themes = null',
    { batchSize: 20000, parallel: false });

CALL apoc.periodic.iterate(
    'MATCH (e:Event) WHERE e.organizations IS NOT NULL RETURN e',
    'UNWIND apoc.coll.toSet(e.organizations) as organization MERGE (o:Organization { name: organization }) CREATE (e)-[:ORG]->(t) SET e.organizations = null',
    { batchSize: 20000, parallel: false });

CALL apoc.periodic.iterate(
    'MATCH (e:Event) WHERE e.locations IS NOT NULL RETURN e',
    'WITH [
        loc in apoc.text.split(e.locations,";") | 
        apoc.text.split(loc, "#") 
    ] as locgroups, e 
    UNWIND locgroups as locgroup 
    MERGE (l:Location { name: locgroup[1] })
      ON CREATE SET l += {
        id: locgroup[0], 
        country: locgroup[2], 
        code: locgroup[3], 
        next: locgroup[4], 
        lat: toFloat(locgroup[5]), 
        lon: toFloat(locgroup[6]), 
        province: locgroup[7], 
        last: locgroup[8]
      }
    MERGE (e)-[:LOCATION]->(l) SET e.locations = null',
    { batchSize: 10000, parallel: false });

/*
CALL apoc.periodic.iterate(
   'MATCH (e:Event) WHERE e.GCAM is not null RETURN e',
   'WITH e, [x in apoc.text.split(e.GCAM,",") | 
       apoc.text.split(x, ":")] as pairs
    UNWIND pairs as pairs
    WITH e, pair[0] as gcam, pair[1] as score
    CREATE (gs:GCAMScore { value: toFloat(score) })
    MERGE (g:GCAMVariable { id: gcam })
    CREATE (e)-[:score]->(gs)-[:gcam]->(g)',
    { batchSize: 500, parallel: false }
);
*/
