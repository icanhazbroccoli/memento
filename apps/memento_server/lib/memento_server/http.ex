defmodule MementoServer.HTTP do
  use Plug.Router
  alias MementoServer.Proto

  #pipeline :before do
  #  plug :super
  #end

  plug Plug.Logger
  plug :match
  plug :dispatch
  # plug :copy_req_body

  # use Plug.Debugger

  #defp copy_req_body(conn, _) do
  #  {:ok, body, _}= Plug.Conn.read_body(conn)
  #  Plug.Conn.put_private(conn, :req_body, body)
  #end

  post "/notes/new" do
    {:ok, body, conn}= Plug.Conn.read_body(conn)
    body
      |> Proto.NoteCreateRequest.decode
      |> dispatch_msg(conn)
  end

  post "/ping" do
    {:ok, body, conn}= Plug.Conn.read_body(conn)
    body
      |> Proto.PingRequest.decode
      |> dispatch_msg(conn)
  end

  def dispatch_msg(req= %Proto.PingRequest{ping_timestamp: ping_timestamp}, conn) do
    pong_timestamp= :calendar.universal_time
    resp= Proto.PongResponse.new()
          |> Proto.put_timestamp(:ping_timestamp, ping_timestamp |> :calendar.gregorian_seconds_to_datetime)
          |> Proto.put_timestamp(:pong_timestamp, pong_timestamp)
          |> Proto.PongResponse.encode
    send_resp(conn, 200, resp)
  end

  def _inspect(obj) do
    IO.inspect obj
    obj
  end

  def dispatch_msg(req= %Proto.NoteCreateRequest{}, conn) do
    #TODO
    resp= Proto.NoteCreateResponse.new(
      status_code: Proto.StatusCode.value(:OK)
    ) |> Proto.put_timestamp
      |> Proto.NoteCreateResponse.encode
    send_resp(conn, 200, resp)
  end

  def dispatch_msg(_, conn) do
    send_resp(conn, 404, "I don't speak your language")
  end

  match _ do
    send_resp(conn, 404, "Who's there?")
  end

end
