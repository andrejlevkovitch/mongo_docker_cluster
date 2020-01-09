#!/bin/bash

KEYFILE_DIR="./keyfile"
MONGO_KEYFILE="$KEYFILE_DIR/mongo-keyfile"

MONGO_UID=999
MONGO_GID=999

if [ $EUID -eq 0 ]; then # XXX need superuser rights
  if [ -f $MONGO_KEYFILE ]; then
    echo "$MONGO_KEYFILE already exists"
    exit 1
  else
    mkdir $KEYFILE_DIR
    openssl rand -base64 756 > $MONGO_KEYFILE
    chmod 400 $MONGO_KEYFILE
    chown $MONGO_UID:$MONGO_GID $MONGO_KEYFILE
  fi
else
  echo "FAILED: START THE SCRIPT WITH SUPERUSER RIGHTS"
  exit 1
fi
