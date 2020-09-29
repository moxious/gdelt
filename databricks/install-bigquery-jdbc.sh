#!/bin/bash

export CLUSTER_ID=$(databricks clusters list | grep RUNNING | sed 's/ .*//')
DIR=JARs

# Unzip and make available the JAR files
# Copy them up to dbfs
databricks fs mkdirs dbfs:/$DIR

for file in ../bigquery/driver/*.jar ; do databricks fs cp $file dbfs:/$DIR/; done
for file in ../spark-connector/*.jar ; do databricks fs cp $file dbfs:/$DIR/ --overwrite;  done

for file in `databricks fs ls dbfs:/$DIR/` ; do 
    databricks libraries install \
        --cluster-id $CLUSTER_ID \
        --jar dbfs:/$DIR/$file ; 
done

