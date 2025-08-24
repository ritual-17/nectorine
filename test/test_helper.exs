ExUnit.start()

{:ok, _} = Nectorine.Repo.start_link()

Ecto.Adapters.SQL.Sandbox.mode(Nectorine.Repo, :manual)
