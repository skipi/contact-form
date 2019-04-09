defmodule ContactForm.DeleteMsgWorker do
  use GenServer
  import Ecto.Query

  alias ContactForm.Message
  alias ContactForm.Repo
  alias ContactForm.Accounts.User

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(_) do
    Process.send(self(), :msg, [])
    {:ok, nil}
  end

  # @impl true
  # def handle_info(:msg, state) do
  #   query =
  #     from(m in Message,
  #       where: m.inserted_at < datetime_add(^NaiveDateTime.utc_now(), -30, "second"),
  #       select: m
  #     )
  #     |> Repo.all()

  #   for item <- query do
  #     user_id =
  #       from(m in Message, where: m.id == ^item.id, select: m.email)
  #       |> Repo.one()
  #       |> case do
  #         nil ->
  #           nil

  #         email ->
  #           User
  #           |> Repo.get_by(email: email)
  #           |> case do
  #             nil ->
  #               nil

  #             user ->
  #               user.id
  #           end
  #       end

  #     Repo.delete(item, returning: true)
  #     |> case do
  #       {:ok, _item} ->
  #         :ok

  #         ContactFormWeb.Endpoint.broadcast("my_messages:lobby", "deleted_messages", %{
  #           user_id: user_id
  #         })

  #       {:error, _} ->
  #         nil
  #     end
  #   end

  #   Process.send_after(self(), :msg, 5000)
  #   {:noreply, state}
  # end

  def handle_info(:msg, state) do
    results =
      Message
      |> join(:left, [message], user in User, on: user.email == message.email)
      |> where(
        [message, _],
        message.inserted_at < datetime_add(^NaiveDateTime.utc_now(), -30, "second")
      )
      |> select([message, user], %{
        user_id: user.id,
        message_id: message.id
      })
      |> Repo.all()

    results
    |> pick_users
    |> Enum.each(fn user_id ->
      results
      |> pick_messages_by_user_id(user_id)
      |> case do
        message_ids ->
          Message
          |> where([message], message.id in ^message_ids)
          |> Repo.delete_all()

          {:ok, user_id}
      end
      |> case do
        {:ok, nil} ->
          :ok

        {:ok, user_id} ->
          ContactFormWeb.Endpoint.broadcast("my_messages:lobby", "deleted_messages", %{
            user_id: user_id
          })
      end
    end)

    Process.send_after(self(), :msg, 5_000)
    {:noreply, state}
  end

  def pick_users(results) do
    results
    |> Enum.map(& &1.user_id)
    |> Enum.uniq()
  end

  def pick_messages_by_user_id(results, user_id) do
    results
    |> Enum.filter(&(&1.user_id == user_id))
    |> Enum.map(& &1.message_id)
  end
end
