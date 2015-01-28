-module(mapreduce_examples).

-export([map_datasize/3]).

map_datasize({error, notfound}, _, _) ->
    [];
map_datasize(RiakObject, _KeyData, _Arg) ->
    [lists:foldl(fun({MD,Val}, A) ->
                     case dict:is_key(<<"X-Riak-Deleted">>, MD) of
                         true ->
                             A;
                         false ->
                             (byte_size(Val) + A)
                     end
                 end, 0, riak_object:get_contents(RiakObject))].

