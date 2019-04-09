defmodule ContactForm.Repo.Migrations.AddReadFlag do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :read, :boolean, default: false
    end
  end
end
