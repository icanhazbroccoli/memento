defmodule MementoClient.CLITest do
  use ExUnit.Case, async: true
  alias MementoClient.CLI

  @tag :parse_args
  test "parse returns command name" do
    {_, args}= CLI.parse_args(["list"])
    assert args == ["list"]
  end

  # test "Returns a file stream instance if the source is specified" do
  #   assert {%File.Stream{}, _, _}= CLI.parse_args(["--from=README.md"])
  # end

  test "proceed runs create if no command given" do
    CLI.parse_args(["--from=README.md"])
      |> CLI.proceed
  end

  test "proceed runs list command" do
    CLI.parse_args(["list"])
      |> CLI.proceed
  end

end
