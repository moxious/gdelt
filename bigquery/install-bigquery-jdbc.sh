#!/bin/bash

CLUSTER_ID=0802-120649-rent6

# Unzip and make available the JAR files
# Copy them up to dbfs
# databricks fs mkdirs dbfs:/bigquery-connector
# for file in ~/Downloads/bq/*.jar ; do databricks fs cp $file dbfs:/bigquery-connector/; done

for file in `databricks fs ls dbfs:/bigquery-connector/` ; do 
    databricks libraries install \
        --cluster-id 0802-120649-rent6 \
        --jar dbfs:/bigquery-connector/$file ; 
done

0802-120649-rent6