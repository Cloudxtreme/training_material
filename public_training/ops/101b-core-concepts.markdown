autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true

![fit](design-assets/Basho-Logos/eps/basho-logo-color-horiz.eps)

---


# Core Concepts

---

# Value

![inline fit](./101b-core-concepts/value.png)

^Opaque binary representation of data stored against a key. 

---

# Key

![inline fit](./101b-core-concepts/key.png)

^An identifier for a value. 

---

# Metadata

![inline fit](./101b-core-concepts/metadata.png)

^Additional data linked to the KV pair that is not part of the value. 

---

# Bucket

![inline fit](./101b-core-concepts/bucket.png)

^Logical grouping of KV pairs, allowing a customisable shared configuration to apply. 

---

# Riak Object

![inline fit](./101b-core-concepts/riak-object.png)


^The combination of Bucket, Key, Value and Metadata. The unit of replication in Riak. 

---

# Node

![inline fit](./101b-core-concepts/node.png)

^An Erlang VM running an instance of Riak. Best practice is a single Erlang VM per OS instance. 

---

# Cluster

![inline fit](./101b-core-concepts/cluster.png)


^A collection of connected Riak nodes. 

---

# Key/Hash Space

![inline fit](./101b-core-concepts/key-hash-space.png)


^To decide where data is persisted to disk in the cluster we use a Cryptographic SHA-1 hash from 0 - 2^160. Any bucket and key combination is hashed and this points to a location in this key/hash space. 

---

# Partition

![inline fit](./101b-core-concepts/partition.png)


^Divisions of the key space are available as directories on the cluster based on available disk space. This is known as the ring creation size. Must be a 2 power: 8, 16, 32, 64, 128 etc. 

---

# Partition Distribution

![inline fit](./101b-core-concepts/partition-distribution.png)

^We then assign the individual partitions to servers/nodes within the cluster so they each have an equal number and therefore manage an equal division of the key/hash space. 

---

# Replication

![inline fit](./101b-core-concepts/replication.png)

^Default n_val (N) of 3. Replication to the next N-1 partitions. 

---

# 

![inline fit](./101b-core-concepts/final-partition.png)


^What happens when you write to the final partition though? 

---

# Consistent Hashing

![inline fit](./101b-core-concepts/consistent-hashing.png)

^Cryptographic SHA-1 hash from 0 - 2^160. Dynamo paper is recommended reading. 

---

# Consistent Hashing

![inline fit](./101b-core-concepts/consistent-hashing-2.png)

---

# Replication

![inline fit](./101b-core-concepts/replication.png)

^Default n_val (N) of 3. Replication to the next N-1 partitions. 

---

# Handoff

^Signed for parcel being delivered to one house (node), occupants are vnodes. Hinted - postman delivers to a neighbour while you are out. When you return the neighbour hands it to you. Ownership - Children move out and get mail sent to their new address (mail split between more addresses) 

---

# Hinted handoff<br/>Normal operation

![inline fit](./101b-core-concepts/hinted-handoff-1.png)

^Replica (n_val) is configurable with a default of 3. 

---

# Hinted handoff<br/>Delegating requests

![inline fit](./101b-core-concepts/hinted-handoff-accepting-requests.png)

^When a server fails, Riak automatically accepts writes to fallback vnodes on different physical nodes ensuring data safety. Existing data is repaired through read-repair and AAE. Read repair ensures replicas are consistent on each read request. AAE works as a background process performing the same consistency checking automatically. 

---

# Hinted handoff<br/>Delegating requests


![inline fit](./101b-core-concepts/hinted-handoff-2.png)

^ Once the failed node has been repaired/recovered back in to the cluster, hinted handoff happens automatically to rebalance data distribution.

---

# Hinted handoff<br/>Handing back

![inline fit](./101b-core-concepts/hinted-handoff-3.png)

---

# Ownership Handoff

![inline fit](./101b-core-concepts/ownership-handoff.png)

---

# Vnode

![inline fit](./101b-core-concepts/vnode.png)

^Erlang process handling requests and managing a partition. A vnode is a virtual node, as opposed to physical node. Each vnode is responsible for one partition on the ring. A vnode is an Erlang process. A vnode is the unit of concurrency, replication, and fault tolerance. Typically many vnodes will run on each physical node. 

---

# Vector Clocks & Siblings

![inline fit](./101b-core-concepts/vector-clocks-and-siblings.png)

^If Riak is configured with allow_mult = true it uses Vector clocks to establish causality of actions. This helps Riak resolve conflicts where it can and provide multiple copies of objects back to the client for resolution where divergent copies result in no causal relationship. 

---

# Quorum

![inline fit](./101b-core-concepts/quorum.png)

^The set of nodes required to participate in a transaction. At most, the same as the configured number of replicas of the data being stored. 

---

# Request Quorums

* Every request contacts all replicas of key
* N - number of replicas (default 3)
* R - read quorum
* W -  write quorum


