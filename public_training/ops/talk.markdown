footer: © Basho Technologies, 2014
slidenumbers: true
autoscale: true

![fit](../basho-horiz.png)

---

## Introduction to Riak

## CSE Bryan Hunt

---
/common/bryan-training/new/section_1_introduction

# Agenda

* Introduction
* High Availability & Reliability
* Scalability
* Global Distribution & Operational Simplicity
* Questions

---
/common/bryan-training/new/section_1_introduction

# Basho Technologies

* A distributed systems company
* Founded 2008 by Akamai Executives
* Global HQ in Seatle, USA
* EMEA HQ in London, Asia HQ in Tokyo
* ~130 staff

---

# What Is Riak?

---

# More About Riak

* Riak is open source - http://www.github.com/basho
* Apache 2.0 License
* Strong community usage and support
* Written in Erlang with some C/C++
* Enterprise edition provides MDC and world-class support

---



# Why use Riak?

---

# High Availability & Reliability 

---

# Life or Death

* Riak has replaced Oracle as database behind the NHS SPINE project handling prescriptions
* Extremely high technical availability requirements
---

# What makes Riak highly available?


* Clusters are masterless
* All data is replicated
* Consistent Hashing
* Designed to operate in presence of failure
* Self healing

---

# CAP Theorem

* C = Consistency
* A = Availability
* P = Partition Tolerance

^ Cap theorem states that a distributed shared data system can at most support 2 out of these 3 properties

---

![fit original](cap-theorem.png)

---

# Consistent Hashing

---

![fit original](consistent-hashing.png)

---

# Replication

---

![fit original](replication.png) 

---

# Node Failure

---

![fit original](node-failure.png)

^Node fails Request goes to fallback Node comes back Handoff - data returned to recovered node Normal operations resume 

---

# Eventual Consistency

* All nodes accept reads and writes
* Concurrent writes and network partitions can cause conflicts
* Conflict resolution method is configurable
* Tunable consistency
* Active and passive anti-entropy mechanisms

---

# Anti-Entropy

* Read-repair corrects inconsistencies on every read.
* Active Anti-Entropy uses Merkle trees to compare data in partitions and periodically ensure consistency.
* Active Anti-Entropy runs as a background process.

---

# Never Lose Data

* Data persisted within request
* Conflict resolution
* Last-Write-Wins
* Siblings
* Commutative Replicated Data Types (CRDT)

---

# CRDTs

* Data types that can be automatically resolved by Riak
* Counters available in 1.4.x
* Riak 2.0 will bring: Last-Write-Wins Registers, Sets, Flags, Maps
* Complex datatypes can be built by assembling CRDTs

---

# Scalability

---

# Boundary

* Server monitoring as a service
* High sampling rate
* Flexible views on data
* Huge amounts of data, growing fast
* Requires predictable latencies and ability to scale

---

# What makes riak scale?

* Built to run in clustered environment
* Near-linear scalability
* Consistent hashing into defined partitions
* Data distribution managed by Riak

---

# How to Query Data?

* Direct key access
* Secondary indexes
* Full-text search
* Map/Reduce

---

# Direct Key Access

* Most efficient way to access data
* GET/PUT/DELETE requests
* Near linear scaling
* De-normalise for efficient access

---

# Secondary Indexes

* Non-primary key lookups
* Defined as metadata when object is written 
* Two index types: integer and binary
* Two query modes: exact match/range query
* An index can have multiple values for an object

---

# Next GenerationFull-Text Search

* Turn-Key Solution
* Integration between Riak and Solr
* Document-based partitioning
* Deep integration
* Index anti-entropy
* Ability to use existing Solr libraries

---

# MapReduce

* For complex, localised data processing
* Flexible input
* Map and Reduce functions implemented in Erlang/JavaScript
* Suitable for batch processing - NOT designed for real-time queries

---

# Global Distribution & Operational Simplicity

---

# Rovio

* Large number of concurrent users world-wide
* Multiple clusters distributed globally
* Small operations team
* Need database that is easy to operate and supports global replication

---

# Multi Datacenter Replication

* Replication across large distances
* Flexible replication topologies
* Two modes that can be combined:
* Real-time replication
* Full-sync replication

---

# Full Sync Replication

---

![fit](mdc_full-sync.png)

---

# Real-Time Replication

---

![fit](mdc-real-time.png)

---

# Easy to Operate

* Riak designed to continue operating in presence of failure
* Cluster survives and self-heals from wide range of failure scenarios
* Little manual intervention required
* Easy to add, delete or replace nodes
* Rolling upgrades - no downtime

---

# Monitoring and Management

* Wide range of statistics available for monitoring and trending
* SNMP support
* Support for orchestration tools:
* Chef
* Puppet

---

# Summary

---

# Questions?


