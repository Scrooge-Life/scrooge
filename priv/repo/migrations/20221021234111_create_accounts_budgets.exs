defmodule Scrooge.Repo.Migrations.CreateAccountsBudgets do
  use Ecto.Migration

  def change do
    create table(:accounts_budgets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :symbol, :string, null: false
      add :name, :string, null: false
      add :color, :string, null: false

      add :user_id, references(:accounts_users, type: :binary_id)

      timestamps()
    end
  end
end
