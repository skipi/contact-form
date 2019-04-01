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

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ContactformWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/email", EmailController
    resources "/listmessages", ListMessagesController
    resources "/registrations", UserController, only: [:new, :create]

    get "/sign-in", SessionController, :new
    post "/sign-in", SessionController, :create
    delete "/sign-out", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", ContactformWeb do
  #   pipe_through :api
  # end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

end
