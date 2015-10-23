defmodule ChaosSpawn.PidList do
  @moduledoc """
  Utilities for dealing with lists of pids
  """

  def only_alive(pids) do
    pids
      |> Enum.filter(&Process.alive?/1)
  end

  def pick_random(pids) do
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
