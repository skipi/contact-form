defmodule ContactformWeb.Router do
  use ContactformWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ContactformWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/email", EmailController
    resources "/listmessages", ListMessagesController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ContactformWeb do
  #   pipe_through :api
  # end
end
