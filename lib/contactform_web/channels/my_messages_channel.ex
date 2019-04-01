defmodule ContactformWeb.MyMessagesChannel do
  use ContactformWeb, :channel
  import Logger

  def join("my_messages:lobby", _payload, socket) do
    Logger.debug socket.assigns.current_user_id
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (my_messages:lobby).
  def handle_in("newmessage", payload, socket) do
    # ContactformWeb.Endpoint.broadcast("my_message:lobby", "msg", %{uid: uid})
    broadcast socket, "newmessage", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
end
