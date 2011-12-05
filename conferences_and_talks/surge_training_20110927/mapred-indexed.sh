#!/bin/bash

read -p "Query on range or equality? (r/e) " -e qtype
prefix="surgeobj"

case "$qtype" in
    r)
        read -p "Range start: " -e start
        read -p "Range end: " -e end
        inputs="\"start\":$start,\"end\":$end"
        ;;
    e)
        read -p "Index value: " -e key
        inputs="\"key\":$key"
        ;;
    *)
        echo "Please choose 'r' for range or 'e' for equality!"
        exit 1
        ;;
esac

query="{\
  \"inputs\":{\
    \"bucket\":\"surge\",\
    \"index\":\"${prefix}_int\"\
    ,$inputs},\
 \"query\":[\
    {\"map\":{\"name\":\"Riak.mapValuesJson\",\"language\":\"javascript\",\"keep\":true}}\
  ]\
}"

echo -e
echo "Executing MapReduce:"
echo $query
echo -e
echo $query | curl -v http://localhost:8091/mapred -H "Content-Type: application/json" --data-binary @-
