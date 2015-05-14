# Core Concepts

---

# Value

^Opaque binary representation of data stored against a key. 

---

# Key

^An identifier for a value. 

---

# Metadata

^Additional data linked to the KV pair that is not part of the value. 

---

# Bucket

^Logical grouping of KV pairs, allowing a customisable shared configuration to apply. 

---

# Riak Object

^The combination of Bucket, Key, Value and Metadata. The unit of replication in Riak. 

---

# Node

^An Erlang VM running an instance of Riak. Best practice is a single Erlang VM per OS instance. 

---

# Cluster

^A collection of connected Riak nodes. 

---

# Key/Hash Space

^To decide where data is persisted to disk in the cluster we use a Cryptographic SHA-1 hash from 0 - 2^160. Any bucket and key combination is hashed and this points to a location in this key/hash space. 

---

# Partition

^Divisions of the key space are available as directories on the cluster based on available disk space. This is known as the ring creation size. Must be a 2 power: 8, 16, 32, 64, 128 etc. 

---

# Partition Distribution

^We then assign the individual partitions to servers/nodes within the cluster so they each have an equal number and therefore manage an equal division of the key/hash space. 

---

# Replication

^Default n_val (N) of 3. Replication to the next N-1 partitions. 

---

# 

^What happens when you write to the final partition though? 

---

# Consistent Hashing

^Cryptographic SHA-1 hash from 0 - 2^160. Dynamo paper is recommended reading. 

---

# <ring diagram>

---

# Replication

user_records/dbrown  

^Default n_val (N) of 3. Replication to the next N-1 partitions. 

---

# Handoff

* Ownership handoff
* Hinted handoff

^Signed for parcel being delivered to one house (node), occupants are vnodes. Hinted - postman delivers to a neighbour while you are out. When you return the neighbour hands it to you. Ownership - Children move out and get mail sent to their new address (mail split between more addresses) 

---

# Hinted Handoff

---

# 

^Replica (n_val) is configurable with a default of 3. 

---

# 

^When a server fails, Riak automatically accepts writes to fallback vnodes on different physical nodes ensuring data safety. Existing data is repaired through read-repair and AAE. Read repair ensures replicas are consistent on each read request. AAE works as a background process performing the same consistency checking automatically. 

---

# 

^Once the failed node has been repaired/recovered back in to the cluster, hinted handoff happens automatically to rebalance data distribution. 

---

# Ownership Handoff

---

# Replication

---

# Vnode

^Erlang process handling requests and managing a partition. A vnode is a virtual node, as opposed to physical node. Each vnode is responsible for one partition on the ring. A vnode is an Erlang process. A vnode is the unit of concurrency, replication, and fault tolerance. Typically many vnodes will run on each physical node. 

---

# Vector Clocks & Siblings

^If Riak is configured with allow_mult = true it uses Vector clocks to establish causality of actions. This helps Riak resolve conflicts where it can and provide multiple copies of objects back to the client for resolution where divergent copies result in no causal relationship. 

---

# Quorum

^The set of nodes required to participate in a transaction. At most, the same as the configured number of replicas of the data being stored. 

---

# Request Quorums

* Every request contacts all replicas of key
* N - number of replicas (default 3)
* R - read quorum
* W -  write quorum


