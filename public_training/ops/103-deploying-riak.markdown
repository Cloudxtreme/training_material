autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true

![fit](design-assets/Basho-Logos/eps/basho-logo-color-horiz.eps)

---


# Deploying Riak

---

# Deployment Considerations

* Where will the cluster be deployed?
* Is MDC and global distribution required?
* Virtual or Physical servers?
* Dedicated servers?
* Local disks? DAS? SAN?
* RAID 0 / RAID 1 / RAID 5 / RAID 6?
* Dedicated data drives?

---

# Deployment Considerations

* Is it a bounded data set?
* RAM to Disk Space ratio?
* Existing backup strategies?
* How is the load distributed/balanced?
* What features are needed? 2i? MR? TTL?
* What is expected growth? 3/6/12 months?

^Data set and RAM/Disk ratio may impact backend choice. How do backups work right now? Any changes for Riak? What does the architecture look like. 

---

# Deployment Considerations

* Existing configuration management system?
* Monitoring & Alerting?
* Networking topology and speed?

^Configure Riak with Ansible, Chef, Puppet? Github repos with samples. Zabbix, DataDog, Graphite? Get everything from OS and /stats endpoint and monitor over time. Riak clusters can heavily load a network. Test. 

---

# Example Architecture 1

^In this example the Web, App and Database layers can all scale independently. The LB layers could be the same hardware/software and handles App requests and Database requests in different ‘pools’ or groups. 

![inline fit](./103-deploying-riak/example-arch-1.png)

---

# Example Architecture 2

![inline fit](./103-deploying-riak/example-arch-2.png)

^In this scenario the application layer is inexpensive in terms of resource requirements and is tied to Riak in terms of availability. If the App or Riak becomes unavailable on the server, the load balancer layer must remove it. 

---

# Production Checklist

![inline fit](./103-deploying-riak/production-checklist.png)

^Provided by Basho Check the doc in the riak-ops repo 


