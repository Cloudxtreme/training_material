# Riak Technology Deep Dive

Advanced topics covering conflict resolution concepts, Solr integration, and Multi-Data Center Replication.

### Relational / Consistent Data vs. Eventually Consistent Data

A good primer on moving from Relational to Riak can be found here: [http://basho.com/assets/RelationaltoRiakDEC.pdf](http://basho.com/assets/RelationaltoRiakDEC.pdf). It is a little outdated with regard to missing new features found in Riak 2.0.

* Why Migrate to Riak?
  * The Requirement of High Availability
    * Relational databases tend to favor consistency over availability, making them ill suited for
applications that require high availability
    * CAP Theorem states that you must have partition tolerance, and you can only choose Consistency OR Availability, not both
    * Typical scaling of relational systems involves sharding based on some category such as region. In the event of a master failure, slaves can still serve reads, but writes are unavailable since consistency can not be guarenteed.
  * Minimizing the Cost of Scale
    * Scaling a relational database to handle more data and usage can be prohibitively expensive
for operators.
    * Problems with sharding:
      * Increased operational and development overhead with logic that splits data
      * Manually resharding is a pain when data shape changes significantly
      * Determining logic to shard data is not trivial. How do you deal with the "Bieber Problem" (hotspots)?
      * Rapid growth often outpaces sharding strategies leading to potential downtime
    * The Riak ring distributes data evenly
      * Image: [https://github.com/basho/training_material/tree/master/unsorted/ps%20dev%20training/sample%20agendas/presales_tech_talk/riak-ring.png](https://github.com/basho/training_material/tree/master/unsorted/ps%20dev%20training/sample%20agendas/presales_tech_talk/riak-ring.png)
  * Simple Data Models
    * The relational data model can be needlessly complex and inflexible for certain types of
applications.
    * Relational datastores do have features that many developers find important and some usecases simply won't work without them
    * However; There has also been an increasing demand for the ability to store unstructured "big data" with the emergence of social and mobile applications
* Tradeoff Decisions
  * Eventual Consistency
    * Normal Riak does not support strictly consistent operations, however it does provide tunable quorums on a per bucket or per request basis (R, W, PR, PW, DR, DW)
    * Riak 2.0 also introduces Strong consistency which uses a multi-paxos variant algorithm to determine consensus on a value which sacrifices some availability
    * Nodes may leave or join a cluster at anytime due to intentional or unintentional scenarios (node failures, network partitions)
    * Riak still strives to accept reads and writes no matter what the state of the cluster
    * Furthermore, the data will eventually converge to a consistent state across all of the nodes using built-in mechanisms such as hinted handoff and read-repair
    * Riak has no locks and allows simultaneous writes which is not a problem for many applications, but conflicts can occur and should be accounted for using a variety conflict resolution strategies
  * Data Modeling
    * Riak’s design does not support the richer data types and model of traditional relational systems
    * There are no join operations, columns / rows, SQL-like language
    * There are, however, Datatypes (CRDTs), Search (Solr), Secondary Indexes (2i), and Map/Reduce
* Development considerations
  * Resolving Data conflicts
    * In any system that replicates data, conflicts can arise – for example, if two clients update the same object at the exact
same time; or if not all updates have yet reached hardware that is experiencing lag.
    * Data is always available in Riak, but at any given point in time, it is possible for one or more of the replicas to have a stale version of that data. Generally the time that data is inconsistent because of the normal transfer of replicas between nodes is on the order of milliseconds while state changes are synchronized
    * Casual Context
      * Previously "Vector Clocks," now "Dotted Version Vectors" or (DVVs) are used to determine the newest version of an object.
      * Stored as metadata with the object
      * When a read request is performed, Riak asks for all replicas for that object and looks at the context to find the latest version; As long as a quorum of vnodes agree on the value of that data, Riak happily returns the correct value
      * If there are disagreements, Read Repair is triggered to fix outdated partitions
      * Clients are also allowed to manually resolve conflicts through the use of siblings if your use-case requires it
      * More information can be found at [http://docs.basho.com/riak/latest/theory/concepts/context/](http://docs.basho.com/riak/latest/theory/concepts/context/)
