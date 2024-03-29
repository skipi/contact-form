defmodule ContactformWeb.EmailController do
  use ContactformWeb, :controller
  alias Contactform.Message
  alias Contactform.Repo
  
  def index(conn, _params) do
    changeset = Message.changeset(%Message{})
    render(conn, "index.html", changeset: changeset)
  end

  def create(conn, %{"message" => message_params}) do
    changeset = Message.changeset(%Message{}, message_params)
    case Repo.insert(changeset) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Wiadomość została wysłana")
        |> redirect(to: Routes.email_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Twój email lub treść wiadomości jest nieprawidłowa")
        |> render("index.html", changeset: changeset)
    end
  end
end