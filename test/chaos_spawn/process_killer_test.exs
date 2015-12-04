defmodule ProcessKillerTest do
  use ExUnit.Case
  alias ChaosSpawn.ProcessKiller

  test "can kill based on pid" do
    pid = spawn(&ProcessKillerTest.TestModule.test_fun/0)
    ProcessKiller.kill(pid)
    assert Process.alive?(pid) == false
  end

  test "can kill a pid which has no extra data" do
    pid = spawn(&ProcessKillerTest.TestModule.test_fun/0)
    ProcessKiller.kill({pid, []})
    assert Process.alive?(pid) == false
  end

  test "won't kill if config defines an allowed time window and now is outside" do
    #during testing now is always {14, 50, 00}
    kill_config = [{:only_kill_between, {{15, 00, 00}, {17, 00, 00}}}]
    pid = spawn(&ProcessKillerTest.TestModule.test_fun/0)
    ProcessKiller.kill(pid, kill_config)
    assert Process.alive?(pid) == true
  end

  test "will kill if config defines an allowed time window and now is inside" do
    #during testing now is always {14, 50, 00}
    kill_config = [{:only_kill_between, {{10, 00, 00}, {16, 00, 00}}}]
    pid = spawn(&ProcessKillerTest.TestModule.test_fun/0)
    ProcessKiller.kill(pid, kill_config)
    assert Process.alive?(pid) == false
  end

  test "won't kill if config defines allowed days and today is not one of them" do
    #during testing now is always a Saturday at {14, 50, 00}
    kill_config = [
      {:only_kill_between, {{10, 00, 00}, {16, 00, 00}}},
      {:only_kill_on_days, [:mon, :tue, :wed, :thu, :fri]},
    ]
    pid = spawn(&ProcessKillerTest.TestModule.test_fun/0)
    ProcessKiller.kill(pid, kill_config)
    assert Process.alive?(pid) == true
  end

  test "will kill if config defines allowed days and today is one" do
    #during testing now is always a Saturday at {14, 50, 00}
    kill_config = [
      {:only_kill_between, {{10, 00, 00}, {16, 00, 00}}},
      {:only_kill_on_days, [:sat, :sun]},
    ]
    pid = spawn(&ProcessKillerTest.TestModule.test_fun/0)
    ProcessKiller.kill(pid, kill_config)
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
