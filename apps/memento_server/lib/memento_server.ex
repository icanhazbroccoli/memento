defmodule MementoServer do
  use Application

  def start(_type, _args) do
    MementoServer.Supervisor.start_link
  end

end
