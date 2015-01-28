-module(exercise05).

-export([create_cart/3,
         add_to_cart/3,
	     remove_from_cart/3,
	     list_cart/2,
	     delete_cart/2,
	     list_stale_carts/2]).

-define(CART_BUCKET, <<"cart">>).
-define(CONTENT_TYPE, "application/x-erlang-binary").
-define(INDEX_NAME, "last_modified").

create_cart(Conn, CartId, ItemList) when is_binary(CartId) ->
    Now = os:timestamp(),
    NewItemList = [{I, Q, Now} || {I, Q} <- ItemList, is_integer(Q)],
    CartList = lists:usort(NewItemList),
    Value = term_to_binary(CartList),
    NewObj = update_2i(riakc_obj:new(?CART_BUCKET, CartId, Value, ?CONTENT_TYPE)),
    riakc_pb_socket:put(Conn, NewObj).

add_to_cart(Conn, CartId, ItemList) when is_binary(CartId) ->
    Now = os:timestamp(),
    NewItemList = [{I, Q, Now} || {I, Q} <- ItemList, is_integer(Q)],
    case riakc_pb_socket:get(Conn, ?CART_BUCKET, CartId) of
        {ok, Obj} ->
            CartList = extract_resolved_list(Obj),
            NewCartList = lists:usort(lists:append([CartList, NewItemList])),
            NewValue = term_to_binary(NewCartList),
            UObj = update_2i(riakc_obj:update_value(Obj, NewValue)),
            riakc_pb_socket:put(Conn, UObj);
        {error, notfound} ->
            CartList = lists:usort(NewItemList),
            Value = term_to_binary(CartList),
            NewObj = update_2i(riakc_obj:new(?CART_BUCKET, CartId, Value, ?CONTENT_TYPE)),
            riakc_pb_socket:put(Conn, NewObj);
        {error, Error} ->
            {error, Error}
    end.

update_2i(Obj) ->
    Val = time_to_bin(calendar:local_time()),
    MD = riakc_obj:add_secondary_index(dict:new(), {{binary_index, ?INDEX_NAME}, [Val]}),
    riakc_obj:update_metadata(Obj, MD).

remove_from_cart(Conn, CartId, ItemList) ->
    NegList = [{I, (-1 * Q)} || {I,Q} <- ItemList],
    add_to_cart(Conn, CartId, NegList).

list_cart(Conn, CartId) ->
    case riakc_pb_socket:get(Conn, ?CART_BUCKET, CartId) of
        {ok, Obj} ->
            case riakc_obj:value_count(Obj) of
                1 -> 
                    present_cartlist(extract_resolved_list(Obj));
                _ ->
                    List = extract_resolved_list(Obj),
                    [MD | _] = riakc_obj:get_metadatas(Obj),
                    Obj2 = riakc_obj:update_metadata(riakc_obj:update_value(Obj, term_to_binary(List)), MD),
                    riakc_pb_socket:put(Conn, Obj2),
                    present_cartlist(List)
            end;
        {error, notfound} ->
            [];
        {error, Error} ->
            {error, Error}
    end.

delete_cart(Conn, CartId) ->
    riakc_pb_socket:delete(Conn, ?CART_BUCKET, CartId).

list_stale_carts(Conn, Age) when is_integer(Age) ->
    CutoffSecs = calendar:datetime_to_gregorian_seconds(calendar:local_time()) - Age,
    CutoffTime = time_to_bin(calendar:gregorian_seconds_to_datetime(CutoffSecs)),
    case riakc_pb_socket:get_index(Conn, ?CART_BUCKET, {binary_index, ?INDEX_NAME}, <<"0001/01/01 00:00:00">>, CutoffTime) of
        {ok, ResultList} ->
            ResultList;
        {error, Error} ->
            {error, Error}
    end.

extract_resolved_list(Obj) ->
    lists:usort(lists:append([binary_to_term(V) || {_, V} <- filter_deleted_contents(riakc_obj:get_contents(Obj))])).

present_cartlist(List) ->
    NewList = dict:to_list(lists:foldl(fun({Item, Qty, _}, D) -> 
                                           case dict:find(Item, D) of
                                               {ok, V} when is_integer(Qty) ->
                                                   dict:store(Item, (V + Qty), D);
                                               error when is_integer(Qty) ->
                                                   dict:store(Item, Qty, D);
                                               _ ->
                                                   D
                                           end 
                                       end, dict:new(), List)),
    [{I, Q} || {I, Q} <- NewList, Q > 0].

filter_deleted_contents(Contents) ->
    filter_deleted_contents(Contents, []).

filter_deleted_contents([], List) ->
    List;
filter_deleted_contents([{MD, V} | Rest], List) ->
    case dict:is_key(<<"X-Riak-Deleted">>, MD) of
        true ->
            filter_deleted_contents(Rest, List);
        false ->
            filter_deleted_contents(Rest, [{MD, V} | List])
    end. 

time_to_bin({{Year, Month, Day}, {Hour, Min, Sec}}) ->
    list_to_binary(io_lib:fwrite("~4B/~2.10.0B/~2.10.0B ~2.10.0B:~2.10.0B:~2.10.0B",[Year, Month, Day, Hour, Min, Sec])).
