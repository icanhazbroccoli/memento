defmodule MementoServer.HTTP do
  use Plug.Router
  alias MementoServer.Proto

  plug :match
  plug :dispatch

  post "/notes" do
    send_resp(conn, 200, Proto.NoteCreateResponse.new(
      status_code: Proto.StatusCode.OK
    ) |> Proto.put_timestamp |> :erlang.term_to_binary)
  end

  post "/ping" do
    send_resp(conn, 200, Proto.PongResponse.new(
      #FIXME: get the timestamp from the request
      ping_timestamp: :calendar.universal_time |> :calendar.datetime_to_gregorian_seconds,
      pong_timestamp: :calendar.universal_time |> :calendar.datetime_to_gregorian_seconds
    ) |> :erlang.term_to_binary)
  end

  match _ do
    send_resp(conn, 404, "Who's there?")
  end

end
