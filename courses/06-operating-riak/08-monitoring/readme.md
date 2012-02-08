# Monitoring #

## Stats! ##
Remember Stats? They're useful in monitoring.

## OS Level ##
### free ###
`free` is a command that will help you monitor a physical node's memory usage

Here's some sample output

```
             total       used       free     shared    buffers     cached
Mem:       3772692    3136556     636136          0     208416    1471592
-/+ buffers/cache:    1456548    2316144
Swap:      1048572      23008    1025564
```

If that's too hard to read, there are options `-b,-k,-m,-g show output in bytes, KB, MB, or GB`

### df & du ###
`df` will tell you how much space is available on a particular mount point, or all mount points if given without arguments

`du` will tell you how much space each file is using. `du -s` will not recurse into directories

### lsof ###
`lsof | wc -l` -> How many open file handles do I have?

## Aggregation Tools ##
Many of these utilities are very good for debugging, but for monitoring an environment, 

### Nagios ###
If you can get the information you need at the command line, you're pretty close to having a nagios check

### Graphite ###
[Graphite](http://graphite.wikidot.com/) - The new hotness in graphing data

### Splunk ###
[Splunk](http://www.splunk.com/) Operational Intelligence by monitoring, reporting and analyzing real-time machine data.