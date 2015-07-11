defmodule Wedding.Router do
  use Phoenix.Router

  scope "/api", Wedding do
    get       "/sessions", SessionController, :index
    post      "/sessions", SessionController, :create
    delete    "/sessions", SessionController, :delete


    resources "users", UserController, only: [:index, :show, :create, :update, :delete]

    resources "photos", PhotoController, only: [:index, :show, :create, :update, :delete]

  end
end
