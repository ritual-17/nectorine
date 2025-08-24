defmodule Nectorine.Repo do
  use Ecto.Repo,
    otp_app: :nectorine,
    adapter: Ecto.Adapters.SQLite3
end
