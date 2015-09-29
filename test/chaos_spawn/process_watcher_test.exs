defmodule ProcessWatcherTest do
  use ExUnit.Case
  alias ChaosSpawn.ProcessWatcher

  setup do
    {:ok, watcher} = ChaosSpawn.ProcessWatcher.start_link
    {:ok, watcher: watcher}
  end

  test "recieves messages and stores those pids", %{watcher: watcher} do
    new_pid = spawn &ProcessWatcherTest.TestModule.test_fun/0
    watcher |> ProcessWatcher.add_pid(new_pid)
    assert ProcessWatcher.all_pids(watcher) == [new_pid]
  end

  test "doesn't store dead pids", %{watcher: watcher} do
    new_pid = spawn &ProcessWatcherTest.TestModule.test_fun/0
    send new_pid, {:die}
    watcher |> ProcessWatcher.add_pid(new_pid)
    assert ProcessWatcher.all_pids(watcher) == []
  end

  test "can request a random pid from the watcher", %{watcher: watcher} do
    new_pid = spawn &ProcessWatcherTest.TestModule.test_fun/0
    watcher |> ProcessWatcher.add_pid(new_pid)
    assert ProcessWatcher.get_random_pid(watcher) == new_pid
  end

  test "random pid returns :none if no pids available", %{watcher: watcher} do
    assert ProcessWatcher.get_random_pid(watcher) == :none
  end

  test "never returns dead pids", %{watcher: watcher} do
    pid_one = spawn &ProcessWatcherTest.TestModule.test_fun/0
    pid_two = spawn &ProcessWatcherTest.TestModule.test_fun/0
    watcher |> ProcessWatcher.add_pid(pid_one)
    watcher |> ProcessWatcher.add_pid(pid_two)
    send pid_one, {:die}
    assert ProcessWatcher.get_random_pid(watcher) == pid_two
  end

end

defmodule ProcessWatcherTest.TestModule do
  def test_fun do
    receive do
      {_} -> :ok
    end
  end
end
