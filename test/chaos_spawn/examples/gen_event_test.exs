defmodule Example.GenEventTest do
  use ExUnit.Case

  test "the gen event provider example should work" do
    {:ok, pid} = ChaosSpawn.Chaotic.GenEvent.start_link([])
    GenEvent.add_handler(pid, ChaosSpawn.Example.MessageSayer, [])

    GenEvent.notify(pid, {:say, "hello"})
    GenEvent.notify(pid, {:say, "world"})

    result = GenEvent.call(pid, ChaosSpawn.Example.MessageSayer, :say)
    assert result == ["hello", "world"]
  end

end
