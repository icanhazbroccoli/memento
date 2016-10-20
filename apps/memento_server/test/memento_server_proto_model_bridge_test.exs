defmodule MementoServerProtoModelBridgeTest do
  use ExUnit.Case, async: true
  alias MementoServer.Proto
  alias MementoServer.Model
  import MementoServer.TestHelper, only: [a_uuid: 0, a_string: 0, a_string: 1]
  alias MementoServer.ProtoModelBridge, as: Bridge

  test "note_to_proto" do
    uuid= a_uuid
    body= a_string(512)
    client_id= a_string
    timestamp= Ecto.DateTime.utc
    model_note= %Model.Note{
      id:          uuid,
      body:        body,
      client_id:   client_id,
      inserted_at: timestamp
    }
    assert (model_note |> Bridge.note_to_proto) == %Proto.Note{
      uuid: uuid,
      body: body,
      client_id: client_id,
      timestamp: timestamp |> Ecto.DateTime.to_erl |> :calendar.datetime_to_gregorian_seconds,
    }
  end

  test "proto_to_note" do
    uuid= a_uuid
    body= a_string(512)
    client_id= a_string
    timestamp= :calendar.universal_time
    proto_note= %Proto.Note{
      uuid: uuid,
      body: body,
      client_id: client_id,
      timestamp: timestamp,
    }
    assert proto_note |> Bridge.proto_to_note == %Model.Note{
      id: uuid,
      body: body,
      client_id: client_id,
      inserted_at: timestamp,
    }
  end


end
