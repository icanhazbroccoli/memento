defmodule MementoServerClockTest do

  use ExUnit.Case, async: true
  alias MementoServer.Clock

  setup_all do
    MementoServer.Clock.start_link(0)
    :ok
  end

  test "should get the current time" do
    assert is_integer Clock.get_time
    assert Clock.get_time >= 0
  end

  test "should increment time" do
    time1= Clock.get_time
    time2= Clock.increment_time
    assert time2 == (time1 + 1)
  end

end
