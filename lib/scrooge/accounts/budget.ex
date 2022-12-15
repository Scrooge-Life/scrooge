defmodule Scrooge.Accounts.Budget do
  @moduledoc """
  An `Ecto.Schema` for budgets. These are setup to
  hold all transaction information, separate from individual
  users for future extendability (shared budgets.)
  """

  use Ecto.Schema

  import Ecto.Changeset

  @colors ~w(neutral red orange yellow green teal blue purple pink)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts_budgets" do
    field :symbol, :string
    field :name, :string
    field :color, Ecto.Enum, values: @colors

    belongs_to :user, Scrooge.Accounts.User

    timestamps()
  end

  @doc false
  def create_changeset(budget, attrs, user) do
    budget
    |> cast(attrs, [:symbol, :name, :color])
    |> validate_required([:symbol, :name, :color])
    |> validate_length(:symbol, max: 2)
    |> put_assoc(:user, user)
    |> assoc_constraint(:user)
  end

  @doc false
  def update_changeset(budget, attrs) do
    budget
    |> cast(attrs, [:symbol, :name, :color])
    |> validate_required([:symbol, :name, :color])
    |> validate_length(:symbol, max: 2)
    |> assoc_constraint(:user)
  end

  def colors, do: @colors
end
