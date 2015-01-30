# Advanced Operations Training

* Ensure Required Tools are Installed
	* Riak 2.0 Downloaded: [http://docs.basho.com/riak/2.0.0/downloads/](http://docs.basho.com/riak/2.0.0/downloads/)
	* Either install Riak locally on machine, or use Vagrant ([http://www.vagrantup.com/](http://www.vagrantup.com/)) with an Ubuntu ([http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box](http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box)) image

### Riak 201: Learning to Share

[https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20201%20-%20LearningToShare.pptx](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20201%20-%20LearningToShare.pptx)

* Consistent Hashing
* Partitions
* Ring
* Hand-Offs

### Riak 201L: Lab

[https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20201L%20-%20BasicQuerying.pptx](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20201L%20-%20BasicQuerying.pptx)

* Demonstrate the following
	* Bring up Riak nodes
	* Join them into a cluster
	* Perform Riak operations against the cluster
	* Conduct a fault tolerance demo
* Hands-On
	* Repeat the demonstrated steps

### Riak 202C: Replica repair

[https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20202c%20-%20Read%20Repair.pptx](https://github.com/basho/riak-training/blob/master/ps%20dev%20training/source%20ppt%20slides/Riak%20202c%20-%20Read%20Repair.pptx)

* Read repair
* AAE

### Deployment / Configuration Management

[http://docs.basho.com/riak/latest/ops/building/planning/system-planning/](http://docs.basho.com/riak/latest/ops/building/planning/system-planning/)
[http://docs.basho.com/riak/latest/ops/building/configuration/](http://docs.basho.com/riak/latest/ops/building/configuration/)

* Cuttlefish
* Tools (Ansible, Chef, Puppet)
* Security
* Capacity Planning
* Rolling Upgrades

### Backup / Disaster Recovery

[http://docs.basho.com/riak/latest/ops/building/basic-cluster-setup/](http://docs.basho.com/riak/latest/ops/building/basic-cluster-setup/)
[http://docs.basho.com/riak/latest/ops/running/backups/](http://docs.basho.com/riak/latest/ops/running/backups/)

* Directories and What Lives Where
* Rolling Backups
* Partial Cluster Failure Recovery
* Disaster Recovery

### Performance Tuning

* Cloud / VM Configuration
* Bare Metal Configuration
* Understanding and Tuning the Erlang VM
* Operating System Tuning
* Benchmarking

### Monitoring

* Nagios
* Hosted Services
* Troubleshooting

### Multi-datacenter Replication

* Setting it Up
* Dealing with Strongly Consistent and Search Data
