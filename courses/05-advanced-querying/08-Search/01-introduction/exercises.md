# Search - Introduction

## Indexing

Open the file `search-introduction.xml`

Note the structure of the XML and the various tags used (`add`, `doc`, etc.)

Use `search-cmd solr` to run the Solr file `search-introduction.xml`. Use 
`searchable-persons` as the `INDEX`.

## Searching

Use `search-cmd search` to lookup all persons in the `da` group

Use `search-cmd search-doc` to lookup all persons in the `da` group

What's the difference between these commands?

## List Buckets

List the buckets in Riak

        curl http://localhost:8098/riak?buckets=true

Notice the `_rsid_searchable-persons` bucket. Also notice that there is no 
`searchable-persons` bucket.

## Groups

Add the following people and groups to `search-introduction.xml`.

### Persons

* dan
* joe
* ian
* justin
* tryn
* sowjanya
* brian
* tanya
* casey
* vin

### Groups

* trainer: dan, joe, ian
* da: dan, ian, tryn, sowjanya, brian, tanya, justin
* ps: casey, joe, vin

Run `search-cmd solr` again

Search for persons in the `trainer` group

Search for persons in the `da` group

Search for persons in the `ps` group
