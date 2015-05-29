autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true

![inline](design-assets/Riak-Product-Logos/eps/riak-logo-color.eps)

# Yokozuna and CRDT example

---

# Overview 



---


# Objectives



---

# Prerequisites

* Machine with 8GB RAM (and most of that free)
* A 'devrel' installation of Riak 2.1+ with 3 available nodes

---

# Global Variables

Set a variable defining the Riak hostname and HTTP port number

```
export RIAK=localhost:10018
```

---

## Perform some cleanup (part 1)!

    for i in 1 2 3
        do ./dev$i/bin/riak stop 
        rm -rf ./dev$i/data
    done

---

### Perform some setup 

    vi ./dev[123]/etc/riak.conf

    search = on
    anti_entropy = active
    anti_entropy.concurrency_limit = 2
    anti_entropy.tree.build_limit.number = 2
    anti_entropy.tree.build_limit.per_timespan = 1h

---

# Join up a fresh cluster

    for i in 1 2 3
        do ./dev$i/bin/riak start
    done

    ./dev1/bin/riak-admin cluster join dev2@127.0.0.1
    ./dev2/bin/riak-admin cluster join dev3@127.0.0.1
    ./dev3/bin/riak-admin cluster join dev1@127.0.0.1
    ./dev1/bin/riak-admin cluster plan
    ./dev1/bin/riak-admin cluster commit

---


### When running on a slow machine...

```
     WAIT_FOR_ERLANG=120 ./dev1/bin/riak start
```


^ And finally, I'm working on a very slow machine, or perhaps it's this version..

---


# Examine and edit the default schema  

```
    curl $RIAK/search/schema/_yz_default > default.schema.xml
    vim default.schema.xml
```

---
# What's in the (schema) file (1) ?

```xml

<?xml version="1.0" encoding="UTF-8" ?>
<schema name="default" version="1.5">
 <fields>
   <field name="_version_" type="long" indexed="true"
    stored="true"/>
   <field name="text" type="text_general" indexed="true" 
    stored="false" multiValued="true"/>
   <dynamicField name="*_i"  type="int"
    indexed="true"  stored="true"  multiValued="false"/>
   ...
``` 

---

# What's in the (schema) file (2) ?

```xml


<!-- languages -->
 <dynamicField name="*_en" type="text_en" 
    indexed="true" stored="true" multiValued="true"/>
 <dynamicField name="*_ar" type="text_ar" 
    indexed="true" stored="true" multiValued="true"/>
 <dynamicField name="*_bg" type="text_bg" 
    indexed="true" stored="true" multiValued="true"/>

```
---


# Upload a new schema named `example_schema`

```
    curl -XPUT \
    -H 'Content-Type: application/xml' \
    http://$RIAK/search/schema/example_schema \
    --data-binary @default.schema.xml
```

---

# Associate `example_schema` with a new index - `example_index`

```
    curl -XPUT \
    http://$RIAK/search/index/example_index \
    -H 'content-type: application/json' \
    -d '{"schema":"example_schema"}'
```

---

# List existing bucket-types 

```
riak-admin bucket-type list
```

---

# Create a bucket-type to hold map Riak Data Types

```
dev1/bin/riak-admin bucket-type create maps '
    {"props":
        {"datatype":"map", "search_index":"example_index" }
    }'
```

---

# Activate the maps bucket-type

```
riak-admin bucket-type activate maps
```

---

## POST a Riak CRDT update 

```bash

curl -X POST "$RIAK/types/maps/buckets/users/datatypes/binarytemple" \
-H "content-type: application/json" \
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

## Search for the key 'binarytemple' 

```
curl "http://$RIAK/search/query/example_index?q=_yz_rk:\"binarytemple\""
```

^ `_yz_rk` is the indexed field used to index riak objects

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
