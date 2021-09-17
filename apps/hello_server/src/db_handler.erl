-module(db_handler).

-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    % connect to database
    {ok, C} = epgsql:connect(#{host => "localhost",
                               username => "user1", password => "user1pw",
                               database => "mydb", timeout => 4000}),
    % query from databse
    {ok, _, Rows} = epgsql:equery(C, "select * from hello_erlang"),
    io:format("Rows:~n"),
    io:format("~p~n", [Rows]),
    % close connection
    ok = epgsql:close(C),
    
    _ = cowboy_req:reply(200,
                             #{<<"content-type">> => <<"text/plain">>},
                             io_lib:format("~p~n", [Rows]),
                             Req),
    {ok, Req, State}.
