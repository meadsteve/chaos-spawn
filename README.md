ChaosSpawn
==========
[![Build Status](https://travis-ci.org/meadsteve/chaos-spawn.svg?branch=master)](https://travis-ci.org/meadsteve/chaos-spawn)

## What and why

Inspired by netfix's chaos monkey. This library is intended to be a low level
process based equivalent. It works by replacing the ```Kernel.spawn```
functions with overidden ones that return processes that die at random. This should
force an app's supervision tree to actually work.

Currently super alpha. Probably not a good idea to use yet.

## Usage
Add Chaos Spawn as an application in your mix.exs:

```elixir
def application do
  [applications: [:logger, :chaos_spawn]]
end
```

### Usage - in manual spawns
Simply use ```ChaosSpawn.Chaotic.Spawn``` in any module you wish to
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
### Usage - in Gen servers
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
