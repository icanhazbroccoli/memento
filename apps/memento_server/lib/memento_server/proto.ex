defmodule MementoServer.Proto do
  use Protobuf, from: Path.expand("../../priv/data.proto", __DIR__)

  def put_timestamp(msg), do: put_timestamp(msg, :calendar.universal_time)
  def put_timestamp(msg, attr) when is_atom(attr), do: put_timestamp(msg, attr, :calendar.universal_time)
  def put_timestamp(msg, datetime), do: put_timestamp(msg, :timestamp, datetime)
  def put_timestamp(msg, attr, datetime) do
    Map.put(msg, attr, datetime |> :calendar.datetime_to_gregorian_seconds)
  end

end
