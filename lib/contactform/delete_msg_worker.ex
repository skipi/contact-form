defmodule Contactform.DeleteMsgWorker do
  use GenServer
  import Ecto.Query

  alias Contactform.Message
  alias Contactform.Repo
  alias Contactform.Accounts.User

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(_) do
    Process.send(self(), :msg, [])
    {:ok, nil}
  end

  @impl true
  def handle_info(:msg, state) do
    query = from(m in Message, where: m.inserted_at < datetime_add(^NaiveDateTime.utc_now, -30, "second"), select: m)
    |> Repo.all

    for item <- query do
      user_id = from(m in Message, where: m.id == ^item.id , select: m.email)
      |> Repo.one
      |> case do
        nil ->
          nil
        email ->
          User
          |> Repo.get_by(email: email)
          |> case do
            nil ->
              nil
            user ->
              user.id
          end
      end

      Repo.delete(item, returning: true)
      |> case do
        {:ok, _item} -> :ok
          ContactformWeb.Endpoint.broadcast("my_messages:lobby", "deleted_messages", %{user_id: user_id})
        {:error, _} ->
          nil
      end
    end
    Process.send_after(self(), :msg, 5000)
    {:noreply, state}
  end

end
