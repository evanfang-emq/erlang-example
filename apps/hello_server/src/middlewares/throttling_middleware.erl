-module(throttling_middleware).

-behavior(cowboy_middleware).

-export([execute/2]).

execute(Req, Env) ->
    case application:get_env(hello_server, rate_limit_type) of
        {ok, ip} ->
            lager:info("rate limit by ip"),
            % https://ninenines.eu/docs/en/cowboy/2.9/manual/cowboy_req.peer/
            {IP, _Port} = cowboy_req:peer(Req),
            Token = IP;
        {ok, authorization} ->
            lager:info("rate limit by authorization header"),
            % https://ninenines.eu/docs/en/cowboy/2.9/manual/cowboy_req.header/
            Authorization = cowboy_req:header(<<"authorization">>,
                                              Req),
            Token = Authorization
    end,
    case throttle:check(api_rate, Token) of
        {limit_exceeded, _, _} ->
            lager:warning("Exceeded api limit, token: ~p", [Token]),
            Req2 = cowboy_req:reply(429,
                                    #{<<"content-type">> => <<"text/plain">>},
                                    "too many requests",
                                    Req),
            {stop, Req2};
        _ -> {ok, Req, Env}
    end.
