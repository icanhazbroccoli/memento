defmodule MementoServer.Clock do

  use GenServer

  def start_link(vector) do
    GenServer.start_link(__MODULE__, vector |> Map.put(Node.self, 0), name: __MODULE__)
  end

  def get_time do
    GenServer.call(__MODULE__, :get_time)
  end

  def increment_time do
    GenServer.call(__MODULE__, :increment_time)
  end

  def update_time(ext_vector) do
    GenServer.call(__MODULE__, {:update_time, ext_vector})
  end

  def handle_call(:get_time, _from, vector) do
    {:reply, vector, vector}
  end

  def handle_call(:increment_time, _from, vector) do
    {_, new_vector}= Map.get_and_update(vector, Node.self, fn time ->
      {time, time + 1}
    end)
    {:reply, new_vector, new_vector}
  end

  def handle_call({:update_time, vector1}, _from, vector2) do
    {_, vector}= Map.merge(vector1, vector2, fn(_k, v1, v2) ->
      case v1 > v2 do
        true  -> v1
        false -> v2
      end
    end) |> Map.get_and_update(Node.self, fn v -> {v, v + 1} end)
    {:reply, vector, vector}
  end

end
