defmodule ContactformWeb.Plugs.CheckAuth do
  import Ecto.Query
  require Logger

  alias Contactform.Message
  alias Contactform.Repo

  # defp check_auth(conn, _args) do
  #   if conn.assigns.signed_in? do
  #     conn
  #   else
  #     conn
  #     |> put_flash(:error, "Musisz być zalogowany, aby mieć dostęp do tej zakładki")
  #     |> redirect(to: Routes.page_path(conn, :index))
  #     |> halt()
  #   end
  # end
end
