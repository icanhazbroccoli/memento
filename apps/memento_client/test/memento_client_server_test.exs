defmodule MementoClientServerTest do
  use ExUnit.Case, async: true

  alias MementoClient.Server
  alias MementoServer.Proto

  test 'is_running?' do
    assert Server.is_running?
  end

  test "list notes" do
    {:ok, resp}= Server.get_notes(1, 20)
    assert is_list(resp.notes)
  end

end
