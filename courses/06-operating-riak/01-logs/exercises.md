## Excercises ##

### Crash and Erlang Process ###

Clear out your logs folder (You should know where that is)

Launch a Riak console: `riak console`

In the console`erlang:whereis(riak_kv_vnode_master) ! crazy_talk.` What you're doing here is sending the vnode_master a message that it can't handle.

This crashes an Erlang process, but not the Erlang VM. What files do you expect to have entries? Go look!

### Crash the Erlang VM ###

Clear out your log folder again and start riak.

Sure, it's easy to kill a process, but to get the VM to crash, we'll need a `kill -usr1`. Kill your riak process.

What do you expect to see? Compare the contents of your log files.