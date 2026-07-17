defmodule E2e.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @currencies ~W(eur usd gbp jpy chf cad aud sek nok sgd)
  @roles ~W(admin editor viewer)

  def currencies, do: @currencies
  def roles, do: @roles

  schema "users" do
    field :name, :string
    field :signature, {:array, :string}
    field :country, :string
    field :birth_date, :date
    field :terms, :boolean, default: false
    field :level, :integer, default: 1
    field :currency, :string
    field :tags, {:array, :string}
    field :password, :string, redact: true
    field :notifications, :boolean, default: false
    field :role, :string
    field :pin, :string
    field :accent_color, :string
    field :heading_angle, :float
    field :title, :string
    field :avatar, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    attrs = normalize_pin_attrs(attrs)

    user
    |> cast(attrs, [
      :name,
      :signature,
      :country,
      :birth_date,
      :terms,
      :level,
      :currency,
      :tags,
      :password,
      :notifications,
      :role,
      :pin,
      :accent_color,
      :heading_angle,
      :title,
      :avatar
    ])
    |> validate_required([
      :name,
      :country,
      :birth_date,
      :terms,
      :level,
      :currency,
      :tags,
      :password,
      :role
    ])
    |> validate_acceptance(:terms)
    |> validate_acceptance(:notifications)
    |> validate_number(:level, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> validate_inclusion(:currency, @currencies)
    |> validate_length(:password, min: 8)
    |> validate_inclusion(:role, @roles)
    |> validate_number(:heading_angle, greater_than_or_equal_to: 0, less_than_or_equal_to: 360)
    |> validate_signature_present()
    |> validate_tags_present()
  end

  defp normalize_pin_attrs(%{} = attrs) do
    attrs = Map.new(attrs, fn {key, value} -> {to_string(key), value} end)

    case Map.get(attrs, "pin") do
      list when is_list(list) -> Map.put(attrs, "pin", Enum.join(list))
      _ -> attrs
    end
  end

  defp normalize_pin_attrs(attrs), do: attrs

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
