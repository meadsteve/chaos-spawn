defmodule ChaosSpawn.Time do
  alias Timex.Date.Convert

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
