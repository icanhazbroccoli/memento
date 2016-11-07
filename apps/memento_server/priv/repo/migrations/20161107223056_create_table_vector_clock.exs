defmodule MementoServer.Repo.Migrations.CreateTableVectorClock do
  use Ecto.Migration

  def change do
    create table(:vector_clock, primary_key: false) do
      add :body, :binary
    end
  end
end
