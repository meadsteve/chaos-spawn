defmodule ChaosSendTest do
  use ExUnit.Case

  test "messages are always sent" do
    max_delay = 10
    for iteration <- 1..100 do
       expected_message = "hello #{iteration}"
       ChaosSpawn.ChaosSend.chaos_send(self, expected_message, max_delay: max_delay)
       message_recieved = receive do
         expected_message -> true
       after
         max_delay + 1   -> false
       end
       assert message_recieved
    end
  end

end
