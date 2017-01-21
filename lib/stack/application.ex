defmodule Stack.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Stack.Server, [[5, "cat", 9]])
    ]

    opts = [strategy: :one_for_one, name: Stack.Supervisor]
    {:ok, _pid} = Supervisor.start_link(children, opts)
  end
end