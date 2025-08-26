defmodule Nectorine.SQL do
  def to_create_materialized_view_sql(name, %Ecto.Query{} = query, repo) do
    {sql, _params} = Ecto.Adapters.SQL.to_sql(:all, repo, query)
    "CREATE MATERIALIZED VIEW #{name} AS #{sql}"
  end

  def to_drop_materialized_view_sql(name) do
    "DROP MATERIALIZED VIEW #{name}"
  end
end
