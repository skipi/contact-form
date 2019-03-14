defmodule Contactform.Repo.Migrations.ChangeContentType do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      modify :content, :text
    end
  end
end
