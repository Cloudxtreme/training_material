-module(quiz_show).

-export([start/0,
         stop/0
        ]).

start() ->
    application:start(quiz_show).

stop() ->
    application:stop(quiz_show).

