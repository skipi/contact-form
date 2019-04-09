defmodule ContactformWeb.PageController do
  use ContactformWeb, :controller
  def index(conn, _params) do
    render(conn, "index.html")
  end

end
