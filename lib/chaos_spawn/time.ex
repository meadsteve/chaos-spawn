defmodule ChaosSpawn.Time do
  @moduledoc """
  Wraps all time operations needed by ChaosSpawn
  """

  alias Timex.Date.Convert

  is_fixed_now = Application.get_env(:chaos_spawn, :fake_fixed_now, false)
  if is_fixed_now do
    def now, do: Timex.Date.from({{2014, 12, 13}, {14, 50, 00}})
  else
    def now, do: Timex.Date.now
  end

  def between?(%Timex.DateTime{} = time, start_time, end_time) do
    {_ignored_date, {h, m, s}} = Convert.to_erlang_datetime(time)
    between?({h, m, s}, start_time, end_time)
  end

  def between?(time, start_time, end_time) when is_tuple(time) do
    time |> after?(start_time) && time |> before?(end_time)
  end

  defp after?(time, compare_to) when is_tuple(time) and is_tuple(compare_to) do
    (time |> in_seconds) >=  (compare_to |> in_seconds)
  end

  defp before?(time, compare_to) when is_tuple(time) and is_tuple(compare_to) do
    (time |> in_seconds) <=  (compare_to |> in_seconds)
  end

  defp in_seconds({hours, minutes, seconds}) do
    (hours * 60 * 60) + (minutes * 60) + seconds
  end

end
