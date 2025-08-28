defmodule Nectorine do
  @moduledoc """
  Nectorine is a simple library for creating materialized views with Ecto.

  It aims to allow you to define materialized views without writing raw SQL in
  migrations and define an interface similar to existing Ecto.Migration objects
  (i.e. indexes, tables, constraints).
  """

  import Ecto.Migration

  alias Nectorine.SQL

  @doc """
  Creates a materialized view from a query.

  When reversing (in a `change/0` running backwards), materialized views are only dropped
  if they exist, and no errors are raised. To enforce dropping a materialized view, use
  `drop_materialized_view/1`.

  ## Examples

    create_materialized_view(:product_names, from(p in "products", select: product.name), with_data: false)

  ## Options

    * `:if_not_exists` - when `true`, will not raise an error if the materialized view already exists. Default is `false`.
    * `:with_data` - when `false`, will not populate the materialized view at creation time. Default is `true`.

  """
  @spec create_materialized_view(String.t() | atom(), Ecto.Query.t()) :: :ok
  @spec create_materialized_view(String.t() | atom(), Ecto.Query.t(), keyword()) :: :ok
  def create_materialized_view(name, %Ecto.Query{} = query, opts \\ []) do
    repo = Ecto.Migration.repo()

    creation_sql = SQL.to_create_materialized_view_sql(name, query, repo, opts)
    drop_sql = SQL.to_drop_materialized_view_sql(name, if_exists: true)

    execute(
      creation_sql,
      drop_sql
    )
  end

  @doc """
  Creates a materialized view from a query if it does not exist.

  Works like `create_materialized_view/3` with `:if_not_exists` set to `true`.
  """
  @spec create_if_not_exists_materialized_view(String.t(), Ecto.Query.t()) :: :ok
  @spec create_if_not_exists_materialized_view(String.t(), Ecto.Query.t(), keyword()) :: :ok
  def create_if_not_exists_materialized_view(name, %Ecto.Query{} = query, opts \\ []) do
    opts = Keyword.merge(opts, if_not_exists: true)

    create_materialized_view(name, query, opts)
  end

  @doc """
  Drops a materialized view.

  A query can be specified to allow this to be called in a `change/0`. When reversing
  (in a `change/0` running backwards), materialized views are only created if they don't exist,
  and no errors are raised. To enforce creating a materialized view, use `create_materialized_view/3`.

  ## Examples

    drop_materialized_view(:product_names)
    
    drop_materialized_view(:product_names, from(p in "products", select: product.name))

    drop_materialized_view(:product_names, nil, on_drop: :cascade)

  ## Options

    * `:if_exists` - when `true`, will not raise an error if the materialized view does not exist. Default is `false`.
    * `:on_drop` - when set to :cascade, automatically drop objects that depend on the materialized view
      (such as other materialized views, or regular views), and in turn all objects that depend on those objects.
      Default is :restrict.

  """
  @spec drop_materialized_view(String.t()) :: :ok
  @spec drop_materialized_view(String.t(), Ecto.Query.t() | nil) :: :ok
  @spec drop_materialized_view(String.t(), Ecto.Query.t() | nil, keyword()) :: :ok
  def drop_materialized_view(name, query \\ nil, opts \\ [])

  def drop_materialized_view(name, nil, opts) do
    name
    |> SQL.to_drop_materialized_view_sql(opts)
    |> execute()
  end

  def drop_materialized_view(name, %Ecto.Query{} = query, opts) do
    repo = Ecto.Migration.repo()

    creation_sql = SQL.to_create_materialized_view_sql(name, query, repo, if_not_exists: true)
    drop_sql = SQL.to_drop_materialized_view_sql(name, opts)

    execute(
      drop_sql,
      creation_sql
    )
  end

  @doc """
  Drops a materialized view if it exists.

  Works like `drop_materialized_view/3` with `:if_exists` set to `true`.
  """
  @spec drop_if_exists_materialized_view(String.t()) :: :ok
  @spec drop_if_exists_materialized_view(String.t(), Ecto.Query.t() | nil) :: :ok
  @spec drop_if_exists_materialized_view(String.t(), Ecto.Query.t() | nil, keyword()) :: :ok
  def drop_if_exists_materialized_view(name, query \\ nil, opts \\ [])

  def drop_if_exists_materialized_view(name, query, opts) do
    opts = Keyword.merge(opts, if_exists: true)

    drop_materialized_view(name, query, opts)
  end
end
