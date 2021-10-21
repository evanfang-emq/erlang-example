-module(time_logger_middleware).

-behavior(cowboy_middleware).

-export([execute/2]).

execute(_Req, _Env) ->
    lager:info("now is: ~p", [get_time_str()]),
    {ok, _Req, _Env}.

get_time_str() ->
    {H, M, S} = time(),
    io_lib:format('~2..0b:~2..0b:~2..0b', [H, M, S]).
