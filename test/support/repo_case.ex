defmodule Nectorine.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Ecto.Integration.TestRepo

      import Ecto
      import Ecto.Query
      import Nectorine.RepoCase

      # setup do
      #   # Explicitly get a connection before each test
      #   :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)
      # end
      # setup do
      #   :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)
      #   # Allow async processes spawned by the test to use the sandbox connection
      #   Ecto.Adapters.SQL.Sandbox.mode(TestRepo, {:shared, self()})
      #   :ok
      # end
    end
  end
end
