defmodule ChaosSpawn.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @process_watcher_name ChaosSpawn.ProcessWatcher

  def init(:ok) do
    children = [
      worker(ChaosSpawn.ProcessWatcher, [[name: @process_watcher_name]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
