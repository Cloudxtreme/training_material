#!/bin/bash

set +e

for i in {1..4}
do
    dev$i/bin/riak stop
done

echo -e

set -e
