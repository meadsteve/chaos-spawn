defmodule ChaosSpawn.ProcessSpawner do
  alias ChaosSpawn.ProcessWatcher
  @moduledoc """
  Provides spawn functions that call Kernel.* methods
  but also pass the new pid to the ChaosSpawn.ProcessWatcher
  """

  def spawn(module, fun, args, watcher) do
    pid = Kernel.spawn(module, fun, args)
    ProcessWatcher.add_pid(watcher, pid)
    pid
  end

  def spawn(fun, watcher) do
    pid = Kernel.spawn(fun)
    ProcessWatcher.add_pid(watcher, pid)
    pid
  end

  def spawn_link(module, fun, args, watcher) do
    pid = Kernel.spawn_link(module, fun, args)
    ProcessWatcher.add_pid(watcher, pid)
    pid
  end

  def spawn_link(fun, watcher) do
    pid = Kernel.spawn_link(fun)
    ProcessWatcher.add_pid(watcher, pid)
    pid
  end

end
