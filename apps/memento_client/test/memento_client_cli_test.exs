defmodule MementoClient.CLITest do
  use ExUnit.Case, async: true
  alias MementoClient.CLI
  alias MementoServer.Proto
  alias MementoClient.Server
  import MementoServer.TestHelper, only: [a_string: 0, a_string: 1]

  @tag :parse_args
  test "parse returns command name" do
    {_, args}= CLI.parse_args(["list"])
    assert args == ["list"]
  end

  # test "Returns a file stream instance if the source is specified" do
  #   assert {%File.Stream{}, _, _}= CLI.parse_args(["--from=README.md"])
  # end

  test "calls create if no command given" do
    CLI.parse_args(["--from=README.md"])
      |> CLI.proceed
  end

  test "list command" do
    CLI.parse_args(["list"])
      |> CLI.proceed
  end

  test "get command" do
    proto_note= %Proto.Note{body: a_string(512)}
      |> Proto.put_uuid
      |> Proto.put_timestamp
    uuid= proto_note.uuid
    {:ok, _note}= Server.create_note(proto_note)
    CLI.parse_args(["get", uuid])
      |> CLI.proceed
  end

end
