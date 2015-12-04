defmodule ChaosSpawn.Chaotic.ChaoticSupervisor do
  @moduledoc """
  Provides supervisor/2 that starts the given module as a supervisor but
  register with ChaosSpawn as a killable process.

  """
  alias ChaosSpawn.Chaotic.Supervisor.Wrapper

  def supervisor(module, args, opts \\ []) do
    Wrapper.child_spec(:supervisor, module, args, opts)
  end
end
