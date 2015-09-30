defmodule ChaosSpawn.Example.MessageSayer do
  use ChaosSpawn.Chaotic.GenEvent

  # Callbacks

  def handle_event({:say, message}, messages) do
    {:ok, [message|messages]}
  end

  def handle_call(:say, messages) do
    {:ok, Enum.reverse(messages), []}
  end

end

# {:ok, pid} = ChaosSpawn.Chaotic.GenEvent.start_link([])
#
# GenEvent.add_handler(pid, ChaosSpawn.Example.MessageSayer, [])
# #=> :ok
#
# GenEvent.notify(pid, {:say, "hello"})
# #=> :ok
#
# GenEvent.notify(pid, {:say, "world"})
# #=> :ok
#
# GenEvent.call(pid, ChaosSpawn.Example.MessageSayer, :say)
# #=> [1, 2]
