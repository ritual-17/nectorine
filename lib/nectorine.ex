defmodule Nectorine do
  @moduledoc """
  Documentation for `Nectorine`.
  """

  import Ecto.Migration

  alias Nectorine.SQL

  def create_materialized_view(name, %Ecto.Query{} = query, opts \\ []) do
    repo = Ecto.Migration.repo()

    creation_sql = SQL.to_create_materialized_view_sql(name, query, repo, opts)
    drop_sql = SQL.to_drop_materialized_view_sql(name, opts)

    execute(
      creation_sql,
      drop_sql
    )
  end

  def create_if_not_exists_materialized_view(name, %Ecto.Query{} = query, opts \\ []) do
    opts = Keyword.merge(opts, if_not_exists: true)

    create_materialized_view(name, query, opts)
  end

  def drop_materialized_view(name, query \\ nil, opts \\ [])

  def drop_materialized_view(name, nil, opts) do
    name
    |> SQL.to_drop_materialized_view_sql(opts)
    |> execute()
  end

  def drop_materialized_view(name, %Ecto.Query{} = query, opts) do
    repo = Ecto.Migration.repo()

    creation_sql = SQL.to_create_materialized_view_sql(name, query, repo, opts)
    drop_sql = SQL.to_drop_materialized_view_sql(name, opts)

    execute(
      drop_sql,
      creation_sql
    )
  end

  def drop_if_exists_materialized_view(name, query \\ nil, opts \\ [])

  def drop_if_exists_materialized_view(name, query, opts) do
    opts = Keyword.merge(opts, if_exists: true)

    drop_materialized_view(name, query, opts)
  end
end
