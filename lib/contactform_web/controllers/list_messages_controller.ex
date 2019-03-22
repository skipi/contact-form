defmodule ContactformWeb.ListMessagesController do
  use ContactformWeb, :controller

  alias Contactform.Message
  alias Contactform.Repo

  def index(conn, _params) do
    # query = from(p in Message, select: p)
    messages =
      Message
      |> Repo.all()

    # messages = Repo.all(query)
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
