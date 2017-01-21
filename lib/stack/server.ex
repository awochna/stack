defmodule Stack.Server do
  use GenServer

  #####
  # External API

  def start_link(stash_pid) do
    GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  @doc """
  Set the stack with the passed list. Overwrites previous stack.

  ## Examples

      iex> Stack.Server.set [5, "cat", 9]
      iex> Stack.Server.inspect
      [5, "cat", 9]

  """
  def set(list) do
    GenServer.cast(__MODULE__, {:set, list})
  end

  @doc """
  Retrieve the item at the top of the stack.

  ## Examples

      iex> Stack.Server.pop
      5

  """
  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  @doc """
  Push item on the top of the stack.

  ## Examples

      iex> Stack.Server.push "dog"
      iex> Stack.Server.pop
      "dog"

  """
  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  @doc """
  Retrieve the contents of the stack without modifying it.

  ## Examples

      iex> Stack.Server.set [5, "cat", 9]
      iex> Stack.Server.inspect
      [5, "cat", 9]

  """
  def inspect do
    GenServer.call(__MODULE__, :inspect)
  end

  def dump do
    GenServer.call(__MODULE__, :inspect)
  end

  #####
  # GenServer implementation

  def init(stash_pid) do
    current_stack = Stack.Stash.get_stack stash_pid
    { :ok, {current_stack, stash_pid} }
  end

  def handle_call(:pop, _from, {[head|tail], stash_pid}) do
    { :reply, head, {tail, stash_pid} }
  end
  def handle_call(:inspect, _from, {current_stack, stash_pid}) do
    { :reply, current_stack, {current_stack, stash_pid} }
  end

  def handle_cast({:set, list}, {_current_stack, stash_pid}) do
    Stack.Stash.save_stack(stash_pid, list)
    { :noreply, {list, stash_pid} }
  end
  def handle_cast({:push, item}, {current_stack, stash_pid}) do
    { :noreply, {[item|current_stack], stash_pid} }
  end

  def terminate(reason, {current_stack, stash_pid}) do
    Stack.Stash.save_stack stash_pid, current_stack
    IO.puts(reason)
    IO.puts("Stack was #{current_stack}")
  end
end
