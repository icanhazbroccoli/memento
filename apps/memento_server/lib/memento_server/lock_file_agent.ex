defmodule MementoServer.LockFileAgent do

  @lock_path "memento.lock"

  def start_link do
    Agent.start_link(fn ->
      Temp.track!
      {:ok, fd, path}= Temp.open @lock_path
      IO.write fd, inspect(self)
      File.close fd
      path
    end, name: __MODULE__)
  end

  def get_lock_path do
    Agent.get(__MODULE__, fn path -> path end)
  end

  def cleanup do
    Temp.cleanup
  end

end
