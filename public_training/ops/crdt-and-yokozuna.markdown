autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true

![inline](design-assets/Riak-Product-Logos/eps/riak-logo-color.eps)

# Yokozuna and CRDT example

---

# Overview 

* Objectives 
* Prerequisites
* Quick overview of steps involved

---


# Global Variables

## Set a variable defining the Riak hostname.

```
export RIAK=localhost:10018
```

---


## Perform some cleanup (part 1)!

```
for i in `seq 1 6`
    do ./dev$i/bin/riak stop 
done

for i in `seq 1 2`
    do 
    rm -rf ./dev$i/data
    ./dev$i/bin/riak start
done

./dev1/bin/riak-admin cluster join dev2@127.0.0.1
./dev1/bin/riak-admin cluster plan
./dev1/bin/riak-admin cluster commit
sleep 5

#TODO: FIX THIS MATCH !!!!
while $(./dev1/bin/riak-admin transfers | egrep "(waiting)" ); do echo waiting; sleep 1; done 



---

### Perform some cleanup (part 2)!

```
for i in `seq 1 6`; 
    do rm -rf \
    dev$i/data/anti_entropy dev$i/data/ring dev$i/data/bitcask \
    dev$i/data/cluster_meta dev$i/data/generated.configs \
    dev$i/data/kv_vnode dev$i/data/riak_kv_exchange_fsm \
    dev$i/data/riak_repl dev$i/data/yz dev$i/data/yz_anti_entropy ;
done
```

---

### Perform some cleanup (part 3)!

>>> Not done yet! In dev$i/etc/riak.conf ...

```
vi ./dev[12]/etc/riak.conf
```

```  
     search = on
     anti_entropy = active
     anti_entropy.concurrency_limit = 2
     anti_entropy.tree.build_limit.number = 2
     anti_entropy.tree.build_limit.per_timespan = 1h
```

---

### And finally, I'm working on a very slow machine, or perhaps it's this version..

```
     WAIT_FOR_ERLANG=120 ./dev1/bin/riak start
```

---


# Examine the default schema  

```
    curl $RIAK/search/schema/_yz_default \
    > default.schema.xml
    vim default.schema.xml
```
---

# Create a new schema named `example_schema`

```
    curl -XPUT \
    -H 'Content-Type: application/xml' \
    http://$RIAK/search/schema/example_schema \
    --data-binary @default.schema.xml
```

---

# Associate `example_schema` with a new index, `example_index`

```
    curl -XPUT \
    http://$RIAK/search/index/example_index \
    -H 'content-type: application/json' \
    -d '{"schema":"example_schema"}'
```

---

# List existing bucket-types 

```
    dev1/bin/riak-admin bucket-type list
```

---

# Create a bucket-type to hold map Riak Data Types

```
    dev1/bin/riak-admin bucket-type create maps \
    '{"props":
        {"datatype":"map", "search_index":"example_index" }
    }'
```

---

# Activate the maps bucket-type

```
    dev1/bin/riak-admin bucket-type activate maps
```

---

## POST a Riak CRDT update into the bucket-type

```
    curl -X POST $RIAK/types/maps/buckets/fooz/datatypes/baz \
    -H"content-type: application/json" \
    -d '
    {
       "update" : {
          "blah_counter" : 1,
          "foo_set" : {
             "add_all" : [
                "1"
             ]
          },
          "stone_counter" : 50,
          "gold_counter" : 100
       }
    }'
```

---

## Search for every field in the Yokozuna index (wildcard)

```
    curl 'http://$RIAK/search/query/example_index?q=_yz_rk:"baz"'
```

---

## Search for the every item matching the key 'baz' 

```
    curl 'http://$RIAK/search/query/example_index?q=_yz_rk:"baz"'
```

---

## Search for every item in the `fooz` bucket

```
    curl 'http://$RIAK/search/query/example_index?q=_yz_rb:"fooz"'
```

---

## Insert another item

```
    curl \
    -X POST $RIAK/types/maps/buckets/fooz/datatypes/baz2 \
    -H"content-type: application/json"  \
    -d '{
        "update":{
           "age_counter": 39, 
           "foo_set" : { "add_all" : [ "java","erlang" ] }}
       }'
```

---

## Query for all items in the `fooz` bucket again

```
curl 'http://$RIAK/search/query/example_index?q=_yz_rb:"fooz"'
```

---

## Fetch the id’s of all the items in the ‘posts' bucket

```
curl -X GET "localhost:8098/types/maps/buckets/fooz/keys?keys=true”
```
---

### *WARNING don't send to console* This produces a binary blob

## >>> curl -X GET "$RIAK/types/maps/buckets/fooz/keys/baz2" | less

---

## But this request gives me a nice JSON representation

```
curl -X GET "$RIAK/types/maps/buckets/fooz/datatypes/baz2”
```
