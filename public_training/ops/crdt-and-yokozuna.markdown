autoscale:true 
footer: © Basho Technologies, 2015
slidenumbers: true

# Yokozuna and CRDT example

---

# Setup

Define a variable containing the IP address (and port) of the Riak hostname.

```bash


export RIAK=localhost:10018

```

---

If this is not a fresh cluster, it might be nice to get it into a consistent state from the start

---

# Cleanup (step 1)!

```bash
for i in `seq 1 6`;
    do ./dev$i/bin/riak stop ; 
done
```
---

# Cleanup (step 2)!

```bash
for i in `seq 1 6`; 
do 
dev$i/bin/riak stop
rm -rf \
dev$i/data/anti_entropy dev$i/data/ring dev$i/data/bitcask \
dev$i/data/cluster_meta dev$i/data/generated.configs \
dev$i/data/kv_vnode dev$i/data/riak_kv_exchange_fsm \
dev$i/data/riak_repl dev$i/data/yz dev$i/data/yz_anti_entropy ;
done
```

---

# Cleanup (step 3)!

in dev$i/etc/riak.conf ...

```ini
anti_entropy = active
anti_entropy.concurrency_limit = 2
anti_entropy.tree.build_limit.number = 2
anti_entropy.tree.build_limit.per_timespan = 1h
```

---

And finally.. 

```bash
WAIT_FOR_ERLANG=120 ./dev1/bin/riak start
```

^The reason we do this, is because in Riak is configured to crash at startup if Riak takes more than 10 seconds to startup. 
^On a heavily loaded virtual machine, it is entirely possible it will take more that that to start.

---

# Solr schema 

---

Download and examine the default schema 

```bash




curl $RIAK/search/schema/_yz_default \
> default.schema.xml
```

^Lets take a look at a typical Solr schema 
^Open `default.schema.xml` using your favorite editor, and examine the contents.

---

## Schema element types

---

* Static 
* Dynamic 
* Multivalued 
* Ignore
* Yokozuna 
* Riak Data Types 

---

### Static elements

---

Example of Static element...

```xml
<field name="_version_" type="long" indexed="true" stored="true"/>
```

* name - Match on the document element name
* type - How Solr should interpret the value (String, time, Integer)
* indexed - whether the field should be indexed or not
* stored - whether to store the object text

---

### Dynamic elements

```xml
<dynamicField 
 name="*_s"  
 type="string"  
 indexed="true"  
 stored="true" 
 multiValued="false"/>
```

^ name = Wildcard match on any element name suffixed with '_s'

---

### Multivalued dynamic elements

```xml
<dynamicField 
 name="*_ss" 
 type="string"  
 indexed="true"
 stored="true"
 multiValued="true"/>
```

^ multiValued = Consider every sub-element of this element when indexing


---

### Ignore 

```xml
<dynamicField name="*" type="ignored" />
```

--- 

### Yokozuna elements



---

### Riak Data Type elements (default fields)

```xml
<field name="counter" 
       type="int"    
       indexed="true" 
       stored="true" 
       multiValued="false" />
<field name="set"     
       type="string" 
       indexed="true" 
       stored="false" 
       multiValued="true" />
```

---

### Riak Data Type elements

```xml
<dynamicField name="*_flag"     
              type="boolean" 
              indexed="true" 
              stored="true" 
              multiValued="false" />
```

---

```xml
<dynamicField name="*_counter"  
              type="int"
              indexed="true"
              stored="true" 
              multiValued="false" />
```

---

```xml
<dynamicField name="*_register" 
              type="string"  
              indexed="true" 
              stored="true" 
              multiValued="false" />
```

---

```xml
<dynamicField name="*_set"      
              type="string"  
              indexed="true" 
              stored="false" 
              multiValued="true" />
```

---

# Create a new schema 

Create a scheme named : `example_schema`

```bash

curl -XPUT \
-H 'Content-Type: application/xml' \
http://$RIAK/search/schema/example_schema \
--data-binary @default.schema.xml
```

---

# Associate the schema 

Associate `example_schema` with `example_index`

```bash

curl -i  \
-XPUT http://$RIAK/search/index/example_index \
-H 'content-type: application/json' \
-d '{"schema":"example_schema"}'
```

---

# List existing bucket-types 

```bash
dev1/bin/riak-admin bucket-type list
```

---

# Create a maps bucket-type

```bash
dev1/bin/riak-admin bucket-type create maps \
'{"props":{"datatype":"map", "search_index":"example_index" }}'
```

---

# Activate the maps bucket-type

```bash
dev1/bin/riak-admin bucket-type activate maps
```

---

# Update a CRDT within the bucket-type

```bash
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
}
'
```

---

Search for every field in the Yokozuna index (wildcard)

```bash
curl 'http://$RIAK/search/query/example_index?q=_yz_rk:"baz"'
```

---

Search for the every item matching the key 'baz' 

```bash
curl 'http://$RIAK/search/query/example_index?q=_yz_rk:"baz"'
```

---

Search for every item in the `fooz` bucket

```bash
curl 'http://$RIAK/search/query/example_index?q=_yz_rb:"fooz"'
```

---

Insert another item

```bash
curl -X POST $RIAK/types/maps/buckets/fooz/datatypes/baz2 \
-H"content-type: application/json"  \
-d '{"update":{"age_counter": 39, "foo_set" : { "add_all" : [ "java","erlang" ] }}}'
```

And query for all items in the `fooz` bucket again

```bash
curl 'http://$RIAK/search/query/example_index?q=_yz_rb:"fooz"'
```

---
Get the id’s of all the items in the ‘posts' bucket

```bash
curl -X GET "localhost:8098/types/maps/buckets/fooz/keys?keys=true”
```
---

*WARNING* - Don't send this to /dev/std\* it returns a nasty binary blob 

```bash
curl -X GET "$RIAK/types/maps/buckets/fooz/keys/baz2" | less
```

---

Lets see a nice JSON representation instead

```
curl -X GET "$RIAK/types/maps/buckets/fooz/datatypes/baz2”
```


