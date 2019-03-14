defmodule ContactformWeb.ListMessagesController do
  use ContactformWeb, :controller
  import Ecto.Query

  alias Contactform.Message
  alias Contactform.Repo
  
  def index(conn, _params) do
    query = from(p in Message, select: p)
    messages = Repo.all(query)
    render(conn, "index.html", messages: messages)
  end

  def delete(conn, %{"id" => message_id}) do
    Repo.get!(Message, message_id) |> Repo.delete!
    conn
    |> put_flash(:info, "Wiadomość usunięta")
    |> redirect(to: Routes.list_messages_path(conn, :index))
  end
end