hello_server
=====

An OTP application

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

# Fetch date from database
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