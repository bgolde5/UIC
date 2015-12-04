#!/bin/bash

n=$1
i=0;
while [ $i -lt $n ]; do
  wget http://localhost:8888/test/dir/endtoend.pdf>/dev/null 2>&1
  wget http://localhost:8888/test/dir/index.html>/dev/null 2>&1
  let i=i+1;
done
