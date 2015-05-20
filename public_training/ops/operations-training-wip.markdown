autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true


![fit](design-assets/Riak-Product-Logos/eps/basho-logo-color-horiz.eps)

---

![fit](design-assets/Basho-Logos/eps/basho-logo-color-horiz.eps)

---


# Operating Riak

^## Teaching Goals + to define what Riak is at the highest level + to tell Riak's core story + for each story point, to:    1. explain what it means    2. justify its importance from a business perspective   3. mention some key related features
 

---

# Operating Riak

* The Basics
* Logs
* Monitoring
* Optimizations
* Backups

---

# The Basics

---

# The Basics

* Files and Locations
* Ports, Protocols, and Services
* Basic Commands
* Rolling Restarts
* Upgrading Riak

---

# Files and locations (2.0)
## configuration

```
/etc/riak
    -|riak.conf
    -|advanced.config
```

```
/var/lib/riak
    -|generated.configs
```

---

# Files and locations (legacy)
## configuration

```
/etc/riak
    -|app.config
    -|vm.args
```

---

# Files and Locations
## libraries

```
/usr/lib/riak
    -|erts-x.y.z
    -|lib
     -|basho-patches
    -|releases
```

^Erts-*: Erlang distribution Lib: 
^ Riak libraries Lib/basho-patches: directory where hot patches reside 
^ Releases: specifies run time module versions for Riak at various installed Riak versions

---

# Files and Locations

## data

```
/var/lib/riak
      -|bitcask
      -|leveldb
      -|ring
      -|anti_entropy
      -|yz
      -|yz_anti_entropy
      -|cluster_metadata
      -|generated.configs
```


^Bitcask: bitcask data files separated into directories by vnode 
^leveldb: leveldb data files separated into directories by vnode 
^Ring: contains the Riak core ring file, a file that is communicated between nodes to share the cluster state as well as extra shared info, such as repl status 
^Merge_index: backend storage for legacy search indexes 
^Anti_entropy: leveldb store for anti-entropy trees 
^yz and yz_anti_entropy: Backend data used to support the Riak Search feature  
^cluster_metadata:  storage for information about bucket types and other shared cluster information
 

---

# Files and Locations

## logs

```
/var/log/riak/
     -|console.log
     -|crash.log
     -|erlang.log
     -|error.log
     -|run_erl.log
```

^Console.log: all Erlang console output (debug file) Crash.log: Erlang stack traces from crash events Error.log: error-level output only from Erlang console Run_erl.log: record of the runtime parameters Riak was started with
 

---

# Files and Locations

## Executables

```
/usr/sbin
  -|riak
  -|riak-admin
  -|riak-repl
  -|riak-debug
```

---

# PORTS, PROTOCOLS, & SERVICES

```
Protocol  Ports	     Service

TCP	      4396	     Erlang Port Mapper Daemon (epmd)
TCP	      6000-7999	 Erlang Inter-node Communication (disterl)
TCP	      8099	     Handoff listener
TCP	      8098	     HTTP API endpoint
TCP	      8087	     Protocol Buffers API endpoint
TCP	      9010	     Multi-datacenter Replication (v2)
TCP	      9080	     Cluster Manager
TCP	      8069	     Riak Control
UDP	      4000	     SNMP listener
```

^8099 is used for transferring partitions during handoff 
^Epmd is an Erlang name server used to associate symbolic node names to machine addresses 
^6000-7999 is a configured port range in the Riak app.config used for inter-node communication between Erlang VMs 
^The Riak HTTP client listens on port 
^8098 The Riak Protocol Buffers client listens on port 8087

---

# Basic Commands


```
/usr/sbin/riak

Usage: riak «command»
where «command» is one of the following:
    { help | start | stop | restart | ping | console | attach
      attach-direct | ertspath | chkconfig | escript | version | getpid
      top [-interval N] [-sort { reductions | memory | msg_q }] [-lines N] } |
      config { generate | effective | describe VARIABLE } [-l debug]

Run `riak help` for more detailed information.
```

---

# riak start

^Starts the riak node in the background. If the node is already started, you will get the message "Node is already running!" If the node is not already running, no output will be given.

---

# riak stop

^ Stops the running riak node. Prints "ok" when successful.  
^ When the node is already stopped or not responding, prints:
^ "Node 'riak@192.168.84.134' not responding to pings."

---

# riak restart

^ Stops and then starts the running riak node. Prints “ok" when successful.  When the node is already stopped or not responding, prints: "Node 'riak@192.168.84.134' not responding to pings."

---

# riak console
^ Starts the riak node in the foreground, giving access to the Erlang shell and runtime messages. Prints "Node is already running - use 'riak attach' instead" when the node is running in the background.

---

# DIAGNOSTIC COMMANDS

---

# riak ping
^ Checks that the riak node is running. Prints "pong" when
^ successful.  When the node is stopped or not responding, prints:
^ "Node 'riak@192.168.84.134' not responding to pings."

---

# riak top [-interval N] [-sort {reductions | memory | msg_q }] [-lines N]
^ Prints performance information about the Erlang Virtual Machine similar
^ to the information provided by the `top` command.
^ -interval N
^ specifies an interval upon which the statistics are collected.
^ -sort { reductions | memory | msg_q }
^ Sorts the output of the command by Reduction Count, Memory
^ Utilization, or Message Queue size
^ -lines N
^ Controls the number of processes displayed in the output

---

# riak attach
^ Attaches to the console of a riak node running in the background
^ using an Erlang remote shell, giving access to the Erlang shell and
^ runtime messages. Prints "Node is not running!" when the node cannot
^ be reached. Exit `riak attach` by pressing Ctrl-C twice.

---

# riak attach-direct

^ Attaches to the console of a riak node running in the background
^ using a directly connected FIFO, giving access to the Erlang shell
^ and runtime messages. Prints "Node is not running!" when the node
^ cannot be reached. Exit `riak attach-direct` by pressing Ctrl-D.

---

# riak chkconfig

^ Confirms whether the riak.conf and advanced.config is
^ valid.
^
^ For applications configured with cuttlefish, this includes a call
^ to `config generate` also.

---

# riak config { generate | effective | describe VARIABLE } [-l debug]

^        prints configuration information for applications configured with
^        cuttlefish enabled. `-l debug` outputs more information for
^        troubleshooting.

---

# riak config generate
^            generates the app.config and vm.args files from the .conf file.
^            This is effectively what happens before start, but you'll need
^            to use `config generate -l debug` to see the cuttlefish debug
^           output.

---

# riak config effective
^            prints out the effective configuration in cuttlefish syntax
^            including defaults not specified in the .conf file. This is
^            for 'start-time' configuration only.

---

#riak config describe VARIABLE
^            for a given setting, prints any documentation and other useful
^            information, such as affected location in app.config, datatype
^            of the value, default value, and effective value.

---

# SCRIPTING COMMANDS

---

# riak ertspath
^        Outputs the path to the riak Erlang runtime environment

---

# riak escript


^        Provides a means to call the `escript` application within the riak
^        Erlang runtime environment

---

# riak version
^        Outputs the riak version identifier

---

# riak getpid

^        Outputs the process identifier for a currently running instance of
^        riak.

---

# Basic administrative commands

```
[root@localhost ~]# riak-admin
Usage: riak-admin { 
          cluster | join | leave | backup | restore | test | 
          reip | js-reload | erl-reload | wait-for-service | 
          ringready | transfers | force-remove | down |
          cluster-info | member-status | ring-status | vnode-status |
          aae-status | diag | stat | status | transfer-limit |
          top [-interval N] [-sort reductions|memory|msg_q] [-lines N] |
          reformat-indexes  | downgrade-objects | security | 
          bucket-type | repair-2i | search | services |
          ensemble-status | handoff | set | show | describe }
```

---

* riak-admin cluster


* join <node>
* leave <node>
* replace <node1> <node2>

* force-remove <node>
* force-replace <node1> <node2>

* plan
* commit
* clear

---

# Rolling Restarts

* `riak-admin ringready` should report TRUE
* `riak-admin transfers` should not show any pending transfers for the current node
* `riak stop`
* `riak start`
* `riak-admin wait-for-service riak_kv`

---

# Upgrading Riak

* Verify Riak status (ringready / transfers)
* Install new package
* Make any required changes to configuration files
*  `riak stop`
*  `riak start`
*  `riak-admin wait-for-service riak_kv`
* Move to the next node

---

# LOGS

---

# Logs

* Log Configuration
* Log Files
* Common Error Messages

---

# Log Configuration

* /etc/riak/riak.conf

```
log.console = file
log.console.level = info
log.console.file = $(platform_log_dir)/console.log
log.error.file = $(platform_log_dir)/error.log
log.syslog = off
log.crash = on
log.crash.file = $(platform_log_dir)/crash.log
log.crash.maximum_message_size = 64KB
log.crash.size = 10MB
log.crash.rotation = $D0
log.crash.rotation.keep = 5
```

---

# Log Files

* /var/log/riak
* console.log
* crash.log
* error.log
* /var/lib/riak/leveldb/*/
* LOG
* LOG.old

^console.log: most useful log for consuming via Splunk for analysis 
^error.log: alert on any new message logged here 
^leveldb logs: best to glob all logs and look for the string “Compaction error” find /var/lib/riak/leveldb -name "LOG" -exec grep -H 'Compaction error' {} \; 
 

---

# Common Error Messages
erlang

* long_gc
* busy_dist_port
* Too many db tables
* {error, ePOSIXERROR}

^Long_gc: warning that garbage collection is taking too long.  An indication that your systems need more memory 
^Busy_dist_port: distributed Erlang was unable to open a connection to another node.  
^Usually indicates you need to increase +zdbbl in /etc/riak/vm.args 
^Too many db tables: Erlang was unable to allocate an ETS table.  Most often encountered when using Riak Search.  Increase ERL_MAX_ETS_TABLES in /etc/riak/vm.args. 
^{error, e___}: indicates the Erlang VM encountered a POSIX error when interacting with the OS.   
^Examples: enoent (no such file or directory) or emfile (exceeded allowed file descriptors)
 

---

# Common Error Messages

* Bitcask
* Failed to merge
* LevelDB
* Compaction error

^Failed to merge: one of your Bitcask data files is likely corrupted.  
^ Most common solution is to truncate the file 
^Compaction error: one of your LevelDB SST files is corrupt. 
^The corrupt partition will need to have leveled repair run on it, and should have KV repair run to ensure that there is no replica loss.
 

---

# Monitoring

---

# Monitoring

* System Metrics
* Riak Status
* Riak Metrics
* Tools

---

# System Metrics

---

# Riak Status

* Service Status
* `riak ping` or /ping
* `riak-admin test`
* `riak-admin ring-status`

---

# riak Status

```
$ riak ping
pong

$ curl http://127.0.0.1:8098/ping
OK

$ riak-admin test
Successfully completed 1 read/write cycle to 'riak@127.0.0.1'
```

---

# riak status

```
$ riak-admin ring status

================================== Claimant ===================================
Claimant:  'riak@127.0.0.1'
Status:     up
Ring Ready: true

============================== Ownership Handoff ==============================
No pending changes.

============================== Unreachable Nodes ==============================
All nodes are up and reachable
```

---

# Metrics

---

# riak-admin status

```
$ riak-admin status

1 minute stats for 'riak@127.0.0.1'

connected_nodes : []
consistent_get_objsize_100 : 0
consistent_get_objsize_95 : 0
consistent_get_objsize_99 : 0
consistent_get_objsize_mean : 0
consistent_get_objsize_median : 0
consistent_get_time_100 : 0
consistent_get_time_95 : 0
```

>> Also available as JSON formatted output from the HTTP `/stats` endpoint

^ Also available in JSON via HTTP interface at /stats
 

---

# Riak Multi-Datacenter Replication Metrics

^-   Also available in JSON via HTTP interface at /stats
 

---

# Monitoring tools

* Riak Enterprise
* SNMP
* JMX
* Riak Nagios
* http://github.com/basho/riak_nagios

---

# Riak Nagios

* `check_node «check name»`
* `node_up`
* `riak_kv_up`
* `file_handle_count`
* `leveldb_compaction (errors)`
* `riak_repl`

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

# Backups

---

# Backups

* Node Backups
* MDC Backup Clusters
* Data Export

---

# Node Backups

* Should be taken on a “cold” node
* Tools:
* filesystem snapshots
* rsync

^Snapshotting filesystems are recommended since there is an intrinsic indeterminism as you back up the cluster.   
^ This can be reduced by taking a rolling snapshot of the cluster and then backing up from the snapshots once the nodes are back running and taking data. 

---

# Node Backups

* /var/lib/riak
* any data directories outside of /var/lib/riak
* /etc/riak
* /usr/lib/riak/lib/basho-patches

---

# Restoring Node Backups

(with the same node name)

* Install Riak
* Restore the backed up files to the proper directories
* Start Riak
* Verify that the cluster sees the restored node using riak-admin member-status

---

# Restoring Node Backups

(with a new node name)

* Install Riak
* Restore the backed up files to the proper directories
* Update the riak.conf file to reflect the new node name
* Remove the contents of /var/lib/riak/ring
* Start Riak

---

# Restoring Node Backups

(with a new node name)

* Join the node to the cluster
* Mark the old node name ‘down’
* Use force-replace to transfer the ownership of the partitions on the old name to the new name
* Plan the changes to the cluster (verify that the expected changes will be made)
* Commit the changes (verify that the cluster sees the restored node using riak-admin member-status)

---

# MDC BACKUP CLusters

* With Riak Enterprise Edition, a backup cluster can be created
* Production cluster and backup cluster are kept in sync with MDC
* Replication is stopped, backup cluster is backed up in a rolling fashion
* Replication is restarted and a full-sync is initiated

---

# Data Export

* Purpose built applications can be used to query the cluster and dump data to backup files
* Riak Data Migrator https://github.com/basho-labs/riak-data-migrator

---

# Backends

---

# Backends

* Bitcask
* LevelDB
* Memory
* Multi

---

# Bitcask

* Strengths
* Low, predictable latency
* Windowed merges
* Supports object expiration
* Weaknesses
* All keys must fit in memory

---

# LevelDB

* Strengths
* Supports Secondary Indexes (2i)
* Data Compression
* Not bounded by memory
* Weaknesses
* Latency increases with data volume

---

# Memory

* Strengths
* Supports Secondary Indexes (2i)
* Supports object expiration
* Everything is in memory
* Weaknesses
* Everything is in memory

---

# MULTI

* Multi backend enables the use of one or more different backend configurations
* Different configurations of same backend can be allowed.  For example, a non-expiring Bitcask backend paired with an expiring one
* Resource demands are multiplied over number of backend instances

---

# Tips and Tricks

---

# Tips and Tricks

### DO...

* Use DNS names for your nodes
* Use KV GET/PUT as much as possible
* Use the Protocol Buffer API
* Load test frequently
* Familiarize yourself with the output of riak-debug
* Perform Disaster Recovery Exercises

---

# Tips and Tricks

### DON’T...

* Use JavaScript MapReduce
* Use Bitcask expiration with AAE or Riak Search
* Use Broadcom network interfaces :(
* Run on untuned nodes
* Fail to configure monitoring on your cluster

---

