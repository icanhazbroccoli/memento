defmodule MementoClient.CLITest do
  use ExUnit.Case
  alias MementoClient.CLI

  test "parse returns command name and argv" do
    assert {%File.Stream{}, _}= CLI.parse_args(["--from=README.md"])
  end

  test "proceed runs" do
    CLI.parse_args(["--from=README.md"])
      |> CLI.proceed
  end


end
