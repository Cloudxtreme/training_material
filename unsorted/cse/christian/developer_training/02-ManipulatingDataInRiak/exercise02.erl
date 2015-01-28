-module(exercise02).

-export([add_to_cart/3,
	     remove_from_cart/3,
	     list_cart/2,
	     delete_cart/2]).

-define(CART_BUCKET, <<"cart">>).
-define(CONTENT_TYPE, "application/x-erlang-binary").

add_to_cart(Conn, CartId, ItemList) when is_binary(CartId) ->
    case riakc_pb_socket:get(Conn, ?CART_BUCKET, CartId) of
        {ok, Obj} ->
            CartList = binary_to_term(riakc_obj:get_update_value(Obj)),
            NewCartList = condense_cartlist(lists:append([CartList, ItemList])),
            NewValue = term_to_binary(NewCartList),
            UpdObj = riakc_obj:update_value(Obj, NewValue),
            riakc_pb_socket:put(Conn, UpdObj);
        {error, notfound} ->
            CartList = condense_cartlist(ItemList),
            Value = term_to_binary(CartList),
            NewObj = riakc_obj:new(?CART_BUCKET, CartId, Value, ?CONTENT_TYPE),
            riakc_pb_socket:put(Conn, NewObj);
        {error, Error} ->
            {error, Error}
    end.

remove_from_cart(Conn, CartId, ItemList) ->
    NegList = [{I, (-1 * Q)} || {I,Q} <- ItemList],
    add_to_cart(Conn, CartId, NegList).

list_cart(Conn, CartId) ->
    case riakc_pb_socket:get(Conn, ?CART_BUCKET, CartId) of
        {ok, Obj} ->
            binary_to_term(riakc_obj:get_update_value(Obj));
        {error, notfound} ->
            [];
        {error, Error} ->
            {error, Error}
    end.

delete_cart(Conn, CartId) ->
    riakc_pb_socket:delete(Conn, ?CART_BUCKET, CartId).

condense_cartlist(List) ->
    NewList = dict:to_list(lists:foldl(fun({Item, Qty}, D) -> 
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
