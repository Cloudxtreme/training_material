-module(questions).
-export([init/1,
         allowed_methods/2,
         resource_exists/2,
         content_types_provided/2,
         to_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

-record(state, {riak, questions}).

init([Pid]) -> {ok, #state{riak=Pid}}.

%% Only allow GET requests
allowed_methods(ReqData, State) ->
    {['GET'], ReqData, State}.

resource_exists(R, S) ->
    Topic = case wrq:get_qs_value("topic", R) of
                undefined -> undefined;
                T -> list_to_binary(T)
            end,
    case riakc_pb_socket:get(S#state.riak, <<"quizzes">>, <<"_index">>) of
        {ok, Obj} ->
            Value = riakc_obj:get_value(Obj),
            List = mochijson2:decode(Value),
            Questions = get_questions(List, Topic, S),
            {true, R, S#state{questions=lists:flatten(Questions)}};
        _ ->
            {false, R, S}
    end.

%% Provide application/json responses
content_types_provided(ReqData, State) ->
    {[{"application/json", to_json}], ReqData, State}.

%% Process JSON view
to_json(ReqData, State) ->
    {mochijson2:encode(State#state.questions), ReqData, State}.

%% internal api

get_questions(Keys, Topic, State) ->
    Inputs = [{<<"quizzes">>, Key} || Key <- Keys],
    Query = [
             %% Map phase
             {map,
              {modfun, quiz_show_mapreduce, get_questions},
              Topic,
              true}
            ],
    mapred(Inputs, Query, State).

%% Run map reduce job
mapred(Inputs, Query, State) ->
     case riakc_pb_socket:mapred(State#state.riak, Inputs, Query) of
         {ok, [{0, Results}]} -> Results;
         Error -> error_logger:error_report(Error), []
     end.
