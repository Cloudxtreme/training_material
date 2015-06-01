autoscale:true 
footer: © Basho Technologies, 2015
slidenumbers: true

---

# CRDT Exercise

---
Start a Riak 2.0 cluster consisting of 2 nodes.

First set up bucket types (note you can name these as you like for your domain (and add other properties)

    $ rel/riak/bin/riak-admin bucket-type create maps '{"props":{"datatype":"map"}}'
    maps created
    $ rel/riak/bin/riak-admin bucket-type create sets '{"props":{"datatype":"set"}}'
    sets created
    $ rel/riak/bin/riak-admin bucket-type create counters '{"props":{"datatype":"counter"}}'
    counters created

---

Then activate the new bucket types

    $ rel/riak/bin/riak-admin bucket-type activate counters
    counters has been activated
    $ rel/riak/bin/riak-admin bucket-type activate sets
    sets has been activated
    $ rel/riak/bin/riak-admin bucket-type activate maps
    maps has been activated
 
---

Example of how to use counters

```bash
    $ curl -X GET localhost:8098/types/counters/buckets/foo/datatypes/bar
    {"type":"counter","error":"notfound"}
    $ curl -X POST localhost:8098/types/counters/buckets/foo/datatypes/bar -H"content-type: application/json" -d 1
    $ curl -X GET localhost:8098/types/counters/buckets/foo/datatypes/bar
    {"type":"counter","value":1}
```
---

Example of how to use a set

    $ curl -X POST localhost:8098/types/sets/buckets/foo/datatypes/bar -H"content-type: application/json" -d \
    '{"add_all":["joel", "richard", "louise", "todd", "matt"]}'

    $ curl -X GET "localhost:8098/types/sets/buckets/foo/datatypes/bar?include_context=false" | json_pp
  
    {
        "value" : [
            "joel",
            "louise",
            "matt",
            "richard",
            "todd"
        ],
        "type" : "set"
    }

---

    $ curl -X POST localhost:8098/types/sets/buckets/foo/datatypes/bar -H"content-type: application/json" -d '{"remove_all":["todd", "matt"]}'

---

    $ curl -X GET "localhost:8098/types/sets/buckets/foo/datatypes/bar?include_context=false" | json_pp
    {
        "value" : [
            "joel",
            "louise",
            "richard"
        ],
        "type" : "set"
    }

---

Example show how to use a map with a nested structure

    $ curl -X POST localhost:8098/types/maps/buckets/foo/datatypes/bar -H"content-type: application/json" -d '{"update":{"gold_counter":100, "stone_counter": 50}}'

    $ curl -X GET localhost:8098/types/maps/buckets/foo/datatypes/bar
    {
        "type": "map",
        "value": {
            "stone_counter": 50,
            "gold_counter": 100
        },
        "context": "TQEAAAAf.....2wAAAABaAJhAWECag=="
    }

---

    $ curl -X POST localhost:8098/types/maps/buckets/foo/datatypes/bar -H"content-type: application/json" \
    -d '{
       "update": {
            "gold_counter": -6,
            "stone_counter": -7,
            "weapons_set": {
                "add_all": [
                    "sword",
                    "dagger",
                    "bazooka"
                ]
            }
        }
    }'

---

    $ curl -X GET localhost:8098/types/maps/buckets/foo/datatypes/bar | json_pp
    {
        "type": "map",
        "value": {
            "weapons_set": [
                "bazooka",
                "dagger",
                "sword"
            ],
        "stone_counter": 43,
        "gold_counter": 94
    },
    "context": "TQEAAAA0g2wAAAAC......hAWoNg2wAAAABaAJhAWEFag=="
    }

---

    $ curl -X GET "localhost:8098/types/maps/buckets/foo/datatypes/bar?include_context=false" | json_pp
    {
        "type": "map",
        "value": {
            "weapons_set": [
                "bazooka",
                "dagger",
                "sword"
            ],
            "stone_counter": 43,
            "gold_counter": 94
        }
    }

---

Example showing nested map structure

    $ curl -X POST localhost:8098/types/maps/buckets/foo/datatypes/bar -H"content-type: application/json" -d '
    {
        "update": {
            "gold_counter": -6,
            "stone_counter": -7,
            "weapons_set": {
                "remove_all": [
                    "bazooka"
                ]
            },
            "attributes_map": {
                "update": {
                    "health_counter": 70,
                    "xpos_counter": 640,
                    "ypos_counter": 480,
                    "acheivements_set": {
                        "add_all": [
                            "head shot",
                            "level 10"
                        ]
                    }
                }
            }
        }
    }'

---

    $ curl -X GET "localhost:8098/types/maps/buckets/foo/datatypes/bar?include_context=false" | json_pp
    {
        "value" : {
            "weapons_set" : [
                "dagger",
                "sword"
            ],
            "attributes_map" : {
                "xpos_counter" : 640,
                "health_counter" : 70,
                "ypos_counter" : 480,
                "acheivements_set" : [
                    "head shot",
                    "level 10"
                ]
           },
           "stone_counter" : 36,
           "gold_counter" : 88
        },
        "type" : "map"
    }

---

Just update a potion of the sub-map (eg player position moved)

    $ curl -X POST localhost:8098/types/maps/buckets/foo/datatypes/bar -H"content-type: application/json" -d \
    '{
        "update": {
            "attributes_map": {
                "update": {
                    "xpos_counter": -10,
                    "ypos_counter": 36
                }
            }
        }
    }'

---

    $ curl -X GET "localhost:8098/types/maps/buckets/foo/datatypes/bar?include_context=false" | json_pp
    {
        "value" : {
            "weapons_set" : [
                "dagger",
                "sword"
            ],
            "attributes_map" : {
                "xpos_counter" : 630,
                "health_counter" : 70,
                "ypos_counter" : 516,
                "acheivements_set" : [
                   "head shot",
                   "level 10"
                ]
            },
            "stone_counter" : 36,
            "gold_counter" : 88
        },
        "type" : "map"
    }

---


Example showing use of registers and booleans

    $ curl -X POST localhost:8098/types/maps/buckets/foo/datatypes/bar -H"content-type: application/json" -d \
    '{
         "update": {
             "name_register": {
                 "assign": "boris"
             },
             "alive_flag": "enable"
         }
     }'
 
 ---

Now remove `stone` 
 
    $ curl -X POST localhost:8098/types/maps/buckets/foo/datatypes/bar -H"content-type: application/json" -d '{"remove": "stone_counter"}'
 
    $  curl -X GET localhost:8098/types/maps/buckets/foo/datatypes/bar?include_context=false | json_pp
    {
        "value" : {
            "weapons_set" : [
                "dagger",
                "sword"
            ],
            "attributes_map" : {
                "xpos_counter" : 630,
                "health_counter" : 70,
                "ypos_counter" : 516,
                "acheivements_set" : [
                    "head shot",
                    "level 10"
                ]
            },
            "alive_flag" : true,
            "name_register" : "boris",
            "gold_counter" : 88
        },
        "type" : "map"
    }
