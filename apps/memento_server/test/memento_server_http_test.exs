defmodule MementoServerHTTPTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias MementoServer.Proto

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

end
