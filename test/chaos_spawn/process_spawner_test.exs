defmodule ProcessSpawnerTest do
  use ExUnit.Case
  alias ChaosSpawn.ProcessSpawner

  test "spawn/2 spawns a processes" do
    pid = ProcessSpawner.spawn(&ProcessSpawnerTest.TestModule.test_fun/0, self)
    assert is_pid(pid)
  end

  test "spawn/2 sends message to watcher with new pid" do
    pid = ProcessSpawner.spawn(&ProcessSpawnerTest.TestModule.test_fun/0, self)
    assert_receive({:new_pid, ^pid})
  end

  test "spawn/4 spawns a processes" do
    pid = ProcessSpawner.spawn(ProcessSpawnerTest.TestModule, :test_fun, [], self)
    assert is_pid(pid)
  end

  test "spawn/4 sends message to watcher with new pid" do
    pid = ProcessSpawner.spawn(&ProcessSpawnerTest.TestModule.test_fun/0, self)
    assert_receive({:new_pid, ^pid})
  end

end

defmodule ProcessSpawnerTest.TestModule do
  def test_fun do
    receive do
      {_} -> :ok
    end
  end
end
