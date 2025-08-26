defmodule Nectorine do
  @moduledoc """
  Documentation for `Nectorine`.
  """

  import Ecto.Migration

  alias Nectorine.SQL

  def create_materialized_view(name, %Ecto.Query{} = query) do
    repo = Ecto.Migration.repo()

    creation_sql = SQL.to_create_materialized_view_sql(name, query, repo)
    drop_sql = SQL.to_drop_materialized_view_sql(name)

    execute(
      creation_sql,
      drop_sql
    )
  end

  def drop_materialized_view(name) do
    name
    |> SQL.to_drop_materialized_view_sql()
    |> execute()
  end

  def drop_materialized_view(name, %Ecto.Query{} = query) do
    repo = Ecto.Migration.repo()

    creation_sql = SQL.to_create_materialized_view_sql(name, query, repo)
    drop_sql = SQL.to_drop_materialized_view_sql(name)

    execute(
      drop_sql,
      creation_sql
    )
  end
end
