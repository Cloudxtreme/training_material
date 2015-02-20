# Intro to Riak
*Teaching Notes*

---
######OUTSTANDING ISSUES:


<br>

## Teaching Goals

+ to define what Riak is at the highest level
+ to tell Riak's core story
+ for each story promise, to:
	1. explain what it means
	2. justify its importance from a business perspective
	3. mention some key features that fulfil it

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
+ the ops-friendly database
+ why do I want an ops-friendly database?
	+ the vast majority of the cost of a database is in operational support over its lifetime
	+ the dangerous failures are the unexpected ones that only appear once the database is operating in a production environment
+ how easy is Riak to operate?
	+ distributes your data for you
	+ re-distributes your data for you when you scale
	+ replicates your data for you locally and globally
	+ resolves your data for you if it is changed concurrently
	+ repairs your data for you if it gets out of sync or corrupted
	+ holds and returns your data for you no matter how many nodes go down
	+ AND...
	+ up-to-the-minute stats
	+ rolling-restarts for upgrading
	+ built-in diagnosis & debug tools
	+ 24/7 paid support with 30 minute SLAs (but actually we respond in 5)

##High Availablity
+ availability unaffected by heavy load or multiple node failure
+ global availability for enterprise customers


##Fault Tolerance
+ masterless operation means there is no single point of failure
+ permanent node failure without data loss
+ full cluster failover

##Horizontal Scalability
+ concurrent operations for a linear performance increase as you scale

##Low Latency
+ order of milliseconds
+ one hop request routing
+ split clusters and tune each one to optimize for each access pattern you support
 


---
