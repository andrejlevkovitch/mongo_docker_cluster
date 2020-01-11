#!/bin/bash
# XXX you can not scale router, because you need sett different host ports for it
# XXX if you want to add some shard replica set, then you have to add new service instance to compse yml file


COMPOSE_FILE="mongo_cluster.yml"
ENV_FILE="environment.env"
MONGO_KEYFILE="resources/mongo-keyfile"

if [ ! -f $MONGO_KEYFILE ]; then
  echo "$MONGO_KEYFILE not exists. Did you forget about generate_keyfile.sh?"
  exit 1
fi

if [ ! -f $ENV_FILE ]; then
  echo "$ENV_FILE not exists. Copy template.env to ${ENV_FILE}."
  exit 1
fi


source $ENV_FILE
export $(cut -d= -f1 $ENV_FILE)

docker-compose -f $COMPOSE_FILE up --scale config=$CONFIG_COUNT --scale rs0shard=$RS0SHARD_COUNT --scale rs1shard=$RS1SHARD_COUNT
