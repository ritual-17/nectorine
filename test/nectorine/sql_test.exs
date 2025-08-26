defmodule Nectorine.SqlTest do
  use Nectorine.RepoCase

  import Ecto.Query

  alias Nectorine.SQL

  describe "to_create_materialized_view_sql/3" do
    test "generates SQL from ecto query" do
      query = from(u in "users", select: u.id)

      sql = SQL.to_create_materialized_view_sql(:my_new_materialized_view, query, TestRepo)

      assert sql ==
               ~s(CREATE MATERIALIZED VIEW my_new_materialized_view AS SELECT u0."id" FROM "users" AS u0)
    end
  end

  describe "to_drop_materialized_view_sql/1" do
    test "generates drop statement" do
      sql = SQL.to_drop_materialized_view_sql(:my_new_materialized_view)

      assert sql == "DROP MATERIALIZED VIEW my_new_materialized_view"
    end
  end
end
