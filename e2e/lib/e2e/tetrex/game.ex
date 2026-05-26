defmodule E2e.Tetrex.Game do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:id, :string, autogenerate: false}

  schema "tetrex_games" do
    field :score, :integer
    field :status, :string
    field :client_state, :map
    field :frames, {:array, :map}, default: []
    field :ended_at, :utc_datetime
    field :player_name, :string

    timestamps(type: :utc_datetime)
  end
end
