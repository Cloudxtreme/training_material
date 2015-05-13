# CRDT Brainstorming

---

# An example 

---

![original fit](crdt.gif)

---

Which CRDT do we implement? 

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
* `register` user\_name
* `flag` email\_notifications
* `counter` site\_visits

---

# Conflict resolution

Data types have built-in conflict resolution, the rules for which favor additive operations.

---

# Flags

>> Enable wins over disable.

*Conflict resolution (continued)*

---

# Registers	

>> The most chronologically recent value wins, based on timestamps.

*Conflict resolution (continued)*

---

# Counters	

>> Pairwise maximum

*Conflict resolution (continued)*

^ Each actor keeps an independent count for increments and decrements. Upon merge, the pairwise maximum of any two actors will win (e.g. if one actor holds 172 and the other holds 173, 173 will win upon merge).


---

# Sets	

>> If an element is concurrently added and removed, the add will win.

*Conflict resolution (continued)*

---

# Maps	

>> If a field is concurrently added or updated and removed, the add/update will win.

*Conflict resolution (continued)*

---

# A unique feature

Are CRDT unique to Riak ?


^hell yeah, nobody else even have vector clocks

---

# Conflict Resolution

^ when does server side conflict resolution matter? with what type of data, what type of workload?

---

# Identifying use-cases

^ what question should we ask customers to help identify strong use cases for CRDTs?

---

# Unnecessary feature ?

---

Vector clocks/CRDT are unnecessary?

^we hear competitors claiming that CRDTs aren't needed - how can they make these claims? ie if you don't have CRDT how can you cope without- thinking either push resolution to client, default to LWW or maybe rearchitect your application to avoid conflict

---

# Immutable data

^ do CRDTs only apply to mutable data? can you avoid need for CRDTs by making your app use only immutable data?

---
