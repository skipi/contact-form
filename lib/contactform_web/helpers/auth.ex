defmodule ContactFormWeb.Helpers.Auth do
  def signed_in?(conn) do
    Plug.Conn.get_session(conn, :current_user_id)
    |> case do
      nil ->
        nil

      user_id ->
        ContactForm.Repo.get(ContactForm.Accounts.User, user_id)
    end
    |> case do
      nil -> false
      _ -> true
    end
  end
end
