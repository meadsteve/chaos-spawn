defmodule ChaosSpawn.KillLoop do
  @moduledoc """
  Module responsible for waiting and randomly killing processes.
  The actual process killing is handled by ChaosSpawn.ProcessKiller
  Is dependent on being given a ChaosSpawn.ProcessWatcher to discover
  proceses it can kill.
  """

  require Logger
  alias ChaosSpawn.ProcessWatcher
  alias ChaosSpawn.ProcessKiller

  def start_link(interval, probability, watcher, name: pid_name) do
    pid = spawn(fn -> kill_loop(interval, probability, watcher) end)
    Process.register pid, pid_name
    {:ok, pid}
  end

  def start_link(interval, probability, watcher) do
    start_link(interval, probability, watcher, name: ChaosSpawn.ProcessKiller)
  end

  defp kill_loop(interval, probability, process_watcher, active \\ true) do
    :timer.sleep(interval)
    remain_active = still_active?(active)
    if remain_active and (:random.uniform <= probability) do
      fetch_and_kill(process_watcher)
    end
    kill_loop(interval, probability, process_watcher, remain_active)
  end

  defp still_active?(active) when is_boolean(active)  do
    receive do
      {:switch_on}  -> still_active?(true)
      {:switch_off} -> still_active?(false)
    after
      0_001         -> active # No more messages
    end
  end

  defp fetch_and_kill(process_watcher) do
    Logger.debug("Finding a process to kill")
    pid = ProcessWatcher.get_random_pid(process_watcher)
    case pid do
      :none -> Logger.debug("no pids to kill")
      pid   -> ProcessKiller.kill(pid)
    end
  end
end
