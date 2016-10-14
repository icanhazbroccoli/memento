defmodule MementoServer.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :client_id, :string
      add :body, :blob
      add :timestamp, :integer
      timestamps
    end

    create index(:notes, [:client_id])
  end
end
