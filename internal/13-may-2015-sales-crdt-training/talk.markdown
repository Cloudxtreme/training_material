autoscale: true 
build-lists: true
footer: © Basho, 2015
slidenumbers: true 

# CRDT Brainstorming Session

![fit inline](basho-logo-color-horiz.png)

---

# An example 

![left filtered](hugs.png)

---

![original fit](crdt.gif)

---

![original fit](tree.png)

---


# Which CRDT <br/> do we implement?

---

# Counters

Can be used alone or as part of a map.

Keeps track of increments/decrements.
Default value is 1 or -1, but configure to any integer value.

* Page likes
* Number of Twitter followers

----

# Sets

Can be used alone or as part of a map.

Collection of unique binary values

Supported operations are add/remove 1 element and add/remove multiple elements.

* Items in an online shopping cart
* GUIDs representing friends of a user in a social networking application.

---

# Flags

Must be used as part of a map; cannot be used alone.

Values limited to enable or disable.

* Whether a tweet has been retweeted
* Whether a user is eligible for preferred pricing

---

# Registers

Must be used as part of a map; cannot be used alone.
Named binary, with values of any binary.  The value may change over time.

* Storing the name Beaker in the register first\_name in the map favorite\_muppets
* Storing the place Timbuktu in the register cities in the map hottest\_places

---

# Maps

Supports nesting any of the data types, including maps.
Operations including adding/removing map fields and performing operations on nested types (e.g. decrement a counter value). 

E.g. a map called user\_profile containing: 

* register user\_name
* flag email\_notifications
* counter site\_visits

---

# Conflict resolution

Data types have built-in conflict resolution, the rules for which favor additive operations.

---

# Conflict resolution - <br/><br/>_Flags_

>> Enable wins over disable.

---

# Conflict resolution - <br/><br/>_Registers_

>> The most chronologically recent value wins, based on timestamps.

---

# Conflict resolution - <br/><br/>_Counters_

>> Pairwise maximum

^ Each actor keeps an independent count for increments and decrements. Upon merge, the pairwise maximum of any two actors will win (e.g. if one actor holds 172 and the other holds 173, 173 will win upon merge).


---

# Conflict resolution - <br/><br/>_Sets_

>> If an element is concurrently added and removed, the add will win.

---

# Conflict resolution - <br/><br/>_Maps_

>> If a field is concurrently added or updated and removed, the add/update will win.

---

# CRDT - <br/>_a unique feature?_ 

Are CRDT unique to Riak ?

^hell yeah, nobody else even have vector clocks

---

# CRDT - <br/>_a needed feature?_ 

Vector clocks/CRDT are unnecessary[^1]?

[^1]: [Why Cassandra doesn’t need vector clocks](http://www.datastax.com/dev/blog/why-cassandra-doesnt-need-vector-clocks)

^we hear competitors claiming that CRDTs aren't needed - how can they make these claims? ie if you don't have CRDT how can you cope without- thinking either push resolution to client, default to LWW or maybe rearchitect your application to avoid conflict
^ Cassandra addresses the problem that vector clocks were designed to solve by breaking up documents/objects/rows into units of data that can be updated and merged independently. This allows Cassandra to offer improved performance and simpler application design. 

---

# Conflict <br/>Resolution

^ when does server side conflict resolution matter? with what type of data, what type of workload?

---

# Identifying <br/>use-cases

^ what question should we ask customers to help identify strong use cases for CRDTs?

---

# Immutable <br/>data

* No conflict, no resolution
* Column database 


^ do CRDTs only apply to mutable data? can you avoid need for CRDTs by making your app use only immutable data?

---
