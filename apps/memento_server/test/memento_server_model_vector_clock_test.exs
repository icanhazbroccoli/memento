defmodule MementoServerModelVectorClockTest do

  use ExUnit.Case, async: true
  alias MementoServer.Model.VectorClock

  test "should store the vector clock hash in the DB" do
    clock_map= %{ a: 1, b: 2 }
    assert VectorClock.set_clock(clock_map)
    assert VectorClock.get_clock == clock_map
  end


end
