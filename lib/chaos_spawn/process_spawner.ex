defmodule ChaosSpawn.ProcessSpawner do

  def spawn(module, fun, args, watcher_pid) do
    pid = Kernel.spawn(module, fun, args)
    send watcher_pid, {:new_pid, pid}
    pid
  end

  def spawn(fun, watcher_pid) do
    pid = Kernel.spawn(fun)
    send watcher_pid, {:new_pid, pid}
    pid
  end

end
