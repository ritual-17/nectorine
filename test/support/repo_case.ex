defmodule Nectorine.RepoCase do
  use ExUnit.CaseTemplate

  alias Ecto.Integration.TestRepo

  using do
    quote do
      alias Ecto.Integration.TestRepo

      import Ecto
      import Ecto.Query
      import Nectorine.RepoCase

      @doc """
      Run migrations inside test cases.
      Runs the migrations in reverse on exit.
      """
      def run_migrations(migrations) do
        Enum.each(migrations, fn
          {:up, migration, version} ->
            :ok = Ecto.Migrator.up(TestRepo, version, migration, log: false)

          {:down, migration, version} ->
            :ok = Ecto.Migrator.down(TestRepo, version, migration, log: false)
        end)

        on_exit(fn ->
          migrations
          |> Enum.reverse()
          |> Enum.each(fn
            {:up, migration, version} ->
              :ok = Ecto.Migrator.down(TestRepo, version, migration, log: false)

            {:down, migration, version} ->
              :ok = Ecto.Migrator.up(TestRepo, version, migration, log: false)
          end)
        end)
      end
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)
  end
end
