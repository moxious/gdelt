/* PARTITION QUERY */
CREATE OR REPLACE TABLE gdelt.coronavirus_extract AS

SELECT 
  /* Project only what load csv needs */
  GKGRECORDID, DATE, SourceCollectionIdentifier, 
  SourceCommonName, DocumentIdentifier, Counts, V2Counts,
  V2Themes, V2Locations, V2Persons, V2Organizations, V2Tone

FROM `gdelt-bq.gdeltv2.gkg_partitioned` 

WHERE 
    _PARTITIONTIME >= "2020-08-01 00:00:00" AND 
    _PARTITIONTIME < "2020-09-01 00:00:00"
;

CREATE OR REPLACE TABLE gdelt.sourcesbycountry AS
SELECT * FROM `gdelt-bq.extra.sourcesbycountry`;