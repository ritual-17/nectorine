defmodule NectorineTest do
  use Nectorine.RepoCase

  defmigration TestCreationMigration do
    def change do
      query = from(u in "users", select: u.id)

      create_materialized_view(:my_new_materialized_view, query)
    end
  end

  describe "create_materialized_view/3" do
    test "builds materialized view on up" do
      run_migrations([{:up, TestCreationMigration, 1}])

      assert_number_of_views(1)
    end

    test "drops materialized view on down" do
      run_migrations([{:up, TestCreationMigration, 1}, {:down, TestCreationMigration, 1}])

      assert_number_of_views(0)
    end
  end

  defmigration TestCreateIfNotExistsMigration do
    def up do
      query = from(u in "users", select: u.id)

      create_if_not_exists_materialized_view(:my_new_materialized_view, query)
    end

    def down do
    end
  end

  describe "create_if_not_exists_materialized_view/3" do
    test "does not raise an error if the materialized view already exists" do
      run_migrations([{:up, TestCreationMigration, 1}, {:up, TestCreateIfNotExistsMigration, 2}])

      assert_number_of_views(1)
    end
  end

  defmigration TestDropWithQueryMigration do
    def change do
      query = from(u in "users", select: u.id)

      drop_materialized_view(:my_new_materialized_view, query)
    end
  end

  defmigration TestDropWithoutQueryMigration do
    def up do
      drop_materialized_view(:my_new_materialized_view)
    end

    # defining down for cleanup after test
    def down do
      query = from(u in "users", select: u.id)

      create_materialized_view(:my_new_materialized_view, query)
    end
  end

  describe "drop migration" do
    test "drops materialized view on up" do
      run_migrations([{:up, TestCreationMigration, 1}, {:up, TestDropWithQueryMigration, 2}])

      assert_number_of_views(0)
    end

    test "drops materialized view on up with no query specified" do
      run_migrations([{:up, TestCreationMigration, 1}, {:up, TestDropWithoutQueryMigration, 2}])

      assert_number_of_views(0)
    end

    test "builds materialized view on down with query specified" do
      run_migrations([
        {:up, TestCreationMigration, 1},
        {:up, TestDropWithQueryMigration, 2},
        {:down, TestDropWithQueryMigration, 2}
      ])

      assert_number_of_views(1)
    end
  end

  defmigration TestDropIfNotExistsMigration do
    def up do
      drop_if_exists_materialized_view(:my_new_materialized_view)
    end

    def down do
    end
  end

  describe "drop_if_exists_materialized_view/3" do
    test "does not raise an error if the materialized view does not exist" do
      run_migrations([{:up, TestDropIfNotExistsMigration, 1}])

      assert_number_of_views(0)
    end
  end

  defp assert_number_of_views(num, view_name \\ "my_new_materialized_view") do
    views =
      TestRepo.query!("SELECT matviewname FROM pg_matviews WHERE matviewname = '#{view_name}'")

    assert views.num_rows == num
  end
end
