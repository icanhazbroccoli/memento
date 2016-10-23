defmodule MementoServer.HTTP do
  use Plug.Router
  alias MementoServer.Proto
  alias MementoServer.Model
  alias MementoServer.Repo
  alias MementoServer.ProtoModelBridge, as: Bridge

  import Ecto.Query, only: [from: 2]

  plug Plug.Logger
  plug :match
  plug :dispatch

  # use Plug.Debugger

  def _inspect(obj) do
    IO.inspect obj
    obj
  end

  post "/notes" do
    {:ok, body, conn}= Plug.Conn.read_body(conn)
    body
      |> Proto.NoteListRequest.decode
      |> dispatch_msg(conn)
  end

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

  def dispatch_msg(req= %Proto.NoteCreateRequest{note: proto_note}, conn) do
    model_note= Bridge.proto_to_note(proto_note)
                |> Map.put(:client_id, req.client_id)
    IO.inspect model_note
    case Repo.insert(model_note) do
      {:ok, note} ->
        resp= Proto.NoteCreateResponse.new(
          status_code: Proto.StatusCode.value(:OK),
          note_id: note.id
        ) |> Proto.put_timestamp
          |> Proto.NoteCreateResponse.encode
        send_resp(conn, 200, resp)
      {:error, error} ->
        send_resp(conn, 400, error)
      _ ->
        send_resp(conn, 500, "unknown error")
    end
  end

  def dispatch_msg(req= %Proto.NoteListRequest{page: page}, conn) when page < 1 do
    dispatch_msg(Map.put(req, :page, 1), conn)
  end

  def dispatch_msg(req= %Proto.NoteListRequest{page_size: page_size}, conn) when page_size > 100 do
    dispatch_msg(Map.put(req, :page_size, 100), conn)
  end

  def dispatch_msg(req= %Proto.NoteListRequest{}, conn) do
    notes= Repo.all(from n in MementoServer.Model.Note,
        where:    n.client_id == ^(req.client_id),
        order_by: [desc: n.inserted_at],
        limit:    type(^req.page_size, :integer),
        offset:   type(^(req.page_size * (req.page-1)), :integer)
      )
      |> Enum.map(fn note ->
        Bridge.note_to_proto(note)
      end)
    resp= Proto.NoteListResponse.new(notes: notes)
          |> Proto.put_timestamp
          |> Proto.NoteListResponse.encode
    send_resp(conn, 200, resp)
  end

  def dispatch_msg(_, conn) do
    send_resp(conn, 404, "You don't speak my dialect but our images reflect!")
  end

  match _ do
    send_resp(conn, 404, "hello i love you won't tell me your name")
  end

end
