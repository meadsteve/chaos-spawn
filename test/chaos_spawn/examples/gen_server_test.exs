defmodule Example.GenServerTest do
  use ExUnit.Case

  test "the gen server provide example should work" do
    {:ok, server} = ChaosSpawn.Example.GenServer.start_link
    assert ChaosSpawn.Example.GenServer.say_hello(server) == "hello"
  end

end
