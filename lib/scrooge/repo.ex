defmodule Scrooge.Repo do
  use Ecto.Repo,
    otp_app: :scrooge,
    adapter: Ecto.Adapters.Postgres
end
