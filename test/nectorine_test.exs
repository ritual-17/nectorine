defmodule NectorineTest do
  use Nectorine.RepoCase

  defmodule TestMigration do
    use Ecto.Migration

    import Ecto.Query
    import Nectorine

    def change do
      query = from(u in "users", select: u.id)

      materialized_view(:my_new_materialized_view, query)
    end
  end

  describe "migration" do
    test "builds materialized view" do
      :ok = Ecto.Migrator.up(TestRepo, 1, TestMigration, log: false)
      Ecto.Adapters.SQL.Sandbox.mode(TestRepo, :manual)
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)

      views =
        TestRepo.query!(
          "SELECT matviewname FROM pg_matviews WHERE matviewname = 'my_new_materialized_view'"
        )

      assert views.num_rows == 1
    end
  end

  describe "to_materialized_view_sql" do
    test "builds SQL from ecto query" do
      query = from(u in "users", select: u.id)
      sql = Nectorine.to_materialized_view_sql(:my_new_materialized_view, query, TestRepo)
    end
  end
end
