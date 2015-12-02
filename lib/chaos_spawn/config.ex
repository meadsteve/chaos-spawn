defmodule ChaosSpawn.Config do
  @moduledoc """
  Wraps around config keys used by ChaosSpawn
  """

  @default_kill_tick 1000  # 1 second
  @default_kill_prob 0.015 # Kill about 1 process a minute
  @default_kill_window :anytime
  @default_kill_days :anyday
  @default_skipped_workers [] # Nothing skipped by default

  def kill_config do
    []
      |> add_kill_window
      |> add_allowed_killing_days
  end

  def kill_tick, do: get_setting(:kill_tick,        @default_kill_tick)
  def kill_prob, do: get_setting(:kill_probability, @default_kill_prob)

  def skipped_workers do
    get_setting(:skip_worker_modules, @default_skipped_workers)
  end

  defp get_setting(setting, default) do
    Application.get_env(:chaos_spawn, setting, default)
  end

  defp add_kill_window(config) do
    case get_setting(:only_kill_between, @default_kill_window) do
      :anytime    -> config
      time_window -> [{:only_kill_between, time_window} | config]
    end
  end

  defp add_allowed_killing_days(config) do
    case get_setting(:only_kill_on_days, @default_kill_days) do
      :anyday  -> config
      days     -> [{:only_kill_on_days, days} | config]
    end
  end

end
