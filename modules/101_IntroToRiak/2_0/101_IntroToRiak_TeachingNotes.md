# Intro to Riak
*Teaching Notes*

---
######OUTSTANDING ISSUES:
+ needs review


<br>

## Teaching Goals

+ to define what Riak is at the highest level
+ to tell Riak's core story
+ for each story point, to:
	1. explain what it means
	2. justify its importance from a business perspective
	3. mention some key related features

<br>


##What is Riak?

+ a database
	+ software you run on computers
		+ maybe they are sitting in your office
		+ maybe they are in the cloud
		+ maybe they are virtual machines
		+ doesn't matter!
	+ lets you store & retrieve information
	+ effectively & efficiently for your use-case
+ there are lots of databases out there... so what's special about Riak?

<br>

##Core Story

+ simple to operate
+ highly available
+ fault tolerant
+ horizontally scalable
+ low-latency

Also:
+ serviced (by Basho)
+ supported (by the community)

<br>

##Operational Simplicity
+ Riak is the ops-friendly database
+ why do I want an ops-friendly database?
	+ the vast majority of the cost of a database is in operational support over its lifetime
	+ the dangerous failures are the unexpected ones that only appear once the database is operating in a production environment
+ how easy is Riak to operate?
	+ distributes your data for you using Consistent Hashing
	+ re-distributes your data for you when you scale, in a balanced way
	+ replicates your data for you locally, and globally using Multi-Datacenter Replication
	+ resolves your data for you if it is changed concurrently using logical clocks and other means
	+ repairs your data for you if it gets out of sync or corrupted using Read Repair and Active Anti-Entropy
	+ holds and returns your data for you no matter how many nodes go down thanks to Sloppy Quorum
	+ AND...
	+ up-to-the-minute stats
	+ rolling-restarts for upgrading
	+ built-in diagnosis & debug tools
	+ 24/7 paid support with 30 minute SLAs (but actually we respond in 5)

##High Availability
+ means users can perform operations even when there are problems, e.g.
	+ nodes are taken down for maintenance
	+ nodes go down due to errors
	+ network partitions divide the cluster
	+ hardware fails permanently
	+ entire datacenters go offline
+ why do I want high-availability?
	+ our most important users are the most exposed, because they are the heaviest users of the database
	+ at scale, even remote possibilities affect large numbers of people; this impacts reputation
+ how highly available is Riak?
	+ thanks to replication and sloppy quorum, Riak remains highly available even when suffering:
		+ heavy load
		+ multiple node failure
		+ network partitions
	+ Riak also supports global availability for enterprise customers via MDC


##Fault Tolerance
+ the system expects faults, and is able to keep running safely despite them
+ why do I care?
	+ because at scale, faults are *always* occurring somewhere
	+ we want to deal with problems when resources are available, rather than be forced to deal with them immediately
+ how is Riak fault tolerant?
	+ written in Erlang, a programming language invented to support reliability (and was the foundation of the nine-nines uptime of the Ericsson AXD301 telecoms switch)
	+ masterless ring permits operation with no single point of failure
	+ permanent node failure without data loss
	+ self-healing thanks to hinted-handoff, conflict resolution, read-repair and active-anti-entropy
	+ if you use MDC, you can even do full cluster failover

##Horizontal Scalability
+ means you can scale the performance of your database by adding more machines to the cluster, instead of replacing slower machines with faster ones
+ aka scaling out, instead of scaling up
+ why do you want to scale?
	+ because you want to grow... more customers, more compute power
+ why do you want to scale out instead of up?
	+ using smaller machines results in less wasted compute power
	+ powerful machines are single points of failure
	+ eventually computers don't get any faster
+ how does Riak scale?
	+ performance increase improves linearly with more nodes
	+ double your cluster size, get double the performance
	+ works because any node can handle any request, so you benefit from concurrency
	+ from an operational standpoint, adding nodes is a one-line operation

##Low Latency
+ this is how long it takes one operation to complete
+ why is latency important?
	+ some use-cases demand real-time response
	+ lower latencies result in a more efficient, cheaper system overall
+ how fast is Riak?
	+ order of milliseconds
+ how is this possible in a distributed system?
	+ consistent hashing provides one hop request routing from the coordinator to the target node, resulting in a total of two hops up and two down
	+ you can configure your R-val to be less than 3, so that coordinators don't wait for all three responses before returning the value
	+ choose your storage backend to suit your use-case:
		+ Bitcask journals writes for fantastic write performance
		+ LevelDB stores data in levels for quick access to frequently-requested data
	+ with MDC, you can split clusters and tune each one to optimize for individual access patterns separately


---
