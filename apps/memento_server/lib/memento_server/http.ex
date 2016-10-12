defmodule MementoServer.HTTP do
  use Plug.Router
  alias MementoServer.Proto

  #pipeline :before do
  #  plug :super
  #end

  plug :match
  plug :dispatch
  plug :copy_req_body
  plug Plug.Logger

  use Plug.Debugger

  defp copy_req_body(conn, _) do
    {:ok, body, _}= Plug.Conn.read_body(conn)
    Plug.Conn.put_private(conn, :req_body, body)
  end

  post "/notes/new" do
    conn.private[:req_body]
      |> Proto.NoteCreateRequest.decode
      |> dispatch_msg(conn)
  end

  post "/ping" do
    conn.private[:req_body]
      |> Proto.PingRequest.decode
      |> dispatch_msg(conn)
  end

  def dispatch_msg(req= %Proto.PingRequest{}, conn) do
    send_resp(conn, 200, Proto.PongResponse.new(
      #FIXME: get the timestamp from the request
      ping_timestamp: :calendar.universal_time |> :calendar.datetime_to_gregorian_seconds,
      pong_timestamp: :calendar.universal_time |> :calendar.datetime_to_gregorian_seconds
    ) |> :erlang.term_to_binary)
  end

  def dispatch_msg(req= %Proto.NoteCreateRequest{}, conn) do
    send_resp(conn, 200, Proto.NoteCreateResponse.new(
      status_code: Proto.StatusCode.OK
    ) |> Proto.put_timestamp |> :erlang.term_to_binary)
  end

  def dispatch_msg(_, conn) do
    send_resp(conn, 404, "I don't speak your language")
  end

  match _ do
    send_resp(conn, 404, "Who's there?")
  end

end
