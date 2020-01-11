#!/bin/bash

INITDB_ROOT_NAME=${MONGO_INITDB_ROOT_USERNAME}
INITDB_ROOT_PASS=${MONGO_INITDB_ROOT_PASSWORD}

RS_SHARD_NAME=$1
RS_SHARD_PORT=$2
SHARD_NAME=$3
RS_SHARD_COUNT=$4

MONGO_INITIALIZED_PLACEHOLDER=".mongo_rs_shard_initialized_"$RS_SHARD_NAME

if [ -f $MONGO_INITIALIZED_PLACEHOLDER ]; then
  echo "INFO: $RS_SHARD_NAME ALREADY INITIALIZED"
  exit 0 # Already initialized
else
  echo "INITIALIZATION RS_SHARD: $RS_SHARD_NAME"

  echo "DEBUG: RS_SHARD_NAME  = $RS_SHARD_NAME"
  echo "DEBUG: RS_SHARD_PORT  = $RS_SHARD_PORT"
  echo "DEBUG: SHARD_NAME     = $SHARD_NAME"
  echo "DEBUG: RS_SHARD_COUNT = $RS_SHARD_COUNT"

  SHARDS_STR=""
  for i in $(seq 1 $RS_SHARD_COUNT); do
    if [ $i -eq 1 ]; then # empty string
      SHARDS_STR="{_id: $i, host: \"${SHARD_NAME}_$i:$RS_SHARD_PORT\"}"
    else
      SHARDS_STR="$SHARDS_STR, {_id: $i, host: \"${SHARD_NAME}_$i:$RS_SHARD_PORT\"}"
    fi
  done

  RS_SHARD_CONTAINER="$SHARD_NAME""_1" # we connect to the container

  echo "DEBUG: $RS_SHARD_CONTAINER:$RS_SHARD_PORT rs.initiate({_id: \"$RS_SHARD_NAME\", members: [$SHARDS_STR]})"
  mongo --host $RS_SHARD_CONTAINER --port $RS_SHARD_PORT -u $INITDB_ROOT_NAME -p $INITDB_ROOT_PASS <<< "rs.initiate({_id: \"$RS_SHARD_NAME\", members: [$SHARDS_STR]})"

  if [ $? -eq 0 ]; then
    touch $MONGO_INITIALIZED_PLACEHOLDER
    echo "SUCCESS RS_SHARD: $RS_SHARD_NAME INITIALIZED"
    exit 0
  else
    echo "ERROR RS_SHARD: $RS_SHARD_NAME NOT INITIALIZED!!!"
    exit 1
  fi
fi

