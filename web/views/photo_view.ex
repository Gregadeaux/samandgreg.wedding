defmodule Wedding.PhotoView do
  use Wedding.Web, :view

  def type(), do: "photo"

  def attributes(photo) do
    Map.take(photo, [:display_url])
  end

  def relationships() do
    %{
    
      user: %{
        view: Wedding.UserView,
        optional: true
      },
    
    }
  end

  def url_func() do
    &photo_url/3
  end

end
