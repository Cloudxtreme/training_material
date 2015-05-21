autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true

![inline](design-assets/Basho-Logos/eps/basho-logo-color-horiz.eps)

# Performance Tuning

---

# Docs website

[http://docs.basho.com/](http://docs.basho.com/)

---

# System Configuration

* OS level tweaks
* Adjust ulimit
* Mount data disk with noatime
* Swappiness can affect IO
* Disk I/O Scheduler

^show out put of riak-admin diag disk i/o from cfq (completely fair queueing) to noop or deadline 

---

# Riak Tuning

## in /etc/riak/vm.args
```
+S 8:8 # half number of cores when using LevelDB
+zdbbl 32768 # if busy_dist_port_seen in logs
```

^+S half number of cores +zdbbl if `busy_dist_port` in console.log 

---

# Riak Tuning

## /etc/riak/app.config

```erlang
 {eleveldb, [
   {cache_size, 8388608},
   {data_root, "/var/lib/riak/leveldb"},
   {max_open_files, 100},
   {write_buffer_size_max, 62914560},
   {write_buffer_size_min, 31457280}
 ]},
```

^-   `max_open_files` defaults to 30.  We’ve found the best performance with values between 70-100. The `max_open_files` value is multiplied by 4 megabytes to create a file cache. 

---

# Optimisations

---

* Riak Tuning
* Operating System Tuning

---

# Operating System Tuning

* Linux Kernel Tuning (Sysctls)
* Mount Options
* Disk IO Tuning

---

# Linux Kernel Tuning

* Virtual Memory 

`vm.swappiness = 0`

^vm.swappiness: instructs the kernel to only swap to avoid an out of memory condition (changed in recent RH to vm.swappiness = 1 )

---

# TCP/IP 

```
net.ipv4.tcp_max_syn_backlog = 40000 
net.core.somaxconn=4000 
net.ipv4.tcp_timestamps = 0 
net.ipv4.tcp_sack = 1 
net.ipv4.tcp_window_scaling = 1 
net.ipv4.tcp_fin_timeout = 15 
net.ipv4.tcp_keepalive_intvl = 30 
net.ipv4.tcp_tw_reuse = 1
```

^ Lets examine these settings one at a time

---


# `tcp_max_syn_backlog`

* Keeps more SYN requests in memory.  

* Helps moderate the effect of a large number of connections at peak times. 

---

# `net.core.somaxconn`

* Increases the max TCP sockets in a LISTEN state 

---

# `tcp_timestamps` 

* We’ve seen performance benefits while disabling this option on networks less than 10GbE.

^ This should be enabled on 10GbE networks. 

---

# `tcp_sack` 

* Enables selective ACKs.  
* Helps to reduce the amount of data sent during retransmits. 

---

# `tcp_window_scaling`

* Enables window scaling.  
* Reduces bandwidth loss on high bandwidth connections. 

---

# `tcp_fin_timeout` 

* How long to keep sockets in the `FIN_WAIT_2` status.  
* Default: 60.  
* Decreasing helps reap closed connections faster. 

---

# `tcp_keepalive_intvl`

* The interval between sending keepalive probes.  
* Default: 75.  
* Decreasing allows failed connections to be closed sooner. 

---

# `tcp_tw_reuse`

Allow reusing sockets in `TIME_WAIT` state for new connections

---

# Mount Options

* EXT4: noatime, nodirtime, barrier = 0, data=writeback
* XFS: noatime, nodirtime, nobarrier, logbufs=8, logbsize=32k, allocsize=2M

^Both Riak backends are append-only and can tolerate end of file corruption.  
^ It is preferable to optimize for long-term throughput than for crash-time consistency. 
^ Riak does not require atime, disable it 
^ Barriers ensure proper write ordering by forcing a flush to media for any given commit before the next flush may begin.  
^ Not necessary when using modern RAID controllers, external storage, or for Riak in general. 
^ Data=writeback allows data to be flushed to disk AFTER its metadata is committed to the journal.  
^ This is an optimization that favors throughput over consistency. 
^ Logbufs specifies the number of in-memory log buffers. Increasing this value will generally improve performance at the cost of greater memory consumption 8 is the max 
^ Logbsize specifies the log buffer size for each log buffer. Default is 32k.  
^ Increasing this value will allow more file modifications to be kept in memory, improving performance Allocsize specifies how much space will be pre-allocated for files in order to reduce fragmentation 
 
---

# Disk IO Tuning

* `/sys/block/x/queue/scheduler`
* Use noop or deadline
* `/sys/block/x/queue/nr_requests`
* 1024

^ Scheduler defines the algorithm by which data is flushed to disk.      
^ Noop tends to work best with network-based file systems since they implement their own flush algorithm     
^ Deadline works best for direct attached storage     
^ The default scheduler is CFQ and tends to be _very_ bad for Riak performance 
^ `nr_requests` defines the depth of the scheduler queue.  Default is 128.  
^ Longer queues allow for more efficient ordering and increased probability of merging requests.
 
---

# Next steps

* docs.basho.com
* OS & filesystem settings
* app.config & vm.args
* Backend configuration and settings


