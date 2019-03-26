defmodule ContactformWeb.ListMessagesController do
  use ContactformWeb, :controller

  alias Contactform.Message
  alias Contactform.Repo

  alias Contactform.Accounts

  plug :check_auth when action in [:index, :delete, :respond]


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
<<<<<<< HEAD

  defp check_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
    current_user = Accounts.get_user!(user_id)

    conn
      |> assign(:current_user, current_user)
    else
      conn
      |> put_flash(:error, "Musisz być zalogowany, aby mieć dostęp do tej zakładki")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
=======
>>>>>>> origin/master
end
