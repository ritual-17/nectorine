defmodule NectorineTest do
  use Nectorine.RepoCase

  alias Nectorine.Repo

  describe "to_materialized_view_sql" do
    test "builds SQL from ecto query" do
      query = from(u in "users", select: u.id)
      sql = Nectorine.to_materialized_view_sql(:my_new_materialized_view, query, Repo)

      IO.inspect(sql)
    end
  end
end
