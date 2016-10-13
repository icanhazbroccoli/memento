ExUnit.start()

defmodule MementoServer.TestHelper do

  def a_string, do: a_string(32)
  def a_string(length) do
    :crypto.strong_rand_bytes(length)
      |> Base.url_encode64
      |> binary_part(0, length)
  end

  def a_uuid, do: UUID.uuid1

end

