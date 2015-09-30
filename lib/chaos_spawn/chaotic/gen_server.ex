defmodule ChaosSpawn.Chaotic.GenServer do
  @moduledoc """
  Wraps around GenServer and provides servers that get registered
  with ChaosSpawn's process killer
  """

  defmacro __using__(_opts) do
    quote do
      use GenServer
      import ChaosSpawn.Chaotic.GenServer,
        only: [start_chaotic_link: 2, start_chaotic_link: 3]
      import GenServer,
        only: [start_link: 2, start_link: 3]
    end
  end

  def start_chaotic_link(module, args, options \\ []) do
    {:ok, pid} = GenServer.start_link(module, args, options)
    ChaosSpawn.register_process pid
    {:ok, pid}
  end

  # alias for start_chaotic_link
  def start_link(module, args, options \\ []) do
    start_chaotic_link(module, args, options)
  end

end
