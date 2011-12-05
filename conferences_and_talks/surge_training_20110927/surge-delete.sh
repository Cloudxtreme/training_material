#!/bin/bash

read -p "Type a key: " -e key

echo -e

curl -v -X DELETE http://127.0.0.1:8091/riak/surge/$key

echo -e
