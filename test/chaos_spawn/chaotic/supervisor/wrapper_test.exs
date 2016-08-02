defmodule ChaosSpawn.Chaotic.Supervisor.WrapperTest do
  use ExUnit.Case
  alias ChaosSpawn.Chaotic.Supervisor.Wrapper
  alias Chaotic.WrapperTest.Example

  setup do
    ChaosSpawn.stop
    on_exit fn -> ChaosSpawn.start end
    :ok
  end

  test "start_link_wrapper/3 calls the wrapped start_func" do
    args = [:expected_arg]
    {:ok, pid} = Wrapper.start_link_wrapper(Example, :start_link, args)
    assert is_pid(pid)
  end

  test "start_link_wrapper/3 registers the pid with ChaosSpawn" do
    args = [:expected_arg]
    {:ok, pid} = Wrapper.start_link_wrapper(Example, :start_link, args)
    assert ChaosSpawn.process_registered?(pid)
  end

  test "start_link_wrapper/4 can be passed config to ignore modules" do
    args = [:expected_arg]
    {:ok, pid} = Wrapper.start_link_wrapper(
      Example, :start_link, args, skip_modules: [Example]
    )
    assert not ChaosSpawn.process_registered?(pid)
  end
end

defmodule Chaotic.WrapperTest.Example do
  def start_link(:expected_arg) do
    {:ok, spawn fn -> receive do
            _ -> :ok
          end end
    }
  end
end
