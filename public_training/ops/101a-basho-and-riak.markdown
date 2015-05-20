autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true

![inline](design-assets/Riak-Product-Logos/eps/riak-logo-color.eps)

---

![inline](design-assets/Basho-Logos/eps/basho-logo-color-horiz.eps)

---

# Basho & Riak

---

# About Basho

^Who are basho? The creators and developers of Riak & Riak CS. Founded in 2008 by ex-Akamai staff. Experts in distributed systems. Offices across the USA, EMEA & Japan. Providing Professional Services, Customer Support. 

---

# About Riak

^What is Riak? At it’s heart Riak is a fast, reliable, distributed and highly available key-value store. Inspired by Amazon Dynamo white paper. Written in Erlang with come C/C++. Open Source. Apache 2.0 licensed. 

---

# What is Riak?


![inline fit](./101a-basho-and-riak/what-is-riak.png)

^Your application stores its data (values) against unique keys (bucket and key combination). When you want to access a particular value, you request it with the bucket/key combination and Riak serves it back to the client. 

---

# KV with extras

* Secondary indexing (2i)
* Data expiry (TTL)
* Search
* Map Reduce
* Commit hooks
* HTTP and PB interfaces

---

# Riak is the

# ops-friendly<br/>database

---

# Cluster of nodes

#DISTRIBUTED<br/>Performance through concurrency

---

# All nodes participate equally

#MASTERLESS<br/>No single point of failure

---

# easily add or remove nodes
#SCALABLE<br/>linear scalability



---

# MULTIPLE PLATFORMS

![inline fit](./101a-basho-and-riak/platforms.png)

---

# replicas of stored data

#HIGHLY AVAILABLE<br/>data redundancy

---

# erlang core
#FAULT TOLERANT<br/>self healing

---

# Riak strengths

^Fast - KV operations are low latency with minimal disk seeks. Scalable - Add nodes to get more CPU/mem/disk/IOPS. Concurrent - Erlang OTP gives you concurrency through multiple processes supporting multiple operations. Available - Any nodes accepts reads/writes. Fault tolerant - Erlang OTP gives you process hierarchy and crash support. The cluster transparently survives node crashes. 

---

# Riak Strengths

* Fast - KV operations are low latency with minimal disk seeks.
* Scalable - Add nodes to get more CPU/mem/disk/IOPS.
* Concurrent - Erlang OTP gives you concurrency through multiple processes supporting multiple operations.
* Available - Any nodes accepts reads/writes.
* Fault tolerant - Erlang OTP gives you process hierarchy and crash support. The cluster transparently survives node crashes.

^Fast - KV operations are low latency with minimal disk seeks.
^Scalable - Add nodes to get more CPU/mem/disk/IOPS.
^Concurrent - Erlang OTP gives you concurrency through multiple processes supporting multiple operations.
^Available - Any nodes accepts reads/writes.
^Fault tolerant - Erlang OTP gives you process hierarchy and crash support. The cluster transparently survives node crashes.


---

# Riak is not an RDBMS

^Does not manage complex object relationships. Does not manage complex queries. Does not support atomic operations across keys. 

---

# Why use Riak?

---

# For Operators

* What’s important as an operator?
* Simplicity 
* Fault Tolerance
* High-availability
* Monitoring
* Excellent support (Community & Enterprise)

---

# Simplicity

* Ease of configuration
* Management & Troubleshooting
* Rolling upgrades
* Provisioning
* Horizontally scalable
* Commodity hardware

^Configuration > 2 files to setup - app.config for Riak, vm.args for Erlang. Management & troubleshooting > command-line tools, riak-debug, logs. Provisioning > support for Puppet, Chef, Ansible etc. Horizontally scalable > designed to be clustered. Add more nodes to get more iops/storage/compute as load is distributed evenly. Scaling a relational database to handle more data and usage can be prohibitively expensive for operators. Horizontal scaling is easier and usually cheaper than vertical scaling. 

---

# Fault Tolerance

* All nodes participate equally - no single point of failure (SPOF)
* All data is replicated
* Cluster transparently survives...
* Node failure
* Network partitions
* Built on Erlang/OTP

^Cluster transparently survives node failure and network partitions. Masterless with no SPOF. All data is replicated to multiple nodes. 

---

# High Availability

* Masterless
* Tunable availability/consistency
* Fallbacks are used when nodes are down
* Hinted-handoff
* Ownership-handoff

^Masterless architecture. Tunable availability if required. Fallbacks are used when nodes are down. Hinted handoff. Rolling restarts and live upgrades. MDC - discussed later. Relational Databases tend to favour consistency over availability, making them ill suited for applications that require high availability. 

---

# CAP Theorem

* C = Consistency
* A = Availability
* P = Partition Tolerance
* Cap theorem states that a distributed shared data system can at most support 2 out of these 3 properties

Network/Data Partition

![fit left](./101a-basho-and-riak/network-partition.png)

^- Riak sacrifices C, eventually consistent - tunable consistency 

---

# Monitoring

* Nagios plugin
* Command line - riak-admin
* HTTP - /stats
* Enterprise
* JMX
* SNMP

^riak-admin status and /stats endpoint give a wealth of information on Riak health and activity. Nagios plugin available. Zabbix template available. Use your favourite monitoring tool. 

---

# Support

* Open Source
* Community
* Mailing list
* IRC
* docs.basho.com - For Operators
* Enterprise
* Telephone, Email & 24x7x365 On-Call Support

---

# For Developers

* What’s important as a developer?
* Simplicity
* Supported languages
* Feature set
* Performance
* Excellent support (community & enterprise)

---

# Simplicity

* Simple to spike (Five-minute install)
* No data normalisation
* No need to design for sharding/scaling
* Supported client libraries

---

# Client Libraries 

* Client libraries supported by Basho: Python, Ruby, Java, Erlang (PB)
* Community supported languages and frameworks: C/C++, Clojure, Common Lisp, Dart, Django, Go, Grails, Griffon, Groovy, Erlang, Haskell, .NET, Node.js, OCaml, Perl, PHP, Play, Racket, Scala, Smalltalk

^Erlang using protocol buffers instead of distributed Erlang. 

---

# Client Types

* REST based HTTP Interface Easy to use from command line (curl) and simple scripts.
* Protocol Buffers Optimized binary encoding standard developed by Google. More efficient and faster than HTTP interface.

---

# Features

* Read-repair
* Active Anti Entropy
* Tunable availability/consistency
* Conflict Resolution
* Multiple storage backends with specific features
* Map Reduce
* Replication in Riak EE MDC

^Tunable consistency per bucket Backend specific features (expiry, indexing) 

---

# Performance

* Near linear performance increase when scaling
* Perfect for high IOPS requirements
* Perfect for heavy write scenarios due to masterless architecture

---

# Support

* Community
* Mailing list
* IRC
* docs.basho.com - For Developers
* Relational to Riak white paper
* Enterprise access to Engineering

---

# Questions ?


