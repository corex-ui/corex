defmodule CorexAdmin.Test.SocialLink do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:label, :string)
    field(:url, :string)
    field(:preferred, :boolean, default: false)
  end

  def changeset(link, attrs) do
    link
    |> cast(attrs, [:label, :url, :preferred])
    |> validate_required([:label, :url])
    |> validate_format(:url, ~r/^https?:\/\//i)
  end
end
