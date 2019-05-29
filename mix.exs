defmodule MazingUmbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      build_embedded: Mix.env() != :dev && Mix.env() != :test,
      deps: deps(),
      start_permanent: Mix.env() != :dev && Mix.env() != :test
    ]
  end

  defp deps do
    []
  end
end
