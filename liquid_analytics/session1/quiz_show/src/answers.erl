-module(answers).
-export([init/1,
         allowed_methods/2,
         malformed_request/2,
         is_authorized/2,
         resource_exists/2,
         content_types_provided/2,
         to_json/2,
         content_types_accepted/2,
         handle_json/2
        ]).

-include_lib("webmachine/include/webmachine.hrl").

-record(state, {riak, obj, key, username, body, data}).

-define(REALM, "Basic realm=Quiz Show").

init([Pid]) -> {ok, #state{riak=Pid}}.

%% /answers only allows GET
%% /answers/:id allows GET and PUT
allowed_methods(ReqData, State) ->
    case wrq:path_info(key, ReqData) of
        undefined ->
            {['GET'], ReqData, State#state{key=undefined}};
        Val ->
            Key = list_to_binary(Val),
            {['GET', 'PUT'], ReqData, State#state{key=Key}}

    end.

%% If this is a PUT request check that the body is valid JSON
malformed_request(ReqData, State) ->
    case wrq:method(ReqData) of
        'GET' ->
            {false, ReqData, State};
        _ ->
            Body = wrq:req_body(ReqData),
            case catch mochijson2:decode(Body) of
                {'EXIT', _Reason} ->
                    {true, ReqData, State};
                Data ->
                    %% TODO: Verify JSON body matches expected answer format
                    {false, ReqData, State#state{body=Body, data=Data}}
            end
    end.

%% Authenticate this request using Basic Auth
is_authorized(ReqData, State) ->
    case wrq:get_req_header("authorization", ReqData) of
        "Basic " ++ Base64 ->
            Auth = base64:mime_decode_to_string(Base64),
            case string:tokens(Auth, ":") of
                [Username, _Password] ->
                    %% TODO: Authentication would be done here
                    {true, ReqData, State#state{username=list_to_binary(Username)}};
                _ ->
                    {?REALM, ReqData, State}
            end;
        _ ->
            {?REALM, ReqData, State}
    end.

%% Retrieve the list of known quizzes when key is undefined
resource_exists(R, S=#state{key=undefined}) ->
    case riakc_pb_socket:get(S#state.riak, <<"quizzes">>, <<"_index">>) of
        {ok, Obj} ->
            {true, R, S#state{obj=Obj}};
        _ ->
            {false, R, S}
    end;

%% Retrieve the specificed answer when a key is provided
resource_exists(R, S=#state{key=Key, username=Username}) ->
    AnswerKey = answer_key(Username, Key),
    case riakc_pb_socket:get(S#state.riak, <<"answers">>, AnswerKey) of
        {ok, Obj} ->
            {true, R, S#state{obj=Obj}};
        _ ->
            {false, R, S}
    end.

%% Provide application/json responses
content_types_provided(ReqData, State) ->
    {[{"application/json", to_json}], ReqData, State}.

%% Return a JSON list of answered quizzes
to_json(ReqData, State=#state{key=undefined}) ->
    List = answered_quizzes(State),
    {mochijson2:encode(List), ReqData, State};

%% Return a JSON representation of the requested answer
to_json(ReqData, State) ->
    {riakc_obj:get_value(State#state.obj), ReqData, State}.

%% Accept application/json requests (PUT, Content-Type: application/json)
content_types_accepted(R, S) ->
    {[{"application/json", handle_json}], R, S}.

%% Process incoming JSON data (already verfied the data is JSON in malformed_request/2)
handle_json(R, S=#state{key=Key, username=Username, body=Body}) ->
    AnswerKey = answer_key(Username, Key),
    Obj = riakc_obj:new(<<"answers">>, AnswerKey, Body, "application/json"),
    case riakc_pb_socket:put(S#state.riak, Obj) of
        ok ->
            {true, R, S};
        _ ->
            {false, R, S}
    end.

%% internal api

%% Convetion: Prefix quiz name with username to generate knowable keys for answers
answer_key(Username, Quiz) ->
        <<Username/binary, "-", Quiz/binary>>.

%% Return list of quiz names already answered
answered_quizzes(State) ->
    case riakc_pb_socket:get(State#state.riak, <<"quizzes">>, <<"_index">>) of
        {ok, Obj} ->
            Value = riakc_obj:get_value(Obj),
            List = mochijson2:decode(Value),
            Username = State#state.username,
            Answers = [answer_key(Username, Quiz) || Quiz <- List],
            Inputs = [{<<"answers">>, Key} || Key <- Answers],
            %% TODO: rewrite map reduce in Erlang and deploy to Riak
            Query = [
                     %% Map phase
                     {map,
                      {jsanon, <<"function(v, keyData, arg) { return [v.key] }">>},
                      undefined, %% arg
                      false}, %% keep

                     %% Reduce phase
                     {reduce,
                      {jsfun, <<"Riak.filterNotFound">>},
                      undefined, %% arg
                      true} %% keep
                    ],
            mapred(Inputs, Query, State);
        _ -> []
    end.

%% Run map reduce job
mapred(Inputs, Query, State) ->
    Answers = case riakc_pb_socket:mapred(State#state.riak, Inputs, Query) of
                  {ok, [{1, Results}]} -> Results;
                  Error -> error_logger:error_report(Error), []
              end,
    %% Remove Username prefix from each key
    %% Result from map reduce
    %% ["user-quiz-name-one", "user-quiz-name-two"]
    %% Result returned to user
    %% ["quiz-name-one", "quiz-name-two"]
    Username = State#state.username,
    Size = size(Username),
    [Key || <<_:Size/binary, "-", Key/binary>> <- Answers].
