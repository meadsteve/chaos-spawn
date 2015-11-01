defmodule ChaosSpawn.ProcessWatcher do
  @moduledoc """
  GenServer implementation to record pids passed in and return random pids
  when requested.
  """
  use ExActor.GenServer
  require Logger

  defstart start_link, gen_server_opts: :runtime, do: initial_state([])

  defcall all_pids(), state: pids, do: reply(pids)

  defcall contains_pid?(pid), state: pids, do: reply(pids |> Enum.member?(pid))

  defcall get_random_pid(), state: pids do
    updated_pids = pids |> ChaosSpawn.PidList.only_alive
    pid = ChaosSpawn.PidList.pick_random(updated_pids)

    set_and_reply(updated_pids, pid)
  end

  defcast add_pid(pid), when: is_pid(pid), state: pids do
    updated_pids = case Process.alive?(pid) do
      true  -> [pid | pids]
      false -> pids
    end
    new_state(updated_pids)
  end

  defcast add_pid(_) do
    Logger.warn "Invalid PID recieved"
    noreply
  end

  defcast tidy_pids(), state: pids do
    new_state(pids |> ChaosSpawn.PidList.only_alive)
  end

end
