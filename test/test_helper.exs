ExUnit.start()

alias Ecto.Integration.TestRepo

Application.put_env(
  :ecto,
  TestRepo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "my_app_test",
  adapter: Ecto.Adapters.Postgres,
  # url: System.get_env("DATABASE_URL", "ecto://localhost/ecto_network_test"),
  pool: Ecto.Adapters.SQL.Sandbox
)

defmodule Ecto.Integration.TestRepo do
  use Ecto.Repo,
    otp_app: :ecto,
    adapter: Ecto.Adapters.Postgres
end

{:ok, _} = Ecto.Adapters.Postgres.ensure_all_started(TestRepo, :temporary)

_ = Ecto.Adapters.Postgres.storage_down(TestRepo.config())
:ok = Ecto.Adapters.Postgres.storage_up(TestRepo.config())
{:ok, _pid} = TestRepo.start_link()

Code.require_file("ecto_migration.exs", __DIR__)
:ok = Ecto.Migrator.up(TestRepo, 0, Ecto.Integration.Migration, log: false)

Process.flag(:trap_exit, true)
