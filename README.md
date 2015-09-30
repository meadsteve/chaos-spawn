ChaosSpawn
==========
[![Build Status](https://travis-ci.org/meadsteve/chaos-spawn.svg?branch=master)](https://travis-ci.org/meadsteve/chaos-spawn)

Inspired by netfix's chaos monkey. This library is intended to be a low level
process based equivalent. Intended to work by replacing the ```Kernel.spawn```
with overidden ones that return processes that die at random. This should
force an app's supervision tree to actually work.

Currently super alpha. Probably not a good idea to use yet.

* Using
Add Chaos Spawn as an application in your mix.exs:

```elixir
def application do
  [applications: [:logger, :chaos_spawn]]
end
```

Then simply use ```ChaosSpawn.Chaotic.Spawn``` in any module you wish to
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
