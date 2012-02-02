#!/bin/bash

echo '$ curl -v http://127.0.0.1:8098/buckets/training/keys/my-first-object -X PUT -H "content-type: text/plain" -d "My first key"'

curl -v http://127.0.0.1:8098/buckets/training/keys/my-first-object -X PUT -H "content-type: text/plain" -d "My first key"

echo -e
