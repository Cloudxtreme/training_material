!SLIDE

# Using Riak

!SLIDE bullets incremental

# Interfaces

* HTTP
* Protocol Buffers

!SLIDE bullets incremental

# Data Model

* Bucket
* Key
* Object

!SLIDE bullets incremental

# Object

* Metadata
* Value

!SLIDE

# Examples

!SLIDE small

	@@@ javascript
	curl -i http://localhost:8098/riak/person/dan

	HTTP/1.1 404 Object Not Found
	Server: MochiWeb/1.1 WebMachine/1.9.0 (someone had painted it blue)
	Date: Tue, 11 Oct 2011 18:57:07 GMT
	Content-Type: text/plain
	Content-Length: 10

	not found

!SLIDE small

	@@@ javascript
    curl -i http://localhost:8098/riak/person/dan \
     -XPUT \
     -d '{"todos":["foo"]}' \
     -H 'Content-Type: application/json'

    HTTP/1.1 204 No Content
    Vary: Accept-Encoding
    Server: MochiWeb/1.1 WebMachine/1.9.0 (someone had painted it blue)
    Date: Tue, 11 Oct 2011 18:59:20 GMT
    Content-Type: application/json
    Content-Length: 0

!SLIDE small

	@@@ javascript
    curl -i http://localhost:8098/riak/person/dan

    HTTP/1.1 200 OK
    X-Riak-Vclock: a85hYGBgzGDKBVIcypz/fvpNmdiUwZTImMfKwMHHeYIvCwA=
    Vary: Accept-Encoding
    Server: MochiWeb/1.1 WebMachine/1.9.0 (someone had painted it blue)
    Link: </riak/person>; rel="up"
    Last-Modified: Tue, 11 Oct 2011 18:59:20 GMT
    ETag: "7NgrhdvqHLRerwz2iV85YW"
    Date: Tue, 11 Oct 2011 19:00:37 GMT
    Content-Type: application/json
    Content-Length: 17

    {"todos":["foo"]}

!SLIDE bullets incremental

# Metadata

* X-Riak-Vclock
* Link
* X-Riak-Index-*

.notes let's talk about metadata
