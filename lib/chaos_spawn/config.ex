defmodule ChaosSpawn.Config do
  @moduledoc """
  Wraps around config keys used by ChaosSpawn
  """

  @default_kill_tick 1000  # 1 second
  @default_kill_prob 0.015 # Kill about 1 process a minute
  @defualt_kill_window :anytime

  def kill_config do
    case get_setting(:only_kill_between, @defualt_kill_window) do
      :anytime    -> []
      time_window -> [{:only_kill_between, time_window}]
    end
  end

  def kill_tick, do: get_setting(:kill_tick,        @default_kill_tick)
  def kill_prob, do: get_setting(:kill_probability, @default_kill_prob)

  defp get_setting(setting, default) do
    Application.get_env(:chaos_spawn, setting, default)
  end

end
