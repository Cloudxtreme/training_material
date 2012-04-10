## Excercises ##

### Crash and Erlang Process ###

Clear out your logs folder (You should know where that is)

Launch a Riak console: `riak console`

In the console`erlang:whereis(riak_core_node_watcher) ! crazy_talk.` What you're doing here is sending the node_watcher a message that it is not intended to handle.

This crashes an Erlang process, but not the Erlang VM. What files do you expect to have entries? Go look!

### Crash the Erlang VM ###

Clear out your log folder again and start riak.

Sure, it's easy to kill a process, but to get the VM to crash, we'll need a `kill -usr1`. Kill your riak process.

What do you expect to see? Compare the contents of your log files.
