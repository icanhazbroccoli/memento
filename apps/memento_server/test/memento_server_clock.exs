defmodule MementoServerClockTest do

  use ExUnit.Case, async: true
  alias MementoServer.Clock

  setup_all do
    MementoServer.Clock.start_link(%{})
    :ok
  end

  test "should get the current time" do
    assert is_map Clock.get_time
    assert (Clock.get_time |> Map.get(Node.self, 0)) >= 0
  end

  test "should increment time" do
    time1= Clock.get_time |> Map.get(Node.self)
    time2= Clock.increment_time |> Map.get(Node.self)
    assert time2 == (time1 + 1)
  end

  test "should update time vector" do
    res= Clock.update_time(%{a: 1, b: 2})
    assert %{:a => 1, :b => 2}= res
    res2= Clock.update_time(%{a: 2, b: 1})
    assert %{:a => 2, :b => 2}= res2
  end


end
