// 
// GKGRECORDID,DATE,SourceCollectionIdentifier,SourceCommonName,
// DocumentIdentifier,Counts,V2Counts,Themes,V2Themes,Locations,V2Locations,Persons,V2Persons,Organizations,V2Organizations,V2Tone,Dates,GCAM,SharingImage,RelatedImages,SocialImageEmbeds,SocialVideoEmbeds,Quotations,AllNames,Amounts,TranslationInfo,Extras

USING PERIODIC COMMIT 20000
LOAD CSV WITH HEADERS FROM "https://storage.googleapis.com/meetup-data/gdelt-2020-02-22000000000000.csv" as line
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
    /* GCAM: line.GCAM, COMPLICATED FIELD - see link stage.  Heavyweight */
    counts: coalesce(line.V2Counts, '')
})
CREATE (e)-[:SOURCE]->(s)
RETURN count(e);
