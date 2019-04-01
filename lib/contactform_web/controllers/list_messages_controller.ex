defmodule ContactformWeb.ListMessagesController do
  use ContactformWeb, :controller
  import Ecto.Query
  require Logger

  alias Contactform.Message
  alias Contactform.Repo

  plug :check_auth when action in [:index]

  def index(conn, _params) do
    # messages =
    #   Message
    #   |> Repo.get_by(email: "mail@wp.pl")

    query = from(m in Message, where: m.email == ^conn.assigns.current_user.username , select: m)
    messages = Repo.all(query)
    render(conn, "index.html", messages: messages)


  end

  def delete(conn, %{"id" => message_id}) do
    Repo.get(Message, message_id)
    |> case do
      nil ->
        {:error, nil}

      message ->
        {:ok, message}
    end
    |> case do
      {:error, _} ->
        conn
        |> respond(:error, "Wiadomość nie została znaleziona")

      {:ok, message} ->
        message
        |> Repo.delete()
        |> case do
          {:ok, _} ->
            conn
            |> respond(:info, "Wiadomość usunięta")

          {:error, _} ->
            conn
            |> respond(:error, "Wiadomość nie została usunięta")
        end
    end
  end

  def respond(conn, error_code, error_msg) do
    conn
    |> put_flash(error_code, error_msg)
    |> redirect(to: Routes.list_messages_path(conn, :index))
  end

  defp check_auth(conn, _args) do
    if conn.assigns.signed_in? do
      conn
    else
      conn
      |> put_flash(:error, "Musisz być zalogowany, aby mieć dostęp do tej zakładki")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
