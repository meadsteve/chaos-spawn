defmodule ChaosSpawn.ProcessWatcher do
  @moduledoc """
  GenServer implementation to record pids passed in and return random pids
  when requested.
  """
  use ExActor.GenServer
  require Logger

  defstart start_link, gen_server_opts: :runtime, do: initial_state([])

  defcall all_pids(), state: pids do
    reply(pids |> Enum.map(fn {pid, _} -> pid end))
  end

  defcall contains_pid?(pid), state: pids do
    contains? = pids
      |> Stream.map(fn {pid, _} -> pid end)
      |> Enum.member?(pid)
    reply(contains?)
  end

  defcall get_random_pid(), state: pids do
     case ChaosSpawn.PidList.pick_random(pids) do
       {pid, _data} -> reply(pid)
       :none -> reply(:none)
     end
  end

  defcast add_pid(pid), when: is_pid(pid), state: pids do
    updated_pids = case Process.alive?(pid) do
      true  ->
        Process.monitor pid
        [{pid, []} | pids]
      false -> pids
    end
    new_state(updated_pids)
  end

  defcast add_pid(_) do
    Logger.warn "Invalid PID recieved"
    noreply
  end

  defhandleinfo {:DOWN, _, :process, dead_pid, _}, state: pids do
    new_state(pids |> Enum.reject(fn {pid, _data} -> pid == dead_pid end))
  end

end
