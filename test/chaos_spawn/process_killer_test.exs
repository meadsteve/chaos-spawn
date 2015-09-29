defmodule ProcessKillerTest do
  use ExUnit.Case
  alias ChaosSpawn.ProcessKiller

  test "can kill based on pid" do
    pid = spawn(&ProcessKillerTest.TestModule.test_fun/0)
    ProcessKiller.kill(pid)
    assert Process.alive?(pid) == false 
  end

end

defmodule ProcessKillerTest.TestModule do
  def test_fun do
    receive do
      {_} -> :ok
    end
  end
end
