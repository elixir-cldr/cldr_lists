defmodule Cldr.Lists.Mixfile do
  use Mix.Project

  @version "2.11.1"

  def project do
    [
      app: :ex_cldr_lists,
      version: @version,
      docs: docs(),
      elixir: "~> 1.12",
      name: "Cldr Lists",
      source_url: "https://github.com/elixir-cldr/cldr_lists",
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore_warnings",
        plt_add_apps: ~w(inets jason mix)a,
        flags: [
          :error_handling,
          :unknown,
          :underspecs,
          :extra_return,
          :missing_return
        ]
      ],
    ]
  end

  defp description do
    """
    List formatting functions for the Common Locale Data Repository (CLDR)
    package ex_cldr.
    """
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_cldr_numbers, "~> 2.25"},

      {:ex_doc, "~> 0.18", optional: true, runtime: false},
      {:jason, "~> 1.0", optional: true},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Kip Cole"],
      licenses: ["Apache-2.0"],
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
      logo: "logo.png",
      formatters: ["html"],
      skip_undefined_reference_warnings_on: ["changelog", "CHANGELOG.md"]
    ]
  end

  def links do
    %{
      "GitHub"    => "https://github.com/elixir-cldr/cldr_lists",
      "Readme"    => "https://github.com/elixir-cldr/cldr_lists/blob/v#{@version}/README.md",
      "Changelog" => "https://github.com/elixir-cldr/cldr_lists/blob/v#{@version}/CHANGELOG.md"
    }
  end

  defp elixirc_paths(:test), do: ["lib", "mix", "test"]
  defp elixirc_paths(:dev), do: ["lib", "mix"]
  defp elixirc_paths(_), do: ["lib"]
end
