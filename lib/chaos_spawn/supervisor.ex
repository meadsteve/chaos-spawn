defmodule ChaosSpawn.Supervisor do
  @moduledoc """
  Top level Supervisor for all ChaosSpawn workers.
  """
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @process_watcher_name ChaosSpawn.ProcessWatcher

  @process_tidy_up_tick 2000 #2 seconds

  @default_kill_tick 1000 #1 second
  @default_kill_probability 0.1

  def init(:ok) do
    kill_tick        = get_setting :kill_tick, @default_kill_tick
    kill_probability = get_setting :kill_probability, @default_kill_probability

    children = [
      worker(ChaosSpawn.ProcessWatcher, [[name: @process_watcher_name]]),
      worker(ChaosSpawn.ProcessKiller,
        [kill_tick, kill_probability, @process_watcher_name]
      ),
      worker(Task, [&tidy_pid_list/0])
    ]

    supervise(children, strategy: :one_for_one)
  end

  defp get_setting(setting, default) do
    Application.get_env(:chaos_spawn, setting, default)
  end

  defp tidy_pid_list do
    :timer.sleep(@process_tidy_up_tick)
    ChaosSpawn.ProcessWatcher.tidy_pids(@process_watcher_name)
    tidy_pid_list
  end
end
