#!/bin/bash

echo '$ curl -v
http://127.0.0.1:8098/buckets/training/keys/my-first-object -X DELETE'

curl -v http://127.0.0.1:8098/buckets/training/keys/my-first-object -X DELETE

echo -e
