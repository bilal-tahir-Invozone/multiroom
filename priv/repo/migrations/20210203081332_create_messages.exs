defmodule MultiRooms.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :text
      add :room, :string

      timestamps()
    end
    create index(:messages, [:room])
  end
end
