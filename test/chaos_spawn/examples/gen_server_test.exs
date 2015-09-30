defmodule Example.GenServerTest do
  use ExUnit.Case

  test "can kill based on pid" do
    {:ok, server} = ChaosSpawn.Example.GenServer.start_link
    assert ChaosSpawn.Example.GenServer.say_hello(server) == "hello"
  end

end
