defmodule Exmath.MixProject do
  use Mix.Project

  def project do
    [
      app: :exmath,
      version: "0.1.0",
      elixir: "~> 1.9",
      compilers: [:make, :elixir, :app],
      aliases: aliases(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def aliases do
    [clean: ["clean", "clean.make"]]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Exmath, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    []
  end
end

defmodule Mix.Tasks.Compile.Make do
  @doc "Compiles helper in c_src"

  def run(_) do
    {result, _error_code} = System.cmd("make", [], stderr_to_stdout: true)
    Mix.shell().info(result)

    :ok
  end
end

defmodule Mix.Tasks.Clean.Make do
  @doc "Cleans helper in c_src"

  def run(_) do
    {result, _error_code} = System.cmd("make", ["clean"], stderr_to_stdout: true)
    Mix.shell().info(result)

    :ok
  end
end
