# Intro to Riak
*Teaching Notes*

---
######WORK IN PROGRESS:

+ how/why is Riak simple to operate?
+ too many features listed
+ each feature should be described in one sentence
+ each feature should justify its existence in terms of the core story

<br>

## Teaching Goals

+ to state and justify Riak's most important unique selling point
+ to tell Riak's core story
+ to describe Riak's basic structure
+ to present an overview of Riak's features, explaining how each one supports the core story
+ to show how applications interface with Riak, with reference to the two APIs and various client libraries

<br>


##What is Riak?

+ the ops-friendly database
+ I want an ops-friendly database because:
	+ the vast majority of the cost of a database is in operational support over its lifetime
	+ the dangerous failures are the unexpected ones that only appear once the database is operating in a production environment

<br>

##Core Story

+ simple to operate
+ highly available
+ fault tolerant
+ horizontally scalable
+ low-latency (order of milliseconds)

Also:
+ serviced (by Basho)
+ supported (by the community)

<br>

##Foundations

###key-value storage protocol

+ when you PUT a blob of data into Riak, you do so with a unique string of characters; this is called the **key**
+ you can GET that same blob of data back later on by telling Riak what the key is
+ this is not a relational database; there are no schemas to worry about 
+ riak is value-agnostic, so you can put whatever kind of data you want in your blobs

###distributed storage location

+ in any system, one node can always fail
+ in Riak, data is stored in clusters of nodes
+ each node sits on its own computer (or virtual machine)

This basic structure is the foundation of Riak. Next, we'll take a brief overview of Riak's features, noting how they take advantage of this foundation to deliver on its core story.

<br>

##Feature Overview

###the ring
+ inspired by Amazon's 2007 Dynamo Paper
+ running a key through a consistent hash function gives you an address that tells you where your data should go
+ this permits:
	+ one-hop request routing for speed
	+ masterless operation for fault tolerance
	+ concurrent operations across all nodes in the cluster for linear performance increase when scaling

###replication
+ duplicates data to extra partitions around the ring
+ configurable number of replicas (n-val)
+ configurable read & write quorum (r, w, pr, pw, dw)
+ makes your data as highly available as you want it to be

###sloppy quorum
+ a secondary node is used for operations if a primary node in the preflist is down
+ keeps your data available even under failure conditions
+ this is fault tolerance

###hinted handoff
+ hands partitions on secondaries back to primaries when they come back up
+ makes the database self-heal, further improving fault tolerance

###ownership handoff
+ partitions are automatically moved between nodes as node count changes
+ happens in a balanced way
+ makes scaling up and down easy

###buckets
+ for grouping configurations
+ [how is this part of the story?]

###conflict resolution
+ via last write wins
+ or logical clocks
+ optionally assisted data types
+ or in-application via siblings
+ [how is this part of the story?]

###read repair (passive anti-entropy)
+ [what is this?]
+ [how is this part of the story?]

###active anti-entropy
+ [what is this?]
+ [how is this part of the story?]

###pluggable storage backends
+ [what is this?]
+ [how is this part of the story?]
	
###indexing
+ [what is this?]
+ [how is this part of the story?]

###search
+ Solr
+ [what is this?]
+ [how is this part of the story?]

###map-reduce
+ [what is this?]
+ [how is this part of the story?]

###multi-data-center replication
+ [what is this?]
+ [how is this part of the story?]

<br>

## Talking To Riak

###Native APIs
+ protocol buffers
+ HTTP(S)

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
+ PHP (expected production-ready Q2 2015)
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