
// 
// GKGRECORDID,DATE,SourceCollectionIdentifier,SourceCommonName,
// DocumentIdentifier,Counts,V2Counts,Themes,V2Themes,Locations,V2Locations,Persons,V2Persons,Organizations,V2Organizations,V2Tone,Dates,GCAM,SharingImage,RelatedImages,SocialImageEmbeds,SocialVideoEmbeds,Quotations,AllNames,Amounts,TranslationInfo,Extras

USING PERIODIC COMMIT 5000
LOAD CSV WITH HEADERS FROM "https://storage.googleapis.com/meetup-data/gdelt_gkg_partitioned.csv" as line
WITH line, 
     apoc.text.split(line.V2Persons, ',\\d+;?') as persons,
     apoc.text.split(line.V2Themes, ',\\d+;?') as themes,
     apoc.text.split(line.V2Organizations, ',\\d+;?') as organizations
MERGE (s:Source { name: line.SourceCommonName })
CREATE (e:Event {
    id: line.GKGRECORDID,
    date: line.DATE,
    document: line.DocumentIdentifier,
    persons: persons,
    themes: themes,
    organizations: organizations,
    locations: line.V2Locations,
    tone: [x in apoc.text.split(line.V2Tone, ',') | toFloat(x)],
    GCAM: line.GCAM,
    counts: coalesce(line.V2Counts, '')
})
CREATE (e)-[:SOURCE]->(s);

CALL apoc.periodic.iterate(
    'MATCH (e:Event) WHERE e.persons IS NOT NULL RETURN e',
    'UNWIND apoc.coll.toSet(e.persons) as person MERGE (p:Person { name: person }) CREATE (e)-[:PERSON]->(p) SET e.persons = null',
    { batchSize: 1000, parallel: false });

CALL apoc.periodic.iterate(
    'MATCH (e:Event) WHERE e.themes IS NOT NULL RETURN e',
    'UNWIND apoc.coll.toSet(e.themes) as theme MERGE (t:Theme { name: theme }) CREATE (e)-[:THEME]->(t) SET e.themes = null',
    { batchSize: 1000, parallel: false });

CALL apoc.periodic.iterate(
    'MATCH (e:Event) WHERE e.organizations IS NOT NULL RETURN e',
    'UNWIND apoc.coll.toSet(e.organizations) as organization MERGE (o:Organization { name: organization }) CREATE (e)-[:ORG]->(t) SET e.organizations = null',
    { batchSize: 1000, parallel: false });

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
    { batchSize: 200, parallel: false });

CALL apoc.periodic.iterate(
   'MATCH (e:Event) WHERE e.GCAM is not null RETURN e',
   'WITH e, [x in apoc.text.split(e.GCAM,",") | 
       apoc.text.split(x, ":")] as pairs
    UNWIND pairs as pair
    WITH e, pair[0] as gcam, pair[1] as score
    CREATE (gs:GCAMScore { value: toFloat(score) })
    MERGE (g:GCAMVariable { id: gcam })
    CREATE (e)-[:score]->(gs)-[:gcam]->(g)',
    { batchSize: 200, parallel: false }
);
