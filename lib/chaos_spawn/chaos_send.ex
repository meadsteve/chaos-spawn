defmodule ChaosSpawn.ChaosSend do

  def chaos_send(dest, message) do
    chaos_send(dest, message, max_delay: 10000)
  end

  def chaos_send(dest, message, max_delay: max_delay) do
    random = :random.uniform
    cond do
        random <= 0.9 ->
          send_normally(dest, message)
        random <= 0.98 ->
          delay = round(max_delay * 0.1 * (0.5 + :random.uniform/2))
          send_slowly(dest, message, delay: delay)
        true ->
          long_delay =  round(max_delay * (0.9 + :random.uniform/10))
          send_slowly(dest, message, delay: long_delay)
    end
  end

  defp send_normally(dest, message) do
    send(dest, message)
  end

  defp send_slowly(dest, message, delay: delay) do
    spawn fn ->
      wait_for(delay)
      send(dest, message)
    end
  end

  defp wait_for(delay) do
    receive do
      :flush -> :ok
    after
      delay  -> :ok
    end
  end

end