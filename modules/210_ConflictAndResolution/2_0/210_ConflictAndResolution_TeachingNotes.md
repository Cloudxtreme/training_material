# Conflict & Resolution
*Teaching Notes*

---
######OUTSTANDING ISSUES:

+ needs redraft
+ needs review

<br>

## Teaching Goals

Students should understand:
+ why consistency matters, and why it must be sacrificed
+ that the next best thing is eventual consistency, and we can achieve that by resolving conflicts
+ how conflicts are discovered on read/write or by AAE
+ some techniques Riak can use to resolve them, including timestamps, logical clocks, and CRDTs

<br>


## Problem: Consistency

If you want to remain available even when there is a network partition, you must sacrifice some consistency among your replicas during these partition events. This is CAP theorem. But what happens in practice?

+ there's no guarantee you can read your own writes
+ correct data can be overwritten by stale data in failure scenarios
+ recycling keys, for example in a queue, becomes dangerous
+ at scale, inconsistency is endemic, because the data is in constant turnover
+ over time, the database suffers from entropy, becoming increasingly disordered and eventually equivalent to noise

## Solution: Conflict Resolution

Whereby discrepancies are discovered and resolved according to some appropriate strategy, and in a way that does not compromise the latency or availability of the database. Let's look first at discovery.

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

As with many things in life, there's a number of ways you can do it in the NoSQL world. Riak lets you pick from a variety of strategies.

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

The shorter causal context represents every event up to m. The longer represents every event up to m, and also event n. These two notations are sufficient to make causal context clear in even the most complex of distributed interactions. We'll look at an example from the paper.

...
Permits you to know truly what is an ancestor of what.

So, having a clear causal context permits Riak to do some intelligent resolution. However, if updates happen on two different machines without shared causal history, further resolution is still required.

Riak now presents two options: either return siblings to the application for resolution at that level, or perform sibling resolution at the database level using provided knowledge of what type of data the current object represents.

This is Riak's **Conflict-Free Replicated Data Type** (CRDT) functionality.

CRDTs are distributed data structures designed to provide strong eventual consistency. If implemented properly, they make merge conflicts mathematically impossible, thus guaranteeing the database tends towards a consistent state over time.

CRDTs work when the type alone is sufficient knowledge for conflict resolution to occur. For the mathematicians among you, that is to say that the merge function must be commutative, associative, and idempotent. This is why only certain types can be modelled in this way.

+ commutative means the operands can be entered in any order and the result will be the same (e.g. minus doesn't work, plus does)
+ associative means the operations can be run in any order and the result will not change (divide doesn't work, multiply does)
+ idempotent... don't worry gentlemen, has nothing to do with potency... means the operation can be repeated multiple times without changing the result beyond the initial application

Riak has the first implementation of CRDTs in a widely-used commercial database. It supports:

+ counters
+ sets
+ maps
+ flags
+ registers

Let's look at a brief example using sets.

Consider modelling a public playlist as a set of track ids. Suppose two users concurrently alter the set, adding different tracks. In this case, the merge function is very simple: a set union operation gives us the correct result every time, which is to include both tracks.

Now suppose a user removes a track while one replica is down. What happens now? A simple set union is clearly not sufficient for this situation... in fact, at first glance there appears to be no safe merge function. What we've created so far is called a "G-SET", or growth-only set.

To get a set that can also shrink, you have to model your CRDT set as two underlying sets: one for additions, the other for removals. The set seen by users is additions *minus* removals, which in proper maths terminology is *the relative complement of removals in additions*.

When merging, you need to check the previous and new state of both sets. If there is a track newly listed in the removals set, but not in the additions set, that means you can safely remove that track from both lists.

Now suppose two users concurrently add and remove the same track. What should we do? Well, here your implementation has to make a choice. Riak elects to believe that more things are better than less things with respect to CRDT sets. So the merge function leaves the track in the additions set, and removes it from the removals set. The result is that the track remains in the list from the user's perspective.

So, that is a CRDT set. Counters are implemented in a similar way, using two growth-only counters. Registers are simple strings, and use last write wins resolution. Flags prefer to be on rather than off.

Maps are compound objects containing other CRDTs within them, even other maps. Resolution is per sub-field, with the addition or removal of the fields themselves treated as with sets.

And that's CRDTs. The advantage of using them is that siblings need not be sent to the application, and application developers can be saved the hassle of writing complex application-specific conflict resolution code for simple types and common use-cases (like playlists for example).

If you want to learn more about CRDTs, an excellent reading list by one of my colleagues can be found here:
http://christophermeiklejohn.com/crdt/2014/07/22/readings-in-crdts.html

<br>