defmodule ChaosSpawn.Chaotic.ChaoticSupervisor do
  @moduledoc """
  Provides supervisor/2 that starts the given module as a supervisor but
  register with ChaosSpawn as a killable process.

  """
  alias Supervisor.Spec, as: OriginalSupervisor
  alias ChaosSpawn.Chaotic.Supervisor.Wrapper

  def supervisor(module, args, opts \\ []) do
    start_link_function = opts |> Keyword.get(:function, :start_link)
    id = opts |> Keyword.get(:id, module)
    OriginalSupervisor.supervisor(
      Wrapper,
      [module, start_link_function, args],
      id: id,
      function: :start_link_wrapper
    )
  end
end
