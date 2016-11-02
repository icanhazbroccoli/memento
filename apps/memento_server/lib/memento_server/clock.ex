defmodule MementoServer.Clock do

  use GenServer

  def start_link(time) do
    GenServer.start_link(__MODULE__, time, name: __MODULE__)
  end

  def get_time do
    GenServer.call(__MODULE__, :get_time)
  end

  def increment_time do
    GenServer.call(__MODULE__, :increment_time)
  end

  def handle_call(:get_time, _from, time) do
    {:reply, time, time}
  end

  def handle_call(:increment_time, _from, time) do
    new_time= time + 1
    {:reply, new_time, new_time}
  end

end
