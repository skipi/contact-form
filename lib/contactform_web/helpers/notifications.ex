defmodule ContactformWeb.Helpers.Notifications do
  import Ecto.Query
  alias Contactform.Message
  alias Contactform.Repo

  def is_read?(conn) do
    Message
    |> select([m], m)
    |> where([m], m.email == ^conn.assigns.current_user.email)
    |> Repo.exists?
    |> case do
      true ->
        Message
        |> select([m], fragment("bool_and(?)", m.read))
        |> where([m], m.email == ^conn.assigns.current_user.email)
        |> Repo.one
      false ->
        true
    end
  end
end
