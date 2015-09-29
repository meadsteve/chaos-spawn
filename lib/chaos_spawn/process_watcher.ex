defmodule ChaosSpawn.ProcessWatcher do
  use GenServer
  require Logger

  ## Client API
  def all_pids(process_watcher) do
    GenServer.call(process_watcher, {:all_pids})
  end

  #######  Server API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_call({:all_pids}, _from, pids) do
    {:reply, pids, pids}
  end

  #######  Message section
  def handle_info({:new_pid, pid}, pids) when is_pid(pid) do
    {:noreply, [pid | pids]}
  end

  def handle_info({:new_pid, _invalid_pid}, pids) do
    Logger.warn "Invalid PID recieved"
    {:noreply, pids}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  ####### Utilities
  defp only_alive_pids(pids) do
    pids
      |> Enum.filter(Process.alive?)
  end

end
