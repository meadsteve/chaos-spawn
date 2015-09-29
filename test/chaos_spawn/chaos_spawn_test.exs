defmodule ChaosSpawnTest do
  use ExUnit.Case
  alias ChaosSpawn.ProcessSpawner

  test "Spawns anon funtions in processes" do
    pid = ProcessSpawner.spawn(&ChaosSpawnTest.TestModule.test_fun/0, self)
    assert is_pid(pid)
  end

  test "Spawns named functions in processes" do
    pid = ProcessSpawner.spawn(ChaosSpawnTest.TestModule, :test_fun, [], self)
    assert is_pid(pid)
  end

end

defmodule ChaosSpawnTest.TestModule do
  def test_fun do
    receive do
      {_} -> :ok
    end
  end
end
