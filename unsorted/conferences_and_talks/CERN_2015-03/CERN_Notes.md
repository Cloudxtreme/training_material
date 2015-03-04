# CERN Talk March 2015
https://indico.cern.ch/event/348657/overview

*Notes*

---
######OUTSTANDING ISSUES:
+ needs review


<br>

## Teaching Goals

+ to present a brief overview of Riak and its core story
+ to explore Riak's approach to a couple of the harder problems in distributed systems

<br>


##Introduction

+ my name is Nicholas Bellerophon
+ I work as a Client Services Engineer for Basho Technologies Inc.
+ We are a distributed company of around 120 people
+ we do sales, engineering and service for the open-source database Riak

By way of introduction, I'm going to push very quickly through Riak's core story just so we have a bit of context. Then, we'll move into the meat of the talk, which will focus on a couple of specific problems in distributed systems. In each case, we'll examine how the problem arises, why it is important, and the details of how Riak and others choose to handle it.

<br>

##Core Story

So let's talk about why people choose to use Riak for storing their data.

+ simple to operate
+ highly available
+ fault tolerant
+ horizontally scalable
+ low-latency

Also:
+ serviced (by Basho)
+ supported (by the open source community)

<br>

##Operational Simplicity
+ Riak is the ops-friendly database
+ why do I want an ops-friendly database?
	+ the vast majority of the cost of a database is in operational support over its lifetime
	+ the dangerous failures are the unexpected ones that only appear once the database is operating in a production environment
+ how easy is Riak to operate?
	+ distributes your data for you
	+ re-distributes your data for you when you scale
	+ replicates your data for you locally and globally
	+ resolves your data for you if it is changed concurrently
	+ repairs your data for you if it gets out of sync or corrupted
	+ holds and returns your data for you no matter how many nodes go down
	+ AND...
	+ up-to-the-minute stats
	+ rolling-restarts for upgrading
	+ built-in diagnosis & debug tools
	+ 24/7 paid support with 30 minute SLAs (but actually we respond in 5)

##High Availability
+ means users can perform operations even when there are problems, e.g.
	+ nodes are taken down for maintenance
	+ nodes go down due to errors
	+ network partitions divide the cluster
	+ hardware fails permanently
	+ entire datacenters go offline
+ why do I want high-availability?
	+ our most important users are the most exposed, because they are the heaviest users of the database
	+ at scale, even remote possibilities affect large numbers of people; this impacts reputation
+ how highly available is Riak?
	+ thanks to replication and sloppy quorum, Riak remains highly available even when suffering:
		+ heavy load
		+ multiple node failure
		+ network partitions
	+ Riak also supports global availability for enterprise customers via our Multi-DataCenter Replication technology

##Fault Tolerance
+ the system expects faults, and is able to keep running safely despite them
+ why do I care?
	+ because at scale, faults are *always* occurring somewhere
	+ we want to deal with problems when resources are available, rather than be forced to deal with them immediately
+ how is Riak fault tolerant?
	+ written in Erlang, a programming language invented to support reliability (and was the foundation of the nine-nines uptime of the Ericsson AXD301 telecoms switch)
	+ masterless ring permits operation with no single point of failure
	+ permanent node failure without data loss
	+ self-healing thanks to hinted-handoff, conflict resolution, read-repair and active-anti-entropy
	+ for our enterprise customers, full cluster failover

##Horizontal Scalability
+ means you can scale the performance of your database by adding more machines to the cluster
+ aka scaling out
+ vertical scaling means replacing slower computers with faster ones
+ aka scaling up
+ why do you want to scale?
	+ because you want to grow... more customers, more compute power
+ why do you want to scale out instead of up?
	+ super-computers are expensive
	+ eventually computers don't get any faster
	+ powerful machines are single points of failure
	+ adding smaller machines more often results in less wasted compute power
	+ you don't have to throw computers away
+ how does Riak scale?
	+ performance increase improves linearly with more nodes
	+ double your cluster size, get double the performance
	+ works because any node can handle any request, so you benefit from concurrency
	+ from an operational standpoint, adding nodes is a one-line operation

##Low Latency
+ how long it takes one operation to complete
+ why is latency important?
	+ some use-cases demand real-time response
	+ lower latencies result in a more efficient, cheaper system overall
+ how fast is Riak?
	+ order of milliseconds
+ how is this possible in a distributed system?
	+ consistent hashing provides one hop request routing
	+ choose your storage backend to suit your use-case:
		+ Bitcask journals writes for fantastic write performance
		+ LevelDB stores data in levels for quick access to frequently-requested data
	+ with enterprise, you can split clusters and tune each one to optimize for individual access patterns separately 

<br>

---

<br>

## Problem: Sharding

One node is no problem, but as soon as you get to multiple nodes, you have to start separating things. This was originally called sharding, but the process became so fraught with problems that sharding is now a dirty word. Some of the main issues:

+ http://highscalability.com/blog/2010/10/15/troubles-with-sharding-what-can-we-learn-from-the-foursquare.html
+ node exhaustion, shard exhaustion (fixed size shards)
+ uneven distribution of data on shards
+ single points of failure, e.g. shard management, key-index
+ custom sharding policies are massively complex to setup
+ both regular operation and scaling requires manual rebalancing, so ops is hard and laborious
+ replication: do I replicate by node or by shard?
+ if by shard, how do I guarantee replicas are on different nodes?
+ is failover manual or automatic when a node goes down?
+ what happens when a node comes back up?
	
## Solution: Consistent Hashing

The practical use of this algorithm to distribute data was formalised by Amazon in their famous paper:
<br>http://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf

However, the technique has been developed by various authors over the past twenty years. I'm not going to rehash all that now. We'll just do a simple walkthrough of the technique:

1. you input your key string into a consistent hash function
2. the resulting **hash** is in the range 0 to 2^160
3. you divide this range into partitions
4. partitions are owned by nodes according to a "claim" algorithm such that each node has an equal number of partitions
5. you PUT the data into the partition its hash falls within, plus the next N partitions along the range
6. if you reach the last partition in the range, you wrap around to the first; this is why we call it the ring

Actually, most of the cleverness is in claim. You can look at the source code:
https://github.com/basho/riak_core/blob/develop/src/riak_core_claim.erl#L429

In its latest form, Riak's claim algorithm is written as an optimisation problem. It creates a number of possible claim plans and evaluates them for violations, balance and diversity, choosing the 'best' plan. Here:
+ **violations** are a count of how many partitions owned by the same node are within target-n of one another
	+ a plan with a zero answer here is better than any plan with a non-zero answer
	+ in a non-zero case, some replicas end up on the same node
	+ thus replication is no longer beneficial, but actually detrimental because of the extra space taken
+ **balance** is a measure of the number of partitions owned versus the number of partitions wanted
	+ an imbalanced cluster won't use disk space as evenly on each node as a well-balanced one
	+ uses root-mean-square of the difference
	+ so lower is better, and zero is best
+ **diversity** measures how often nodes are close to one another in the preference
list (walking clockwise round the ring)
	+ the more diverse, the more evenly the responsibility for a failed node is spread across the cluster
	+ the ring in the diagram actually has very poor diversity!
	+ diversity is calculated by working out the count of each distance for each node pair and computing the RMS on those counts, so a lower diversity score is better

### What does this do?

+ one-hop request routing for speed
+ masterless operation for fault tolerance
+ concurrent operations across all nodes in the cluster for linear performance increase when scaling

### Doesn't help with...
+ hot key (excessive access to a particular key, e.g. Lady Gaga)
+ large objects (big values again lead to imbalance)
+ inconsistency

<br>
	
---

<br>

## Problem: Consistency

If you want to remain available even when there is a network partition, you must sacrifice some consistency among your replicas during these partition events. This is CAP theorem. But what happens in practice?

+ there's no guarantee you can read your own writes
+ correct data can be overwritten by stale data in failure scenarios
+ recycling keys, for example in a queue, becomes dangerous
+ at scale, inconsistency is endemic, because the data is in constant turnover
+ over time, the database suffers from entropy, becoming increasingly disordered and eventually equivalent to noise

## Solution: Conflict Resolution

Whereby discrepancies and discovered and resolved according to some appropriate strategy, and in a way that does not compromise the latency or availability of the database. Let's look first at discovery.

### Discovery
+ you can do it on read, that's read repair
+ you can do it on write by doing an internal read first, that's write repair
+ you can also do it asynchronously by scanning keys in some manner

In its default configuration, Riak does all three things. Read repair and write repair aren't too hard, because you know the key. The difficult part is the asynchronous repair, because you don't know which keys are in need of repair, and scanning all of them is slow.

Unfortunately, it's actually only this asynchronous repair which really solves the entropy problem in the long run, because otherwise keys that are never read never get resolved and the database suffers from increasingly disordered state over time.

Riak's solution for asynchronous repair involves Merkle Trees, as part of a feature appropriately named Active-Anti-Entropy.

Merkle Trees, otherwise known as hash trees, actually fairly simple binary tree structures, but very useful. Here's how you build one:

1. Hash every object's value. These are your leaf nodes.
2. For each pair of leaf nodes, concatenate, then hash again.
3. The result is your next node up the tree.
4. Keep going until you run out of pairs.

So why is this useful? Well, imagine comparing two of them side by side. To find values that diverge:

1. you start at the top and compare the hashes
2. if they are the same, then all values beneath them must be the same, so you stop
3. if they are different, you move down one level and compare the next two pairs of hashes
4. continuing this process, we can see that if only one value differs, we've only had to compare a portion of the hashes to find out, rather than every one
5. this algorithm is in fact O(log n) efficient, which is *much* better than O(n) for large numbers of objects

So Riak AAE just builds up these hash trees, modifying them as PUTs come in, and occasionally running comparisons between replica partitions. If a diverging pair of values is found, a simple internal read-repair is triggered.

So the question now arises: once we discover inconsistency, how do we resolve and repair it?

### Resolution

As with many things in life, there's a number of ways you can do it. Riak lets you pick from a variety of strategies.

The simplest of these is by timestamp. Riak simply looks at when the value was last updated, according to the local clock of the node into which the object was put. It then overwrites all values on all nodes with the object with the latest clock value.

This is a poor way of dealing with inconsistency, because it disregards the strong likelihood of clock drift, and also completely ignores the possibility of concurrent updates, i.e. those that happen at almost exactly the same time. This can happen easily with objects that are updated very frequently, like state in a game for instance.

So, to partly alleviate these problems, Riak adds logical clock stamps to object meta-data as well as timestamps. Our latest implementation uses **dotted version vectors**.

You can find more info about these clever clocks by reading the paper...

http://arxiv.org/pdf/1011.5808v1.pdf

...but I'll give you a quick summary. The notation looks like this:

{(r, m)}:v OR {(r, m, n)}:v

Here:

+ r is the server node id
+ m, n are integer values describing a point in local logical time
+ everything in {} is a causal context
+ v is the object value associated with the causal context

The shorter causal context represents every event up to m. The longer represents every event up to m, and also event n.

Having a clear causal context permits Riak to do some intelligent resolution, but it updates happen on two different machines without shared causal history, further resolution is still required.

Riak now presents two options: either return siblings to the application for resolution at that level, or perform sibling resolution using provided knowledge of what type of data the current object represents.

This is Riak's **Conflict-Free Replicated Data Type** (CRDT) functionality. Riak supports:

+ counters
+ sets
+ maps
+ flags
+ registers

CRDTs work when the type alone is sufficient knowledge for conflict resolution to occur. For the mathematicians among you, that is to say that the merge function must be commutative, associative, and idempotent.

+ commutative means the operands can be entered in any order and the result will be the same
+ associative means the operations can be run in any order and the result will not change
+ idempotent means the operation can be repeated multiple times without changing the result beyond the initial application

As an example, consider modelling a public playlist as a set of track ids. Now suppose two users concurrently add and remove the same track. What should we do?

In the case of Riak's CRDT set, the rule is defined as "keep it". Everything else is a simple union operation. In this way, siblings need not be sent to the application, and application developers can be saved the hassle of writing complex application-specific conflict resolution code.

If you want to learn more about CRDTs, an excellent reading list by one of my colleagues can be found here:
http://christophermeiklejohn.com/crdt/2014/07/22/readings-in-crdts.html

Questions!

