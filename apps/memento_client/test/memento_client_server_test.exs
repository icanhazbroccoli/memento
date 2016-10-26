defmodule MementoClientServerTest do
  use ExUnit.Case, async: true
  import MementoServer.TestHelper, only: [a_string: 0, a_string: 1]

  alias MementoClient.Server
  alias MementoServer.Proto

  test 'is_running?' do
    assert Server.is_running?
  end

  test "list notes" do
    {:ok, resp}= Server.get_notes(1, 20)
    assert is_list(resp.notes)
  end

  test "get note" do
    note= %Proto.Note{body: a_string(512)}
            |> Proto.put_uuid
            |> Proto.put_timestamp
    uuid= note.uuid
    {:ok, _resp}= Server.create_note(note)
    {:ok, created_note}= Server.get_note(uuid)
    assert created_note.uuid == uuid
  end


end
