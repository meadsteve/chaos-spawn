defmodule ChaosSpawn.Supervisor do
  @moduledoc """
  Top level Supervisor for all ChaosSpawn workers.
  """
  use Supervisor
  alias ChaosSpawn.Config

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @process_watcher ChaosSpawn.ProcessWatcher
  @kill_loop ChaosSpawn.KillLoop

  @process_tidy_up_tick 2000 #2 seconds


  def init(:ok) do
    children = [
      worker(ChaosSpawn.ProcessWatcher, [[name: @process_watcher]]),
      worker(ChaosSpawn.KillLoop,
        [kill_tick, kill_prob, @process_watcher, [name: @kill_loop]]
      ),
      worker(Task, [&tidy_pid_list/0])
    ]

    supervise(children, strategy: :one_for_one)
  end

  defp kill_tick, do: Config.kill_tick
  defp kill_prob, do: Config.kill_prob

  defp tidy_pid_list do
    :timer.sleep(@process_tidy_up_tick)
    ChaosSpawn.ProcessWatcher.tidy_pids(@process_watcher)
    tidy_pid_list
  end
end
