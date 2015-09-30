defmodule ChaosSpawn.Chaotic.Spawn do
  @moduledoc """
  Using this module automatically replaces all spawn and spawn_*
  functions.
  """
  @spawn_functions [spawn: 1, spawn: 3,
                    spawn_link: 1, spawn_link: 3,
                    spawn_monitor: 1, spawn_monitor: 3]

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: unquote(@spawn_functions)
      import ChaosSpawn, only: unquote(@spawn_functions)
    end
  end
end
