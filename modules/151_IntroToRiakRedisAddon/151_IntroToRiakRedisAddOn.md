# Intro to Riak Redis Add-on
*Teaching Notes*

---
###### Outstanding Issues:
+ needs review

## Teaching Goals
+ to define what Riak Redis Add-on (RRA) is at the highest level
+ to tell the Riak Redis Add-on's core story
+ for each story point, to:
  1. explain what it means
  2. justify its importance from a business perspective
  3. mention some key related features

## What is the Riak Redis Add-on?
+ a distributed caching layer
  + using Riak KV for clustered, masterless persistence
  + using Redis for cache
  + run either distributed or local to the (typically web) application(s)

## Core Story
+ reduce latency
  + for immutable data
  + for infrequently-updated data
  + for frequently-updated data
+ riak + redis + rra
  + an AP system
  + with near CP speed near the edge
+ remain coherent
  + there are multiple ways to implement cache coherence, even locally for CPU
  and RAM
  + while writing applications, achieve more coherent code by using components
+ community-based development
  + based on Twemproxy
    + scalable
      + developed and employed at Twitter
      + uses and contributed to OSS
    + simple to operate
      + simple to configure
      + stateless
      + monitorable
    + Redis-aware
      + connection aggregation
      + presharding
      + command pipelining
    + speaks the Redis protocol
  + extended by Basho
    + embedded cache strategy for Riak KV
    + Riak-aware
      + sibling resolution
      + avoid sibling explosion
+ typical deployments
  + local cache deployment
    + advantage: moves Redis near the application
    + disadvantage: Redis is memory-hungry
    + disadvantage: cache writes on one application server do not lead to cache
    writes on other application server, so ...
      + "thundering herd" effect is not mitigated
      + aggregate cache hit ratio is less than distributed deployments
  + colocated cache deployment
    + advantage: increases cache hit rate, compared to local cache deployment
    + advantage: moves Cache Proxy and Redis near to Riak KV nodes
    + disadvantage: Redis is memory-hungry
    + disadvantage: fewer Redis nodes than Riak KV nodes are typically required
    + disadvantage: data locality can be achieved initially, but is difficult
    to maintain during faults, so cross-server communication is likely
  + distributed cache deployment
    + advantage: increases cache hit rate, compared to local cache deployment
    + advantage: keeps Cache Proxy near the application
    + advantage: moves memory-hungry Redis to distinct servers, friendly for
    horizontal scaling
    + disadvantage: Redis is farther from application servers
+ supports KV
  + String operations: GET, SET, DEL
    + Content-Type inference for Riak Search integration
+ upcoming support for DT
  + Counter
  + Set
  + Sorted Set
  + Hash
