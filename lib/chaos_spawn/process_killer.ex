defmodule ChaosSpawn.ProcessKiller do
  @moduledoc """
  Module responsible for killing processes. Called by ChaosSpawn.KillLoop
  """

  require Logger
  alias ChaosSpawn.Time
  alias ChaosSpawn.Config

  def kill(pid), do: kill(pid, Config.kill_config)

  def kill(pid, only_kill_between: {start_time, end_time}) do
    in_killing_window? = Time.now |> Time.between?(start_time, end_time)
    if in_killing_window?, do: kill(pid, [])
  end

  def kill(pid, []) do
    Logger.debug("Killing pid #{inspect pid}")
    Process.exit(pid, :kill)
  end


end
