# Backup & Restore

^60 MINUTES 

---

# Backup Methods

* Node Backups
* MDC Cluster Backup
* Data Migrator

---

# Node Backups

* rsync
* snapshots
* dir copy for Bitcask and eLevelDB
* GETs for memory backend
* Multi - specific approach per backend

---

# Node Backups - Data & State directories

* /var/lib/riak/ 
    - *bitcask/ 
    - *leveldb/ 
    - *merge_index/ 
    - *ring/ 
    - *anti_entropy/

^Bitcask & eLevelDB - Because of the log structured file format, you just copy the ring and data directories 

---

# Node Backups - Node configuration (1.4)

* /etc/riak
    - app.config
    - vm.args

---

# Node Backups - Node configuration (2.x)

* /etc/riak
    - riak.conf

---

# Node Backups - Riak Patches

* /usr/lib/riak/lib/basho-patches

---

# Restoring Node Backups

1. Install Riak
2. Restore Riak directories
3. (rename ring dir)
4. Join node to cluster
5. Mark old node down 
6. Replace old node with new node

---

# Restoring Node Backups

1. `riak-admin cluster join riak@riak6.example.com`
2. `riak-admin down riak@riak1.example.com`
3. `riak-admin cluster force-replace riak@riak1.example.com riak@riak6.example.com`
4. `riak-admin cluster plan`
5. `riak-admin cluster commit`

^Join new node to any existing, cluster node 
^Mark the old instance down 
^Force-replace the original instance with the new one 
^Display and review the cluster change plan 
^Commit the changes to the cluster

---

# MDC Cluster Backup

---

# Data Migrator

* [http://github.com/basho/riak-data-migrator](http://github.com/basho/riak-data-migrator)  
* Java tool to export and import data
* Easy to use: $ java -jar riak-data-migrator-0.2.6.jar [options]
