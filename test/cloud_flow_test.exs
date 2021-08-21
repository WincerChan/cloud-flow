defmodule CloudFlowTest do
  use ExUnit.Case
  doctest CloudFlow

  test "greets the world" do
    assert CloudFlow.hello() == :world
  end
end
