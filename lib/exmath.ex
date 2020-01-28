defmodule Exmath do
  alias Exmath.Commands

  def ping do
    IO.puts(Commands.ping())
  end
end
