defmodule Nectorine.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Ecto.Integration.TestRepo

      import Ecto
      import Ecto.Query
      import Nectorine.RepoCase

      setup do
        # Explicitly get a connection before each test
        :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)
      end
    end
  end
end
