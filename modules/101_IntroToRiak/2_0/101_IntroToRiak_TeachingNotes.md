# Intro to Riak
*Teaching Notes*

---
######OUTSTANDING ISSUES:

+ too many features?
+ too much detail for 20 minutes, indigestible?

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
+ duplicates data to a configurable number of partitions around the ring
+ improves availability under node failure or heavy load
+ allows the cluster to tolerate permanent node failure without data loss

###multi-data-center replication
+ replicate data to additional clusters, either locally or globally
+ make data globally available
+ full-cluster failover for industry-leading fault tolerance and disaster recovery
+ tune different clusters for different workloads to get ultra low-latency and efficient operation at enterprise scale

###sloppy quorum
+ a secondary node is used for operations if a primary node is down
+ keeps your data highly available even under multi-node failure conditions

###hinted handoff
+ hands partitions on secondaries back to primaries when they come back up
+ makes the database self-heal, further improving fault tolerance

###ownership handoff
+ partitions are automatically moved between nodes as node count changes
+ happens in a balanced way
+ makes scaling up and down easy

###buckets & bucket types
+ allows grouping of configurations
+ makes setup & operation of complex environments much simpler

###conflict resolution
+ let the application handle inconsistency externally, or adopt one of several internal resolution strategies
+ sliding scale between simplicity and power

###read repair (passive anti-entropy)
+ repairs stale replicas on read
+ efficient self healing mechanism for medium-term fault tolerance
+ no manual repair work required by operators

###active anti-entropy
+ repairs stale replicas in the background, solving the data-never-read problem
+ provides long-term (forever) fault tolerance
+ further reduces operational pain since regular repairs are not necessary

###pluggable storage backends
+ different storage characteristics to suit different access patterns
+ helps to optimize for low-latency to the maximum degree possible per use-case
	
###secondary indexing
+ retrieve groups of objects by shared tags instead of by primary key
+ atomic local writes (object + index to same partition) keep complexity down and latency low

###search
+ use the Apache Solr interface to find anything, anytime
+ one line command to link a bucket to an index

###map-reduce
+ write powerful jobs directly in code to support analytics clusters
+ simply use a terminal to attach directly to a running node and execute the job or snippet

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