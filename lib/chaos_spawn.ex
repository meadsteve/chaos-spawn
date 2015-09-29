defmodule ChaosSpawn do
  use Application

  def start(_type, _args) do
    ChaosSpawn.Supervisor.start_link
  end

end
