defmodule ContactformWeb.EmailController do
  use ContactformWeb, :controller
  alias Contactform.Message
  alias Contactform.Repo

  def index(conn, _params) do
    changeset = Message.changeset(%Message{})
    render(conn, "index.html", changeset: changeset)
  end

  # Gettext
  def create(conn, %{"message" => message_params}) do
    Message.changeset(%Message{}, message_params)
    |> Repo.insert()
    |> case do
      {:ok, message} ->
        ContactformWeb.Endpoint.broadcast!("my_messages:lobby", "newmessage", %{
          message_id: message.id
        })

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
