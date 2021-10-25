hello_server
=====

An OTP application.

A simple example showing how to use `cowboy` and connect to postgreSQL database by `epgsql`.

Build
-----
```
$ rebar3 compile
```

Run
-----
```
$ rebar3 shell
```

API
-----
```sh
# Index handler
curl localhost:8080

# Fetch data from database
curl localhost:8080/db
# Output example:
# [{1,<<"Alice">>},{2,<<"Bob">>},{3,<<233,133,183,229,147,165>>}]
```

Dependencies
----
```
{deps, [
  {cowboy, "2.7.0"},
  {epgsql, "4.6.0"}
]}.
```

Applications in .src file
```
{applications,
   [kernel,
    stdlib,
    cowboy
   ]},
```

Envs
---

### sys.config

- `rate_limit_type` could be `ip` or `authorization`
> Could use CURL command to send request with authorization header, like:
>
> curl -H "Authorization: hello" localhost:8080

### Distributed Throttling

```sh
# start node1
rebar3 shell --sname node1@localhost --config config/sys.node1.config

# start node2
rebar3 shell --sname node2@localhost --config config/sys.node2.config
```

In node1 REPL:
```sh
# connect to node2
net_adm:ping(node2@localhost).

# start distributed throttling
throttle_mnesia:setup().
```