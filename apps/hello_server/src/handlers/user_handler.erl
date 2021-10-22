-module(user_handler).

-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    _ = cowboy_req:reply(200,
                         #{<<"content-type">> => <<"text/plain">>},
                         <<"User\n">>,
                         Req),
    {ok, Req, State}.
