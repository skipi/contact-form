defmodule Contactform.Repo do
  use Ecto.Repo,
    otp_app: :contactform,
    adapter: Ecto.Adapters.Postgres
end
