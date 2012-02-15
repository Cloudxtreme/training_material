# AT&T Silver Lining Reference #

## Deployment Overview (riak, MOSS, haproxy, pound, nagios) ##

Each storage node runs four services: pound, MOSS, HAProxy and Riak EDS. We'll discuss them from the top down.

## DYNECT ##
DYNECT is used to resolve the following domains

** data.attstorage.com **
** *.data.attstorage.com **

**NOTE**: There

## Pound ##
Used to manage SSL certificates, and redirect traffic to MOSS on port 8080. It is configured to listen on the external IP of the storage node on port 443.

## MOSS Overview ##
MOSS is Riak's S3 interface. It implements the S3 API for Riak. It is only accessible from the outside via Pound. 

#### Current Status ####
MOSS currently bypasses HAProxy, due to an issue with large files. 

## HAProxy ##
Used to load balance Riak EE. Compute applications will access Riak via these HAProxy instances which redirect to Riak running on the same host. If that host's instance of Riak is down, HAProxy then redirects traffic evenly to the other nodes in the cluster. HAProxy listens on 10.0.0.0/8 interfaces on ports 8098 and 8087 which are the ports Riak traditionally listens on.

## Riak EDS ##
Riak EDS is running on each node, and listening on ports 8198 (HTTP) and 8187 (Protocol Buffers). It listens on the eth0, and all connections from the Compute layer come in via HAProxy

## Nagios (Riak related scripts) ##
[riak\_nagios GitHub repo](https://github.com/basho/riak_nagios)

Deployed to /usr/lib/riak\_nagios

`check_riak` is a shell script wrapper for available riak tests.

Nagios is also configured to fire an alert if any of the following processes are not running on a storage node: pound, epmd, haproxy, memsup, cpu\_sup, beam.smp, and run\_erl

### NPRE ###
Sample entries in `/etc/nagios/npre.cfg`
```
command[check_pound]=/usr/lib/nagios/plugins/check_procs -w 2:3 -c 1:5 -C pound
command[check_epmd]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C epmd
command[check_haproxy]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C haproxy
command[check_memsup]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C memsup
command[check_cpu_sup]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C cpu_sup
command[check_beam.smp]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C beam.smp
command[check_run_erl]=/usr/lib/nagios/plugins/check_procs -c 1:5 -C run_erl
command[check_riak_up]=/usr/lib/riak_nagios/check_riak up 
command[check_riak_end_to_end]=/usr/lib/riak_nagios/check_riak end_to_end localhost 8098 riak 
command[check_riak_repl_to_remote_site]=/usr/lib/riak_nagios/check_riak repl server remote_site-on-local_site
command[check_riak_repl_from_remote_site]=/usr/lib/riak_nagios/check_riak repl client local_site-on-remote_site
```


