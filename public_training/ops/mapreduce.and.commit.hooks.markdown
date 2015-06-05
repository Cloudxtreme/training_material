# MapReduce

---

# What is MapReduce?

* A way to query your data in advanced ways
* Parallel processing based on data locality - no quorum read
* Batch oriented processing framework

---

# When to Use?

* When you know the set of objects you want to MapReduce over
* When you want to return actual objects or pieces of the object
* When you need utmost flexibility in querying your data.

---

# When Not to Use?

* When you want to query data of an entire bucket. Better suited for smaller well defined data sets.
* When you want low and/or predictable latency.
* For real-time queries/processing

---

# How Does It Work?

* Processing is split into one or more chained phases
* 2 types of phases: Map and Reduce 
* Map phases work on individual records. Runs where the data resides
* Reduce phases work recursively on collections of data

---

# MapReduce Processing

---

# Processing Distribution

---

# MapReduce Functions

* Implemented in JavaScript or Erlang
* Named or anonymous
* Pools of SpiderMonkey JavaScript VMs
* Erlang recommended for heavy production use

---

# Map Phases

* Works on single object instance
* Executes where data is located
* Used for:
* Filtering
* Data extraction/processing

---

# Map Phase Functions

* Takes 3 arguments:
* Object - Internal Riak Object
* KeyData - Custom data that can be passed with record between map phases.
* Arg - Argument supplied when specifying the map/reduce job. 

---

# Map Phase Functions

* Must return a list of:
* Bucket/Key
* Bucket/Key/Keydata
* Formatted data - Only when followed by a reduce phase

---

# Reduce Phases

* Work with a list of results
* Executes recursively
* Executes on coordinating node
* Used for: aggregating, sorting, limiting

---

# Reduce Phase Functions

* Takes 2 arguments
* Values - List of values from previous phase and/or iteration
* Arg - Argument supplied when specifying the map/reduce job.
* Must return a list of results

---

# Reduce Phase Functions

* Must be able to handle re-reduce
* No indication of when last data is processed
* Reduce functions must be commutative, associative, and idempotent. F([a,b,c,d]) == F([F([a,c]),F([b]),F([d])])

---

# Running MapReduce


---

# MapReduce Inputs

* Bucket/Key List, possibly with Keydata
* Bucket
* Secondary Index Query
* Search Query
* Key Filter

---

# MapReduce Example

* Count records in a bucket

curl -XPOST http://localhost:8098/mapred 
  -H 'Content-Type: application/json' 
  -d '{"inputs":"testbucket",
       "query":[{"reduce":{"language":"erlang",
                           "module":"riak_kv_mapreduce",
                           "function":"reduce_count_inputs"
                          }}],
       “timeout”:60000}'

---

# Writing MapReduce Functions in Erlang

* riak_object contains all data related to the object
* riak_object functions are specified in riak_kv/src/riak_object.erl
* Erlang mapreduce examples: riak_kv/src/riak_kv_mapreduce.erl

---

# Map Phase Function

---

# Reduce Phase Function

---

# Deploying Map/Reduce Functions

* Specify location of module in app.config (add_paths / js_source_dir)
* Reload using riak-admin erl-reload / riak-admin js-reload
* Always deploy on all nodes

---

# Commit Hooks

---

# What are Commit Hooks

* Automatically triggered when objects are updated, inserted or deleted.
* Registered and enabled per bucket.
* Triggered on PUT FSM

---

# Pre-Commit Hooks

* Can be written in Erlang or JavaScript. Erlang recommended for production.
* Triggers before object written to Riak.
* Can alter object before write
* May fail request

---

# What Is It Used For?

* Modifying object
* Adding data to object
* Validating object
* Logging 
* Notifying other systems

---

# Erlang Example

%% Limits object values to 5MB or smaller
precommit_limit_size(RiakObject) ->
    case erlang:byte_size(riak_object:get_value(Object)) of
      Size when Size > 5242880 -> 
          {fail, "Object is larger than 5MB."};
      _ -> 
          RiakObject
    end.

RiakObject to be written as input. May indicate a delete through the ‘X-Riak-Deleted’ metadata

Returns failure with custom error message

Returns riak_object to be written on success

---

# JavaScript Example

function validateJSON(object){
  // A delete is a type of put in Riak so check and see what this
  // operation is doing and pass over objects being deleted
  if (obj.values[0]['metadata']['X-Riak-Deleted']){
    return obj;
  }

  try {
    Riak.mapValuesJson(object);
    return object;
  } catch(e) {
    return {"fail":"Object is not JSON"};
  }
}

---

# Post-Commit Hooks

* Must be written in Erlang
* Triggers outside request path
* Does not affect latencies

---

# What Is It Used For?

* Notification of external systems, e.g. via Web Service or Message Queue
* Record Audit information
* Logging

---


