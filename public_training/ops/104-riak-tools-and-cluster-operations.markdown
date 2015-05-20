autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true

![fit](design-assets/Basho-Logos/eps/basho-logo-color-horiz.eps)

---

# Riak Tools & Cluster Operations

---

# Tools: riak-admin

---

# test

* ## performs a read/write test against the cluster
* riak@node:~$ riak-admin test
* Successfully completed 1 read/write cycle to ‘riak@node.example.com’

^Runs a test of a few standard Riak operations against the running node. 

---

# js-reload

* Forces the embedded Javascript virtual machines to be restarted

^Forces the embedded Javascript virtual machines to be restarted.  This is useful when deploying new custom built-in MapReduce functions.  (This needs to be run on all nodes in the cluster.) 

---

# wait-for-service

* ## useful for scripting to check when backend is ready riak@node:~$ riak-admin wait-for-service riak_kv riak@<nodename>

^Waits on a specific watchable service to be available (typically riak_kv). This is useful when (re-)starting a node while the cluster is under load. Use “services” to see what services are available on a running node. 

---

# ringready

* ## checks if all nodes in the cluster agree on the ring state
* riak@node:~$ riak-admin ringready

^Checks whether all nodes in the cluster agree on the ring state.  Prints “FALSE” if the nodes do not agree.  This is useful after changing cluster membership to make sure that ring state has settled. 

---

# transfers

* ## checks for ownership or partition handoff
* riak@node:~$ riak-admin transfers
* ## example output
* Active Transfers: 'dev5@127.0.0.1' waiting to handoff 39 partitions 'dev4@127.0.0.1' waiting to handoff 39 partitions 'dev3@127.0.0.1' waiting to handoff 38 partitions 

^Identifies nodes that are awaiting transfer of one or more partitions.  This usually occurs when partition ownership has changed (after adding or removing a node) or after node recovery. 

---

# transfer-limit

* Change the handoff_concurrency limit
* Limited from 2-8
* Affects node performance of other ops
* Remember to change it back

---

# cluster-info

* ## output information from all nodes to /tmp/cluster_info.txt
* riak@node:~$ riak-admin cluster_info /tmp/cluster_info.txt
* ## output information from the current node
* riak@node:~$ riak-admin cluster_info /tmp/cluster_info.txt local
* ## output information from a subset of nodes
* riak@node:~$ riak-admin cluster_info /tmp/cluster_info.txt riak@192.168.1.10 riak@192.168.1.11

^dumps cluster state to files not the kind of command you would run regularly useful when submitting any support requests to basho 

---

# member-status

* Prints the current status of all cluster members

---

# ring-status

* Ring ready
* Ownership handoff
* Unreachable nodes

^Outputs the current claimant, its status, ringready, pending ownership handoffs and a list of unreachable nodes. Claimant: When a new node joins an existing cluster, it throws away it's existing ring and replaces it with a copy of the ring from the target cluster, thus joining into the same cluster history. 

---

# vnode-status

* Per vnode information
* Backend file information

^Outputs the status of all vnodes running on the local node 

---

# aae-status

* Exchanges
* Entropy Trees
* Keys Repaired

---

# diag

* ## checks riak configuration and performs some system diagnosis riak@node:~$ riak-admin diag
* ## example output
* [critical] vm.swappiness is 60, should be no more than 0 [critical] net.core.wmem_default is 229376, should be at least 8388608 [critical] net.core.rmem_default is 229376, should be at least 8388608 [critical] net.core.wmem_max is 131071, should be at least 8388608
* [notice] Data directory /var/lib/riak/bitcask is not mounted with 'noatime'. Please remount its disk with the 'noatime' flag to improve performance.

---

# status

* One-minute stats
* GETs & PUTs: mean, median, 95/99/100%
* FSM times
* GET FSM siblings
* Totals
* Erlang CPU & memory statistics
* Miscellaneous information & versions

^GET_FSM_Sibling Stats offer a count of the number of siblings encountered by this node on the occasion of a GET request. GET_FSM_Objsize is a window on the sizes of objects flowing through this node's GET_FSM.  The size of an object is obtained by summing the length of the bucket name, key, the serialized vector clock, the value, and the serialized metadata of each sibling. Totals - since node restart 

---

# top

* ## check cpu, memory usage and message queues in the erlang vm
* riak@node:~$ riak-admin top [-interval N] [-sort reductions|memory|msg_q] [-lines N]

^Top provides information about what the Erlang processes inside of Riak are doing.  Top reports process reductions (an indicator of CPU utilization), memory used and message queue sizes 

---

# Basic Commands

* riak-admin { test | ringready | member-status | ring-status | status }
* riak-admin cluster { join | leave | replace | plan | commit }

^exercise 04: clustering riak cluster management test: write and read from riak wait-for-service - check riak_kv backend ringready: check nodes agree on ring state diag: system diag against node - useful for system tuning status: node status report 

---

# Tools: riak-debug

^We cover this in more detail in the troubleshooting section 

---

# Cluster Operations

---

# Riak Cluster Operations

* http://goo.gl/89gx7e

---

# Rolling Restarts

* riak-admin ringready # should report true
* riak-admin transfers # should NOT show pending transfers
* riak stop
* riak start
* riak-admin wait-for-service riak_kv
* ## move to next node

^any node, any order 

---

# Upgrading Riak

* riak-admin ringready # should report true
* riak-admin transfers # should NOT show pending transfers
* riak stop
* ## install new package
* ## make any app.config changes
* riak start
* riak-admin wait-for-service riak_kv
* ## move to next node

^When installing Riak on RHEL-based systems, use `yum install` rather than `rpm –Uvh` to avoid dependency issues 

---

# Transfers & Transfer-Limit

* When a node is unavailable, fallbacks are used
* When a node re-joins the ring hinted-handoff transfers occur
* Transfer-limit governs how quickly this happens 

^- Use riak-ops curl scripts with a node down  - Start node and walk through transfer behaviour - Show adjusting transfer-limit and explain why this may be useful 

---

# Adding Nodes

* ## configure the new node
* riak start
* riak-admin cluster join riak@<existing_node>
* riak-admin cluster plan
* riak-admin cluster commit
* ## wait for ownership handoff to complete
* watch -n 1 "riak-admin transfers"

^- Point out that scaling up should be done in groups of nodes if possible, rather than one at a time 

---

# Removing Nodes

* ## connect to the node being removed
* riak-admin cluster leave
* ## or request another node leave
* riak-admin cluster leave riak@node6
* ## plan and commit
* riak-admin cluster plan
* riak-admin cluster commit
* ## wait for ownership handoff to complete
* watch -n 1 "riak-admin transfers"

---

# Replacing Nodes

* Backup data directory
* Install and start Riak on new node
* Plan the join of the new node to the cluster
* Plan the replacement of the existing node with the new node 
* Plan and commit changes

---

# Renaming Nodes

* Changing a nodes name or IP address can be done without cluster impact
* Down the first node (node1a)
* Mark down from a different node (node2)
* Edit vm.args and app.config (node1a)
* Rename the ring directory (node1a)
* Start the node and join to cluster (node1b)
* Force replace node1a with node1b

^e.g. moving the cluster to a new ip range 

---

# Force-Replace a Node

* ## if a node is completely unresponsive e.g hardware failure
* riak-admin cluster force-replace riak@<node4> riak@<node7>


