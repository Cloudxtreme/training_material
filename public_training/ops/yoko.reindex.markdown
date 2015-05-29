riak_core_util:rpc_every_member_ann(application, set_env, [yokozuna, anti_entropy_build_limit, {4, 3600000}], 60).
riak_core_util:rpc_every_member_ann(application, set_env, [yokozuna, anti_entropy_concurrency, 4], 60).
rpc:multicall([node() | nodes()], yz_entropy_mgr, expire_trees, []).



yz_index:reload(<<"commercial">>)


# 1) Remove the index association from the commercial bucket
curl -u 'abc:def' -XPUT http://myriakmachine.com/types/commercial/buckets/commercial/props -H 'Content-Type: application/json' -d '{"props":{"search_index":"_dont_index_"}}'

# 2) Delete the commercial index
curl -XDELETE -u abc:def http://myriakmachine.com/search/index/commercial

# 3) Load the commercial schema
curl -u 'abc:def' -XPUT http://myriakmachine.com/search/schema/commercial -H'content-type:application/xml' --data-binary @commercial.xml

# 4) Associate the commercial schema with the commercial index
curl -XPUT -u abc:def http://myriakmachine.com/search/index/commercial -H 'Content-Type: application/json' -d '{"schema":"commercial"}'

# 5) Associate the commercial index with the commercial bucket
curl -XPUT -u abc:def http://myriakmachine.com/types/commercial/buckets/commercial/props -H 'Content-Type: application/json' -d '{"props":{"search_index":"commercial"}}'
