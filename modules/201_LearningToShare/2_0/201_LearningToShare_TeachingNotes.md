# Learning To Share
*Teaching Notes*

---
######OUTSTANDING ISSUES:

+ needs redraft?
+ needs review

<br>

## Teaching Goals

Students should understand:
+ what consistent hashing is and how it distributes data into partitions
+ that replication puts data onto consecutive partitions around a ring
+ how the claim algorithm works to help nodes figure out which partitions to claim

<br>


## The Problem: Sharding

One node is no problem, but as soon as you get to multiple nodes, you have to start sharing things. This was originally called sharding, but the process became so fraught with problems that sharding is now a dirty word. Some of the main issues:

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
	
## Riak's Solution: Consistent Hashing

The practical use of this algorithm to distribute data was formalised by Amazon in their famous paper:
<br>http://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf

However, the technique has been developed by various authors over the past twenty years. I'm not going to rehash all that now. We'll just do a simple walkthrough of the technique:

1. input a key string into a consistent hash function
2. the resulting **hash** is in the range 0 to 2^160
3. divide this range into partitions
4. partitions are owned by nodes according to a "claim" algorithm such that each node has an equal (or nearly equal) number of partitions
5. PUT the data into the partition its hash falls within...
6. ...plus the next N partitions along the range
7. if you reach the last partition in the range, you wrap around to the first; this is why we call it... the ring!

And that, in a nutshell, is consistent hashing. As it turns out, most of the cleverness is in the claim algorithm. You can look at the source code:
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

### So what does all this give us?

+ one-hop request routing for low-latency
+ masterless operation for fault tolerance
+ concurrent operations across all nodes in the cluster for linear performance increase when scaling horizontally

### But this doesn't solve all problems...
+ hot key (excessive access to a particular key, e.g. Lady Gaga)
+ large objects (big values again lead to imbalance)
+ inconsistency

<br>
	
---

