defmodule MementoClient.ProtoTest do
  use ExUnit.Case

  test "reads the data from the proto file" do
    assert %MementoClient.Proto.Note{}= MementoClient.Proto.Note.new
  end

  test "encodes uuid as 2xsfuxed64" do
    msg= MementoClient.Proto.Note.new(uuid: UUID.uuid1())
    assert %MementoClient.Proto.Note{uuid: uuid}= msg
    assert uuid != nil
  end

  test "put_uuid generates a uuid" do
    msg= MementoClient.Proto.Note.new
          |> MementoClient.Proto.put_uuid
    assert %MementoClient.Proto.Note{uuid: uuid}= msg
    assert uuid != nil
  end

  test "put_timestamp adjusts the timestamp" do
    datetime= :calendar.universal_time
    msg= MementoClient.Proto.Note.new
          |> MementoClient.Proto.put_timestamp(datetime)
    assert %MementoClient.Proto.Note{timestamp: timestamp}= msg
    assert timestamp == :calendar.datetime_to_gregorian_seconds(datetime)
  end

end
