defmodule Nectorine.SqlTest do
  use Nectorine.RepoCase

  import Ecto.Query

  alias Nectorine.SQL

  @view_name :my_new_materialized_view

  describe "to_create_materialized_view_sql/3" do
    setup do
      query = from(u in "users", select: u.id)

      [query: query]
    end

    test "generates SQL from ecto query", %{query: query} do
      sql = SQL.to_create_materialized_view_sql(@view_name, query, TestRepo)

      assert sql ==
               ~s(CREATE MATERIALIZED VIEW #{@view_name} AS SELECT u0."id" FROM "users" AS u0;)
    end

    test "ignores invalid opts", %{query: query} do
      sql =
        SQL.to_create_materialized_view_sql(@view_name, query, TestRepo,
          if_not_exists: "hello",
          with_data: "world"
        )

      assert sql ==
               ~s(CREATE MATERIALIZED VIEW #{@view_name} AS SELECT u0."id" FROM "users" AS u0;)
    end

    test "adds IF NOT EXISTS from opts", %{query: query} do
      sql = SQL.to_create_materialized_view_sql(@view_name, query, TestRepo, if_not_exists: true)

      assert sql ==
               ~s(CREATE MATERIALIZED VIEW IF NOT EXISTS #{@view_name} AS SELECT u0."id" FROM "users" AS u0;)
    end

    test "adds WITH NO DATA from opts", %{query: query} do
      sql = SQL.to_create_materialized_view_sql(@view_name, query, TestRepo, with_data: false)

      assert sql ==
               ~s(CREATE MATERIALIZED VIEW #{@view_name} AS SELECT u0."id" FROM "users" AS u0 WITH NO DATA;)
    end
  end

  describe "to_drop_materialized_view_sql/1" do
    test "generates drop statement" do
      sql = SQL.to_drop_materialized_view_sql(@view_name)

      assert sql == "DROP MATERIALIZED VIEW #{@view_name};"
    end

    test "ignores invalid opts" do
      sql = SQL.to_drop_materialized_view_sql(@view_name, if_exists: "hello", mode: "world")

      assert sql == "DROP MATERIALIZED VIEW #{@view_name};"
    end

    test "adds IF EXISTS from opts" do
      sql = SQL.to_drop_materialized_view_sql(@view_name, if_exists: true)

      assert sql == "DROP MATERIALIZED VIEW IF EXISTS #{@view_name};"
    end

    test "adds CASCADE from opts" do
      sql = SQL.to_drop_materialized_view_sql(@view_name, mode: :cascade)

      assert sql == "DROP MATERIALIZED VIEW #{@view_name} CASCADE;"
    end
  end
end
