defmodule Nectorine.SQL do
  def to_create_materialized_view_sql(name, %Ecto.Query{} = query, repo, opts \\ []) do
    {query_sql, _params} = Ecto.Adapters.SQL.to_sql(:all, repo, query)

    build_create_statement(name, query_sql, opts)
  end

  def to_drop_materialized_view_sql(name, opts \\ []) do
    build_drop_statement(name, opts)
  end

  defp build_create_statement(name, query, opts) do
    if_not_exists = Keyword.get(opts, :if_not_exists, false)
    with_data = Keyword.get(opts, :with_data, true)

    "CREATE MATERIALIZED VIEW"
    |> if_not_exists(if_not_exists)
    |> table_name(name)
    |> query(query)
    |> with_data(with_data)
    |> end_statement()
  end

  defp build_drop_statement(name, opts) do
    if_exists = Keyword.get(opts, :if_exists, false)
    mode = Keyword.get(opts, :mode, :restrict)

    "DROP MATERIALIZED VIEW"
    |> if_exists(if_exists)
    |> table_name(name)
    |> mode(mode)
    |> end_statement()
  end

  defp if_not_exists(statement, true), do: statement <> " IF NOT EXISTS"
  defp if_not_exists(statement, _), do: statement

  defp table_name(statement, name), do: statement <> " " <> to_string(name)

  defp query(statement, query), do: statement <> " AS " <> query

  defp with_data(statement, false), do: statement <> " WITH NO DATA"
  defp with_data(statement, _), do: statement

  defp if_exists(statement, true), do: statement <> " IF EXISTS"
  defp if_exists(statement, _), do: statement

  defp mode(statement, :cascade), do: statement <> " CASCADE"
  defp mode(statement, _), do: statement

  defp end_statement(statement), do: statement <> ";"
end
