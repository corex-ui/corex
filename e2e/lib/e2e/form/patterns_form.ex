defmodule E2e.Form.PatternsForm do
  use Ecto.Schema
  import Ecto.Changeset

  @currencies E2e.Accounts.Admin.currencies()

  embedded_schema do
    field(:country, Ecto.Enum, values: [:fra, :deu, :bel])
    field(:currency, :string)
    field(:tags, {:array, :string})
    field(:terms, :boolean, default: false)
    field(:notifications, :boolean, default: false)
    field(:password, :string, redact: true)
  end

  def currencies, do: @currencies

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:country, :currency, :tags, :terms, :notifications, :password])
    |> validate_required([:country, :currency, :tags, :password],
      message: "can't be blank"
    )
    |> validate_acceptance(:terms, message: "must be accepted to continue")
    |> validate_acceptance(:notifications, message: "must be accepted to continue")
    |> validate_inclusion(:country, Ecto.Enum.values(__MODULE__, :country))
    |> validate_inclusion(:currency, @currencies)
    |> validate_length(:password, min: 8, message: "must be at least 8 characters")
    |> validate_tags_present()
  end

  def format_for_toast(%__MODULE__{} = data) do
    [
      "country=#{data.country}",
      "currency=#{data.currency}",
      "tags=#{inspect(data.tags)}",
      "terms=#{data.terms}",
      "notifications=#{data.notifications}",
      "password=***"
    ]
    |> Enum.join(" ")
  end

  defp validate_tags_present(changeset) do
    tags =
      changeset
      |> get_field(:tags)
      |> List.wrap()
      |> Enum.reject(&(&1 == ""))

    if tags == [], do: add_error(changeset, :tags, "can't be blank"), else: changeset
  end
end
