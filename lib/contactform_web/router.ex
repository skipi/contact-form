defmodule ContactformWeb.Router do
  use ContactformWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ContactformWeb.Plugs.SetCurrentUser
    plug :put_user_token
  end

  pipeline :with_auth do
    plug ContactformWeb.Plugs.SetCurrentUser
  end

  pipeline :requires_auth do
    # plug ContactformWeb.Plugs.CheckAuth
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ContactformWeb do
    pipe_through [:browser, :with_auth]

    get "/", PageController, :index

    scope "/" do
      pipe_through :requires_auth

      resources "/email", EmailController
      resources "/listmessages", ListMessagesController
      resources "/registrations", UserController, only: [:new, :create]
      delete "/sign-out", SessionController, :delete
    end

    get "/sign-in", SessionController, :new
    post "/sign-in", SessionController, :create
  end


  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

end
