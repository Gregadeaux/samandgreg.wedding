defmodule Wedding.UserView do
  use Wedding.Web, :view

  def type(), do: "user"

  def render("index.json", %{data: users, params: params}) do
    users
  end

  def url_func() do
    &user_url/3
  end

end
