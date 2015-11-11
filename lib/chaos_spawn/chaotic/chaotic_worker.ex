defmodule ChaosSpawn.Chaotic.ChaoticWorker do
  @moduledoc """
  Provides worker/2 and worker/3 that wrap around Supervisor.Spec's worker
  functions and registered any spawned pids with ChaosSpawn's process killer.
  """
  alias Supervisor.Spec, as: OriginalSupervisor
  alias ChaosSpawn.Chaotic.Supervisor.Wrapper

  def worker(module, args) do
    worker(module, args, function: :start_link)
  end

  def worker(module, args, function: start_link_function) do
    OriginalSupervisor.worker(
      Wrapper,
      [module, start_link_function, args],
      id: module,
      function: :start_link_wrapper
    )
  end

end
