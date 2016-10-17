ExUnit.start()
Mix.Task.run "ecto.drop", ~w(-r MementoServer.Repo --quiet)
Mix.Task.run "ecto.create", ~w(-r MementoServer.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r MementoServer.Repo --quiet)
#Ecto.Adapters.SQL.Sandbox.mode(MementoServer.Repo, :manual)

defmodule MementoServer.TestHelper do

  def a_string, do: a_string(32)
  def a_string(length) do
    :crypto.strong_rand_bytes(length)
      |> Base.url_encode64
      |> binary_part(0, length)
  end

  def a_uuid, do: UUID.uuid1

end

