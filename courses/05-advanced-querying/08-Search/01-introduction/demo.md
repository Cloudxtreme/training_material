# Search - Introduction

## Indexing

Open the file `search-introduction.xml`

Note the structure of the XML and the various tags used (`add`, `doc`, etc.)

Use the `search-introduction.xml` file to index example data

        search-cmd solr searchable-persons search-introduction.xml

## Searching

Use `search-cmd search` to lookup all persons in the `trainer` group

        search-cmd search searchable-persons groups:trainer

Repeat with `search-cmd search-doc`

        search-cmd search-doc searchable-persons groups:trainer

Note the difference between these commands.

## List Buckets

List the buckets in Riak

        curl http://localhost:8098/riak?buckets=true

Make note of the `_rsid_searchable-persons` bucket

Also make note that there is no `searchable-persons` bucket
