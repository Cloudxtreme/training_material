# Simple Search 2.0 Setup

##### Create an index

```
curl -i -XPUT http://localhost:8098/search/index/my_index
```

##### Link the index to a bucket

```
curl -XPUT \
  -H 'content-type: application/json' \
  -d '{"props":{"search_index":"my_index"}}' \
  http://localhost:8098/buckets/people/props
```

##### Add data

```
curl -XPUT \
  -H "Content-Type: application/json" \
  -d '{"myfield_s": "this is a test", "phone_s": "555-555-5555"}' \
  http://localhost:8098/buckets/people/keys/person1
```

##### Search for data

```
curl 'http://localhost:8098/search/query/my_index?wt=json&q=phone_s:555-555-5555'
```

# Advanced (with custom schema)

##### Create Schema

(Based on default Yokozuna Solr Schema with our own field definitions, the default schema can be found here: [https://raw.githubusercontent.com/basho/yokozuna/develop/priv/default_schema.xml](https://raw.githubusercontent.com/basho/yokozuna/develop/priv/default_schema.xml))

Create a `my_schema.xml` based on the default schema:

```
...
<field name="phone" type="string" indexed="true" stored="true" multiValued="false"/>
<field name="myfield" type="string" indexed="true" stored="true" multiValued="false"/>
...
```

```
curl -XPUT "http://localhost:8098/search/schema/my_schema" \
  -H 'content-type:application/xml' \
  --data-binary @my_schema.xml
```

##### Create a search index using your schema

```
curl -XPUT "http://localhost:8098/search/index/my_index" \
     -H'content-type:application/json' \
     -d'{"schema":"my_schema"}'
```

##### Create a bucket type so that multiple buckets can share an index

```
riak-admin bucket-type create my_type '{"props":{"search_index":"my_index"}}'
riak-admin bucket-type activate my_type
```

##### Add data

```
curl -XPUT \
  -H "Content-Type: application/json" \
  -d '{"myfield": "this is a test", "phone": "555-555-5555"}' \
  http://localhost:8098/types/my_type/buckets/people/keys/person1
```

##### Search for data

```
curl 'http://localhost:8098/search/query/my_index?wt=json&q=phone:555-555-5555'
```

# Indexing Map and Set Datatypes

##### Create Schema

(Based on default Yokozuna Solr Schema with our own field definitions, the default schema can be found here: [https://raw.githubusercontent.com/basho/yokozuna/develop/priv/default_schema.xml](https://raw.githubusercontent.com/basho/yokozuna/develop/priv/default_schema.xml))

Create a `my_schema.xml` based on the default schema:

```
...
<field name="contacts_set" type="string" indexed="true" stored="true" multiValued="false"/>
<field name="phone_register" type="string" indexed="true" stored="true" multiValued="false"/>
<field name="age_register" type="int"    indexed="true"  stored="true"  multiValued="false"/>
...
```

Note that all map values (such as strings, integers, dates, etc) are named as _register when they get to Solr. All registers can only be represented as strings, so in order to make Solr treat them as something else (like an integer), they need to have their own fields in a custom schema.

```
curl -XPUT "http://localhost:8098/search/schema/my_schema" \
  -H 'content-type:application/xml' \
  --data-binary @my_schema.xml
```

##### Create a search index using your schema

```
curl -XPUT "http://localhost:8098/search/index/my_index" \
     -H'content-type:application/json' \
     -d'{"schema":"my_schema"}'
```

##### Create a bucket type so that multiple buckets can share an index as well as be treated as CRDT Maps

```
riak-admin bucket-type create my_type '{"props":{"search_index":"my_index","datatype":"map"}}'
riak-admin bucket-type activate my_type
```

##### Add data

```
curl -XPOST http://localhost:8098/types/my_type/buckets/people/datatypes/person1 \
  -H "Content-Type: application/json" \
  -d '
  {
    "update": {
      "phone_register": "555-555-5555",
      "age_register": "25",
      "contacts_set": {
        "add_all": [
          "luc",
          "drew",
          "piotr"
        ]
      }
    }
  }'
```

##### Search for data

```
curl 'http://localhost:8098/search/query/my_index?wt=json&q=phone_register:555-555-5555'
```