-module(quizzes).
-export([init/1,
         allowed_methods/2,
         resource_exists/2,
         content_types_provided/2,
         to_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

-record(state, {riak, obj, key}).

init([Pid]) -> {ok, #state{riak=Pid}}.

%% Only allow GET requests
allowed_methods(ReqData, State) ->
    Key = case wrq:path_info(key, ReqData) of
              undefined -> undefined;
              Val -> list_to_binary(Val)
          end,
    {['GET'], ReqData, State#state{key=Key}}.

%% Retrieve the list of quizzes when key is undefined
resource_exists(R, S=#state{key=undefined}) ->
    case riakc_pb_socket:get(S#state.riak, <<"quizzes">>, <<"_index">>) of
        {ok, Obj} ->
            {true, R, S#state{obj=Obj}};
        _ ->
            {false, R, S}
    end;

%% Retrieve the specified quiz when key is provided by the client
resource_exists(R, S=#state{key=Key}) ->
    case riakc_pb_socket:get(S#state.riak, <<"quizzes">>, Key) of
        {ok, Obj} ->
            {true, R, S#state{obj=Obj}};
        _ ->
            {false, R, S}
    end.

%% Provide application/json responses
content_types_provided(ReqData, State) ->
    {[{"application/json", to_json}], ReqData, State}.

%% Process JSON view
to_json(ReqData, State) ->
    {riakc_obj:get_value(State#state.obj), ReqData, State}.
