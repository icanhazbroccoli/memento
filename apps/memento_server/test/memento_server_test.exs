defmodule MementoServerTest do
  use ExUnit.Case
  doctest MementoServer

  test "write_lock" do
    MementoServer.write_lock
  end


end
