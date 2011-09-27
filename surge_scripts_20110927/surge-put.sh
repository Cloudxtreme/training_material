#!/bin/bash

read -p "Enter a key: " -e key
read -p "Enter a value: " -e value
read -p "Enter a write quorum value (default: quorum): " -e w

if [ -z "$w" ]
then
    w="quorum"
fi

echo -e

curl -v -d "$value" -X PUT -H "Content-Type: text/plain" http://127.0.0.1:8091/riak/surge/$key?returnbody=true\&w=$w

echo -e
