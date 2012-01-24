1) Perform the following requests:

  - Store:

        curl -v http://127.0.0.1:8098/buckets/training/keys/my-first-object -X PUT -H "content-type: text/plain" -d "My first key"

  - Fetch:

        curl -v http://127.0.0.1:8098/buckets/training/keys/my-first-object

  - Delete:

        curl -v http://127.0.0.1:8098/buckets/training/keys/my-first-object -X DELETE

2) Requests through failures

  - Stora an object:

        curl -v 127.0.01:8098/buckets/training/keys/test?returnbody=true\&pw=1 -X PUT -H "content-type: text/plain" -d "testing"

  - Stop two nodes

  - Run the following commands:

        curl -v 127.0.0.1:8098/buckets/training/keys/test?pr=3

        curl -v 127.0.0.1:8098/buckets/training/keys/test?r=3


3) Getting and Setting bucket properties

  - Get:

        curl -v 127.0.0.1:8098/buckets/training/props

  - Set:

        curl -v 127.0.0.1:8098/buckets/training/props -X PUT -H "content-type: application/json" -d '{ "props": { "allow_mult":true, "r":1 } }'

4) Siblings

  - Create Siblings:

        curl -v 127.0.0.1:8098/buckets/training/keys/test?returnbody=true -X PUT -H "content-type: text/plain" -d "sibling"

  - Resolve Siblings:

        curl -v 127.0.0.1:8098/buckets/training/keys/test?returnbody=true -X PUT -H "content-type: text/plain" "x-riak-vclock: [vclock]" -d "resolved"
