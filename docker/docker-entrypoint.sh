#!/bin/bash

set -e

export DOT_dbpath=/mongo/data/$MONGO_ID
export DOT_logpath=/mongo/log/$MONGO_ID/$MONGO_ID.log
export DOT_pidfilepath=/mongo/run/$MONGO_ID/$MONGO_ID.pid

if [ ! -d "$DOT_dbpath" ]; then
  mkdir -p "$DOT_dbpath" "/mongo/run/$MONGO_ID" "/mongo/log/$MONGO_ID"
  chmod 755 "/mongo/run/$MONGO_ID" "/mongo/log/$MONGO_ID" "$DOT_dbpath"
fi

if [ ! -d "$MONGO_CONFIG_DIR" ]; then
  mkdir -p "$MONGO_CONFIG_DIR"
  chmod 755 "$MONGO_CONFIG_DIR"
fi

if [ ! -f "$MONGO_CONFIG_DIR/$MONGO_ID.conf" ]; then
  for VAR in `env`
  do
    if [[ $VAR =~ ^DOT_ ]]; then
      mongo_name=`echo "$VAR" | sed -r "s/DOT_(.*)=.*/\1/g"`
      env_var=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
      echo "$mongo_name=${!env_var}" >> "$MONGO_CONFIG_DIR/$MONGO_ID.conf"
    fi
  done
fi

exec "$@"