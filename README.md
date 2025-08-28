# Nectorine

Nectorine is a simple Elixir library for creating materialized views with Ecto.

It aims to allow you to define materialized views without writing raw SQL in
migrations and define an interface similar to existing Ecto.Migration objects
(i.e. indexes, tables, constraints).

## Usage

Nectorine allows you to to define your materialized views using Ecto queries
rather than writing raw SQL in migrations.

```elixir
defmodule MyRepo.Migrations.AddUserNamesMaterializedView do
  use Ecto.Migration

  import Ecto.Query
  import Nectorine

  def change do
    query = from(u in "users", select: u.name)

    create_materialized_view(:my_new_materialized_view, query)
  end
end
```

This executes the raw SQL

```sql
CREATE MATERIALIZED VIEW my_new_materialized_view AS SELECT u0."id" FROM "users" AS u0;
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `nectorine` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nectorine, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/nectorine>.
