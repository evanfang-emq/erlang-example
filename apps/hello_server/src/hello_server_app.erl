%%%-------------------------------------------------------------------
%% @doc hello_server public API
%% @end
%%%-------------------------------------------------------------------

-module(hello_server_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    % start lagger
    lager:start(),

    {ok, Port} = application:get_env(hello_server, port),
    lager:info("server is listening on port: ~p", [Port]),

    % setup throttling
    % Allowed rate periods are per_second, per_minute, per_hour and per_day

    % setup throttling for each hander
    throttle:setup(user_handler, 1, per_minute),
    throttle:setup(product_handler, 1, per_minute),

    % server
    Dispatch = cowboy_router:compile([{'_', % must use SINGLE quote
                                [{<<"/">>, index_handler, []},
                                 {<<"/user">>, user_handler, []},
                                 {<<"/product">>, product_handler, []},
                                 {<<"/db">>, db_handler, []}]}]),
    {ok, _} = cowboy:start_clear(hello_listener,
                                 [{port, Port}],
                                 #{env => #{dispatch => Dispatch},
                                   middlewares => [
                                       cowboy_router,
                                       throttling_middleware,
                                       time_logger_middleware,
                                       cowboy_handler]}),
    hello_server_sup:start_link().

stop(_State) -> ok.

%% internal functions

