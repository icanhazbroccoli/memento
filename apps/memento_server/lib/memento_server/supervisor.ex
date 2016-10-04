defmodule MementoServer.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children= [
      Plug.Adapters.Cowboy.child_spec(:http, MementoServer.HTTP, [], [port: 9876])
    ]
    supervise(children, strategy: :one_for_one)
  end

end
