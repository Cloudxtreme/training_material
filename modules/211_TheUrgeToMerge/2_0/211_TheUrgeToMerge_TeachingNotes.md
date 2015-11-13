# The Urge to Merge
*Teaching Notes*

---
######OUTSTANDING ISSUES:

+ needs redraft
+ needs review

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

### Flags

We'll start with an easy one: flags. Flags are like booleans; their value can be either true or false (set or unset). They are very simple structures. You might use a flag to track whether a customer has completed a tutorial or not.

The merge function for them is also extremely simple: it's a boolean AND operation. So truth wins over falsehood. Perhaps a better way of putting it is that data wins over lack of data, because the default value for flags is false. Therefore, it is slightly more likely that a true value represents an actual update than a false value does.

### Registers

Next we'll look at registers. These are also quite simple. They are strings of characters. For example, you might use a register to store a customer's name.

The merge function for registers is relatively basic, but does rely on some metadata. When a register value is written, a timestamp is written with it. Later, when two values are merged, the result is the value with the latest timestamp. This is called `Timestamp` or `Last Write Wins` resolution.

### Counters

Two G-Counters! I think.

### Sets

Let's look at a brief example using sets.

Consider modelling a public playlist as a set of track ids. Suppose two users concurrently alter the set, adding different tracks. In this case, the merge function is very simple: a set union operation gives us the correct result every time, which is to include both tracks.

Now suppose a user removes a track while one replica is down. What happens now? A simple set union is clearly not sufficient for this situation... in fact, at first glance there appears to be no safe merge function. What we've created so far is called a "G-SET", or growth-only set.

To get a set that can also shrink, you can to model your CRDT set as two underlying sets: one for additions, the other for removals. The set seen by users is additions *minus* removals, which in proper maths terminology is *the relative complement of removals in additions*.

When merging, you need to check the previous and new state of both sets. If there is a track newly listed in the removals set, but not in the additions set, that means you can safely remove that track from both lists.

Unfortunately, this isn't particularly performant for Riak, so although we use a similar concept for Counters, for Sets we actually use something called an ORSWAT.

Now suppose two users concurrently add and remove the same track. What should we do? Well, here your implementation has to make a choice. Riak elects to believe that more things are better than less things with respect to CRDT sets. So the merge function leaves the track in the additions set, and removes it from the removals set. The result is that the track remains in the list from the user's perspective.

So, that is a CRDT set. Counters are implemented in a similar way, using two growth-only counters. Registers are simple strings, and use last write wins resolution. Flags prefer to be on rather than off.

### Maps

Maps are compound objects containing other CRDTs within them, even other maps. Resolution is per sub-field, with the addition or removal of the fields themselves treated as with sets.

And that's CRDTs. The advantage of using them is that siblings need not be sent to the application, and application developers can be saved the hassle of writing complex application-specific conflict resolution code for simple types and common use-cases (like playlists for example).

If you want to learn more about CRDTs, an excellent reading list by one of my colleagues can be found here:
http://christophermeiklejohn.com/crdt/2014/07/22/readings-in-crdts.html

<br>
