defmodule MementoServerHTTPTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias MementoServer.Proto

  @opts MementoServer.HTTP.init([])

  test "ping proto" do
    req_body= Proto.PingRequest.new()
                |> Proto.put_timestamp(:ping_timestamp)
                |> Proto.PingRequest.encode
    test_conn= conn(:post, "/ping", req_body)
            |> MementoServer.HTTP.call(@opts)
    assert test_conn.state == :sent
    assert test_conn.status == 200
  end



end
