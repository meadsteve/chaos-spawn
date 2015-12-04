defmodule PidListTest do
  use ExUnit.Case
  alias ChaosSpawn.PidList

  test "only_alive/1 removes dead pids" do
    pid_to_kill = spawn(&PidListTest.TestModule.test_fun/0)
    other_pid = spawn(&PidListTest.TestModule.test_fun/0)
    list = [{pid_to_kill, []}, {other_pid, []}]
    Process.exit(pid_to_kill, :kill)

    alive_list = PidList.only_alive(list)
    assert Enum.count(alive_list) == 1
  end

  test "pick_random/1 returns :none when given empty list" do
    empty_list = []
    assert PidList.pick_random(empty_list) == :none
  end

  test "pick_random/1 returns a single pid and its data" do
    single_pid = spawn(&PidListTest.TestModule.test_fun/0)
    {pid, _data} = PidList.pick_random([{single_pid, []}])
    assert is_pid(pid)
  end

end

defmodule PidListTest.TestModule do
  def test_fun do
    receive do
      {_} -> :ok
    end
  end
end
