defmodule ChaosSpawn.Chaotic.ChaoticSupervisor do
  @moduledoc """
  Provides supervisor/2 that starts the given module as a supervisor but
  register with ChaosSpawn as a killable process.

  """
  alias Supervisor.Spec, as: OriginalSupervisor
  alias ChaosSpawn.Chaotic.Supervisor.Wrapper

  def supervisor(module, args) do
    supervisor(module, args, function: :start_link)
  end

  def supervisor(module, args, function: start_link_function) do
    OriginalSupervisor.supervisor(
      Wrapper,
      [module, start_link_function, args],
      id: module,
      function: :start_link_wrapper
    )
  end
  
end
