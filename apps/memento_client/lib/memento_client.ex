defmodule MementoClient do
  alias MementoClient.CLI
  def main(args) do
    args
      |> CLI.parse_args
      |> CLI.process
  end
end
