autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true

![inline](design-assets/Riak-Product-Logos/eps/riak-logo-color.eps)

---

![inline](design-assets/Basho-Logos/eps/basho-logo-color-horiz.eps)

---

# Basic Operations

---

# Client Interfaces

* REST Based HTTP Interface
* Protocol Buffers Interface

---

# Clients

* Client libraries supported by Basho:
* Community supported languages and frameworks:
* C/C++, Clojure, Common Lisp, Dart, Django, Go, Grails, Griffon, Groovy, Erlang, Haskell, Java, .NET, Node.js, OCaml , Perl, PHP, Play, Python, Racket, Ruby, Scala, Smalltalk

---

# Bucket Properties


```
curl -X GET http://127.0.0.1:8098/buckets/test/props
{
   "props" : {
      "postcommit" : [],
      "dw" : "quorum",
      "notfound_ok" : true,
      "pr" : 0,
      "precommit" : [],
      "rw" : "quorum",
      "last_write_wins" : false,
      "basic_quorum" : false,
      "allow_mult" : false,
      "name" : "test",
      "pw" : 0,
      "n_val" : 3,
      "w" : "quorum",
      "r" : "quorum"
   }
}
```

^ Bucket properties can be retrieved via HTTP or Protocol Buffers

---

# Bucket Properties (1.4)

* Default bucket properties can be specified in the app.config file:
```
{default_bucket_props, [{n_val,5},{allow_mult,true}]}
```

---

# Bucket Properties (2.x)

* Default bucket properties can be specified in the riak.conf file:

```
buckets.default.allow_mult = false
buckets.default.basic_quorum = false
buckets.default.dw = quorum
buckets.default.last_write_wins = false
buckets.default.merge_strategy = 1
buckets.default.n_val = 3
buckets.default.notfound_ok = true
buckets.default.pr = 0
buckets.default.pw = 0
buckets.default.r = quorum
buckets.default.rw = quorum
buckets.default.w = quorum
```

---

# Bucket Properties (2.x) (continued)

Or using "bucket types"...

```
riak-admin bucket-type <action>
```

*   list                
*   status <type>      
*   activate <type>   
*   create <type> <json> 
*   update <type> <json> 

---

* Bucket properties can be overridden via PB or HTTP interface:

```
curl -X PUT -H "Content-Type: application/json"\
-d '{"props":{"allow_mult":true}}'\
http://127.0.0.1:8098/buckets/test/props
```

---

# HTTP PUT Example

```
$ curl -v -XPUT -d '{"id":456,"firstname":"Bob","lastname":"Smith"}' 
-H "Content-Type: application/json" http://127.0.0.1:8098/buckets/person/keys/456?returnbody=true
* About to connect() to 127.0.0.1 port 8098 (#0)
* ... 
* upload completely sent off: 57 out of 57 bytes
< HTTP/1.1 200 OK
< X-Riak-Vclock: a85hYGBgzGDKBVIcypz/fgZyerzOYEpkzGNlkCloPMWXBQA=
< Vary: Accept-Encoding
< Server: MochiWeb/1.1 WebMachine/1.9.0 (someone had painted it blue)
< Link: </buckets/person>; rel="up"
< Last-Modified: Sat, 02 Feb 2013 11:10:20 GMT
< ETag: "1SEquAcTHEwXLlwcPYeE5Q"
< Date: Sat, 02 Feb 2013 11:10:20 GMT
< Content-Type: application/json
< Content-Length: 57
< 
* Connection #0 to host 127.0.0.1 left intact
{"id":456,"firstname":"Bob","lastname":"Smith"}
```

^ Identify for the audience...
^ Key 
^ Bucket 
^ Value 
^ Content type header 
^ Vector clock header 

---

# HTTP GET Example

```
curl -v -X GET http://127.0.0.1:8098/buckets/person/keys/456
* Connected to 127.0.0.1 (127.0.0.1) port 8098 (#0)
> GET /buckets/person/keys/456 HTTP/1.1
> Host: 127.0.0.1:8098
> Accept: */*
> 
< HTTP/1.1 200 OK
< X-Riak-Vclock: a85hYGBgzGDKBVIcypz/fgZyerzOYEpkzGNlkCloPMWXBQA=
< Vary: Accept-Encoding
< Server: MochiWeb/1.1 WebMachine/1.9.0 (someone had painted it blue)
< Link: </buckets/person>; rel="up"
< Last-Modified: Sat, 02 Feb 2013 11:10:20 GMT
< ETag: "1SEquAcTHEwXLlwcPYeE5Q"
< Date: Sat, 02 Feb 2013 11:34:02 GMT
< Content-Type: application/json
< Content-Length: 57
< 
* Connection #0 to host 127.0.0.1 left intact
{"id":456,"firstname":"Bob","lastname":"Smith"}
```

^Identify for the audience
^Bucket 
^Key 

---

# HTTP UPDATE Example

```
curl -v -X PUT -d '{"id":456,"firstname":"Robert","lastname":"Smith"}' 
-H "Content-Type: application/json" 
-H "X-Riak-Vclock: a85hYGBgzGDKBVIcypz/fgZyerzOYEpkzGNlkCloPMWXBQA=" 
http://127.0.0.1:8098/buckets/person/keys/456
* About to connect() to 127.0.0.1 port 8098 (#0)
* Connected to 127.0.0.1 (127.0.0.1) port 8098 (#0)
> PUT /buckets/person/keys/459 HTTP/1.1
> Host: 127.0.0.1:8098
> Accept: */*
> Content-Type: application/json
> X-Riak-Vclock: a85hYGBgzGDKBVIcypz/fgZyerzOYEpkzGNlkCloPMWXBQA=
> Content-Length: 53
* upload completely sent off: 53 out of 53 bytes
< HTTP/1.1 204 No Content
< Vary: Accept-Encoding
< Server: MochiWeb/1.1 WebMachine/1.9.0 (someone had painted it blue)
< Date: Sat, 02 Feb 2013 11:45:55 GMT
< Content-Type: application/json
< Content-Length: 0
< 
* Closing connection #0
```

^explain the significance of the vector clock

---

# HTTP DELETE Example

```
curl -v -X DELETE http://127.0.0.1:8098/buckets/person/keys/456
* About to connect() to 127.0.0.1 port 8098 (#0)
*   Trying 127.0.0.1...
* connected
* Connected to 127.0.0.1 (127.0.0.1) port 8098 (#0)
> DELETE /buckets/person/keys/460 HTTP/1.1
> User-Agent: curl/7.24.0 (x86_64-apple-darwin12.0) libcurl/7.24.0 OpenSSL/0.9.8r zlib/1.2.5
> Host: 127.0.0.1:8098
> Accept: */*
> 
< HTTP/1.1 204 No Content
< Vary: Accept-Encoding
< Server: MochiWeb/1.1 WebMachine/1.9.0 (someone had painted it blue)
< Date: Sat, 02 Feb 2013 12:03:55 GMT
< Content-Type: application/json
< Content-Length: 0
< 
* Connection #0 to host 127.0.0.1 left intact
* Closing connection
```

^ Delete the record. No vector clock needed.

---

# Tuneable Consistency


R / W / DW / RW

---

# Tuneable Consistency


PR / PW 

---

# Tuneable Consistency


`return_body`
`return_head`

---

# Tuneable Consistency


`notfound_ok`
`basic_quorum`

---

# What are Secondary Indexes?

* Non-primary key lookups
* Defined as object metadata
* Requires sorted backend: Memory or LevelDB
* Document-based partitioning

---

# Direct key access vs Coverage Query


![inline](./basic.operations//coverage-vs-normal-query.png)


^explain the costs involved in carrying out a coverage query

---

# What Can Be Indexed?

* Indexes are metadata, not tied to object data
* Binary indexes (suffixed `_bin`)
* Integer indexes (suffixed `_int`)

---

# Querying Secondary Indexes

* Only one index can be queried
* Exact match query
* Range query
* Supports pagination
* Returns key, optionally index value

---

# Special Indexes

* $key - Key name
* $bucket - Bucket name

---

# Specifying Indexes

```
curl -XPUT -d '{"id":1,"firstname":"Christian","lastname":"Dahlqvist"}' \
-H 'x-riak-index-age_int: 29' -H 'x-riak-index-team_bin: ecse' \
-H "Content-Type: application/json" http://127.0.0.1:8098/buckets/person/keys/1

curl -XPUT -d '{"id":2,"firstname":"Dan","lastname":"Brown"}' \
-H 'x-riak-index-age_int: 32' -H 'x-riak-index-team_bin: cse' \
-H "Content-Type: application/json" http://127.0.0.1:8098/buckets/person/keys/2

curl -XPUT -d '{"id":3,"firstname":"Ciprian","lastname":"Manea"}' \
-H 'x-riak-index-age_int: 41' -H 'x-riak-index-team_bin: cse' \
-H "Content-Type: application/json" http://127.0.0.1:8098/buckets/person/keys/3
```

---

# Exact Match Queries

```
curl 127.0.0.1:8098/buckets/person/index/team_bin/cse
{"keys":["1","2","3"]}

curl 127.0.0.1:8098/buckets/person/index/age_int/41
{"keys":["3"]}
```

---

# Range Queries

```
curl 127.0.0.1:8098/buckets/person/index/team_bin/c/e
{"keys":["1","2,","3"]}

curl 127.0.0.1:8098/buckets/person/index/age_int/29/33
{"keys":["1","2"]}

curl 127.0.0.1:8098/buckets/person/index/team_bin/c/e?return_terms=true
{"results":[{"ecse":"1"},{"cse":"2"},{"cse":"3"}] ]}

curl 127.0.0.1:8098/buckets/person/index/\$key/1/2
{"keys":["1","2"]}
```
---

# Query Options

* Streaming of results
* Limiting number of results returned
* Pagination - Requires sorting of results

---

# Pagination

```
curl 127.0.0.1:8098/buckets/person/index/age_int/20/50?max_results=2
{"keys":["2","3"],"continuation":"g2gCYRNtAAAAATM="}

curl 127.0.0.1:8098/buckets/person/index/age_int/20/50?continuation=g2gCYRNtAAAAATM=&max_results=2
{"keys":["1"]}
```

---

# User Metadata

* Tags (Key-Value string pairs) that can be associated with any object.
* For compatibility with the HTTP interface, user metadata keys should be prefixed with ‘X-Riak-Meta-’.

---

# Listing Keys and Buckets

* *Very* expensive operations, especially bucket listing
* *Do not* use in production
* Always stream data
* Key listing uses secondary indexes if bucket allows

---

# Listing Keys and Buckets

```
curl 127.0.0.1:8098/buckets?buckets=true
{"buckets":["person"]}

curl 127.0.0.1:8098/buckets/person/keys?keys=true
{"keys":["1","3","2"]}
```

