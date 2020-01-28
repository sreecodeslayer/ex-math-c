defmodule ExmathTest do
  use ExUnit.Case
  doctest Exmath

  test "greets the world" do
    assert Exmath.hello() == :world
  end
end
