/* PARTITION QUERY */
CREATE OR REPLACE TABLE gdelt.coronavirus_extract AS

SELECT 
  /* Project only what load csv needs */
  GKGRECORDID, DATE, SourceCollectionIdentifier, 
  SourceCommonName, DocumentIdentifier, Counts, V2Counts,
  V2Themes, V2Locations, V2Persons, V2Organizations, V2Tone

FROM `gdelt-bq.gdeltv2.gkg_partitioned` 

WHERE 
    _PARTITIONTIME >= "2020-01-01 00:00:00" AND 
    /* Uncomment to set an end partition date range */
    /* _PARTITIONTIME < "2020-03-19 00:00:00" AND */

    /* TOPIC FILTER */
    (lower(V2Themes) like '%coronavirus%' OR
     lower(V2Themes) like '%covid-19%' OR
     lower(V2Themes) like '%outbreak%' OR
     lower(DocumentIdentifier) like '%coronavirus%' OR
     lower(DocumentIdentifier) like '%covid-19%' OR
     lower(DocumentIdentifier) like '%outbreak%' OR
     lower(V2Counts) like '%coronavirus%' OR
     lower(V2Counts) like '%covid-19%' OR
     lower(V2Counts) like '%outbreak%' OR 
     lower(V2Organizations) like '%coronavirus%' OR
     lower(V2Organizations) like '%covid-19%' OR
     lower(V2Organizations) like '%outbreak%'
    )
;


CREATE OR REPLACE TABLE gdelt.sourcesbycountry AS
SELECT * FROM `gdelt-bq.extra.sourcesbycountry`;