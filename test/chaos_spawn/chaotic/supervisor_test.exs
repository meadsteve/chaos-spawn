defmodule Chaotic.SupervisorTest do
  use ExUnit.Case
  alias ChaosSpawn.Chaotic.ChaoticSupervisor
  alias ChaosSpawn.Chaotic.Supervisor.Wrapper
  alias Chaotic.WorkerTest.Example

  test "supervisor/2 wraps up a call to Supervisor.Spec supervisor/2" do
    args = [:arg_one, :arg_two]

    expected = {
      ModuleToCall,
      {Wrapper, :start_link_wrapper, [ModuleToCall, :start_link, args]},
      :permanent,
      :infinity,
      :supervisor,
      [ModuleToCall]
    }

    assert ChaoticSupervisor.supervisor(ModuleToCall, args) == expected
  end

end
