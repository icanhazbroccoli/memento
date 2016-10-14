defmodule MementoServer.Repo do
  use Ecto.Repo, otp_app: :memento_server, adapter: Sqlite.Ecto
end
