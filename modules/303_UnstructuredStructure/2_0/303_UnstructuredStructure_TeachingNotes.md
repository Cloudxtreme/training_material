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
+ specifics of how data is modelled in some common use-cases

<br>

## Data Is as Data Does

Let's start by making sure we understand what data modelling is. It sounds complex and highly technical, and sometimes it can be... but the idea itself is very simple: it's the way we choose to structure our data.

Let's look at an example. Suppose we have some contact data. Let's say that each contact has a name, a phone number and an email address. The job of the data model is to answer *how* each record is stored, and also *why* it should be stored that way.

Most databases have something called a `primary key`. It's the usual way you look up the data when you want to retrieve it. This isn't data modelling: it's just how most databases work.

However, the choice of what part of the data (if any) to use as the primary key for each record is part of data modelling. In our example, the naive choice is to use the name of the contact. In a way, that seems obvious, since that's usually how we want to look up a contact.

Unfortunately, most databases won't allow you to store contacts this way, because names are not always unique, and primary keys must be. So we've hit our first data modelling problem: what can we use as the primary key of our contacts?

Well, maybe email address is a better idea. Email addresses are unique, after all. But now there are more problems: email addresses can change, and people often have more than one. So if we do choose to key by email address, first we'll have to figure out a way to work around these issues.

This is data modelling in a nutshell: weighing options; dodging problems; fearing the future.

<br>

## More Than Just SQL

In the SQL world, data modelling tends to focus on `normalisation`. This means breaking the data up into small, simple chunks, and building relations between these chunks by adding fields that contain pointers to related chunks. That's why these databases are called `Relational Databases`.

Normalisation is extremely useful for reducing the space the data occupies, because it abhors repeating itself. If an element is found to be repeated in multiple records, that element gets factored out into its own record, and every field that previously contained it now contains just a pointer to it, usually in the form of its primary key.

In the past, disk space was expensive. This had two effects:

1. only really useful data was stored
2. data was stored as few times as possible

Hence, normalisation was the dominant force in data modelling. But these days the tables have turned, so to speak. Disk space is astoundingly cheap. We're not in the data revolution anymore... we're in the **Big Data** revolution. The new incentives are:

1. store all the data!
2. the more copies the better!

TODO

<br>

## Data Modelling in Riak

TODO

<br>

## Use Cases

TODO

<br>






