# Use Case / Performance Assessment

Following is a loose agenda and goals for Basho Professional Services Use Case / Performance Assessment.

### Overview

====================================

* Introductions
* Agenda review
* Determine prior knowledge and experience with Riak
* Annotate specific pain points with Riak and/or client level interactions with Riak
* Discuss audience goals for the engagement
  * Improve client application performance
  * Improve Riak cluster performance
  * Learn advanced datamodeling techniques
  * Technical deep dive for specific Riak features and best practices
  * Production cluster monitoring and best practices
  * Etc

### Use Case

====================================

* Review use case and system architecture as a whole
* In-depth review of Riak integration points and any other storage system integrations
* Code walkthrough
* Annotate all data access patterns / queries / indexes and data models used

### Configuration

====================================

* Inspect overall system architecture and health
* Hardware / VM capacity
* Inspect Riak configuration and review performance implications
  * Cluster setup
  * Backend settings
  * Merge / Compaction settings
  * Erlang VM settings
  * AAE settings
* Inspect system configuration
  * Operating system specific tunings
  * Scheduler
  * Filesystem
  * Network
  * Memory
* Inspect network configuration
  * Firewall
  * Security
  * Nodename DNS
  * Network interfaces for internal / external traffic

### Benchmarking

====================================

* Define performance and scalability goals / requirements for each system component
* Design and implement basho_bench configuration / scripts to accurately simulate previously annotated data models and access patterns against Riak
* Install one or more basho_bench instance(s)
* Run tests to determine baseline information about the existing system
  * Max operations per second
  * Max concurrent connections
  * CPU and Memory footprint under load
* Iterate over any configuration, data model, access pattern, or application changes and annotate performance delta until performance goals for engagement are met
  * Assist with application / configuration changes by implementing changes to codebase as necessary
  * Implement patches to Riak if necessary

### Training

====================================

* Review high level development and operatations training topics
* Deliver training and in-depth discussion for modules of interest as audience schedules permit
* Riak 2.0 feature deep dive
  * Datatypes (Server side CRDTs)
  * Search (Solr/Yokozuna)
  * Strong Consistency
  * Security
* Data modeling concepts
  * Term based inverted indexes
  * Pure K/V indexing techniques for massive scale
  * Client side CRDTs
  * Timeseries
  * Secondary indexes

### Deliverables

====================================

* Develop and deliver report with the following topics covered
  * Tasks accomplished / Goals achieved
  * Benchmark results
  * Recommended alternative or new approaches not implemented on-site