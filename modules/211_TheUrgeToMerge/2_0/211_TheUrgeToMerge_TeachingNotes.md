# The Urge to Merge
*Teaching Notes*

---
Written by Nicholas Bellerophon, December 2015.<br>
Reviewed by Russell Brown, December 2015.<br>

<br>
## Teaching Goals

Students should understand:
+ what CRDTs are
+ how they work
+ why they work
+ which ones are implemented in Riak
+ how they are implemented (optional)

<br>

## Definition

This module is all about Riak's **Conflict-Free Replicated Data Type** (CRDT) functionality.

CRDTs are distributed data structures designed to provide strong eventual consistency. If implemented properly, they make merge conflicts mathematically impossible, thus guaranteeing the database tends towards a consistent state over time.

CRDTs work when the type alone is sufficient knowledge for conflict resolution to occur. For the mathematicians among you, that is to say that the merge function must be commutative, associative, and idempotent. This is why only certain types can be modelled in this way.

+ commutative means the operands can be entered in any order and the result will be the same (e.g. minus doesn't work, plus does)
+ associative means the operations can be run in any order and the result will not change (divide doesn't work, multiply does)
+ idempotent... don't worry gentlemen, has nothing to do with potency... means the operation can be repeated multiple times without changing the result beyond the initial application

## Supported Types

Riak has the first implementation of CRDTs in a widely-used commercial database. It supports:

+ counters
+ sets
+ maps
+ flags
+ registers

Let's look at each of these in turn.


### Registers

First we'll look at registers. These are quite simple structures. They are strings of characters. For example, you might use a register to store a customer's name.

The merge function for registers is relatively basic, but does rely on some metadata. When a register value is written, a timestamp is written with it. Later, when two values are merged, the result is the value with the latest timestamp. This is called `Timestamp` or sometimes `Last Write Wins` resolution.


### Counters

A counter is something like a running total; Facebook Likes is the canonical example.

The way to model a counter as a CRDT is by permitting only two operations: `add` and `remove`. This makes it impossible to set the counter to a specific value, but if we needed that functionality it wouldn't be a counter, it would be an integer.

Let's look at `add` first. We can model a counter that only does additions quite simply, as a set of {actor, count} tuples. Each actor may only increment its own count, and the value of the counter is the sum of counts. But what is an actor? The actor is an identifier that describes the source of an update. If the source is the same, it is assumed that updates can only be serial.

In Riak, we use the node id of the PUT coordinator (with the node start timestamp appended to cover an edge case). We can do this because PUTs in Riak are serialised at the coordinator prior to being replicated to n-val partitions.

To illustrate the success of this implementation, consider two users pressing a "Like" button on the same post simultaneously. Further assume that these two updates arrive at the database cluster on different sides of a transient network partition, thus guaranteeing different coordinators. The counters would look like this:

```
Old = [{A,412},{B,437},...]
NewA = [{A,413},{B,437},...]
NewB = [{A,412},{B,438},...]
```

When the network partition falls, Riak will be able to merge `NewA` and `NewB`. The merge function is a per-actor maximum of counts. So, the resulting new counter (after merge) will look like:

```
Merged = [{A,413},{B,438},...]
```

The reported value of a counter is the sum of all its counts. Therefore, the merged counter value contains a new count reflecting both the updates, as it should. Were there no actor ids, and only a single count, the merge function would in this case take a maximum and thus under-represent the correct value of the counter by one.

So now we have a counter that works fine for addition. Unfortunately it doesn't work if we need to accept subtractions as well. Given two values, it cannot be said that the higher of the two is the correct one when it is possible that the user intended the value to decrement.

The solution is to use two G-Counters in a pair, one to count increments and the other to count decrements. This is called a Positive-Negative (PN) Counter. The true value of the PN Counter at any point is the count of increments minus the count of decrements.


### Sets

Now let's look at a brief example using sets.

Consider a public playlist of music tracks, for example as offered by Spotify. We can model this as a list of track ids (perhaps with some additional metadata like order and date added). How would we implement this as a CRDT, and what are the problems?

Let's start simple and use a basic list. Suppose two users concurrently alter this list, adding different tracks. In this case, the merge function is also very simple: a set union operation gives us the correct result every time, which is to include both tracks.

Now suppose a user removes a track while one replica is down. What happens now? Unfortunately set union is not sufficient for this situation. It would cause the removed track to be re-added. This is a similar problem to that faced in the counters example.

One solution is to use two sets, one for additions and one for removals. However, Riak chooses not to use this solution, because it is difficult to keep the size of the sets down. Counters don't have this problem because you only need to count the operations; but for a set each deleted entry would have to be stored indefinitely. This results in a set whose size may in the worst case approach total operations, rather than the sum of current elements.

Therefore Riak uses a different solution for Sets, called ORSWOT. This stands for __Observe Remove Set WithOut Tombstones__. It allows the adding, and removal, of elements. Should an `add` and `remove` be concurrent, the `add` wins. To manage without tombstones, there is a version vector for the whole set. When an element is added to the set, the version vector is incremented and the `{actor(), count()}` pair for that increment is stored against the element as its _birth dot_. Every time the element is re-added to the set, its birth dot is updated to that of the `{actor(), count()}` version vector entry resulting from the add. When an element is removed, we simply drop it, no tombstones.

When an element exists in replica A but not in replica B, is it because A added it and B has not yet seen that, or that B removed it and A has not yet seen that? Usually the presence of a tombstone arbitrates. In this implementation we compare the birth dot of the present element to the clock in the Set it is absent from. If the element dot is not "seen" by the Set clock, that means the other set has yet to see this add, and the item is in the merged Set. If the Set clock dominates the dot, that means the other Set has removed this element already, and the item is not in the merged Set.


### Maps

Maps are compound objects containing other CRDTs within them, even other maps. Resolution is per sub-field, with the addition or removal of the fields themselves treated as a special case of the rules for sets. In other words, each maps are implemented as sets of key-value pairs.


### Flags

We'll end with flags. Flags are like booleans in usage; their value can be either true or false (set or unset). You might use a flag to track whether a customer has completed a tutorial or not.

A Riak flag is implemented as an ORSWOT containing exactly zero or one item. If the item is absent, the value of the flag is `false`. If the item is present, it is `true`. As with the Set implementation, this item has a version vector and birth dot permitting it to merge without tombstones. Also, as with Sets, in the concurrent case presence overrules absence (truth wins over falsehood).


### Summary

And that's CRDTs. The advantage of using them is that siblings need not be sent to the application, and application developers can be saved the hassle of writing complex application-specific conflict resolution code for simple types and common use-cases (like playlists for example). A leading user of CRDTs in Riak published an excellent write-up in InfoQ discussing this point, and their use of CRDTs in general:

http://www.infoq.com/articles/key-lessons-learned-from-transition-to-nosql

If you want to learn more about CRDTs, an excellent reading list by a Basho expert can be found here:
http://christophermeiklejohn.com/crdt/2014/07/22/readings-in-crdts.html

You are also welcome to read the source at:
https://github.com/basho/riak_dt

<br>
