defmodule ChaosSpawn.ProcessSpawner do

  def spawn(module, fun, args, _watcher_pid) do
    Kernel.spawn(module, fun, args)
  end

  def spawn(fun, _watcher_pid) do
    Kernel.spawn(fun)
  end

end
