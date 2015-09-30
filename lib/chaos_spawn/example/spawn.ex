defmodule ChaosSpawn.Example.Spawn do
  @moduledoc """
  The module provides an example of using the spawn functions.
  Using the following will automatically replace all the spawn
  functions with the chaotic ones.
  """
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
