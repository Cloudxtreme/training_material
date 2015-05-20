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

# Installing from source

* ## install erlang - R15B01
* ## download OSS source $ git clone https://github.com/basho/riak.git
* ## checkout version 1.4.10
* $ cd riak $ git checkout riak-1.4.10
* ## make release
* $ make rel
* ## or make development release (DEVNODES defaults to 5) $ make devrel DEVNODES=N

^devnodes parameter 

---

# Installing from package

* ## copy Enterprise Edition release package to node
* ## install deb (Debian/Ubuntu)
* $ sudo dpkg -i riak-ee_1.4.10-1_amd64.deb
* ## or install rpm (RedHat/CentOS)
* $ rpm -Uvh riak-ee-1.4.10-1.el6.x86_64.rpm

---

# Files and Locations

* /etc/riak/ |_app.config |_vm.args

---

# Files and Locations

* /usr/lib/riak/ |_erts-5.9.1/ |_lib/ |_lib/basho-patches/ |_releases/

^Erts-*: Erlang distribution. Erlang is bundled with Riak to reduce hunting for dependencies. Lib: Riak libraries Lib/basho-patches: directory where hot patches reside Releases: specifies run time module versions for Riak at various installed Riak versions 

---

# Files and Locations

* /var/lib/riak/ |_anti_entropy/ |_bitcask/ |_leveldb/ |_merge_index/ |_riak_repl/ |_ring/ 

^Anti_entropy: leveldb store for anti-entropy trees Bitcask: bitcask data files separated into directories by vnode leveldb: leveldb data files separated into directories by vnode Merge_index: backend storage for search indexes riak_repl: replication data (key list comparison files) Ring: contains the Riak core ring file, a dbase3 file that is communicated between nodes to share the cluster state as well as extra shared info, such as repl status 

---

# Files and Locations

* /var/log/riak/ |_console.log |_crash.log |_erlang.log |_error.log |_run_erl.log

^Console.log: all Erlang console output (debug file) Crash.log: Erlang stack traces from crash events Erlang.log: Error.log: error-level output only from Erlang console Run_erl.log: record of the runtime parameters Riak was started with 

---

# Files and Locations

* /usr/sbin/ |_riak |_riak-admin |_riak-debug |_riak-repl

^riak: useful to start/stop/ping riak riak-admin: primary cluster control script riak-debug: for troubleshooting, zips up lots of useful info at script runtime for further analysis riak-repl: similar to riak-admin but for managing MDC configuration and status 

---

# Riak configuration

* app.config
* Ports & Endpoints
* Active Anti-Entropy
* Javascript VM settings
* Riak Search
* Backends
* Log settings

^- show app.config in sublime text - explain each section is covered in more detail as we go through the training 

---

# Ports Protocols & Services

^Epmd is an Erlang name server used to associate symbolic node names to machine addresses 6000-7999 is an example of a configured port range in the Riak app.config used for inter-node communication between Erlang VMs 8099 is used for transferring partitions during handoff The Riak HTTP client listens on port 8098 The Riak Protocol Buffers client listens on port 8087 

---

# Erlang VM configuration

* vm.args
* Erlang -name and -setcookie
* ERL_MAX_PORTS
* ERL_MAX_ETS_TABLES
* +zdbbl

^The vm.args file is used to configure the Erlang virtual machine. Examples of the types of configuration are provided.  Review vm.args file with the group and point to http://www.erlang.org/documentation/doc-5.9.1/doc/ for more info on each tuning. -name: Makes the Erlang runtime system into a distributed node. This flag invokes all network servers necessary for a node to become distributed. Should be “something”@IP or “something”@FQDN -setcookie: A layer of security to prevent riak nodes being accidentally added to the wrong cluster ERL_MAX_PORTS = maximum number of erlang ports (like number of open files) ERL_MAX_ETS_TABLES = maximum number of ETS tables allowed +zdbbl - Set the distribution buffer busy limit (dist_buf_busy_limit) in kilobytes. Valid range is 1-2097151. Default is 1024. 

---

# Basic Commands

* riak { start | stop | restart | reboot | ping | console | attach }

^Start: starts riak Stop: stops riak Restart: restarts Riak while leaving the Erlang VM running. Does not apply vm.args changes. Think of it as a “riak reload” Reboot: DOESN’T WORK. Should stop Riak AND the Erlang VM, then start Riak again. Think of it as a normal “restart” Ping: runs an Erlang RPC ping against the Erlang VM to ensure it is loaded and accepting requests. Does not confirm Riak is fully loaded. Console: starts riak and places you within the Erlang console. Useful for debugging startup errors. Attach: remote-shell with access to Riak. Use Ctrl-c a or Ctrl-c Ctrl-c to exit. Attach-direct: direct-shell like `riak console` 

---

# Controlling Riak

* http://goo.gl/dF2RPp

---

# Configuring Riak

* http://goo.gl/4FiuLK

---

# Querying Riak

* http://goo.gl/r5ekmt


