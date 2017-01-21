defmodule Stack.ServerTest do
  use ExUnit.Case
  doctest Stack.Server

  test "inspect after pop doesn't include given element" do
    Stack.Server.set [5, "cat", 9]
    element = Stack.Server.pop
    refute Enum.member?(Stack.Server.inspect, element)
  end

  test "inspect after push includes given element" do
    Stack.Server.set [5, "cat", 9]
    element = "dog"
    Stack.Server.push element
    assert Enum.member?(Stack.Server.inspect, element)
  end

end
