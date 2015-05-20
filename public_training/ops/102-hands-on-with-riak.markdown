autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true

![fit](design-assets/Basho-Logos/eps/basho-logo-color-horiz.eps)

---


# Hands-on with Riak

---

# What we will cover 

* Install Riak
* A tour of the source and package directories
* Riak configuration files
* The ports, protocols and services Riak uses
* Basic commands
* Ingest some data to the cluster
* Perform simple GET, PUT, DELETE operations

---

# Installing 

Installation [script](http://bit.ly/1IQaLLX) for Centos 6.5

```

curl -L http://bit.ly/1IQaLLX > out.txt
source out.txt
```

^devnodes parameter 

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

# vm.args (legacy)

* `vm.args`
* `Erlang -name and -setcookie`
* `ERL_MAX_PORTS`
* `ERL_MAX_ETS_TABLES`
* `+zdbbl`

^ The vm.args file is used to configure the Erlang virtual machine. 
^ Examples of the types of configuration are provided.  
^ Review vm.args file with the group and point to http://www.erlang.org/documentation/doc-5.9.1/doc/ for more info on each tuning. 
^ -name: Makes the Erlang runtime system into a distributed node. This flag invokes all network servers necessary for a node to become distributed. Should be “something”@IP or “something”@FQDN 
^ -setcookie: A layer of security to prevent riak nodes being accidentally added to the wrong cluster 
^ ERL_MAX_PORTS = maximum number of erlang ports (like number of open files) 
^ ERL_MAX_ETS_TABLES = maximum number of ETS tables allowed 
^ +zdbbl - Set the distribution buffer busy limit (dist_buf_busy_limit) in kilobytes. 
^ Valid range is 1-2097151. Default is 1024. 

--- 

# vm.args (2.x)

Prefix arbitrary flags like so:

```
echo "erlang.distribution.net_ticktime=15" >> ./dev1/etc/riak.conf
```

[http://bit.ly/1LmMNru](https://gist.github.com/binarytemple/45af59df164ecc85c675)


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

# Riak configuration


^- show app.config in sublime text - explain each section is covered in more detail as we go through the training 


---

# Controlling Riak

Exercise [http://goo.gl/dF2RPp](http://goo.gl/dF2RPp)

---

# Configuring Riak


Exercise [http://goo.gl/4FiuLK](http://goo.gl/4FiuLK)

---

# Querying Riak

Exercise [http://goo.gl/r5ekmt](http://goo.gl/r5ekmt)


