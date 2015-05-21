autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true

# Failure Scenarios

---

# Bitcask - Invalid hint files

```
2014-01-27 11:02:54.404 [error] <0.8667.0> Hintfile '/opt/riak/bitcask/1438665674247607560106752257205091097473808596992/2.bitcask.hint' invalid  
2014-01-27 11:08:43.675 [error] <0.8739.0> Hintfile '/opt/riak/bitcask/1438665674247607560106752257205091097473808596992/3.bitcask.hint' invalid  
2014-01-27 11:15:27.981 [error] <0.8816.0> Hintfile '/opt/riak/bitcask/1438665674247607560106752257205091097473808596992/4.bitcask.hint' invalid
```
---

# Bitcask - Invalid hint files

* Frequently it is quicker/easier to remove hint files rather than repair them
* Frequently cleaned up on restart 
* Rebuilt on merge

---

# Siblings & Large Objects

^Latency spikes Count reported in /stats but not bucket/key sibling-scanner and large object scanner script (basho patch) 

---

# Did something change?

^Node maintenance Ring configuration 

---

# Workshop.. lets break stuff

