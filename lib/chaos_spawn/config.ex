defmodule ChaosSpawn.Config do
  def kill_config do
    case get_setting(:only_kill_between) do
      nil         -> []
      time_window -> [{:only_kill_between, time_window}]
    end
  end

  defp get_setting(setting) do
    Application.get_env(:chaos_spawn, setting, nil)
  end

end
