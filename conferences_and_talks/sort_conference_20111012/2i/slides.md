!SLIDE bullets incremental

# Secondary Indexes

* Defined as metadata
* Two index types: \_int and \_bin
* Two query types: equal and range
* Input to MapReduce

!SLIDE

# Examples

!SLIDE small

# Store Persons indexed by Team

	@@@ javascript
        for NAME in dan grant sean mark; do
            curl -i http://localhost:8098/riak/person/$NAME \
                 -XPUT \
                 -d "{\"name\":\"${NAME}\"}" \
                 -H 'Content-Type: application/json' \
                 -H 'X-Riak-Index-team_bin: basho'
        done

!SLIDE small

# List Persons by Team

	@@@ javascript
        curl -i $URL/buckets/person/index/team_bin/basho

        HTTP/1.1 200 OK
        Vary: Accept-Encoding
        Server: MochiWeb/1.1 WebMachine/1.9.0 (someone had painted it blue)
        Date: Wed, 12 Oct 2011 06:08:50 GMT
        Content-Type: application/json
        Content-Length: 38

        {"keys":["grant","sean","dan","mark"]}

!SLIDE small

# Store Persons indexed by Nyan Score

	@@@ javascript
        curl -i http://localhost:8098/riak/person/dan \
             -XPUT \
             -d "{\"name\":\"dan\"}" \
             -H 'Content-Type: application/json' \
             -H "X-Riak-Index-nyan_int: 15"

        curl -i http://localhost:8098/riak/person/grant \
             -XPUT \
             -d "{\"name\":\"grant\"}" \
             -H 'Content-Type: application/json' \
             -H "X-Riak-Index-nyan_int: 4"

        curl -i http://localhost:8098/riak/person/sean \
             -XPUT \
             -d "{\"name\":\"sean\"}" \
             -H 'Content-Type: application/json' \
             -H "X-Riak-Index-nyan_int: 98"

        curl -i http://localhost:8098/riak/person/mark \
             -XPUT \
             -d "{\"name\":\"mark\"}" \
             -H 'Content-Type: application/json' \
             -H "X-Riak-Index-nyan_int: 36"

!SLIDE small

# List Persons within Nyan range

	@@@ javascript
        curl -i $URL/buckets/person/index/nyan_int/5/40

        HTTP/1.1 200 OK
        Vary: Accept-Encoding
        Server: MochiWeb/1.1 WebMachine/1.9.0 (someone had painted it blue)
        Date: Wed, 12 Oct 2011 06:34:44 GMT
        Content-Type: application/json
        Content-Length: 23

        {"keys":["dan","mark"]}

!SLIDE small

# MapReduce from Secondary Indexes

	@@@ javascript
        curl -i http://localhost:8098/mapred \
             -XPOST \
             -d '{"inputs":{
                        "bucket":"person",
                        "index":"nyan_int",
                        "start":5,
                        "end":40},
                  "query":[{"map":{
                        "name":"Riak.mapValuesJson",
                        "language":"javascript",
                        "keep":true}}]}'

        HTTP/1.1 200 OK
        Server: MochiWeb/1.1 WebMachine/1.9.0 (someone had painted it blue)
        Date: Wed, 12 Oct 2011 06:42:09 GMT
        Content-Type: application/json
        Content-Length: 32

        [{"name":"dan"},{"name":"mark"}]
