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
+ supports KV
  + String operations: GET, SET, DEL
    + Content-Type inference for Riak Search integration
+ upcoming support for DT
  + Counter
  + Set
  + Sorted Set
  + Hash
