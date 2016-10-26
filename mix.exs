defmodule Peselx.Mixfile do
  use Mix.Project

  def project do
    [app: :peselx,
     version: "0.2.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [ {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:credo, "~> 0.4", only: [:dev, :test]}
    ]
  end

  defp description do
    """
    Validator of PESEL number - Polish national ID number. Checks checksum.
    """
  end

  defp package do
    [# These are the default files included in the package
     name: :peselx,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Bartek 'Koziołek' Kuczyński"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/Koziolek/peselx",
              "Docs" => "http://koziolek.github.io/peselx/"}]
  end

end
