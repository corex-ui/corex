defmodule E2e.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @currencies ~W(eur usd gbp jpy chf cad aud sek nok sgd)

  def currencies, do: @currencies

  schema "users" do
    field :name, :string
    field :signature, {:array, :string}
    field :country, :string
    field :birth_date, :date
    field :terms, :boolean, default: false
    field :level, :integer, default: 1
    field :currency, :string
    field :tags, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :signature, :country, :birth_date, :terms, :level, :currency, :tags])
    |> validate_required([
      :name,
      :country,
      :birth_date,
      :terms,
      :level,
      :currency,
      :tags
    ])
    |> validate_acceptance(:terms)
    |> validate_number(:level, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> validate_inclusion(:currency, @currencies)
    |> validate_signature_present()
    |> validate_tags_present()
  end

  defp validate_signature_present(changeset) do
    signature =
      changeset
      |> get_field(:signature)
      |> List.wrap()
      |> Enum.reject(&(&1 == ""))

    if signature == [], do: add_error(changeset, :signature, "can't be blank"), else: changeset
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
