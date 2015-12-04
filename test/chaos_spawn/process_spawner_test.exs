defmodule ProcessSpawnerTest do
  use ExUnit.Case
  alias ChaosSpawn.ProcessSpawner

  for spawn_fun <- [:spawn, :spawn_link] do
    test "#{spawn_fun}/2 spawns a processes" do
      pid = apply(ProcessSpawner, unquote(spawn_fun), [&ProcessSpawnerTest.TestModule.test_fun/0, self])
      assert is_pid(pid)
    end

    test "#{spawn_fun}/2 sends message to watcher with new pid" do
      pid = apply(ProcessSpawner, unquote(spawn_fun), [&ProcessSpawnerTest.TestModule.test_fun/0, self])
      assert_receive({:"$gen_cast", {:add_pid, ^pid, []}})
    end

    test "#{spawn_fun}/4 spawns a processes" do
      pid = apply(ProcessSpawner, unquote(spawn_fun), [ProcessSpawnerTest.TestModule, :test_fun, [], self])
      assert is_pid(pid)
    end

    test "#{spawn_fun}/4 sends message to watcher with new pid" do
      pid = apply(ProcessSpawner, unquote(spawn_fun), [ProcessSpawnerTest.TestModule, :test_fun, [], self])
      assert_receive({:"$gen_cast", {:add_pid, ^pid, []}})
    end
  end

  test "spawn_monitor/2 spawns a processes" do
    {pid, _monitor_ref} = apply(ProcessSpawner, :spawn_monitor, [&ProcessSpawnerTest.TestModule.test_fun/0, self])
    assert is_pid(pid)
  end

  test "spawn_monitor/2 sends message to watcher with new pid" do
    {pid, _monitor_ref} = apply(ProcessSpawner, :spawn_monitor, [&ProcessSpawnerTest.TestModule.test_fun/0, self])
    assert_receive({:"$gen_cast", {:add_pid, ^pid, []}})
  end

  test "spawn_monitor/4 spawns a processes" do
    {pid, _monitor_ref} = apply(ProcessSpawner, :spawn_monitor, [ProcessSpawnerTest.TestModule, :test_fun, [], self])
    assert is_pid(pid)
  end

  test "spawn_monitor/4 sends message to watcher with new pid" do
    {pid, _monitor_ref} = apply(ProcessSpawner, :spawn_monitor, [ProcessSpawnerTest.TestModule, :test_fun, [], self])
    assert_receive({:"$gen_cast", {:add_pid, ^pid, []}})

  end

end

defmodule ProcessSpawnerTest.TestModule do
  def test_fun do
    receive do
      {_} -> :ok
    end
  end
end
