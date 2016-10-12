defmodule MementoServerProtoTest do
  use ExUnit.Case, async: true

  alias MementoServer.Proto

  test "put_timestamp/1" do
    msg= %{} |> Proto.put_timestamp
    assert Map.get(msg, :timestamp, 0) > 0
  end

  test "put_timestamp/2 with atom" do
    msg= %{} |> Proto.put_timestamp(:my_timestamp)
    assert Map.get(msg, :my_timestamp, 0) > 0
  end

  test "put_timestamp/2 with datetime" do
    datetime= {{2016, 10, 12}, {7, 15, 35}}
    msg= %{} |> Proto.put_timestamp(datetime)
    assert Map.get(msg, :timestamp, 0) == (datetime |> :calendar.datetime_to_gregorian_seconds)
  end

  test "put_timestamp/3" do
    datetime= {{2016, 10, 12}, {7, 15, 35}}
    msg= %{} |> Proto.put_timestamp(:my_timestamp, datetime)
    assert Map.get(msg, :my_timestamp, 0) == (datetime |> :calendar.datetime_to_gregorian_seconds)
    
  end


end
