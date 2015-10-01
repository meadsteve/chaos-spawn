defmodule ChaosSpawn.ProcessKiller do
  @moduledoc """
  Module responsible for waiting and randomly killing processes.
  Is dependent on being given a ChaosSpawn.ProcessWatcher to discover
  proceses it can kill.
  """

  require Logger
  alias ChaosSpawn.ProcessWatcher

  def start_link(interval, probability, process_watcher) do
    pid = spawn(fn -> kill_loop(interval, probability, process_watcher) end)
    {:ok, pid}
  end

  def kill(pid) do
    Logger.debug("Killing pid #{inspect pid}")
    Process.exit(pid, :kill)
  end

  defp kill_loop(interval, probability, process_watcher) do
    :timer.sleep(interval)
    if :random.uniform <= probability do
      fetch_and_kill(process_watcher)
    end
    kill_loop(interval, probability, process_watcher)
  end

  defp fetch_and_kill(process_watcher) do
    Logger.debug("Finding a process to kill")
    pid = ProcessWatcher.get_random_pid(process_watcher)
    case pid do
      :none -> Logger.debug("no pids to kill")
      pid   -> kill(pid)
    end
  end

end
