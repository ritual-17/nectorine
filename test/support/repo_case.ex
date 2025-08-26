defmodule Nectorine.RepoCase do
  use ExUnit.CaseTemplate

  alias Ecto.Integration.TestRepo

  using do
    quote do
      alias Ecto.Integration.TestRepo

      import Ecto
      import Ecto.Query
      import Nectorine.RepoCase
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)
  end

  @doc """
  Run migrations inside test cases.
  Runs the migrations in reverse on exit, unless clean_up migrations are specified.
  """
  def run_migrations(migrations) do
    Enum.each(migrations, fn
      {:up, migration, version} ->
        :ok = Ecto.Migrator.up(TestRepo, version, migration, log: false)

      {:down, migration, version} ->
        :ok = Ecto.Migrator.down(TestRepo, version, migration, log: false)
    end)

    on_exit(fn -> reverse_migrations(migrations) end)
  end

  defmacro defmigration(name, block) do
    quote do
      defmodule unquote(name) do
        use Ecto.Migration

        import Ecto.Query
        import Nectorine

        unquote(block)
      end
    end
  end

  defp reverse_migrations(migrations) do
    migrations
    |> Enum.reverse()
    |> Enum.each(fn
      {:up, migration, version} ->
        :ok = Ecto.Migrator.down(TestRepo, version, migration, log: false)

      {:down, migration, version} ->
        :ok = Ecto.Migrator.up(TestRepo, version, migration, log: false)
    end)
  end
end
