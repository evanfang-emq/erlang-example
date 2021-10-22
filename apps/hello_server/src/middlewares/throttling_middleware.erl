-module(throttling_middleware).

-behavior(cowboy_middleware).

-export([execute/2]).

execute(Req, Env) ->
    % Check if api handler has rate limit setup
    % if no, use default rate
    HandlerName = maps:get(handler, Env),
    case throttle:peek(HandlerName, 0) of
        rate_not_set ->
            lager:info("handler has no rate limit setup, use "
                       "default rate"),
            Scope = default_api_rate;
        _ ->
            Scope = HandlerName
    end,
    case application:get_env(hello_server, rate_limit_type)
        of
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
    case throttle:check(Scope, Token) of
        {limit_exceeded, _, _} ->
            lager:warning("Exceeded api limit, token: ~p", [Token]),
            Req2 = cowboy_req:reply(429,
                                    #{<<"content-type">> => <<"text/plain">>},
                                    "too many requests",
                                    Req),
            {stop, Req2};
        _ -> {ok, Req, Env}
    end.
