defmodule ChaosSpawn.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @process_watcher_name ChaosSpawn.ProcessWatcher
  @process_kill_tick 1000 #1 second
  @tick_kill_probality 0.1

  def init(:ok) do
    children = [
      worker(ChaosSpawn.ProcessWatcher, [[name: @process_watcher_name]]),
      worker(ChaosSpawn.ProcessKiller,
        [@process_kill_tick, @tick_kill_probality, @process_watcher_name]
      )
    ]

    supervise(children, strategy: :one_for_one)
  end
end
