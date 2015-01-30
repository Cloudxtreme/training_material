# Solutions Architect Training

## Day 1
====================================

### Overview
#### *9:00am-9:30am*

====================================

* Introductions
* Agenda Review
* Ground Rules
	* There will be time for questions at the end of each section, but feel free to interrupt as well if more detail is needed
* Ensure Required Tools are Installed
	* Riak 2.0 Downloaded: [http://docs.basho.com/riak/2.0.0/downloads/](http://docs.basho.com/riak/2.0.0/downloads/)
	* Either install Riak locally on machine, or use Vagrant ([http://www.vagrantup.com/](http://www.vagrantup.com/)) with an Ubuntu ([http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box](http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box)) image
* Audience Prior Knowledge of Riak
* Audience Goals for Training
	* More developer focused vs operations
	* Specific goals: Datamodeling techniques, backups, etc

### Riak 101: Intro to Riak
#### *9:30am-10:00am*

====================================

[https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20101%20-%20IntroToRiak.pptx](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20101%20-%20IntroToRiak.pptx)

* Properties of Riak
* APIs for Data Access
* Client Libraries

### Riak 102: Basic Anatomy
#### *10:00am-11:00am*

====================================

[https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20102%20-%20BasicAnatomy.pptx](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20102%20-%20BasicAnatomy.pptx)

* The Riak Object
* Buckets
* Bucket Types
* Node
* Cluster
* Operations

### Riak 201: Learning to Share
#### *11:00am-12:00pm*

====================================

[https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20201%20-%20LearningToShare.pptx](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20201%20-%20LearningToShare.pptx)

* Consistent Hashing
* Partitions
* Ring
* Hand-Offs

### Lunch
#### *12:00pm-1:00pm*

====================================

### Riak 201L: Lab
#### *1:00pm-2:00pm*

====================================

[https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20201L%20-%20BasicQuerying.pptx](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20201L%20-%20BasicQuerying.pptx)

* Demonstrate the following
	* Bring up Riak nodes
	* Join them into a cluster
	* Perform Riak operations against the cluster
	* Conduct a fault tolerance demo
* Hands-On
	* Repeat the demonstrated steps

### Riak 202A: Conflict and Resolution
#### *2:00pm-3:00pm*

====================================

[https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20202a%20-%20Conflicts%20and%20Resolution.pptx](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20202a%20-%20Conflicts%20and%20Resolution.pptx)

* Object replication
* N-Val
* Race conditions
* Resolution strategies:  time stamps, vector-clocks, siblings, strong consistency

### Riak 202B:  Quorums
#### *3:00pm-4:00pm*

====================================

[https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20202b%20-%20Quorum.pptx](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20202b%20-%20Quorum.pptx)

* Read and write
* Durable write
* Primary write

### Riak 202C: Replica repair
#### *4:00pm-5:00pm*

====================================

[https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20202c%20-%20Read%20Repair.pptx](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20202c%20-%20Read%20Repair.pptx)

* Read repair
* AAE

## Day 2
====================================

### Basic Operations
#### *9:00am-10:00am*

====================================

* [http://docs.basho.com/riak/latest/ops/building/basic-cluster-setup/](http://docs.basho.com/riak/latest/ops/building/basic-cluster-setup/)
* [http://docs.basho.com/riak/latest/ops/building/planning/system-planning/](http://docs.basho.com/riak/latest/ops/building/planning/system-planning/)
* [http://docs.basho.com/riak/latest/ops/building/configuration/](http://docs.basho.com/riak/latest/ops/building/configuration/)
* [http://docs.basho.com/riak/latest/ops/running/backups/](http://docs.basho.com/riak/latest/ops/running/backups/)

* Directories and what lives where
* How to backup and restore
* Deployment Tools
* Security

### Riak Indexing Techniques
#### *10:00am-11:00am*

====================================

* [http://docs.basho.com/riak/latest/dev/using/2i/](http://docs.basho.com/riak/latest/dev/using/2i/)
* [http://docs.basho.com/riak/latest/dev/using/search/](http://docs.basho.com/riak/latest/dev/using/search/)
* [http://docs.basho.com/riak/latest/dev/using/data-types/](http://docs.basho.com/riak/latest/dev/using/data-types/)
* [https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20basho%20academy%20slides/Term%20Based%20Indexing%20Slides.key](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20basho%20academy%20slides/Term%20Based%20Indexing%20Slides.key)

* 2i
* Search
* Term-based indexing
* CRDTs

### Access Patterns
#### *11:00am-12:00pm*

====================================

[https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20300%20-%20AccessPatterns.pptx](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20300%20-%20AccessPatterns.pptx)

* Scheduled vs spontaneous
* Static vs dynamic
* Map techniques to quadrants
* Strengths of weaknesses of access patterns
* Best practices and techniques for shifting use cases from one quadrant to another
* Sample case studies

### Lunch
#### *12:00pm-1:00pm*

====================================

### Advanced indexing use cases
#### *1:00pm-4:00pm*

====================================

* [https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20basho%20academy%20slides/Time%20Series%20Slides.key](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20basho%20academy%20slides/Time%20Series%20Slides.key)
* [https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20basho%20academy%20slides/Versioning%20Slides.key](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20basho%20academy%20slides/Versioning%20Slides.key)
* [https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20basho%20academy%20slides/Transaction%20Slides.key](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20basho%20academy%20slides/Transaction%20Slides.key)

* Time series
* Versioning and soft-deletes
* Highly available Transactions

### Basic CRUD with participant-preferred Riak Client
#### *4:00pm-5:00pm*

====================================

* [http://docs.basho.com/riak/latest/dev/using/libraries/](http://docs.basho.com/riak/latest/dev/using/libraries/)

## Day 3
====================================

### Use Case and Data Modeling Review
#### *9:00am-12:00pm*

====================================

* Time-Series
* Session Storage
* Shopping Cart / Product Data

### Lunch
#### *12:00pm-1:00pm*

====================================

### Review Professional Services Products
#### *1:00pm-5:00pm*

====================================

* Riak / Riak CS Implementation
* Riak Operations Training
* Riak Developer Training
* Use Case & Data Access Analysis
* Performance Assessment
* System Assessment (Health Check)
* Custom Services
* Block of Days

## Day 4
====================================

### Review
#### *9:00am-EOD*

====================================

* Question and Answer
* Revisit any areas of interest
