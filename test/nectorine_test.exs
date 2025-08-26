defmodule NectorineTest do
  use Nectorine.RepoCase

  defmodule TestMigration do
    use Ecto.Migration

    import Ecto.Query
    import Nectorine

    def change do
      query = from(u in "users", select: u.id)

      create_materialized_view(:my_new_materialized_view, query)
    end
  end

  describe "creation migration" do
    test "builds materialized view on up" do
      run_migrations([{:up, TestMigration, 1}])

      views =
        TestRepo.query!(
          "SELECT matviewname FROM pg_matviews WHERE matviewname = 'my_new_materialized_view'"
        )

      assert views.num_rows == 1
    end

    test "drops materialized view on down" do
      run_migrations([{:up, TestMigration, 1}, {:down, TestMigration, 1}])

      views =
        TestRepo.query!(
          "SELECT matviewname FROM pg_matviews WHERE matviewname = 'my_new_materialized_view'"
        )

      assert views.num_rows == 0
    end
  end

  describe "to_materialized_view_sql" do
    test "builds SQL from ecto query" do
      query = from(u in "users", select: u.id)

      sql = Nectorine.to_materialized_view_sql(:my_new_materialized_view, query, TestRepo)

      assert sql =~
               ~s(CREATE MATERIALIZED VIEW my_new_materialized_view AS SELECT u0."id" FROM "users" AS u0)
    end
  end
end
