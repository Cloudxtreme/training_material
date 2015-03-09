# Three Day Operations Training

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

### Intro to Riak Operations

====================================

* Installation
* Controlling
* Configuring
* Clustering
* Directories and what lives where

### Intro to Riak Operations: Lab

====================================

* Demonstrate the following
	* Bring up Riak nodes
	* Join them into a cluster
	* Perform Riak operations against the cluster
	* Conduct a fault tolerance demo
* Hands-On
	* Repeat the demonstrated steps

### Riak Architecture

====================================

* Intro to Erlang/OTP

### Operating Riak

====================================

* Logs
* Stats
* Backends
	* Intro
	* Leveldb
	* Bitcask
	* Memory
	* Multi
* riak-debug
* riaknostic

### Deployment / Configuration Management

====================================

* Cuttlefish
* Tools (Ansible, Chef, Puppet)
* Security
* Capacity Planning
* Rolling Upgrades

## Day 3
====================================

### Backup, Restore, Disaster Recovery

====================================

* Directories and What Lives Where
* Rolling Backups
* Partial Cluster Failure Recovery
* Disaster Recovery

### Performance Tuning

====================================

* Cloud / VM Configuration
* Bare Metal Configuration
* Understanding and Tuning the Erlang VM
* Operating System Tuning
* Network Topology and Architecture
* Benchmarking Lab

### Monitoring

====================================

* Nagios
* Hosted Services
* Troubleshooting

### Multi-datacenter Replication

====================================

* Setting it Up
* Dealing with Strongly Consistent and Search Data

### Review

====================================

* Question and Answer
* Revisit any areas of interest
