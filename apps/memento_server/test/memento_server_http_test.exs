defmodule MementoServerHTTPTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias MementoServer.Proto

  import MementoServer.TestHelper, only: [a_uuid: 0, a_string: 0, a_string: 1]

  @opts MementoServer.HTTP.init([])

  test "ping proto" do
    time= :calendar.universal_time
    timestamp= time |> :calendar.datetime_to_gregorian_seconds
    req_body= Proto.PingRequest.new()
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

  test "/notes/new" do
    note= Proto.Note.new(
      uuid:      a_uuid,
      client_id: a_string,
      body:      a_string(512)
    ) |> Proto.put_timestamp
    req_body= Proto.NoteCreateRequest.new(note: note)
      |> Proto.put_timestamp
      |> Proto.NoteCreateRequest.encode
    test_conn= conn(:post, "/notes/new", req_body)
                |> MementoServer.HTTP.call(@opts)
    assert test_conn.status == 200
    proto_resp= test_conn.resp_body |> Proto.NoteCreateResponse.decode
    assert proto_resp.timestamp > 0
    assert proto_resp.status_code == :OK
  end

end
