/*
MATCH (s:Source)<-[:FROM]-(:Document)<-[:DOCUMENT]-(:Event)-[r:THEME]->(t:Theme)
RETURN id(s) as source, id(t) as target, sum(r.weight) as weight
*/

CALL gds.graph.drop('sourcesAndThemes');

WITH 
'sourcesAndThemes' 
    AS name,
'MATCH (n) WHERE n:Source OR n:Theme RETURN id(n) as id' 
    AS nodeQuery,
'MATCH (s:Source)<-[:FROM]-(:Document)<-[:DOCUMENT]-(e:Event)-[r:THEME]->(t:Theme)
WHERE abs(e.Tone) > 10 and e.Polarity > 10
WITH id(s) as source, id(t) as target, count(e) as events, sum(r.weight) as weight
WHERE events > 20
RETURN source, target, weight' 
    AS relQuery
CALL gds.graph.create.cypher(
    name, nodeQuery, relQuery,
    {
        readConcurrency: 4,
        validateRelationships: false
    }
)
YIELD graphName, nodeCount, relationshipCount
RETURN *;


// CALL gds.nodeSimilarity.stream('sourcesAndThemes')
// YIELD node1, node2, similarity
// WITH gds.util.asNode(node1).name AS Source1, gds.util.asNode(node2).name AS Source2, similarity
// CREATE (s:Similar { a: Source1, b: Source2, similarity: similarity });

CALL gds.nodeSimilarity.stream('sourcesAndThemes')
YIELD node1, node2, similarity
RETURN gds.util.asNode(node1).name AS Source1, gds.util.asNode(node2).name AS Source2, similarity
ORDER BY similarity DESCENDING, Source1, Source2 
LIMIT 100;