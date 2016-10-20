defmodule MementoServer.Model.Note do
  use Ecto.Model
  import Ecto.Query, only: [from: 2]
  alias MementoServer.Repo

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "notes" do
    field :client_id, :string
    field :body,      :string
    timestamps
  end

end
