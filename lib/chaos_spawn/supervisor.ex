defmodule ChaosSpawn.Supervisor do
  @moduledoc """
  Top level Supervisor for all ChaosSpawn workers.
  """
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @process_watcher ChaosSpawn.ProcessWatcher
  @process_killer ChaosSpawn.ProcessKiller

  @process_tidy_up_tick 2000 #2 seconds

  @default_kill_tick 1000 #1 second
  @default_kill_prob 0.015 # Kill about 1 process a minute

  def init(:ok) do
    children = [
      worker(ChaosSpawn.ProcessWatcher, [[name: @process_watcher]]),
      worker(ChaosSpawn.ProcessKiller,
        [kill_tick, kill_prob, @process_watcher, [name: @process_killer]]
      ),
      worker(Task, [&tidy_pid_list/0])
    ]

    supervise(children, strategy: :one_for_one)
  end

  defp kill_tick, do: get_setting(:kill_tick, @default_kill_tick)
  defp kill_prob, do: get_setting(:kill_probability, @default_kill_prob)

  defp get_setting(setting, default) do
    Application.get_env(:chaos_spawn, setting, default)
  end

  defp tidy_pid_list do
    :timer.sleep(@process_tidy_up_tick)
    ChaosSpawn.ProcessWatcher.tidy_pids(@process_watcher)
    tidy_pid_list
  end
end
