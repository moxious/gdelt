:auto USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "https://storage.googleapis.com/meetup-data/GDELT-million.txt" AS line FIELDTERMINATOR '\t'
WITH line
MERGE (src:Entity { code: line.Source })
MERGE (target:Entity { code: line.Target })
MERGE (code:Entity:EventCode { code: line.CAMEOCode })
CREATE (e:Event {
    date: date(datetime({epochMillis: apoc.date.parse(line.Date, "ms", "yyyyMMdd")})),
    events: toInteger(line.NumEvents),
    arts: toInteger(line.NumArts),
    quadClass: toInteger(line.QuadClass),
    goldstein: toFloat(line.Goldstein)
})
CREATE (src)-[:EVENT]->(e)-[:EVENT]->(target)
CREATE (e)-[:CODE]->(code);

