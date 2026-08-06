defmodule E2e.Accounts.User do
  @moduledoc """
  Demo-only user schema for the Corex e2e app.

  Passwords are stored in **plaintext** on purpose for form demos — do not copy
  this pattern into production apps (use `phx.gen.auth` / hashing instead).
  """
  use Ecto.Schema
  import Ecto.Changeset

  @currencies ~W(eur usd gbp jpy chf cad aud sek nok sgd)
  @roles ~W(admin editor viewer)
  @countries ~W(fra bel deu nld che aut)

  def currencies, do: @currencies
  def roles, do: @roles
  def countries, do: @countries

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
      :password,
      :role,
      :pin,
      :accent_color,
      :heading_angle,
      :title
    ])
    |> validate_acceptance(:terms)
    |> validate_acceptance(:notifications)
    |> validate_inclusion(:country, @countries)
    |> validate_number(:level, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> validate_inclusion(:currency, @currencies)
    |> validate_length(:password, min: 8)
    |> validate_inclusion(:role, @roles)
    |> validate_length(:pin, is: 4)
    |> validate_format(:pin, ~r/^\d+$/, message: "must be digits")
    |> validate_number(:heading_angle, greater_than_or_equal_to: 0, less_than_or_equal_to: 360)
    |> validate_accent_color_not_default()
    |> validate_heading_angle_not_default()
    |> validate_signature_present()
    |> validate_tags_present()
    |> validate_avatar_present()
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

  defp validate_avatar_present(changeset) do
    avatar = get_field(changeset, :avatar)

    if is_binary(avatar) and String.trim(avatar) != "" do
      changeset
    else
      add_error(changeset, :avatar, "can't be blank")
    end
  end

  defp validate_accent_color_not_default(changeset) do
    validate_change(changeset, :accent_color, fn :accent_color, value ->
      if default_accent_color?(value) do
        [accent_color: "can't be blank"]
      else
        []
      end
    end)
  end

  defp validate_heading_angle_not_default(changeset) do
    validate_change(changeset, :heading_angle, fn :heading_angle, value ->
      if default_heading_angle?(value) do
        [heading_angle: "can't be blank"]
      else
        []
      end
    end)
  end

  defp default_accent_color?(value) when is_binary(value) do
    normalized = value |> String.trim() |> String.downcase()

    normalized in ["#000000", "#000", "000000", "000"] or
      Regex.match?(~r/^rgba\(\s*0\s*,\s*0\s*,\s*0\s*,/i, normalized) or
      Regex.match?(~r/^rgb\(\s*0\s*,\s*0\s*,\s*0\s*\)$/i, normalized)
  end

  defp default_accent_color?(_), do: false

  defp default_heading_angle?(value) when value in [0, 0.0], do: true

  defp default_heading_angle?(value) when is_binary(value),
    do: value in ["0", "0.0", "0.00"]

  defp default_heading_angle?(_), do: false
end
