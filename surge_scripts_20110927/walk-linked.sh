#!/bin/bash

read -p "Enter the origin key: " -e origin
read -p "Enter the link spec (default: _,_,_): " -e spec

echo -e

if [ -z "$spec" ]
then
  spec="_,_,_"
fi

curl -v http://localhost:8091/riak/surge/$origin/$spec

echo -e
