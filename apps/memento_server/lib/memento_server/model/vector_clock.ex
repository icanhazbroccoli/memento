defmodule MementoServer.Model.VectorClock do

  use Ecto.Model
  alias MementoServer.Repo
  alias MementoServer.Model

  @required ~w(body)

  schema "vector_clock" do
    field :body, :binary
  end

  def changeset(vector_clock, params) do
    vector_clock
      |> cast(params, @required)
  end

  def set_clock(clock) when is_map(clock) do
    body= :erlang.term_to_binary(clock)
    Repo.insert_or_update(
      changeset(%Model.VectorClock{}, %{body: body})
    )
  end

  def set_clock(_), do: raise "A map clock is expected"

  def get_clock do
    #TODO
    query= from vc in Model.VectorClock, select: vc.body, limit: 1
    Repo.all(query) |> List.first |> :erlang.binary_to_term
  end


end
