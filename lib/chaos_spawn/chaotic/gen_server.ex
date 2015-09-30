defmodule ChaosSpawn.Chaotic.GenServer do
  @moduledoc """
  Wraps around GenServer and provides servers that get registered
  with ChaosSpawn's process killer
  """

  defmacro __using__(_opts) do
    quote do
      use GenServer
    end
  end

  def start_link(module, args, options \\ []) do
    {:ok, pid} = GenServer.start_link(module, args, options)
    ChaosSpawn.register_process pid
    {:ok, pid}
  end

end
