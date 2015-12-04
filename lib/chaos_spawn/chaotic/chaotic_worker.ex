defmodule ChaosSpawn.Chaotic.ChaoticWorker do
  @moduledoc """
  Provides worker/2 and worker/3 that wrap around Supervisor.Spec's worker
  functions and registered any spawned pids with ChaosSpawn's process killer.
  """
  alias ChaosSpawn.Chaotic.Supervisor.Wrapper

  def worker(module, args, opts \\ []) do
    Wrapper.child_spec(:worker, module, args, opts)
  end
end
