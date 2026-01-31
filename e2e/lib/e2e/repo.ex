defmodule E2e.Repo do
  use Ecto.Repo,
    otp_app: :e2e,
    adapter: Ecto.Adapters.Postgres
end
