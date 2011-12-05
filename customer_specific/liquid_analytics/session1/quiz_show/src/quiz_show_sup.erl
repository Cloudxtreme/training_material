-module(quiz_show_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    %% TODO: Move Riak connection management into a standalone process
    %% Perhaps a locally registered gen_server that can manage
    %% connection pooling and re-connects
    {ok, Pid} = riakc_pb_socket:start_link("127.0.0.1", 8087),

    %% Determine the IP to listen on
    %% TODO: make this configuration via an application environment parameter
    %% e.g. application:get_env(quiz_show, ip)
    Ip = case os:getenv("WEBMACHINE_IP") of false -> "0.0.0.0"; Any -> Any end,

    %% Define the resources webmachine should manage
    Dispatch = [{["quizzes"], quizzes, [Pid]},
                {["quizzes", key], quizzes, [Pid]},
                {["answers"], answers, [Pid]},
                {["answers", key], answers, [Pid]}
               ],

    %% Configure webmachine
    WebConfig = [
                 {ip, Ip},
                 {port, 8000},
                 {log_dir, "priv/log"},
                 {dispatch, Dispatch}],

    %% Define child spec for this webmachine instance
    Web = {webmachine_mochiweb,
           {webmachine_mochiweb, start, [WebConfig]},
           permanent, 5000, worker, dynamic},
    Processes = [Web],
    {ok, { {one_for_one, 10, 10}, Processes} }.
