# Riak CS Architecture

# Riak CS Architecture (basic)


      +------------------+
      |                  |
      |     Riak CS      |
      |                  |
      |                  |
      +---+----------+---+
          |          |
          |          |
          |          v
          |      +---+--------------+
          |      |                  |
          |      |    Stanchion     |
          |      |                  |
          |      |                  |
          |      +---+--------------+
          |          |
          |          |
          v          v
       +--+----------+----+
       |                  |
       |      Riak        |
       |                  |
       |                  |
       +------------------+

# What is Riak?

* Fault Tolerant
* Highly Available
* Key/Value Store

# What is Riak CS?

* Large File Storage
* Based on S3

# What is Stanchion?

* Serialization Point
* Required for Certain Operations

## What Requests Require Serialization?

* User Creation
* Bucket Creation
* Bucket ACL Modification

## What if Stanchion Fails?

* Can't Create New Users
* Can't Create New Buckets
* Can't Modify Bucket ACLs

# Riak CS Architecture (data.attstorage.com)

             +---------------+   +---------------+
             |               |   |               |
             |  Stud (SSL)   +--->    HAProxy    |
             |               |   |               |
             +---------------+   +-------+-------+
                                         |
           +-----------------------------v-----------------------------+
           | +----------------+  +----------------+ +----------------+ |
           | |                |  |                | |                | |
           | |     Riak CS    |  |     Riak CS    | |     Riak CS    | |
           | |                |  |                | |                | |
           | +----------------+  +----------------+ +----------------+ |
           +-----------------------------------------------------------+
                                     |         |
                                     |      +--v-------------+
                                     |      |                |
                                     |      |   Stanchion    |
                                     |      |                |
                                     |      +--+-------------+
                                     |         |
                                  +--v---------v---+
                                  |                |
                                  |     HAProxy    |
                                  |                |
                                  +-------+--------+
                                          |
           +------------------------------v-------------------------------+
           | +----------------+   +----------------+   +----------------+ |
           | |                |   |                |   |                | |
           | |      Riak      |   |      Riak      |   |      Riak      | |
           | |                |   |                |   |                | |
           | +----------------+   +----------------+   +----------------+ |
           +--------------------------------------------------------------+
