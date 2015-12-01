defmodule ChaosSpawn.Time do
  @moduledoc """
  Wraps all time operations needed by ChaosSpawn
  """

  alias Timex.Date.Convert

  @use_fake_now Application.get_env(:chaos_spawn, :fake_fixed_now, false)
  @fake_now {{2014, 12, 13}, {14, 50, 00}}

  if @use_fake_now do
    def now, do: Timex.Date.from(@fake_now)
  else
    def now, do: Timex.Date.now
  end

  def on_one_of_days?(%Timex.DateTime{} = datetime, days) do
    current_day = datetime
      |> Timex.Date.weekday
    days
      |> Enum.map(&Timex.Date.day_to_num/1)
      |> Enum.any?(fn day -> day == current_day end)
  end

  def on_one_of_days?(erlang_datetime, days) do
    erlang_datetime
      |> Timex.Date.from
      |> on_one_of_days?(days)
  end

  def between?(%Timex.DateTime{} = time, start_time, end_time) do
    {_ignored_date, {h, m, s}} = Convert.to_erlang_datetime(time)
    between?({h, m, s}, start_time, end_time)
  end

  def between?({h, m, s} = time, start_time, end_time)
  when is_integer(h) and is_integer(m) and is_integer(s)
  do
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
