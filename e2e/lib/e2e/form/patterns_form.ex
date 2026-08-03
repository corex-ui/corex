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
    |> validate_length(:pin, is: 4)
    |> validate_format(:pin, ~r/^\d+$/, message: "must be digits")
    |> validate_number(:heading_angle, greater_than_or_equal_to: 0, less_than_or_equal_to: 360)
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

  def normalize_avatar_params(params) when is_map(params) do
    case Map.get(params, "avatar") do
      %Plug.Upload{filename: name} when is_binary(name) and name != "" ->
        Map.put(params, "avatar", name)

      _ ->
        case Map.get(params, "avatar_label") do
          label when is_binary(label) ->
            trimmed = String.trim(label)

            if trimmed != "" do
              Map.put(params, "avatar", trimmed)
            else
              params
            end

          _ ->
            params
        end
    end
  end

  def normalize_avatar_params(params), do: params

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
end
