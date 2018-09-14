defmodule ChaosSpawn.ProcessKiller do
  @moduledoc """
  Module responsible for killing processes. Called by ChaosSpawn.KillLoop
  """

  require Logger
  alias ChaosSpawn.Config
  alias ChaosSpawn.Time

  def kill(pid), do: kill(pid, Config.kill_config)

  def kill(pid, config) do
    if allowed_to_kill?(config) do
      Logger.debug(fn -> "Killing pid #{inspect pid}" end)
      Process.exit(pid, :kill)
    end
  end

  defp allowed_to_kill?([]), do: true

  defp allowed_to_kill?(only_kill_between: time_window) do
    time_allows?(time_window)
  end

  defp allowed_to_kill?(only_kill_between: window, only_kill_on_days: days) do
    time_allows?(window) && day_allows?(days)
  end

  defp allowed_to_kill?(only_kill_on_days: allowed_days) do
    day_allows?(allowed_days)
  end

  defp time_allows?({start_time, end_time}) do
    Time.now |> Time.between?(start_time, end_time)
  end

  defp day_allows?(allowed_days) do
    Time.now |> Time.on_one_of_days?(allowed_days)
  end

end
