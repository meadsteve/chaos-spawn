defmodule ChaosSpawn.Example.Spawn do
  # Using the following with automatically repalce all the spawn
  # functions with the choatic ones.
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
