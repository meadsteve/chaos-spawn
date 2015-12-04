defmodule ChaosSpawn.Chaotic.Supervisor.Wrapper do
  @moduledoc """
  Provides the common functionality for the Supervisor and Worker modules
  """
  alias ChaosSpawn.Config

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

  @doc false
  def child_spec(type, module, args, opts) do
    start_link_function = opts |> Keyword.get(:function, :start_link)
    wrapped_args = [module, start_link_function, args]
    updated_opts = opts
      |> Keyword.put(:function, :start_link_wrapper)
      |> Keyword.put_new(:id, module)
      |> Keyword.put_new(:modules, [module])
    apply(Supervisor.Spec, type, [__MODULE__, wrapped_args, updated_opts])
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
