#!/bin/bash

read -p "Query on range or equality? (r/e) " -e qtype
prefix="surgeobj"

case "$qtype" in
    r)
        read -p "Range start: " -e start
        read -p "Range end: " -e end
        echo -e
        curl -v http://localhost:8091/buckets/surge/index/${prefix}_int/$start/$end
        echo -e
        ;;
    e)
        read -p "Index value: " -e key
        echo -e
        curl -v http://localhost:8091/buckets/surge/index/${prefix}_int/$key
        echo -e
        ;;
    *)
        echo "Please choose 'r' for range or 'e' for equality!"
        exit 1
        ;;
esac
