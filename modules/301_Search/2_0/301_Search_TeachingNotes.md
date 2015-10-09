# Search
*Teaching Notes*

---
######OUTSTANDING ISSUES:

+ needs first draft
+ needs review

<br>

## Teaching Goals

Students should understand:
+ what search is, why it matters and how it works
+ what Solr is and why we chose it
+ why Riak + Solr is greater than the sum of its parts (Yokozuna in EVM, Solr in JVM)
+ how to use Solr

<br>

###What Is Search?

In a key-value datastore, the paradigmatic way to retrieve data is by key. But sometimes this isn't good enough. We may not know the key of the data we want to find, or we may want to find data based upon other properties or combinations of other properties. This is what search is for. Search is how we find data when we don't already know the keys of the items we wish to find.

<br>

###How Does Search Work?

Effective search has two sides to it. On the write-side, it's all about creating indexes. On the read-side, it's a matter of running queries against those indexes.

Let's look at a standard example. A contact record might be keyed by a unique ID. This is better than keying by name because people often share the same name.

However, when we search for a contact, we have a problem: we don't know what the ID is. We only know the name. Unfortunately, in a simple key-value store, knowing the contact's name doesn't help retrieve the rest of the contact data, because there is no link between names and IDs. To find all contacts that have the specified name by brute force, it would be necessary to retrieve every single entry in the entire database, and check to see what the name was.

This is a prohibitively expensive operation. What is needed is an **index**, linking each name to a list of IDs of contacts who are so named. With such an index, it becomes computationally inexpensive to search by name.

The main difficulty of indexes is creation and maintenance. As new contacts are added, the new IDs must be added to the indexes atomically. Otherwise, the indexes and objects will become out of sync, and the indexes will need to be repaired. Further problems arise when working in a highly-available distributed system, because there are no guarantees of strong consistency against which to build distributed atomicity.

The goal of Riak Search is to solve these problems.

<br>

###How Does Riak Search Work?





