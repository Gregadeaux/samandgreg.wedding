defmodule Photo do
  use Wedding.Web, :model
  alias Wedding

  @required_fields ~w(display_url)
  @optional_fields ~w()

  schema "photos" do
    field :display_url, :string
    belongs_to :user, User, foreign_key: :user_id

    timestamps inserted_at: :created_at
  end

  def changeset(:create, model, params) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def changeset(:update, model, params) do
    model
    |> cast(params, [], @required_fields ++ @optional_fields)
  end

  def create(params) do
    photo_changeset = changeset(:create, %Photo{}, params)
    if photo_changeset.valid? do
      {:ok, Repo.insert(photo_changeset)}
    else
      {:error, photo_changeset}
    end
  end

  def update(photo, params) do
    photo_changeset = changeset(:update, photo, params)
    if photo_changeset.valid? do
      {:ok, Repo.update(photo_changeset)}
    else
      {:error, photo_changeset}
    end
  end

  def touch(photo) do
    change(photo, []) |> Repo.update
  end

  def delete!(photo) do
    photo = Repo.preload(photo, [:user])
    Repo.delete(photo)
  end

  def preload!(photo) do
    Repo.preload(photo, [:user])
  end
end
