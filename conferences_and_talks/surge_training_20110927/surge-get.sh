#!/bin/bash

read -p "Enter a key: " -e key
read -p "Enter a read quorum value (default: quorum): " -e r

if [ -z "$r" ]
then
    r="quorum"
fi

echo -e

curl -v http://127.0.0.1:8091/riak/surge/$key?r=$r

echo -e
