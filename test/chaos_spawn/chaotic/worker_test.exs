defmodule Chaotic.WorkerTest do
  use ExUnit.Case
  alias ChaosSpawn.Chaotic.ChaoticWorker
  alias Chaotic.WorkerTest.Example

  test "worker/2 wraps up a call to Supervisor.Spec worker" do
    args = [:arg_one, :arg_two]

    expected = {
      ModuleToCall,
      {ChaoticWorker, :start_link_wrapper, [ModuleToCall, :start_link, args]},
      :permanent,
      5000,
      :worker,
      [ChaoticWorker]
    }

    assert ChaoticWorker.worker(ModuleToCall, args) == expected
  end

  test "worker/2 takes :function as an option" do
    args = [:arg_one, :arg_two]
    my_start_func = :special_start_link

    expected = {
      ModuleToCall,
      {ChaoticWorker, :start_link_wrapper, [ModuleToCall, my_start_func, args]},
      :permanent,
      5000,
      :worker,
      [ChaoticWorker]
    }

    worker = ChaoticWorker.worker(ModuleToCall, args, function: my_start_func)
    assert worker == expected
  end

  test "start_link_wrapper/3 calls the wrapped start_func" do
    args = [:expected_arg]
    {:ok, pid} = ChaoticWorker.start_link_wrapper(Example, :start_link, args)
    assert is_pid(pid)
  end
end

defmodule Chaotic.WorkerTest.Example do
  def start_link(:expected_arg) do
    {:ok, spawn fn -> receive do
            _ -> :ok
          end end
    }
  end
end
