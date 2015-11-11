defmodule Chaotic.WorkerTest do
  use ExUnit.Case
  alias ChaosSpawn.Chaotic.ChaoticWorker
  alias ChaosSpawn.Chaotic.Supervisor.Wrapper
  alias Chaotic.WorkerTest.Example

  test "worker/2 wraps up a call to Supervisor.Spec worker" do
    args = [:arg_one, :arg_two]

    expected = {
      ModuleToCall,
      {Wrapper, :start_link_wrapper, [ModuleToCall, :start_link, args]},
      :permanent,
      5000,
      :worker,
      [Wrapper]
    }

    assert ChaoticWorker.worker(ModuleToCall, args) == expected
  end

  test "worker/2 takes :function as an option" do
    args = [:arg_one, :arg_two]
    my_start_func = :special_start_link

    expected = {
      ModuleToCall,
      {Wrapper, :start_link_wrapper, [ModuleToCall, my_start_func, args]},
      :permanent,
      5000,
      :worker,
      [Wrapper]
    }

    worker = ChaoticWorker.worker(ModuleToCall, args, function: my_start_func)
    assert worker == expected
  end
end
