defmodule MementoServerModelNoteTest do
  use ExUnit.Case, async: true

  import MementoServer.TestHelper, only: [a_uuid: 0, a_string: 0, a_string: 1]
  alias MementoServer.Model.Note
  alias MementoServer.Repo

  test "Insert into the DB" do
    {:ok, note}= %Note{client_id: a_string, body: a_string(512)} |> Repo.insert
  end

end

