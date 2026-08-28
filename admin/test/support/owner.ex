defmodule CorexAdmin.Test.Owner do
  @moduledoc false
  use Ecto.Schema

  schema "owners" do
    field(:name, :string)
    field(:email, :string)

    has_many(:tickets, CorexAdmin.Test.Ticket, foreign_key: :owner_id)

    timestamps(type: :utc_datetime)
  end
end
