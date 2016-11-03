defmodule MementoServer.Supervisor do
  import Supervisor.Spec

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children= [
      worker(MementoServer.Repo, []),
      worker(MementoServer.ClockSupervisor, []),
      Plug.Adapters.Cowboy.child_spec(:http, MementoServer.HTTP, [], [port: 9876]),
    ]
    supervise(children, strategy: :one_for_one)
  end

end
