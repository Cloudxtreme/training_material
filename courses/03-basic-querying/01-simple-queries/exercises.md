# Basic Querying - Simple Queries

1) Perform the following requests:

  - Store:

        curl -v http://127.0.0.1:8098/buckets/training/keys/my-first-object -X PUT -H "content-type: text/plain" -d "My first key"

  - Fetch:

        curl -v http://127.0.0.1:8098/buckets/training/keys/my-first-object

  - Delete:

        curl -v http://127.0.0.1:8098/buckets/training/keys/my-first-object -X DELETE

2) Store, fetch, and update an object making sure to submit the vclock when updating
