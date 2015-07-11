defmodule Wedding.Repo.Migrations.CreatePhoto do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :display_url, :string
      add :user_id, references(:users)
      add :created_at, :datetime, null: false
      add :updated_at, :datetime, null: false
    end
  end
end
