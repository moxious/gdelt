# GDELT

This repo provides for a repeatable method of loading Google's GDELT dataset into Neo4j.

If you don't know what GDELT is, that's the place to start:

https://www.gdeltproject.org/

Their data documentation is here: https://www.gdeltproject.org/data.html#documentation

## Basic Process

We use publicly available Google BigQuery tables to create a dated extract.  That goes into
a temporary table in Google Cloud.   That table gets exported to a set of shard CSV files on 
Google Storage.   Those files end up in `segments.list`, which are fed into the load process.

See the bigquery-extract.sql file for which data is pulled with which criteria.
With that table, export to CSV.

## Benchmarking

The benchmark.sh script runs the complete load process, with timings suitable to be fed into
other benchmarking rigs that I have in place.

