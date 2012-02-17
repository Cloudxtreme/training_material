# Search - Indexing

## Demo data

Create a directory of text files

        mkdir demo
        cd demo
        echo "demo data goes here" > foo.txt
        echo "demo demo demo demo" > bar.txt
        echo "nothing to see here" > baz.txt
        echo "demo demo" > qux.txt

## search-cmd index

Index demo data into the `cmd-index` index using `search-cmd index`

Use `search-cmd search` to search the documents using the query `demo`

## search:index/1,2

Index demo data into the `search-index` index using `search:index(Index, Path)`

Use `search-cmd search` to search the documents using the query `demo`

## Solr

Index demo data into the `solr-index` through the Solr API

Use `search-cmd search` to search the documents using the query `demo`

## Bonus

What index is used when none is specified? (e.g. `search-cmd index path`)

How did you figure this out?

What other strategies can you think of to figure this out?
