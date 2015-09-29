defmodule ChaosSpawn.ProcessSpawner do

  def spawn(module, fun, args, watcher) do
    pid = Kernel.spawn(module, fun, args)
    ChaosSpawn.ProcessWatcher.add_pid(watcher, pid)
    pid
  end

  def spawn(fun, watcher) do
    pid = Kernel.spawn(fun)
    ChaosSpawn.ProcessWatcher.add_pid(watcher, pid)
    pid
  end

end
