defmodule User do
  use Wedding.Web, :model
  alias Wedding

  @required_fields ~w(email password)
  @optional_fields ~w(crypted_password auth_token facebook_token)

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :crypted_password, :string
    field :auth_token, :string, virtual: true
    field :facebook_token, :string
    has_many :photo, Photo, foreign_key: :user_id

    timestamps inserted_at: :created_at
  end

  def changeset(:create, model, params) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> validate_unique(:email, on: Repo)
    |> validate_length(:password, min: 6, too_short: "needs to be longer than 6 characters")
  end

  def changeset(:update, model, params) do
    model
    |> cast(params, [], @required_fields ++ @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> validate_unique(:email, on: Repo)
    |> validate_length(:password, min: 6, too_short: "needs to be longer than 6 characters")
  end

  def create(params) do
    user_changeset = changeset(:create, %User{}, params)
    if user_changeset.valid? do
        user_changeset = put_change(user_changeset, :crypted_password, crypt(user_changeset.changes[:password]))
      {:ok, Repo.insert(user_changeset)}
    else
      {:error, user_changeset}
    end
  end

  def update(user, params) do
    user_changeset = changeset(:update, user, params)
    if user_changeset.valid? do
      if Dict.has_key?(user.changes, :password) do
        user = put_change(user, :crypted_password, crypt(user.changes[:password]))
      end
      {:ok, Repo.update(user_changeset)}
    else
      {:error, user_changeset}
    end
  end

  def touch(user) do
    change(user, []) |> Repo.update
  end

  def delete!(user) do
    user = Repo.preload(user, [:photo])
    Repo.delete(user)
  end

  def preload!(user) do
    Repo.preload(user, [:photo])
  end
  def fetch(email) do
    case find_by_email(email) do
      [user] -> user
      [] -> nil
      _err -> raise "Two users with the same email"
    end
  end

  def find_by_email(nil), do: []
  def find_by_email(""), do: []
  def find_by_email(email) do
    Repo.all(from u in __MODULE__,
      where: fragment("? = lower(?)", u.email, ^email),
      limit: 1)
  end

  def crypt(nil), do: raise "You cannot encrypt an empty password."
  def crypt(""), do: raise "You cannot encrypt an empty password."
  def crypt(password) do
    :erlpass.hash(password)
  end

  def password_check(_user, nil), do: false
  def password_check(_user, ""), do: false
  def password_check(nil, _password), do: false
  def password_check(%__MODULE__{:crypted_password => nil}, _password), do: false
  def password_check(%__MODULE__{:crypted_password=>crypted_password}, password) do
    :erlpass.match(password, crypted_password)
  end
end
