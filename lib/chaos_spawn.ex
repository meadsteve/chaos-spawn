defmodule ChaosSpawn do
  @moduledoc """
  The app for Chaos spawn. Provides all the wrapped spawn functions.
  """
  use Application
  require Logger
  alias ChaosSpawn.ProcessSpawner
  alias ChaosSpawn.ProcessWatcher

  @process_watcher ChaosSpawn.ProcessWatcher
  @kill_loop ChaosSpawn.KillLoop

  def start(_type, _args) do
    ChaosSpawn.Supervisor.start_link
  end

  # For convience provide all 6 spawning functions
  for spawn_fun <- [:spawn, :spawn_link, :spawn_monitor] do
    def unquote(spawn_fun)(module, fun, args) do
      args = [module, fun, args, @process_watcher]
      apply(ProcessSpawner, unquote(spawn_fun), args)
    end

    def unquote(spawn_fun)(fun) do
      apply(ProcessSpawner, unquote(spawn_fun), [fun, @process_watcher])
    end
  end

  def register_process(pid) do
    ProcessWatcher.add_pid(@process_watcher, pid)
  end

  def register_process(pid, extra) do
    ProcessWatcher.add_pid(@process_watcher, pid, extra)
  end

  def process_registered?(pid) do
    ProcessWatcher.contains_pid?(@process_watcher, pid)
  end

  def stop do
    send @kill_loop, {:switch_off}
  end

  def start do
    send @kill_loop, {:switch_on}
  end

end
