defmodule Wedding.SessionView do
  use Wedding.Web, :view

  def type, do: "session"

  def attributes(data) do
    %{
      email: data.email,
      auth_token: data.user.auth_token || Wedding.Authenticate.generate_token_for(data)
    }
  end

  def relationships() do
    
    %{
      user: %{
        view: Wedding.UserView
      }
    }
    
  end

  def url_func() do
    &user_url/3
  end
end
