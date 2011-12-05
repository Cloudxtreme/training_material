#!/bin/bash

read -p "Enter the number of objects to create: " -e count
prefix="surgeobj"

for ((i=1; i <= $count; i++))
do
    curl -X PUT \
        -v -H "Content-Type: application/json" \
        -H "X-Riak-Index-${prefix}_int: $i" \
        -d "{\"$prefix\":$i}" \
        http://localhost:8091/riak/surge/$prefix$i?returnbody=true
done
