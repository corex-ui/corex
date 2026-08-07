defmodule E2e.Form.PatternsForm do
  use Ecto.Schema
  import Ecto.Changeset

  @currencies E2e.Accounts.Admin.currencies()
  @roles E2e.Accounts.Admin.roles()

  embedded_schema do
    field(:name, :string)
    field(:country, Ecto.Enum, values: [:fra, :deu, :bel])
    field(:currency, :string)
    field(:tags, {:array, :string})
    field(:birth_date, :date)
    field(:signature, {:array, :string})
    field(:level, :integer, default: 1)
    field(:terms, :boolean, default: false)
    field(:password, :string, redact: true)
    field(:notifications, :boolean, default: false)
    field(:role, :string)
    field(:pin, :string)
    field(:accent_color, :string)
    field(:heading_angle, :float)
    field(:title, :string)
    field(:avatar, :string)
  end

  def currencies, do: @currencies
  def roles, do: @roles

  def changeset_validate(form, attrs \\ %{}) do
    attrs = normalize_pin_attrs(attrs)

    form
    |> cast(attrs, [
      :name,
      :country,
      :currency,
      :tags,
      :birth_date,
      :signature,
      :level,
      :terms,
      :password,
      :notifications,
      :role,
      :pin,
      :accent_color,
      :heading_angle,
      :title,
      :avatar
    ])
    |> validate_required(
      [
        :name,
        :country,
        :currency,
        :tags,
        :birth_date,
        :level,
        :password,
        :role,
        :pin,
        :accent_color,
        :heading_angle,
        :title
      ],
      message: "can't be blank"
    )
    |> validate_acceptance(:terms, message: "must be accepted to continue")
    |> validate_acceptance(:notifications, message: "must be accepted to continue")
    |> validate_inclusion(:country, Ecto.Enum.values(__MODULE__, :country))
    |> validate_inclusion(:currency, @currencies)
    |> validate_number(:level, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> validate_length(:password, min: 8, message: "must be at least 8 characters")
    |> validate_inclusion(:role, @roles)
    |> validate_pin()
    |> validate_number(:heading_angle, greater_than_or_equal_to: 0, less_than_or_equal_to: 360)
    |> validate_accent_color_not_default()
    |> validate_heading_angle_not_default()
    |> validate_level_not_default()
    |> validate_signature_present()
    |> validate_tags_present()
    |> validate_avatar_present()
  end

  def format_for_toast(%__MODULE__{} = data) do
    [
      "name=#{data.name}",
      "country=#{data.country}",
      "currency=#{data.currency}",
      "tags=#{inspect(data.tags)}",
      "birth_date=#{data.birth_date}",
      "level=#{data.level}",
      "terms=#{data.terms}",
      "notifications=#{data.notifications}",
      "role=#{data.role}",
      "pin=***",
      "accent_color=#{data.accent_color}",
      "heading_angle=#{data.heading_angle}",
      "title=#{data.title}",
      "avatar=#{data.avatar}",
      "password=***"
    ]
    |> Enum.join(" ")
  end

  def normalize_avatar_params(params), do: E2e.Form.AvatarParams.normalize(params)

  defp normalize_pin_attrs(%{} = attrs) do
    attrs = Map.new(attrs, fn {key, value} -> {to_string(key), value} end)

    case Map.get(attrs, "pin") do
      list when is_list(list) -> Map.put(attrs, "pin", Enum.join(list))
      _ -> attrs
    end
  end

  defp normalize_pin_attrs(attrs), do: attrs

  # Incomplete pins are ignored on :validate so mid-entry digits don't surface
  # length/format errors (or steal focus via LiveView re-render). Insert/update
  # still enforce a full 4-digit code.
  defp validate_pin(changeset) do
    pin = get_field(changeset, :pin)

    cond do
      not is_binary(pin) or pin == "" ->
        changeset

      byte_size(pin) < 4 and changeset.action == :validate ->
        changeset

      true ->
        changeset
        |> validate_length(:pin, is: 4)
        |> validate_format(:pin, ~r/^\d+$/, message: "must be digits")
    end
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

  # Number input defaults to min (1) — treat as blank until the user changes it.
  defp validate_level_not_default(changeset) do
    if default_level?(get_field(changeset, :level)) do
      add_error(changeset, :level, "can't be blank")
    else
      changeset
    end
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

  defp default_level?(value) when value in [1, 1.0], do: true

  defp default_level?(value) when is_binary(value),
    do: value in ["1", "1.0", "1.00"]

  defp default_level?(_), do: false
end
