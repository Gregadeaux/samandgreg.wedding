defmodule Wedding.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password, :string
      add :crypted_password, :string
      add :auth_token, :string
      add :facebook_token, :string
      add :created_at, :datetime, null: false
      add :updated_at, :datetime, null: false
    end
  end
end
