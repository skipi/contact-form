defmodule Contactform.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :email, :string
    field :read, :boolean

    timestamps()
  end

  @params [:email, :content]
  @required_params @params

  @doc false
  def changeset(message, attrs \\ %{}) do
    message
    |> cast(attrs, @params)
    |> validate_required(@required_params)
    |> validate_format(:email, ~r/([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})/)
  end
end
