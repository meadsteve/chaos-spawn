defmodule ChaosSpawn.Example.GenServer do
  @moduledoc """
  The module provides an example of using the GenServer.
  The only change required from a normal gen server is
  in start_link
  """
  use GenServer

  ## Client API
  def say_hello(server) do
    GenServer.call(server, {:say_hello})
  end

  #######  Server API
  def start_link(opts \\ []) do
    ChaosSpawn.Chaotic.GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, :server_state}
  end

  def handle_call({:say_hello}, _from, state) do
    {:reply, "hello", state}
  end

end
