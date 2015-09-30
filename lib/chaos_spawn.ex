defmodule ChaosSpawn do
  @moduledoc """
  The app for Chaos spawn. Provides all the wrapped spawn functions.
  """
  use Application
  require Logger
  alias ChaosSpawn.ProcessSpawner
  alias ChaosSpawn.ProcessWatcher

  @process_watcher_name ChaosSpawn.ProcessWatcher

  def start(_type, _args) do
    ChaosSpawn.Supervisor.start_link
  end

  # For convience provide all 6 spawning functions
  for spawn_fun <- [:spawn, :spawn_link, :spawn_monitor] do
    def unquote(spawn_fun)(module, fun, args) do
      args = [module, fun, args, @process_watcher_name]
      apply(ProcessSpawner, unquote(spawn_fun), args)
    end

    def unquote(spawn_fun)(fun) do
      apply(ProcessSpawner, unquote(spawn_fun), [fun, @process_watcher_name])
    end
  end

  def register_process(pid) do
    ProcessWatcher.add_pid(@process_watcher_name, pid)
  end


end
