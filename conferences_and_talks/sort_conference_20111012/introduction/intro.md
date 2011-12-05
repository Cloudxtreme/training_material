!SLIDE center section

![Basho Technologies](basho.gif) 
 
# LDS SORT Conference

## Daniel Reverri

### dan@basho.com

!SLIDE bullets incremental

# What is Riak?

* A distributed, horizontally scalable
* highly available
* fault tolerant
* key/value store (plus extras)

!SLIDE bullets incremental

# Distributed, Horizontally Scalable

* Designed for a cluster of machines
* Load and data are spread evenly
* Add more nodes to get more X

.notes X => throughput, compute power, storage

!SLIDE bullets incremental

# Highly Available

* Any node can server any client request
* Fallbacks are used when nodes are down
* Always accepts read and write requests

!SLIDE bullets incremental

# Fault Tolerant

* All nodes participate equally - no SPOF
* Data is replicated...
 * within the cluster
 * across data centers

!SLIDE bullets incremental

# Fault Tolerant

* Clusters transparently survive...
 * node failure
 * network partitions

!SLIDE bullets incremental

# Key/Value Store

* Simple - get, put, delete
* Objects are referenced by a bucket/key pair
* Values are mostly opaque (some metadata)

!SLIDE bullets incremental

# Extras

* Link Walking
* Secondary Indexes
* Full-text search
* MapReduce
