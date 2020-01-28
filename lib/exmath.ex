defmodule Exmath do
  use Application

  alias Exmath.Commands

  # Aliased functions for simplicity
  def sin(angle) do
    :ok = Commands.sin(angle)
  end

  def cos(angle) do
    :ok = Commands.cos(angle)
  end

  def tan(angle) do
    :ok = Commands.tan(angle)
  end

  def sqrt(number) do
    :ok = Commands.sqrt(number)
  end

  # Application supervision tree
  def start(_type, _args) do
    children = [
      %{
        id: Commands,
        start: {Commands, :connect, []}
      }
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
