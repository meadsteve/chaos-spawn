defmodule ChaosSpawn.Chaotic.GenEvent do
  @moduledoc """
  Wraps around GenEvent and provides a pid that get registered
  with ChaosSpawn's process killer
  """

  defmacro __using__(_opts) do
    quote do
      use GenEvent
    end
  end

  def start_link(options \\ []) do
    {:ok, pid} = GenEvent.start_link(options)
    ChaosSpawn.register_process pid
    {:ok, pid}
  end

end
