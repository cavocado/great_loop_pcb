defmodule LoopFwTest do
  use ExUnit.Case
  doctest LoopFw

  test "greets the world" do
    assert LoopFw.hello() == :world
  end
end
