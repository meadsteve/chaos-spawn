defmodule ChaosSpawn.Mixfile do
  use Mix.Project

  def github_url, do: "https://github.com/meadsteve/chaos-spawn"

  def project do
    [app: :chaos_spawn,
     name: "Chaos Spawn",
     package: [
       maintainers: ["Steve Brazier"],
       licenses: ["MIT"],
       links: %{"GitHub" => github_url},
     ],
     source_url: github_url,
     docs: [
       extras: ["README.md", "usage-automatic.md", "usage-manual.md"]
     ],
     version: "0.4.0",
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
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.8", only: :dev}
    ]
  end
end
