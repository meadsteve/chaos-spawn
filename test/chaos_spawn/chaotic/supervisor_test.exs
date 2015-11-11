defmodule Chaotic.SupervisorTest do
  use ExUnit.Case
  alias ChaosSpawn.Chaotic.ChaoticSupervisor
  alias Chaotic.WorkerTest.Example

  setup do
    ChaosSpawn.stop
    on_exit fn -> ChaosSpawn.start end
    :ok
  end

  test "supervisor/2 wraps up a call to Supervisor.Spec supervisor/2" do
    args = [:arg_one, :arg_two]

    expected = {
      ModuleToCall,
      {ChaoticSupervisor, :start_link_wrapper, [ModuleToCall, :start_link, args]},
      :permanent,
      :infinity,
      :supervisor,
      [ChaoticSupervisor]
    }

    assert ChaoticSupervisor.supervisor(ModuleToCall, args) == expected
  end

end
