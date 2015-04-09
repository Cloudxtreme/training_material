# Capacity & Scaling

---

# Considerations

* RAM
* Disk space
* Disk IO
* Read/Write Profile
* Number of nodes and ring size
* Network IO

^RAM most important - crucial for bitcask - leveldb if this is an issue Disk - Disk space needs are much easier to calculate and essentially boil down to a simple equation Disk IO - no need for RAID? discussion Read/Write profile  - mainly writes? less RAM  - reading only new keys? less RAM Network - riak is chatty, put it on a low latency fast network. gigabit or more 

---

# Capacity Planning

* Initial Capacity
* Scaling Profile
* Scaling Thresholds

---

# Initial Capacity

* How many objects?
* What size are the objects?
* Object count change over time?

---

# Access Profile

* How many requests per second?
* What is the request distribution?

---

# Bottlenecks

---

# Estimating Disk Capacity

* Disk space per node           (objects * size * n_val) ——————————————                  node count

---

# Estimating Disk Capacity

* Disk space per node   (60,000,000 * 10kB * 3 replicas) ——————————————                    5 nodes            = 360GB per node 
* (not including free space) 

---

# ring_creation_size

* Can only be set once
* Power of 2
* All nodes must agree
* 10-30 vnodes per node is considered best

^128 is good for 5-10 nodes 256 is a good number for scaling between 5 and 20 nodes consider overhead of vnode processes and backends 

---

# Thresholds

* CPU: 75% x num_cores
* Memory: 75% utilization
* Swap: >0% used
* File Descriptors: 75% of ulimit

---

# Tips

* Bitcask calculator
* Scale early to avoid handoff pain
* Scale up in groups not a node at a time
* Up transfer limit off-peak (if you have one)
* Auto scale up but not down
* Configuration management avoids human error


