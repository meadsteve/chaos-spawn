defmodule ChaosSpawn.PidList do
  @moduledoc """
  Utilities for dealing with lists of pids
  """

  def only_alive(pids) do
    pids
      |> Stream.filter(&Process.alive?/1)
  end

  def pick_random(pids) do
    try do
      [pid] = pids
        |> Enum.shuffle
        |> only_alive
        |> Enum.take(1)
      pid
    rescue
      _error in MatchError -> :none
    end
  end

end
