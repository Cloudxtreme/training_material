!SLIDE bullets incremental

# Vector Clocks

* Track the history of an object
* Automatically resolve stale versions
* Let clients resolve conflicts later

.notes similar to a version control system

!SLIDE bullets incremental

# Replicated Shopping Cart

* Two copies on separate machines
* Fault tolerant
* Always available

!SLIDE bullets incremental

# Conflict Resolution Strategies

* Leader Election
* Timestamp
* Vector Clock (Riak)

!SLIDE

# Leader Election

!SLIDE bullets

* Normal operation

!SLIDE bullets

* one: foo, bar
* two: foo, bar

!SLIDE bullets

* add "baz"

!SLIDE bullets

* one: foo, bar, baz
* two: foo, bar

!SLIDE bullets

* one: foo, bar, baz
* two: foo, bar, baz

!SLIDE

# OK

!SLIDE bullets

* Network partition
* Update leader

!SLIDE bullets

* one: foo, bar
* ---
* two: foo, bar

!SLIDE bullets

* add "baz"
* ---

!SLIDE bullets

* one: foo, bar, baz
* ---
* two: foo, bar

!SLIDE bullets

* one: foo, bar, baz
* two: foo, bar

!SLIDE bullets

* one: foo, bar, baz
* two: foo, bar, baz

!SLIDE

# OK

!SLIDE bullets

* Network partition
* Update non-leader

!SLIDE bullets

* one: foo, bar
* ---
* two: foo, bar

!SLIDE bullets

* ---
* add "baz"

!SLIDE

# UNAVAILABLE

!SLIDE

# Timestamp

!SLIDE bullets

* Normal operation

!SLIDE bullets

* one [1:00]: foo, bar
* two [1:00]: foo, bar

!SLIDE bullets

* add "baz"

!SLIDE bullets

* one [1:01]: foo, bar, baz
* two [1:00]: foo, bar

!SLIDE bullets

* one [1:01]: foo, bar, baz
* two [1:01]: foo, bar, baz

!SLIDE

# OK

!SLIDE bullets

* Network partition

!SLIDE bullets

* one [1:00]: foo, bar
* ---
* two [1:00]: foo, bar

!SLIDE bullets

* add "baz"
* ---

!SLIDE bullets

* one [1:01]: foo, bar, baz
* ---
* two [1:00]: foo, bar

!SLIDE bullets

* one [1:01]: foo, bar, baz
* two [1:00]: foo, bar

!SLIDE bullets

* one [1:01]: foo, bar, baz
* two [1:01]: foo, bar, baz

!SLIDE

# OK

!SLIDE bullets

* Network partition with clock skew

!SLIDE bullets

* one [1:00]: foo, bar
* ---
* two [1:05]: foo, bar

!SLIDE bullets

* add "baz"
* ---

!SLIDE bullets

* one [1:01]: foo, bar, baz
* ---
* two [1:05]: foo, bar

!SLIDE bullets

* one [1:02]: foo, bar
* two [1:05]: foo, bar

!SLIDE

# LOST baz

!SLIDE bullets

* Network partition with updates on both sides

!SLIDE bullets

* one [1:00]: foo, bar
* ---
* two [1:00]: foo, bar

!SLIDE bullets

* add "baz"
* ---

!SLIDE bullets

* one [1:01]: foo, bar, baz
* ---
* two [1:00]: foo, bar

!SLIDE bullets

* ---
* add "qux"

!SLIDE bullets

* one [1:01]: foo, bar, baz
* ---
* two [1:02]: foo, bar, qux

!SLIDE bullets

* one [1:02]: foo, bar, qux
* two [1:02]: foo, bar, qux

!SLIDE

# LOST baz

!SLIDE

# Vector Clock

!SLIDE bullets

* Normal operation

!SLIDE bullets

* one [o1]: foo, bar
* two [o1]: foo, bar

!SLIDE bullets

* add "baz"

!SLIDE bullets

* one [o2]: foo, bar, baz
* two [o1]: foo, bar

!SLIDE bullets

* one [o2]: foo, bar, baz
* two [o2]: foo, bar, baz

!SLIDE

# OK

!SLIDE bullets

* Network partition

!SLIDE bullets

* one [o1]: foo, bar
* ---
* two [o1]: foo, bar

!SLIDE bullets

* add "baz"
* ---

!SLIDE bullets

* one [o2]: foo, bar, baz
* ---
* two [o1]: foo, bar

!SLIDE bullets

* one [o2]: foo, bar, baz
* two [o1]: foo, bar

!SLIDE bullets

* one [o2]: foo, bar, baz
* two [o2]: foo, bar, baz

!SLIDE

# OK

!SLIDE bullets

* Network partition with clock skew

!SLIDE bullets

* one [o1]: foo, bar
* ---
* two [o1]: foo, bar

!SLIDE bullets

* add "baz"
* ---

!SLIDE bullets

* one [o2]: foo, bar, baz
* ---
* two [o1]: foo, bar

!SLIDE bullets

* one [o2]: foo, bar, baz
* two [o2]: foo, bar, baz

!SLIDE

# OK

!SLIDE bullets

* Network partition with updates on both sides

!SLIDE bullets

* one [o1]: foo, bar
* ---
* two [o1]: foo, bar

!SLIDE bullets

* add "baz"
* ---

!SLIDE bullets

* one [o2]: foo, bar, baz
* ---
* two [o1]: foo, bar

!SLIDE bullets

* ---
* add "qux"

!SLIDE bullets

* one [o2]: foo, bar, baz
* ---
* two [o1t1]: foo, bar, qux

!SLIDE bullets

* one [o2, o1t1]: foo, bar, baz; foo, bar, qux
* two [o2, o1t1]: foo, bar, baz; foo, bar, qux

!SLIDE

# SIBLINGS

!SLIDE bullets incremental

# Using Vector Clocks

* Include X-Riak-Vclock with PUT and DELETE

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

!SLIDE bullets smaller

# Vector Clock

* a85hYGBgzGDKBVIcypz/fvpNmdiUwZTImMfKwMHHeYIvCwA=

!SLIDE small

	@@@ javascript
    curl -i http://localhost:8098/riak/person/dan \
     -XPUT \
     -d '{"todos":["foo, bar"]}' \
     -H 'Content-Type: application/json'
     -H 'X-Riak-Vclock: a85hYGBgzGDKBVIcypz/fvpNmdiUwZTImMfKwMHHeYIvCwA='

    HTTP/1.1 204 No Content
    Vary: Accept-Encoding
    Server: MochiWeb/1.1 WebMachine/1.9.0 (someone had painted it blue)
    Date: Tue, 11 Oct 2011 18:59:20 GMT
    Content-Type: application/json
    Content-Length: 0
