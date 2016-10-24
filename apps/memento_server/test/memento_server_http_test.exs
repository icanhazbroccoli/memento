defmodule MementoServerHTTPTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias MementoServer.Proto
  alias MementoServer.Repo
  alias MementoServer.Model

  import MementoServer.TestHelper, only: [a_uuid: 0, a_string: 0, a_string: 1]

  @opts MementoServer.HTTP.init([])

  test "ping proto" do
    time= :calendar.universal_time
    timestamp= time |> :calendar.datetime_to_gregorian_seconds
    client_id= a_string
    req_body= Proto.PingRequest.new(client_id: client_id)
                |> Proto.put_timestamp(:ping_timestamp, time)
                |> Proto.PingRequest.encode
    test_conn= conn(:post, "/ping", req_body)
                |> MementoServer.HTTP.call(@opts)
    assert test_conn.state == :sent
    assert test_conn.status == 200
    proto_resp= test_conn.resp_body |> Proto.PongResponse.decode
    assert proto_resp.ping_timestamp == timestamp
    assert proto_resp.pong_timestamp >= timestamp
  end

  test "/notes, all items fit in a single page" do
    client_id= a_string
    num_notes= 10
    page_size= 20

    req_body= Proto.NoteListRequest.new(
      client_id: client_id,
      page_size: page_size,
    ) |> Proto.NoteListRequest.encode

    (0..num_notes-1) |> Enum.each(fn _ ->
      %Model.Note{ client_id: client_id, body: a_string(512) }
        |> Repo.insert
    end)

    test_conn= conn(:post, "/notes", req_body)
                |> MementoServer.HTTP.call(@opts)
    assert test_conn.status == 200
    proto_resp= test_conn.resp_body |> Proto.NoteListResponse.decode
    assert proto_resp.timestamp > 0
    assert is_list(proto_resp.notes)
    assert length(proto_resp.notes) == num_notes
  end

  test "/notes, items don't fit into 1 page" do
    client_id= a_string
    num_notes= 10
    page_size= 5

    req_body= Proto.NoteListRequest.new(
      client_id: client_id,
      page_size: page_size,
    ) |> Proto.NoteListRequest.encode

    (0..num_notes-1) |> Enum.each(fn _ ->
      %Model.Note{ client_id: client_id, body: a_string(512) }
        |> Repo.insert
    end)

    test_conn= conn(:post, "/notes", req_body)
                |> MementoServer.HTTP.call(@opts)
    assert test_conn.status == 200
    proto_resp= test_conn.resp_body |> Proto.NoteListResponse.decode
    assert proto_resp.timestamp > 0
    assert is_list(proto_resp.notes)
    assert length(proto_resp.notes) == page_size
  end

  test "/notes, client_id lookup" do
    client_id1= a_string
    client_id2= a_string
    num_notes= 10
    page_size= 20

    [client_id1, client_id2]
      |> Enum.each(fn client_id ->
        (0..num_notes-1) |> Enum.each(fn _ ->
          %Model.Note{ client_id: client_id, body: a_string(512) }
            |> Repo.insert
        end)
      end)

    req_body= Proto.NoteListRequest.new(
      client_id: client_id1,
      page_size: page_size,
    ) |> Proto.NoteListRequest.encode

    test_conn= conn(:post, "/notes", req_body)
                |> MementoServer.HTTP.call(@opts)

    assert test_conn.status == 200
    proto_resp= test_conn.resp_body |> Proto.NoteListResponse.decode
    assert proto_resp.timestamp > 0
    assert is_list(proto_resp.notes)
    assert length(proto_resp.notes) == num_notes
  end

  test "/notes/new" do
    uuid= a_uuid
    client_id= a_string
    body= a_string(512)

    note= Proto.Note.new(
      uuid:      uuid,
      body:      body
    ) |> Proto.put_timestamp

    req_body= Proto.NoteCreateRequest.new(note: note, client_id: client_id)
      |> Proto.put_timestamp
      |> Proto.NoteCreateRequest.encode

    test_conn= conn(:post, "/notes/new", req_body)
                |> MementoServer.HTTP.call(@opts)

    assert test_conn.status == 200
    proto_resp= test_conn.resp_body |> Proto.NoteCreateResponse.decode
    assert proto_resp.timestamp > 0
    assert proto_resp.status_code == :OK

    db_note= Repo.get!(MementoServer.Model.Note, uuid)
    assert db_note.id        == uuid
    assert db_note.client_id == client_id
    assert db_note.body      == body
  end

  @tag :get_note
  test "/notes/get with an existing note and full uuid" do
    client_id= a_string
    uuid= a_uuid
    note= %Model.Note{ id: uuid, client_id: client_id, body: a_string(512) }
    {:ok, model_note}= note |> Repo.insert
    req_body= Proto.NoteGetRequest.new(
      client_id: client_id,
      note_id: uuid,
    ) |> Proto.put_timestamp
      |> Proto.NoteGetRequest.encode

    test_conn= conn(:post, "/notes/get", req_body)
                |> MementoServer.HTTP.call(@opts)

    assert test_conn.status == 200
    proto_resp= test_conn.resp_body |> Proto.NoteGetResponse.decode
    assert proto_resp.timestamp > 0
    assert proto_resp.status_code == :OK
    assert %Proto.Note{}= proto_resp.note
  end

end
