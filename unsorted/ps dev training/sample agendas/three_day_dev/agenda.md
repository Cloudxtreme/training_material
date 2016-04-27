# Three Day Dev Training

## Day 1
====================================

### Overview

====================================

* Introductions
* Agenda Review
* Ground Rules
	* There will be time for questions at the end of each section, but feel free to interrupt as well if more detail is needed
* Ensure Required Tools are Installed
	* Riak 2.0 Downloaded: [http://docs.basho.com/riak/2.0.0/downloads/](http://docs.basho.com/riak/2.0.0/downloads/)
	* Either install Riak locally on machine, or use Vagrant ([http://www.vagrantup.com/](http://www.vagrantup.com/)) with an Ubuntu ([http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box](http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box)) image
* Audience Prior Knowledge of Riak
* Audience Goals for Training
	* More developer focused vs operations
	* Specific goals: Datamodeling techniques, backups, etc

### Riak 101: Intro to Riak

====================================

* Properties of Riak
* APIs for Data Access
* Client Libraries

### Riak 102: Basic Anatomy

====================================

* The Riak Object
* Buckets
* Bucket Types
* Node
* Cluster
* Operations

### Riak 201: Learning to Share

====================================

* Consistent Hashing
* Partitions
* Ring
* Hand-Offs

### Riak 201L: Lab

====================================

* Demonstrate the following
	* Bring up Riak nodes
	* Join them into a cluster
	* Perform Riak operations against the cluster
	* Conduct a fault tolerance demo
* Hands-On
	* Repeat the demonstrated steps

### Riak 202A: Conflict and Resolution

====================================

* Object replication
* N-Val
* Race conditions
* Resolution strategies: time stamps, vector-clocks, siblings, strong consistency

### Riak 202B:  Quorums

====================================

* Read and write
* Durable write
* Primary write

### Riak 202C: Replica repair

====================================

* Read repair
* AAE

## Day 2
====================================

### Basic Operations

====================================

* Directories and what lives where
* How to backup and restore
* Deployment Tools
* Security

### Riak Indexing Techniques

====================================

* 2i
* Search
* Term-based indexing
* CRDTs
* Timeseries & Quanta

### Access Patterns

====================================

* Scheduled vs spontaneous
* Static vs dynamic
* Map techniques to quadrants
* Strengths of weaknesses of access patterns
* Best practices and techniques for shifting use cases from one quadrant to another
* Sample case studies


### Basic CRUD with participant-preferred Riak Client

====================================

* Pair coding with participants

## Day 3
====================================

### 2.0 Feature Deep Dive

====================================

* Strong Consistency
* Search (Solr/Yokozuna)
* Datatypes
* Security

### Advanced Data Modeling

====================================

* Time-Series
* Versioning and soft-deletes
* Highly available Transactions
* Session Storage
* Shopping Cart / Product Data

### Client Specific Use-Case

* Access Patterns
* Data Model
* Improvements

### Review

====================================

* Question and Answer
* Revisit any areas of interest
