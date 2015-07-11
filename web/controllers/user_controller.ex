defmodule Wedding.UserController do
  use Wedding.Web, :controller

  alias Wedding

  plug Authenticate when action in [:update, :show, :delete]

  plug ValidateFilters, [[], []] when action in [:index]
  plug :scrub_params, "data" when action in [:create, :update]
  plug :action

  # GET /users
  def index(conn, params) do
    params = clean_params(params)
    current_user = conn.assigns[:current_user]

    query = from(p in User)

    users = Repo.all(query)
    render conn, "index.json", %{data: users, params: params}
  end

  # GET /users/:id
  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    |> User.preload!()

    render conn, "show.json", data: user
  end

  # POST /users
  def create(conn, json=%{"format" => "json"}) do
    current_user = conn.assigns[:current_user]
    user_json = Dict.get(json, "data", %{})

    case User.create(user_json) do
      {:ok, user} ->
      conn
      |> put_resp_header("Location", user_path(conn, :show, user.id))
      |> put_status(201)
      |> render "show.json", data: user
      {:error, errors} ->
      put_status(conn, 400) |> render ErrorView, "errors.json", errors: errors
    end
  end

  # PUT /users/:id
  def update(conn, json=%{"format" => "json", "id" => id}) do
    user = Repo.get!(User, id)
    |> User.preload!()

    user_json = Dict.get(json, "data", %{})
    current_user = conn.assigns[:current_user]

    case User.update(user, user_json) do
    {:ok, user} ->
      conn
      |> put_status(200)
      |> render "show.json", data: user
    {:error, errors} ->
      put_status(conn, 400) |> render ErrorView, "errors.json", errors: errors
    end
  end

  # DELETE /users/:id
  def delete(conn, %{"format" => "json", "id" => id}) do
    user = Repo.get!(User, id)
    |> User.preload!()

    current_user = conn.assigns[:current_user]

    User.delete!(user)

    send_resp(conn, 204, "") |> halt
  end
end
