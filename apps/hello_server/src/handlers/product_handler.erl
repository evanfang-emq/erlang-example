-module(product_handler).

-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    _ = cowboy_req:reply(200,
                         #{<<"content-type">> => <<"text/plain">>},
                         <<"Product\n">>,
                         Req),
    {ok, Req, State}.
