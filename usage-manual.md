## Manual Usage
The ```ChaosSpawn``` module provides the following function that can be used
to register any pid. This pid is then eligible to be terminated randomly.

``` elixir
ChaosSpawn.registr_pid( pid )
```

For example adding this to a simple gen server's init would look like:

``` elixir
def init(:ok) do
  ChaosSpawn.register_pid(self)
  {:ok, []}
end
```

This gen server will then register itself everytime it is started as a process
that can be killed.
