defmodule Stack.Server do
  use GenServer

  def handle_call(:pop, _from, [head|tail]) do
    { :reply, head, tail }
  end

  def handle_cast({:push, item}, current_stack) do
    { :noreply, [item|current_stack] }
  end
end
