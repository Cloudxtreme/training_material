#!/bin/bash
b=shell_counters1
k=my_counter
h="localhost:8098"
 
#curl -XPUT "$h/buckets/$b/props" -H 'Content-Type: application/json' -d '{ "props":{ "allow_mult" : true } }'
#curl -XPUT "$h/buckets/$b/props" -H 'Content-Type: application/json' -d '{ "props":{ "allow_mult" : true, "dvv_enabled" : true } }'
#curl -XPUT "$h/buckets/$b/props" -H 'Content-Type: application/json' -d '{ "props":{ "allow_mult" : true, "dvv_enabled" : false } }'
 
 
url="localhost:8098/buckets/$b/keys/$k"
 
 
 
curl -XPUT $url -d "1"
 
while true; do
  echo "#### PRE ####"
  if $(curl -s $url|grep Siblings: > /dev/null); then
    echo "Siblings: "
    for vtag in `curl -s $url|grep -v Siblings:`; do
      val=$(curl -s $url?vtag=$vtag)
      echo "[$vtag]: $val"
    done
  else
    echo "No Siblings: $(curl -s $url)"
  fi
  echo "#### ADDING ####"
  echo "Adding 1"
  curl -XPUT $url -d "1"
  echo "Adding 1"
  curl -XPUT $url -d "1"
 
  echo "#### READING ####"
  vclock=`curl -s $url -o /dev/null -D - | grep -E '^X-Riak-Vclock: '`
  total="0"
  for vtag in `curl -s $url|grep -v Siblings:`; do
    val=$(curl -s $url?vtag=$vtag)
    if echo $val | grep -E '^[0-9][0-9]*$' > /dev/null; then
      echo "[$vtag]: $val"
      total=$(expr $total + $val)
    fi
  done
 
  echo "#### RESOLVING ####"
  echo "!!!! WAIT! ADDING SOME! !!!!"
  echo "Adding 1"
  curl -XPUT $url -d "1"
  echo "Adding 1"
  curl -XPUT $url -d "1"
  echo "!!!! DONE ADDING !!!!"
  echo "Saving $total"
  echo "$vclock"
  curl -XPUT $url -H "$vclock" -d "$total"
  echo "#### RESOLVING COMPLETE ####"
  if $(curl -s $url|grep Siblings: > /dev/null); then
    for vtag in `curl -s $url|grep -v Siblings:`; do
      val=$(curl -s $url?vtag=$vtag)
      echo "[$vtag]: $val"
    done
  else
    echo "Single: $(curl -s $url)"
  fi
  sleep 3
done