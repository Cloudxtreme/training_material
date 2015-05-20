autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true

![fit](design-assets/Basho-Logos/eps/basho-logo-color-horiz.eps)

---

# Monitoring

^If it moves, watch it. 

---

# Monitoring

* Riak Health
* Riak Metrics
* System Metrics
* Thresholds
* Tools
* Alerting

---

# Riak Health

* riak@node:~$ riak ping
* pong
* riak@node:~$ riak-admin test
* Successfully completed 1 read/write cycle to ‘riak@node.example.com’

---

# Riak Health

* riak@node:~$ riak-admin ring_status
* =========================== Claimant =============================
* Claimant:  ‘riak@node.example.com’
* Status:     up
* Ring Ready: true
* ======================= Ownership Handoff ========================
* No pending changes.
* ======================= Unreachable Nodes ========================
* All nodes are up and reachable

---

# Riak Metrics

* riak@node:~$ riak-admin status
* 1-minute stats for ‘riak@node.example.com’
* -------------------------------------------
* riak_kv_stat_ts : 1396505566
* vnode_gets : 87324
* vnode_gets_total : 12387621
* vnode_puts : 13572
* vnode_puts_total : 1625343
* vnode_index_refreshes : 1278
* vnode_index_refreshes_total : 18726
* vnode_index_reads : 9826421
* vnode_index_reads_total : 347214
* …

---

# Riak Metrics

![inline fit](./106-monitoring-and-logging//riak-metrics-1.png)

^Trend things over time 

---

# Riak Metrics

![inline fit](./106-monitoring-and-logging//riak-metrics-2.png)

^Stack certain graphs to get a clearer picture 

---

# System Metrics

* CPU
* Disk IO
* Disk Space
* File Descriptors
* Memory
* Network
* Swap

---

# System Metrics

![inline fit](./106-monitoring-and-logging//system-metrics.png)

^Trends help you spot issues 

---

# Thresholds

* CPU: 75% x num_cores
* Memory: 65% utilization
* Swap: >0% used
* File Descriptors: 75% of ulimit

---

# Alerting

* console.log messages
* Sibling explosion
* Object size
* GET and PUT latencies
* Replication issues

---

# Tools

* Your favourite/existing monitoring software
* Zabbix templates
* Nagios plugins

---

# Logging

---

# Logging Configuration

* {lager, [    {handlers, [        {lager_file_backend, [           {"/var/log/riak/error.log", error, 10485760, "$D0", 5},           {"/var/log/riak/console.log", info, 10485760, "$D0", 5}        ]},        {lager_syslog_backend, ["riak", daemon, info]}    ]},

---

# Logging Configuration

* {crash_log, "/var/log/riak/crash.log"},
* {crash_log_msg_size, 65536},
* {crash_log_size, 10485760},
* {crash_log_date, "$D0"},
* {crash_log_count, 5},

---

# Common Log Files

* console.log
* error.log
* crash.log
* /var/lib/riak/leveldb/*/LOG

---

# Common Error Messages

* Erlang
* long_gc
* busy_dist_port
* emfile
* {error, e____}
* Posix errors: http://erldocs.com/R15B/kernel/inet.html

^Long_gc - use less memory, or increase the memory settings in your app.config Busy_dist_port - erlang buffers are full; increase zdbbl setting in vm.args Too many db tables Emfile - hit the ulimit 

---

# Erlang Errors

* {error,duplicate_name}
* {error,econnrefused} / {error,ehostunreach}
* {error,eacces}
* {error,enoent}
* {error,erofs}
* system_memory_high_watermark

^{error,duplicate_name} - duplicate name already running / multiple nodes on same machine with same vm.args -name value / Riak is already running, check for beam.smp. / epmd thinks Riak is running, check/kill epmd {error,econnrefused} / {error,ehostunreach} - Ensure your cluster is up and nodes are able to communicate with each other (check connections and setcookie etc) {error,eacces} - Ensure the riak beam process has permission to write to all *_dir values in app.config, for example, ring_state_dir, platform_data_dir, and others. {error,enoent} - Missing an expected file or directory - check app.config *_dir {error,erofs} - A file/directory is attempted to be written to a read-only filesystem System_memory_high_watermark- Often a sign than an ETS table has grown too large - is vnode count reasonable ? (measured in dozens per node rather than hundreds). 

---

# Monitoring Logs

* Lager supports syslog
* Log rotate and look for errors & warnings
* Logstash?
* Splunk?


