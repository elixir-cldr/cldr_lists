defmodule Cldr.Lists.Mixfile do
  use Mix.Project

  @version "2.2.0"

  def project do
    [
      app: :ex_cldr_lists,
      version: @version,
      docs: docs(),
      elixir: "~> 1.5",
      name: "Cldr Lists",
      source_url: "https://github.com/kipcole9/cldr_lists",
      description: description(),
      package: package(),
      start_permanent: Mix.env == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore_warnings",
        plt_add_apps: ~w(inets jason mix)a
      ],
    ]
  end

  defp description do
    """
    List formatting functions for the Common Locale Data Repository (CLDR)
    package ex_cldr
    """
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_cldr, "~> 2.6"},
      {:ex_cldr_numbers, "~> 2.6"},
      {:ex_doc, "~> 0.18", only: [:release, :dev]},
      {:jason, "~> 1.0", optional: true},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Kip Cole"],
      licenses: ["Apache 2.0"],
      links: links(),
      files: [
        "lib", "config", "mix.exs", "README*", "CHANGELOG*", "LICENSE*"
      ]
    ]
  end

  def docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: ["README.md", "CHANGELOG.md", "LICENSE.md"],
      logo: "logo.png"
    ]
  end

  def links do
    %{
      "GitHub"    => "https://github.com/kipcole9/cldr_lists",
      "Readme"    => "https://github.com/kipcole9/cldr_lists/blob/v#{@version}/README.md",
      "Changelog" => "https://github.com/kipcole9/cldr_lists/blob/v#{@version}/CHANGELOG.md"
    }
  end

  defp elixirc_paths(:test), do: ["lib", "mix", "test"]
  defp elixirc_paths(:dev), do: ["lib", "mix"]
  defp elixirc_paths(_), do: ["lib"]
end
