defmodule ContactformWeb.MyMessagesChannel do
  use ContactformWeb, :channel
  import Ecto.Query
  alias Contactform.Message
  alias Contactform.Accounts.User
  alias Contactform.Repo

  import Logger

  def join("my_messages:lobby", _payload, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (my_messages:lobby).

  def handle_in("new_message", payload, socket) do
    broadcast socket, "new_message", payload
    {:noreply, socket}
  end

  def handle_in("deleted_messages", payload, socket) do
    broadcast socket, "deleted_messages", payload
    {:noreply, socket}
  end

  intercept ["new_message", "deleted_messages"]

  def handle_out("new_message", payload, socket) do
    user_id = from(m in Message, where: m.id == ^payload.message_id , select: m.email)
    |> Repo.one
    |> case do
      nil ->
        nil
      email ->
        User
        |> Repo.get_by(email: email)
        |> case  do
           nil ->
            nil
          user ->
            user.id
        end
    end

    case user_id == socket.assigns.current_user_id do
      true ->
        socket
        |> push("new_message", payload)
      false ->
        nil
    end

    {:noreply, socket}
  end

  def handle_out("deleted_messages", payload, socket) do
    case payload.user_id == socket.assigns.current_user_id do
      true ->
        socket
        |> push("deleted_messages", payload)
      false ->
        nil
    end

    current_email = from(u in User, where: u.id == ^socket.assigns.current_user_id, select: u.email)
    |> Repo.one

    Message
    |> select([m], m)
    |> where([m], m.email == ^current_email)
    |> Repo.exists?
    |> case do
      true ->
        nil
      false ->
        socket
        |> push("delete_notification", payload)
      end

    {:noreply, socket}
  end



  # Add authorization logic here as required.
end
