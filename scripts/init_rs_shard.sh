#!/bin/bash

INITDB_ROOT_NAME=${MONGO_INITDB_ROOT_USERNAME}
INITDB_ROOT_PASS=${MONGO_INITDB_ROOT_PASSWORD}

RS_SHARD_NAME=$1
RS_SHARD_PORT=$2
SHARDS=${@:3}
RS_SHARD_CONTAINER=$3 # we connect to the container

MONGO_INITIALIZED_PLACEHOLDER=".mongo_rs_shard_initialized_"$RS_SHARD_NAME

if [ -f $MONGO_INITIALIZED_PLACEHOLDER ]; then
  echo "INFO: $RS_SHARD_NAME ALREADY INITIALIZED"
  exit 0 # Already initialized
else
  echo "INITIALIZATION RS_SHARD: $RS_SHARD_NAME"

  COUNTER=0
  SHARDS_STR=""
  for SHARD in $SHARDS; do
    if [ -z "$SHARDS_STR" ]; then # empty string
      SHARDS_STR="{_id: $COUNTER, host: \"$SHARD:$RS_SHARD_PORT\"}"
    else
      SHARDS_STR="$SHARDS_STR, {_id: $COUNTER, host: \"$SHARD:$RS_SHARD_PORT\"}"
    fi

    COUNTER=$((COUNTER + 1))
  done

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

