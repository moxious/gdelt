/* PARTITION QUERY */
SELECT * FROM `gdelt-bq.gdeltv2.gkg_partitioned` 
    WHERE _PARTITIONTIME >= "2020-03-01 00:00:00" AND _PARTITIONTIME < "2020-03-19 00:00:00";


/* Put that into extract, then cut down */

CREATE OR REPLACE TABLE gdelt.gdelt_march_2020_extract AS
SELECT
  GKGRECORDID, DATE, SourceCollectionIdentifier, 
  SourceCommonName, DocumentIdentifier, Counts, V2Counts,
  V2Themes, V2Locations, V2Persons, V2Organizations, V2Tone
 FROM gdelt.gdelt_march_2020;