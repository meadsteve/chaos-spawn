defmodule ChaosSpawn.Time do
  @moduledoc """
  Wraps all time operations needed by ChaosSpawn
  """

  @use_fake_now Application.get_env(:chaos_spawn, :fake_fixed_now, false)
  @fake_now {{2014, 12, 13}, {14, 50, 00}}

  if @use_fake_now do
    def now, do: Timex.Protocol.to_datetime(@fake_now, :utc)
  else
    def now, do: Timex.now
  end

  def on_one_of_days?(%DateTime{} = datetime, days) do
    current_day = datetime
      |> Timex.weekday
    days
      |> Enum.map(&Timex.day_to_num/1)
      |> Enum.any?(fn day -> day == current_day end)
  end

  def on_one_of_days?(erlang_datetime, days) do
    erlang_datetime
      |> Timex.Protocol.to_datetime(:utc)
      |> on_one_of_days?(days)
  end

  def between?(%DateTime{} = time, start_time, end_time) do
    {_ignored_date, {h, m, s}} = Timex.to_erl(time)
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
