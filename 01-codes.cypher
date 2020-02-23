LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/moxious/gdelt/master/data/CAMEO.ethnic.txt" AS line
FIELDTERMINATOR '\t'
MERGE (e:Entity:EthnicGroup { code: line.CODE })
SET e.label = line.LABEL
return count(e);

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/moxious/gdelt/master/data/CAMEO.knowngroup.txt" AS line
FIELDTERMINATOR '\t'
MERGE (e:Entity:KnownGroup { code: line.CODE })
SET e.label = line.LABEL
return count(e);

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/moxious/gdelt/master/data/CAMEO.religion.txt" AS line
FIELDTERMINATOR '\t'
MERGE (e:Entity:Religion { code: line.CODE })
SET e.label = line.LABEL
return count(e);

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/moxious/gdelt/master/data/CAMEO.eventcodes.txt" AS line
FIELDTERMINATOR '\t'
MERGE (e:Entity:EventCode {
    code: line.CAMEOEVENTCODE,
    description: line.EVENTDESCRIPTION
})
return count(e);

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/moxious/gdelt/master/data/CAMEO.goldsteinscale.txt" AS line
FIELDTERMINATOR '\t'
MERGE (e:Entity:EventCode { code: line.CAMEOEVENTCODE })
SET e.goldsteinScale = line.GOLDSTEINSCALE
return count(e);

LOAD CSV FROM "https://raw.githubusercontent.com/moxious/gdelt/master/data/LOOKUP-GKGTHEMES.TXT" AS line
FIELDTERMINATOR '\t'
MERGE (t:Theme { name: line[0] })
  SET t.id = line[1]
RETURN count(t);

MERGE (e:Entity:EventCode { code: line.CAMEOEVENTCODE })
SET e.goldsteinScale = line.GOLDSTEINSCALE
return count(e);

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/moxious/gdelt/master/data/GCAM-MASTER-CODEBOOK.TXT" AS line
FIELDTERMINATOR '\t'
MERGE (g:GCAMVariable {
   id: line.Variable,
   dictionary: line.DictionaryID,
   dimension: line.DimensionID,
   type: line.Type,
   language: line.LanguageCode,
   dictionaryHumanName: line.DictionaryHumanName,
   dimensionHumanName: line.DimensionHumanName,
   citation: line.DictionaryCitation
})
RETURN count(g);