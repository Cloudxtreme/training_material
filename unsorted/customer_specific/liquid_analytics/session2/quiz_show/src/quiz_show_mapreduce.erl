-module(quiz_show_mapreduce).
-compile(export_all).

%% Good reference:
%% https://github.com/basho/riak_kv/blob/master/src/riak_kv_mapreduce.erl

%% return found keys
map_found_keys({error, notfound}, _, _) ->
    [];
map_found_keys(RO, _, _) ->
    [riak_object:key(RO)].

%% return list of decode questions
get_questions(RO, _, Topic) ->
    Value = riak_object:get_value(RO),
    Questions = mochijson2:decode(Value),
    case Topic of
        undefined ->
            Questions;
        _ ->
            [{struct, Q} || {struct, Q} <- Questions, topic(Q) =:= Topic]
    end.

topic(Q) ->
    case lists:keyfind(<<"topic">>, 1, Q) of
        {<<"topic">>, Topic} ->
            Topic;
        false ->
            undefined
    end.
