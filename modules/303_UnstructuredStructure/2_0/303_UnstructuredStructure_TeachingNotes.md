# Unstructured Structure
*Teaching Notes*

---
######OUTSTANDING ISSUES:

+ needs first draft
+ needs review

<br>

## Teaching Goals

Students should understand:
+ what data modelling is
+ how data modelling in NoSQL is different from SQL
+ general principles of data modelling in Riak

<br>

## What is Data Modelling?

Let's start by making sure we understand what data modelling is. It sounds complex and highly technical, and sometimes it can be... but conceptually it's very simple. It's the way we choose to structure our data.

Let's look at an example. Suppose we have some contact data. Let's say that each contact has a name, a phone number and an email address. The job of the data model is to answer *how* each record is stored, and also *why* it should be stored that way.

Most databases have something called a `primary key`, which can be thought of as an ID. The vast majority of databases will allow you to retrieve a record if you specify its primary key. This isn't data modelling; it's database design.

The data modelling comes in when a choice must be made regarding what part of the record (if any) to use as its primary key. In our example, one quite naive choice would be to use the name of the contact as the primary key. In a way, that seems obvious, since that's usually how we want to look up a contact.

Unfortunately, most databases won't allow you to store contacts using a name as the primary key, because names are not always unique, and primary keys must be. So we've hit our first data modelling problem: what can we use as the primary key for our contact records?

Well... maybe email address is a better? Email addresses are unique, after all. But now there are more problems: email addresses can change, and people often have more than one. So if we do choose to key by email address, first we'll have to figure out a way to deal with these issues.

This is data modelling in a nutshell: understanding limitations and weighing options.

<br>

## Not Only SQL

In the SQL world, data modelling tends to focus on `normalisation`. This means breaking the data up into small, simple chunks, and building relations between these chunks by adding fields that contain pointers to related chunks. That's why most of these databases are called `Relational Databases`.

Normalisation is extremely useful for reducing the space the data occupies, because it abhors repetition. If an element is found to be repeated in multiple records, that element gets factored out into its own record, and every field that previously contained it now contains just a pointer to it.

But why should we normalise? In the past, disk space was expensive. This had two effects:

1. only really useful data was stored
2. data was stored as few times as possible

Hence, normalisation was the dominant force in data modelling. But now, the tables have turned, so to speak. Disk space is astoundingly cheap. We're not in the data revolution anymore... we're in the **Big Data** revolution. The new incentives are:

1. store all the data!
2. the more copies the better!

The reason people want to store more data is because they often believe they'll be able to draw more intelligent conclusions that way. This isn't always true, but in many cases it can be. Machine learning, in particular, requires vast amounts of data to draw effective inferences. Storing more copies of data is useful as well, both as a guard against data loss due to failure, and as part of data locality, meaning users are closer to their data and may therefore be able to access it faster.

Thus, normalisation has become less important.

On the other hand, there's also a big problem with normalisation. When you split data up, it implies that you must join it back together if multiple parts are requested. Tabular `joins` are one of the main features of SQL services, but unfortunately they can lead to poor performance, for example when joining by column.

Big data aggravates this performance issue. As data volumes balloon, tables grow very large and start needing to be broken up across multiple servers, making joins and even simple primary-key lookups expensive.

These are some of the reasons that NoSQL has become the vogue. In NoSQL, we tend to denormalise rather than normalise. In other words, we deliberately generate redundant data, not just physically but structurally. We do this to make reads and queries faster and easier, at the expense of increased data volume and potentially more complex writes.

In NoSQL, we don't devise structure from the data itself; rather we start from the queries, and build data models specifically designed to fulfil them.

<br>

## Data Modelling in Riak

Riak is a NoSQL Key-Value store. It is optimised for storing and retrieving objects by primary key, although it does also support secondary indexing and search via Solr.

If we were modelling the SQL way, we might use a hidden UUID as the primary key of each contact record. This is fine, and does work. In fact, most contact databases are done this way. But there's a problem with it.

The problem is we didn't start from the query. 99% of queries in a contact database will be by name, because that's what humans tend to remember when searching for someone's phone number or email address. Now, we certainly could make a secondary index of first names, and another one of last names, and use these for our lookup. This is also fine, and many very large user databases may actually do this.

Riak can do this too. However, if we found that performance wasn't good enough once we got to millions of records, Riak has a better option. We can actually store the data as lists of records keyed by name. We might even go so far as to store all the data twice: one set keyed by first name, another by last name. It has to be lists, because people do share the same name from time to time.

Go ahead and open the contacts app on your phone, if you have one. Do a search for a very popular name, e.g. "John". Assuming you have more than one "John" in your contacts, you will be presented with a list of them. So why not just store the data that way?! It's not efficient for storage... but it's ideal for retrieval!

In Riak, we prefer Key-Value to cover our hotspots, because it's the most performant way to get data. But KV can't cover everything. Let's say we want to see everyone who works at a certain company in our contacts list. We don't want to build a whole new set of data for this, because the query is rare. So, instead, we will index these fields. Riak has several built-in mechanisms to do this, including a strong integration with Apache Solr, one of the most widely-used open-source search engines.

One important limitation to bear in mind when using Riak is object size. Riak gossips a lot amongst its nodes, so smaller objects are preferred to keep the pipes unblocked. The suggestion is to keep most objects smaller than 1MB. Most use-cases won't require objects this big, but for those that do, one solution is to break objects up as needed to keep size down. For really large objects the recommendation is to use Riak Simple Storage (RiakS2) instead of RiakKV. This is a storage engine designed for objects from 1MB up to petabyte size, but has different performance characteristics than RiakKV.

So, at the end of the day, we have to weigh the available options, consider the specifics of our use cases, and try to predict the access patterns expected for those cases. This is the foundation of data modelling.

<br>







