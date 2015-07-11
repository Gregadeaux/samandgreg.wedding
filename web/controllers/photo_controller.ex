defmodule Wedding.PhotoController do
  use Wedding.Web, :controller

  alias Wedding

  plug Authenticate

  plug ValidateFilters, [[], []] when action in [:index]
  plug :scrub_params, "data" when action in [:create, :update]
  plug :action

  # GET /photos
  def index(conn, params) do
    params = clean_params(params)
    current_user = conn.assigns[:current_user]

    query = from(p in Photo)
    |> JSONAPI.Query.add_query_paging(params)

    photos = Repo.all(query)
    render conn, "index.json", %{data: photos, params: params}
  end

  # GET /photos/:id
  def show(conn, %{"id" => id}) do
    photo = Repo.get!(Photo, id)
    |> Photo.preload!()

    render conn, "show.json", data: photo
  end

  # POST /photos
  def create(conn, json=%{"format" => "json"}) do
    current_user = conn.assigns[:current_user]
    photo_json = Dict.get(json, "data", %{})

    case Photo.create(photo_json) do
      {:ok, photo} ->
      conn
      |> put_resp_header("Location", photo_path(conn, :show, photo.id))
      |> put_status(201)
      |> render "show.json", data: photo
      {:error, errors} ->
      put_status(conn, 400) |> render ErrorView, "errors.json", errors: errors
    end
  end

  # PUT /photos/:id
  def update(conn, json=%{"format" => "json", "id" => id}) do
    photo = Repo.get!(Photo, id)
    |> Photo.preload!()

    photo_json = Dict.get(json, "data", %{})
    current_user = conn.assigns[:current_user]

    case Photo.update(photo, photo_json) do
    {:ok, photo} ->
      conn
      |> put_status(200)
      |> render "show.json", data: photo
    {:error, errors} ->
      put_status(conn, 400) |> render ErrorView, "errors.json", errors: errors
    end
  end

  # DELETE /photos/:id
  def delete(conn, %{"format" => "json", "id" => id}) do
    photo = Repo.get!(Photo, id)
    |> Photo.preload!()

    current_user = conn.assigns[:current_user]

    Photo.delete!(photo)

    send_resp(conn, 204, "") |> halt
  end
end
