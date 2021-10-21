-module(throttling_middleware).

-behavior(cowboy_middleware).

-export([execute/2]).

execute(Req, Env) ->
    % https://ninenines.eu/docs/en/cowboy/2.9/manual/cowboy_req.peer/
    {IP, _Port} = cowboy_req:peer(Req),

    case throttle:check(api_rate, IP) of
        {limit_exceeded, _, _} ->
            lager:warning("IP ~p exceeded api limit", [IP]),
            Req2 = cowboy_req:reply(429,
                                    #{<<"content-type">> => <<"text/plain">>},
                                    "too many requests",
                                    Req),
            {stop, Req2};
        _ -> {ok, Req, Env}
    end.
