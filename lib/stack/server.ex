defmodule Stack.Server do
  use GenServer

  #####
  # External API

  def start_link(current_stack) do
    GenServer.start_link(__MODULE__, current_stack, name: __MODULE__)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  def dump do
    GenServer.call(__MODULE__, :dump)
  end

  #####
  # GenServer implementation

  def handle_call(:pop, _from, [head|tail]) do
    { :reply, head, tail }
  end
  def handle_call(:dump, _from, stack) do
    { :reply, stack, stack }
  end

  def handle_cast({:push, item}, current_stack) do
    { :noreply, [item|current_stack] }
  end

  def terminate(reason, stack) do
    IO.puts(reason)
    IO.puts("Stack was #{stack}")
  end
end
