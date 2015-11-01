defmodule ChaosSpawn.Chaotic.ChaoticWorker do
  @moduledoc """
  Provides worker/2 and worker/3 that wrap around Supervisor.Spec's worker
  functions and registered any spawned pids with ChaosSpawn's process killer.
  """
  alias Supervisor.Spec, as: OriginalSupervisor
  alias ChaosSpawn.Config

  def worker(module, args) do
    worker(module, args, function: :start_link)
  end

  def worker(module, args, function: start_link_function) do
    OriginalSupervisor.worker(
      __MODULE__,
      [module, start_link_function, args],
      id: module,
      function: :start_link_wrapper
    )
  end

  def start_link_wrapper(module, function, args)
  when is_atom(module) and is_atom(function)
  do
    skipped_modules = Config.skipped_workers
    start_link_wrapper(module, function, args, skip_modules: skipped_modules)
  end

  def start_link_wrapper(module, function, args, skip_modules: skipped)
  when is_atom(module) and is_atom(function) and is_list(skipped)
  do
    module
      |> apply(function, args)
      |> register_unless_skipped(module, skipped)
  end

  defp register_unless_skipped(result, module, skipped_modules) do
    if (skip_module?(skipped_modules, module)) do
      result
    else
      result |> register_start_result
    end
  end

  defp register_start_result({:ok, pid}) do
    ChaosSpawn.register_process(pid)
    {:ok, pid}
  end

  defp register_start_result(failed) do
    failed
  end

  defp skip_module?(skipped_modules, module) do
    Enum.member?(skipped_modules, module)
  end

end
