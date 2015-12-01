defmodule ChaosSpawn.ProcessKiller do
  @moduledoc """
  Module responsible for killing processes. Called by ChaosSpawn.KillLoop
  """

  require Logger
  alias ChaosSpawn.Time
  alias ChaosSpawn.Config

  def kill(pid), do: kill(pid, Config.kill_config)

  def kill(pid, config) do
    if allowed_to_kill?(config) do
      Logger.debug("Killing pid #{inspect pid}")
      Process.exit(pid, :kill)
    end
  end

  defp allowed_to_kill?([]), do: true

  defp allowed_to_kill?(only_kill_between: {start_time, end_time}) do
    Time.now |> Time.between?(start_time, end_time)
  end

  defp allowed_to_kill?(only_kill_between: {start_time, end_time}, only_kill_on_days: allowed_days) do
    time_allows = Time.now |> Time.between?(start_time, end_time)
    day_allows  = Time.now |> Time.is_on_one_of_days?(allowed_days)
  end

end
