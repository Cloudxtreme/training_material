#!/bin/bash

ulimit -n 1024

for i in {1..4}
do
    echo "dev$i/bin/riak start"
    dev$i/bin/riak start
done

for i in {2..4};
do
    echo "dev$i/bin/riak-admin join dev1"
    dev$i/bin/riak-admin join dev1
done;

echo -e
