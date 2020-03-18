#!/bin/bash

echo "====================================================" 
echo "== GDELT BENCHMARK"
echo "== START: " $(date)
echo "====================================================" 

if [ -z $2 ] ; then 
   echo "Usage: ./benchmark.sh bolt+routing://host:7687 Neo4jPassword"
   exit 1
fi

if [ -z $1 ] ; then
   echo  "Usage: ./benchmark.sh bolt+routing://host:7687 Neo4jPassword"
   exit 1
fi

export NEO4J_URI=$1
export NEO4J_PASSWORD=$2
export NEO4J_USERNAME=neo4j
SEGMENT_FILE=https://storage.googleapis.com/meetup-data/gdelt-2020-02-22000000000000.csv

TAG=$(head -c 3 /dev/urandom | md5 | head -c 5)

STARTTIME=$(date +%s)

# We will add the exit code of all sub-processes
# If they're all zero, we exit good.  Otherwise
# we exit non-zero error.
OVERALL_EXIT_CODE=0

echo "Index phase" 
START_INDEX=$(date +%s)
cat 00-index.cypher | cypher-shell -a $NEO4J_URI
OVERALL_EXIT_CODE=$(($OVERALL_EXIT_CODE + $?))
END_INDEX=$(date +%s)
ELAPSED_INDEX=$(($END_INDEX - $START_INDEX))

echo "Codes phase"
START_CODES=$(date +%s)
cat 01-codes.cypher | cypher-shell -a $NEO4J_URI
OVERALL_EXIT_CODE=$(($OVERALL_EXIT_CODE + $?))
END_CODES=$(date +%s)
ELAPSED_CODES=$(($END_CODES - $START_CODES))

echo "Load phase" 
START_LOAD=$(date +%s)
cat 02-load.cypher | cypher-shell -a $NEO4J_URI
OVERALL_EXIT_CODE=$(($OVERALL_EXIT_CODE + $?))
END_LOAD=$(date +%s)
ELAPSED_LOAD=$(($END_LOAD - $START_LOAD))

echo "Link groups phase"
START_LINK=$(date +%s)
cat 03-link.cypher | cypher-shell -a $NEO4J_URI
OVERALL_EXIT_CODE=$(($OVERALL_EXIT_CODE + $?))
END_LINK=$(date +%s)
ELAPSED_LINK=$(($END_LINK - $START_LINK))

echo BENCHMARK_SETTING_TIME_RESOLUTION=seconds
echo BENCHMARK_SETTING_SEGMENT=$SEGMENT_FILE
echo BENCHMARK_SETTING_TAG=$TAG
echo BENCHMARK_SETTING_NEO4J_URI=$NEO4J_URI

NODES=$(echo 'MATCH (n) RETURN count(n) as val;' | cypher-shell -a $NEO4J_URI --format plain | tail -n 1)
EDGES=$(echo 'MATCH (n)-[r]->(m) RETURN count(r) as val;' | cypher-shell -a $NEO4J_URI --format plain | tail -n 1)

echo BENCHMARK_NODE_COUNT=$NODES
echo BENCHMARK_EDGE_COUNT=$EDGES

ENDTIME=$(date +%s)
ELAPSED=$(($ENDTIME - $STARTTIME))
echo "BENCHMARK ELAPSED TIME IN SECONDS: " $ELAPSED

echo "Done"

echo "====================================================" 
echo "== GDELT BENCHMARK $TAG $1"
echo "== FINISH: " $(date)
echo "===================================================="
echo "Benchmark $TAG complete with $ELAPSED elapsed"

echo "BENCHMARK_ELAPSED=$ELAPSED"
echo "BENCHMARK_LINK=$ELAPSED_LINK"
echo "BENCHMARK_LOAD=$ELAPSED_LOAD"
echo "BENCHMARK_CITIES=$ELAPSED_CITIES"
echo "BENCHMARK_INDEX=$ELAPSED_INDEX"
exit $OVERALL_EXIT_CODE