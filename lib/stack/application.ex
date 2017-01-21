defmodule Stack.Application do
  use Application

  def start(_type, stack) do
    {:ok, _pid} = Stack.Supervisor.start_link(stack)
  end
end
