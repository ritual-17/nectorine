defmodule NectorineTest do
  use Nectorine.RepoCase

  defmodule TestCreationMigration do
    use Ecto.Migration

    import Ecto.Query
    import Nectorine

    def change do
      query = from(u in "users", select: u.id)

      create_materialized_view(:my_new_materialized_view, query)
    end
  end

  defmodule TestDropWithQueryMigration do
    use Ecto.Migration

    import Ecto.Query
    import Nectorine

    def change do
      query = from(u in "users", select: u.id)

      drop_materialized_view(:my_new_materialized_view, query)
    end
  end

  defmodule TestDropWithoutQueryMigration do
    use Ecto.Migration

    import Nectorine

    def up do
      drop_materialized_view(:my_new_materialized_view)
    end

    # defining down for cleanup after test
    def down do
      query = from(u in "users", select: u.id)

      create_materialized_view(:my_new_materialized_view, query)
    end
  end

  describe "creation migration" do
    test "builds materialized view on up" do
      run_migrations([{:up, TestCreationMigration, 1}])

      views =
        TestRepo.query!(
          "SELECT matviewname FROM pg_matviews WHERE matviewname = 'my_new_materialized_view'"
        )

      assert views.num_rows == 1
    end

    test "drops materialized view on down" do
      run_migrations([{:up, TestCreationMigration, 1}, {:down, TestCreationMigration, 1}])

      views =
        TestRepo.query!(
          "SELECT matviewname FROM pg_matviews WHERE matviewname = 'my_new_materialized_view'"
        )

      assert views.num_rows == 0
    end
  end

  describe "drop migration" do
    test "drops materialized view on up" do
      run_migrations([{:up, TestCreationMigration, 1}, {:up, TestDropWithQueryMigration, 2}])

      views =
        TestRepo.query!(
          "SELECT matviewname FROM pg_matviews WHERE matviewname = 'my_new_materialized_view'"
        )

      assert views.num_rows == 0
    end

    test "drops materialized view on up with no query specified" do
      run_migrations([{:up, TestCreationMigration, 1}, {:up, TestDropWithoutQueryMigration, 2}])

      views =
        TestRepo.query!(
          "SELECT matviewname FROM pg_matviews WHERE matviewname = 'my_new_materialized_view'"
        )

      assert views.num_rows == 0
    end

    test "builds materialized view on down with query specified" do
      run_migrations([
        {:up, TestCreationMigration, 1},
        {:up, TestDropWithQueryMigration, 2},
        {:down, TestDropWithQueryMigration, 2}
      ])

      views =
        TestRepo.query!(
          "SELECT matviewname FROM pg_matviews WHERE matviewname = 'my_new_materialized_view'"
        )

      assert views.num_rows == 1
    end
  end
end
