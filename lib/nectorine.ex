defmodule Nectorine do
  @moduledoc """
  Documentation for `Nectorine`.
  """

  import Ecto.Migration

  defmacro materialized_view(name, query) do
    quote do
      repo = Ecto.Migration.repo()

      sql = to_materialized_view_sql(unquote(name), unquote(query), repo)

      execute(
        sql,
        "DROP MATERIALIZED VIEW #{unquote(name)}"
      )
    end
  end

  def to_materialized_view_sql(name, %Ecto.Query{} = query, repo) do
    {sql, _params} = Ecto.Adapters.SQL.to_sql(:all, repo, query)
    "CREATE MATERIALIZED VIEW #{name} AS #{sql}"
  end
end
