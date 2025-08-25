defmodule Ecto.Integration.Migration do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name, :string)
      add(:age, :integer)
    end
  end
end
