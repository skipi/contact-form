defmodule ContactForm.Models.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ContactForm.Crypto

  schema "users" do
    field :encrypted_password, :string
    field :email, :string, source: :username

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password])
    |> validate_required([:email, :encrypted_password])
    |> unique_constraint(:email)
    |> update_change(:encrypted_password, &Crypto.hash/1)
  end
end
