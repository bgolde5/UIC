#!/bin/bash

# to run: $ bash <ip> <port>

host=$1
port=$2

while read LINE; do
  if [ ! ${LINE:0:1} == "#" ]
  then
    curl -o /dev/null --silent --get --write-out '%{http_code}' "$host:$port/$LINE"
    echo " $LINE"
  else
    echo " $LINE"
  fi
done < url-list.txt