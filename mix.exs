defmodule ChaosSpawn.Mixfile do
  use Mix.Project

  def project do
    [app: :chaos_spawn,
     name: "Chaos Spawn",
     description: """
     Providing tools to randomly kill proceses. With the goal of creating
     robust supevision trees.
     """,
     package: [
       maintainers: ["Steve Brazier"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/meadsteve/chaos-spawn"},
     ],
     version: "0.7.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger], mod: {ChaosSpawn, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:exactor, "~> 2.2.0"},
      {:timex, "0.19.5"},
      {:dogma, "0.0.9", only: [:dev, :test]},
      {:credo, "0.1.9", only: [:dev, :test]},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.8", only: :dev}
    ]
  end
end
