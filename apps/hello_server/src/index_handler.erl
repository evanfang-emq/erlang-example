-module(index_handler).

-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    _ = cowboy_req:reply(200,
                             #{<<"content-type">> => <<"text/plain">>},
                             <<"hello, erlang\n">>,
                             Req),
    {ok, Req, State}.
