defmodule MementoClient do
  alias MementoClient.CLI
  def main(args) do
    args
      |> CLI.parse_args
      |> CLI.proceed
  end
end
