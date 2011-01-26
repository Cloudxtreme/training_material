-module(quiz_show).

-define(DEPS, [crypto, mochiweb, webmachine]).

-export([start/0,
         stop/0
        ]).

start() ->
    start_deps(),
    application:start(quiz_show).

stop() ->
    application:stop(quiz_show).

start_deps() ->
    ok = ensure_started(?DEPS).

ensure_started([]) ->
    ok;
ensure_started([App|Apps]) ->
    case application:start(App) of
        ok ->
            ensure_started(Apps);
        {error, {already_started, _}} ->
            ensure_started(Apps);
        Error ->
            Error
    end.
