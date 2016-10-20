defmodule MementoServer.ProtoModelBridge do
  alias MementoServer.Proto
  alias MementoServer.Model

  def note_to_proto(model_note= %Model.Note{}) do
    #TODO
    Proto.Note.new(
      uuid:      model_note.id,
      body:      model_note.body,
      client_id: model_note.client_id,
      timestamp: model_note.inserted_at
                   |> Ecto.DateTime.to_erl
                   |> :calendar.datetime_to_gregorian_seconds
    )
  end

  def proto_to_note(proto_note= %Proto.Note{}) do
    %Model.Note{
      id:          proto_note.uuid,
      body:        proto_note.body,
      client_id:   proto_note.client_id,
      inserted_at: proto_note.timestamp
    }
  end

end
