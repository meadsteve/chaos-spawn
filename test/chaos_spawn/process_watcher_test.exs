defmodule ProcessWatcherTest do
  use ExUnit.Case
  alias ChaosSpawn.ProcessWatcher

  setup do
    {:ok, watcher} = ChaosSpawn.ProcessWatcher.start_link
    {:ok, watcher: watcher}
  end

  test "recieves messages and stores those pids", %{watcher: watcher} do
    new_pid = spawn &ProcessWatcherTest.TestModule.test_fun/0
    send watcher, {:new_pid, new_pid}
    assert ProcessWatcher.all_pids(watcher) == [new_pid]
  end

end

defmodule ProcessWatcherTest.TestModule do
  def test_fun do
    receive do
      {_} -> :ok
    end
  end
end
