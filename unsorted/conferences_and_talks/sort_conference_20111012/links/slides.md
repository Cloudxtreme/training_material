!SLIDE bullets incremental

# Links

* Declared in the "Link" metadata
* Lightweight relationships, like \<a\>
* Includes a "tag"
* Built-in traversal op ("walking")

!SLIDE

# Examples

!SLIDE small

# Create several Person objects

	@@@ javascript
        for NAME in dan grant sean mark; do
            curl -i http://localhost:8098/riak/person/$NAME \
                 -XPUT \
                 -d "{\"name\":\"${NAME}\"}" \
                 -H 'Content-Type: application/json'
        done

!SLIDE small

# Create a Team object

	@@@ javascript
        curl -i http://localhost:8098/riak/team/basho \
         -XPUT \
         -d '{"name":"Basho"}' \
         -H 'Content-Type: application/json' \
         -H 'Link: </riak/person/dan>; riaktag="da"' \
         -H 'Link: </riak/person/sean>; riaktag="da"' \
         -H 'Link: </riak/person/grant>; riaktag="da"' \
         -H 'Link: </riak/person/mark>; riaktag="cm"'

!SLIDE small

# Walk to Person objects

	@@@ javascript
        curl http://localhost:8098/riak/team/basho/person,_,_

.notes Returns dan, grant, sean, and mark Person objects

!SLIDE small

# Walk to Person objects tagged 'da'

	@@@ javascript
        curl http://localhost:8098/riak/team/basho/person,da,_

.notes Returns dan, grant, and sean Person objects
