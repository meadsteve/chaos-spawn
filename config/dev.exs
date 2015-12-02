use Mix.Config
config :logger, :console, level: :warn
config :chaos_spawn, :fake_fixed_now, true

#config :chaos_spawn, :kill_tick, 1000
#config :chaos_spawn, :kill_probability, 0.1
#config :chaos_spawn, :only_kill_between, {{10, 00, 00}, {16, 00, 00}}
#config :chaos_spawn, :only_kill_on_days, [:mon, :tue, :wed, :thu, :fri]
# config :chaos_spawn, :skip_worker_modules, [
#   Chaotic.WorkerTest.Example
# ]
