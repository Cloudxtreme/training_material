# Querying Riak

* Primary Key (already covered)
* Link Walking
* Secondary Indexing
* Full-Text Search
* MapReduce

# Example: Link Walking

Store several people
Store a team object with links to the people
Retrieve the people by walking the links
Store another team object
Store an organization object
Walk to the people from the organization through the teams

# Example: Secondary Indexes

Store several contacts with an account index
Look up contacts by account (e.g. account: basho)

# Example: Full-Text Search

TODO

# Example: MapReduce

TODO

Mention use cases per feature (2i, FT, MR, etc)

# Demo

Todo list
Login via Twitter
Manage a list of todos
Kill a node
Continue modifying the list
Restore the node
Continue modifying the list
Fake a netsplit
 stop riak_repl
 make changes in the different data centers
 start riak_repl
 refresh the list
