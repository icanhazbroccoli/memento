defmodule MementoServer.ProtoModelBridge do
  alias MementoServer.Proto
  alias MementoServer.Model

  def note_to_proto(model_note= %Model.Note{}) do
    Proto.Note.new(
      uuid:      model_note.id,
      body:      model_note.body,
      timestamp: model_note.inserted_at
                   |> Ecto.DateTime.to_erl
                   |> :calendar.datetime_to_gregorian_seconds
    )
  end

  def proto_to_note(proto_note= %Proto.Note{}) do
    %Model.Note{
      id:          proto_note.uuid,
      body:        proto_note.body,
      inserted_at: proto_note.timestamp
                    |> :calendar.gregorian_seconds_to_datetime
                    |> Ecto.DateTime.from_erl
    }
  end

  def vector_clock_to_map(%Proto.VectorClock{ clocks: clocks }) do
    clocks
      |> Enum.map(fn %Proto.Clock{ key: key, value: value } -> {key, value} end)
      |> Enum.into(%{})
  end

  def map_to_vector_clock(map) do
    Proto.VectorClock.new(
      clocks: map |> Enum.map( fn {k, v} -> Proto.Clock.new( key: k, value: v ) end ) 
    )
  end

end
