defmodule Wedding.PageController do
  use Wedding.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end
