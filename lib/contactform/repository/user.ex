defmodule ContactForm.Repository.User do
  defstruct [
    :id,
    :email
  ]

  alias ContactForm.Repository.User
  alias ContactForm.Models.User, as: UserModel
  alias ContactForm.Repo

  @spec get_by_id(integer()) :: {:ok, %User{}} | {:error, atom()}
  def get_by_id(user_id) do
    UserModel
    |> Repo.get(user_id)
    |> case do
      nil ->
        {:error, :not_found}

      user_model ->
        user = %User{
          id: user_model.id,
          email: user_model.email
        }

        {:ok, user}
    end
  end

  def get_by_email(email) do
    UserModel
    |> Repo.get_by(email: email)
    |> case do
      nil ->
        {:error, :not_found}

      user_model ->
        user = %User{
          id: user_model.id,
          email: user_model.email
        }

        {:ok, user}
    end
  end
end
