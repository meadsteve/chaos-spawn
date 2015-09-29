defmodule ChaosSpawn do
  use Application
  require Logger

  @process_watcher_name ChaosSpawn.ProcessWatcher

  def start(_type, _args) do
    ChaosSpawn.Supervisor.start_link
  end

  def spawn(module, fun, args) do
    ChaosSpawn.ProcessSpawner.spawn(module, fun, args, @process_watcher_name)
  end

  def spawn(fun) do
    ChaosSpawn.ProcessSpawner.spawn(fun, @process_watcher_name)
  end

end
