# Basic Anatomy
*Teaching Notes*

---
######OUTSTANDING ISSUES:

+ needs review

<br>

## Teaching Goals

Students should understand:
+ the constitution of Riak's core storage protocol, the Riak Object
+ what buckets and bucket types are, and what they are not
+ that Riak distributes objects into partitions, nodes and clusters

<br>


##Riak Object

The riak object is the core unit of storage in riak. The riak object consists of three parts: the identifier, the causal-context, and the contents.

###Identifier
+ when you PUT a blob of data into Riak, you must supply an identifier;
+ there are several ways to GET that same blob of data back later on, but the fastest and simplest way is to tell Riak what the identifier is
+ in its simplest form, the identifier consists of a unique string of characters which is called the **key**
+ optionally, the identifier can also include a bucket and bucket-type; if you do not supply these Riak assumes you wish to use the default bucket and bucket-type
+ we'll talk more about buckets and bucket-types in a minute

###Causal-Context
+ causal-context is an opaque term that represents the distributed update history of the object
+ having it around helps your data remain consistent
+ we'll talk more about it in future modules

### Contents
+ the contents are where the **value** is stored
+ the **value** is your blob of data, your payload
+ riak is value-agnostic, so you can put whatever kind of data you want into objects; riak doesn't care
+ each value in the contents may optionally have some metadata associated with it
+ usually, there will only be one value-metadata pair in each contents
+ if there is more than one, we say the object has siblings
+ we'll talk more about siblings in future modules

Here's an example of a Riak Object:

identifier: employee_1
<br>causal-context: a85hYGBgzGDKBVIcypz/foaqyN7JYEpkymNlUFk88xxfFgA=
<br>contents: [{{"firstName":"John","lastName":"Doe"},[]}]

<br>

##Buckets

As discussed previously, riak object identifiers may include the name of the bucket to which the object belongs, and the bucket-type of that bucket. But what is a bucket in riak?

+ buckets are logical groupings of riak objects; they allow a group of objects to share many of riak's configuration settings
+ buckets are NOT physical groupings of objects on machines
+ buckets are NOT tables of objects that share the same schema; riak doesn't have schema
+ some elements of buckets are defined at the bucket-type level; each bucket belongs to exactly one bucket-type (the default one if none is specified)
+ buckets and bucket-types form part of the object identifier, along with the key
+ two different objects are permitted to share the same key if either their bucket or bucket-type are different
+ therefore, buckets *can* be used as namespaces, but this is not their raison d'être; namespaces can just as easily be included in the key, for example: "employees-00127"

<br>

##Distribution

For a database to be useable at scale, it has to be distributed. Computers only get so big, and any one computer in a single location is a single point of failure. But there are lots of ways to go about distribution, some smarter than others. Let's look at how Riak does it.

+ riak objects are stored in **partitions**
 + when using disk-based storage (as opposed to in-memory storage), partitions can be viewed in the filesystem as folders
 + partitions are named by long numbers, e.g. 22835963083295358096932575511191922182123945984 (find out why later!)
+ partitions are in turn distributed amongst **nodes**
 + each node is an instance of the Riak application running in the Erlang Virtual Machine
 + each node should be run on a dedicated computer such that hardware failures don't affect more than a single node at a time
 + if you are running riak on a cloud service like AWS or Rackspace, guarantees should be sought that the virtual machines don't share the same underlying hardware
+ nodes join together to form a **cluster**
 + in riak all nodes in a cluster must have extremely low latency between them because they need gossip a lot
 + therefore, nodes in a cluster are almost always in the same physical datacentre
+ to achieve global availability, fault tolerance, and disaster recover, you can even join clusters together that are in different physical locations using Riak's enterprise feature, MDC. We sometimes call these clusters of clusters, but a better name is **superclusters**.

##Summary

So in summary, from big to small, Riak's basic anatomy looks like this:

+ supercluster
+ cluster
+ node
+ partition
+ object

Buckets and bucket-types are not on this list, because they separate objects by configuration, and don't have anything directly to do with where the data is distributed. But we can say that they are defined at the cluster level, and are not shared amongst clusters in a a supercluster.
<br>

