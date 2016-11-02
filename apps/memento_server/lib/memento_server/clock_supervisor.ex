defmodule MementoServer.ClockSupervisor do

  use Supervisor

  def start_link(time) do
    Supervisor.start_link(__MODULE__, time)
  end

  def init(time) do
    children= [
      worker(MementoServer.Clock, [time])
    ]
    supervise(children, strategy: :one_for_one)
  end


end
