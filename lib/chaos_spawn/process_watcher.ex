defmodule ChaosSpawn.ProcessWatcher do
  @moduledoc """
  GenServer implementation to record pids passed in and return random pids
  when requested.
  """
  use ExActor.GenServer
  require Logger

  defstart start_link, gen_server_opts: :runtime, do: initial_state([])

  defcall all_pids, state: pids, do: reply(pids)

  defcall get_random_pid, state: pids do
    updated_pids = pids |> only_alive_pids
    pid = pick_random_pid(updated_pids)

    set_and_reply(updated_pids, pid)
  end

  defcast add_pid(pid), when: is_pid(pid), state: pids do
    updated_pids = case Process.alive?(pid) do
      true  -> [pid | pids]
      false -> pids
    end
    new_state(updated_pids)
  end

  defcast add_pid(_), state: pids do
    Logger.warn "Invalid PID recieved"
    new_state(pids)
  end

  defcast tidy_pids(), state: pids do
    new_state(pids |> only_alive_pids)
  end


  ####### Utilities
  defp only_alive_pids(pids) do
    pids
      |> Enum.filter(&Process.alive?/1)
  end

  defp pick_random_pid(pids) do
    pids
      |> Enum.shuffle
    case Enum.count(pids) do
      0 ->
        :none
      _ ->
        [pid] = pids |> Enum.take(1)
        pid
    end
  end

end
