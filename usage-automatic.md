# Adding ChaosSpawn to projects using helper modules
Chaos spawn provides a number of modules to make using it in your projects
a little easier.

## In manual spawns
Use ```ChaosSpawn.Chaotic.Spawn``` in any module you wish to
have unreliable spawn calls. This will automatically replace the spawn calls
with the versions from the ```ChaosSpawn``` module.
``` elixir
defmodule ChaosSpawn.Example.Spawn do
  # Using the following will automatically replace all the spawn
  # functions with the chaotic ones.
  use ChaosSpawn.Chaotic.Spawn

  def test do
    spawn fn ->
      IO.puts "waiting for message"
      receive do
        _ -> IO.puts "message recieved!"
      end
    end
  end
end
```

## In Workers of a Supervisor
Replace a call to ```worker``` with a call to ```ChaosSpawn.Chaotic.ChaoticWorker.worker```.
Any proceses of this child will then be automatically registered as a process that can be killed.

Alternatively a call to ```supervisor``` can be replaced with a call
to ```ChaoticSupervisor.supervisor```

``` elixir
defmodule ChaosSpawn.Example.Supervisor do
  alias ChaosSpawn.Chaotic.ChaoticWorker

  def init(:ok) do
    children = [
      ChaoticWorker.worker(Some.Module, [:arg, :another_arg])
    ]

    supervise(children, strategy: :one_for_one)
  end

end
```

## In Gen servers
Instead of ```use```ing GenServer ```use``` the chaotic version and then
modify the start_link as below:  
```elixir
defmodule ChaosSpawn.Example.GenServer do
  use ChaosSpawn.Chaotic.GenServer

  def start_link(opts \\ []) do
    # This function is imported when using ChaosSpawn.Chaotic.GenServer
    start_chaotic_link(__MODULE__, :ok, opts)
    # or to switch to the non chaotic version this is imported from GenServer:
    # start_link(__MODULE__, :ok, opts)
  end
end
```

## In Gen events
Replace ```GenEvent.start_link``` with ```ChaosSpawn.Chaotic.GenEvent.start_link```.
```elixir
{:ok, pid} = ChaosSpawn.Chaotic.GenEvent.start_link([])
GenEvent.add_handler(pid, SomeHandler, [])
```
