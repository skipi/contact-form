defmodule ContactFormWeb.SessionController do
  use ContactFormWeb, :controller
  alias ContactForm.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => auth_params}) do
    user = Accounts.get_by_username(auth_params["email"])

    case ContactForm.Crypto.check_hash(user.encrypted_password, auth_params["password"]) do
      true ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Zalogowano pomyślnie")
        |> redirect(to: Routes.page_path(conn, :index))

      false ->
        conn
        |> put_flash(:error, "Nieprawidłowy login lub hasło")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Wylogowano pomyślnie")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
