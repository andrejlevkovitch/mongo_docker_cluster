#!/bin/bash

INITDB_ROOT_NAME=${MONGO_INITDB_ROOT_USERNAME}
INITDB_ROOT_PASS=${MONGO_INITDB_ROOT_PASSWORD}

ROUTER_CONTAINER=$1 # we connect to the container
ROUTER_PORT=$2
RS_SHARD_NAME=$3
RS_SHARD_PORT=$4
SHARDS=${@:5}

MONGO_INITIALIZED_PLACEHOLDER=".mongo_rs_shard_added_"$RS_SHARD_NAME

if [ -f $MONGO_INITIALIZED_PLACEHOLDER ]; then
  echo "INFO: $RS_SHARD_NAME ALREADY ADDED"
  exit 0 # Already initialized
else
  echo "ADD SHARD: $RS_SHARD_NAME"

  SHARD_STR=""
  for SHARD in $SHARDS; do
    if [ -z "$SHARDS_STR" ]; then #empty string
      SHARD_STR="$SHARD:$RS_SHARD_PORT"
    else
      SHARD_STR="$SHARDS_STR,$SHARD:$RS_SHARD_PORT"
    fi
  done

  echo "DEBUG: $ROUTER_CONTAINER:$ROUTER_PORT sh.addShard(\"$RS_SHARD_NAME/$SHARD_STR\")"
  mongo --host $ROUTER_CONTAINER --port $ROUTER_PORT -u $INITDB_ROOT_NAME -p $INITDB_ROOT_PASS <<< "sh.addShard(\"$RS_SHARD_NAME/$SHARD_STR\")"

  if [ $? -eq 0 ]; then
    touch $MONGO_INITIALIZED_PLACEHOLDER
    echo "SUCCESS SHARD: $RS_SHARD_NAME ADDED"
    exit 0
  else
    echo "ERROR SHARD: $RS_SHARD_NAME NOT ADDED!!!"
    exit 1
  fi
fi

