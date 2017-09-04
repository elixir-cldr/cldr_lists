defmodule CldrLists.Mixfile do
  use Mix.Project

  @version "0.1.2"

  def project do
    [
      app: :ex_cldr_lists,
      version: @version,
      docs: docs(),
      elixir: "~> 1.5",
      name: "Cldr_Lists",
      source_url: "https://github.com/kipcole9/cldr_lists",
      description: description(),
      package: package(),
      start_permanent: Mix.env == :prod,
      deps: deps()
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
      {:ex_cldr, "~> 0.6.2"},
      {:ex_doc, ">= 0.0.0", only: :dev}
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
      main: "README",
      extras: ["README.md", "CHANGELOG.md"]
    ]
  end

  def links do
    %{
      "GitHub"    => "https://github.com/kipcole9/cldr_lists",
      "Changelog" => "https://github.com/kipcole9/cldr_lists/blob/v#{@version}/CHANGELOG.md"
    }
  end

end
