#!/bin/bash

read -p "Enter the origin key: " -e origin
read -p "Enter the target key: " -e target
read -p "Enter the link's tag: " -e tag

echo "*** Storing the origin ***"
curl -X PUT \
  -v -H "Content-Type: text/plain" -d "origin" \
  -H "Link: </riak/surge/$target>;riaktag=\"$tag\"" \
  http://localhost:8091/riak/surge/$origin

echo -e

echo "*** Storing the target ***"
curl -X PUT \
  -v -H "Content-Type: text/plain" -d "target" \
  http://localhost:8091/riak/surge/$target

echo -e
