# Talking To Riak
*Teaching Notes*

---
######OUTSTANDING ISSUES:

+ very basic
+ some examples of http usage would be good
+ maybe also some examples of client code
+ a PUT in all supported clients?

<br>

## Teaching Goals

+ to introduce the Riak APIs and various client libraries

<br>


## Talking To Riak

###Native APIs
+ HTTP(S): for quick and easy development
+ protocol buffers: for low-latencies in production

###Client Libraries

#####Official (internally developed and supported)
+ Java
	+ https://github.com/basho/riak-java-client
+ Ruby
	+ https://github.com/basho/riak-ruby-client
+ Python
	+ https://github.com/basho/riak-python-client
+ Erlang
	+ https://github.com/basho/riak-erlang-client
+ C#
	+ https://github.com/basho-labs/riak-dotnet-client/tree/master
+ PHP (expected production-ready Q3 2015)
	+ https://github.com/basho/riak-php-client

#####Community (under active development as of Jan 2015)

+ C
	+ https://github.com/trifork/riack
+ C++
	+ https://github.com/ajtack/riak-cpp
+ Clojure
	+ https://github.com/michaelklishin/welle
	+ https://github.com/bluemont/kria
+ Go
	+ https://github.com/riaken
	+ https://github.com/tpjg/goriakpbc
+ Node.js: 
	+ https://github.com/nathanaschbacher/nodiak
	+ https://github.com/nlf/riakpbc
+ Perl
	+ https://metacpan.org/pod/Riak::Light
+ PHP
	+ https://github.com/php-riak/riak-client
	+ https://github.com/php-riak/php_riak
	+ https://github.com/remialvado/RiakBundle
+ Scala
	+ https://github.com/gideondk/Raiku
+ Smalltalk
	+ http://smalltalkhub.com/#!/~gokr/Phriak/
+ plus several supporting Erlang, Python & Ruby projects