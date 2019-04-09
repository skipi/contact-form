defmodule ContactFormWeb.ListMessagesController do
  use ContactFormWeb, :controller
  import Ecto.Query
  require Logger

  alias ContactForm.Message
  alias ContactForm.Repo

  def index(conn, _params) do
    from(m in Message,
      where: m.read == false and m.email == ^conn.assigns.current_user.email,
      select: m
    )
    |> Repo.update_all(set: [read: true])

    query = from(m in Message, where: m.email == ^conn.assigns.current_user.email, select: m)
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
end
