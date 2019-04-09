defmodule ContactFormWeb.Plugs.UserRequired do
  import Plug.Conn
  import Phoenix.Controller
  alias ContactFormWeb.Router.Helpers, as: Router

  def init(_params) do
  end

  def call(conn, _params) do
    conn.assigns
    |> case do
      %{current_user: nil} ->
        conn
        |> invalidate_request()

      %{current_user: _} ->
        conn

      _ ->
        conn
        |> invalidate_request()
    end
  end

  defp invalidate_request(conn) do
    conn
    |> put_flash(:error, "Musisz być zalogowany, aby mieć dostęp do tej zakładki")
    |> redirect(to: Router.page_path(conn, :index))
    |> halt()
  end
end
