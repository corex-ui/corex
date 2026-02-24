defmodule E2e.Repo do
  use Ecto.Repo,
    otp_app: :corex_web,
    adapter: Ecto.Adapters.Postgres
end
