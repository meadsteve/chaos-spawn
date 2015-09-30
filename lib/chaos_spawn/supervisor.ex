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

  @process_kill_tick 1000 #1 second
  @tick_kill_probality 0.1

  def init(:ok) do
    children = [
      worker(ChaosSpawn.ProcessWatcher, [[name: @process_watcher_name]]),
      worker(ChaosSpawn.ProcessKiller,
        [@process_kill_tick, @tick_kill_probality, @process_watcher_name]
      ),
      worker(Task, [&tidy_pid_list/0])
    ]

    supervise(children, strategy: :one_for_one)
  end

  defp tidy_pid_list do
    :timer.sleep(@process_tidy_up_tick)
    ChaosSpawn.ProcessWatcher.tidy_pids(@process_watcher_name)
    tidy_pid_list
  end
end
