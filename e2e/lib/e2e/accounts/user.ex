defmodule E2e.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @currencies ~W(eur usd gbp jpy chf cad aud sek nok sgd)

  def currencies, do: @currencies

  schema "users" do
    field :name, :string
    field :signature, :string
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
      :signature,
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
    |> validate_tags_present()
  end

  defp validate_tags_present(changeset) do
    validate_change(changeset, :tags, fn :tags, tags ->
      tags = if is_list(tags), do: Enum.reject(tags, &(&1 == "")), else: []

      if tags == [], do: [tags: "can't be blank"], else: []
    end)
  end
end
