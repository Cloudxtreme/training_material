# Getting Started - Clustering

Download the `generate-node.sh` script from Github

    curl -O https://raw.github.com/gist/1672990/e4946eeebff27732f005d47fa66e1ea6f6f72e41/generate-node.sh
    chmod a+x generate-node.sh

Create three test nodes

    generate-node.sh /path/to/bin/riak test1
    generate-node.sh /path/to/bin/riak test2
    generate-node.sh /path/to/bin/riak test3

Explain that the `generate-node.sh` script uses the basename of the destination 
directory as the node name. For example, the above three nodes have the names 
`test1@127.0.0.1`, `test2@127.0.0.1`, and `test3@127.0.0.1`.

Start the three test nodes

    test1/bin/riak start
    test2/bin/riak start
    test3/bin/riak start

Join the nodes into a cluster

    test2/bin/riak-admin join test1@127.0.0.1
    test3/bin/riak-admin join test1@127.0.0.1