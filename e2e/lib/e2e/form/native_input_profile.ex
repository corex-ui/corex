defmodule E2e.Form.NativeInputProfile do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :birth_date, :string
    field :datetime, :string
    field :reminder_time, :string
    field :month, :string
    field :week, :string
    field :website, :string
    field :phone, :string
    field :q, :string
    field :color, :string
    field :count, :integer
    field :password, :string
    field :role, :string
    field :tags, {:array, :string}, default: []
    field :size, :string
    field :agree, :boolean, default: false
  end

  @fields [
    :name,
    :email,
    :bio,
    :birth_date,
    :datetime,
    :reminder_time,
    :month,
    :week,
    :website,
    :phone,
    :q,
    :color,
    :count,
    :password,
    :role,
    :tags,
    :size,
    :agree
  ]

  @required_fields @fields

  def changeset(profile, attrs \\ %{}) do
    profile
    |> cast(attrs, @fields)
    |> validate_required([:name, :email, :agree])
    |> validate_acceptance(:agree)
  end

  def changeset_validate(profile, attrs \\ %{}) do
    profile
    |> cast(attrs, @fields)
    |> validate_required(@required_fields, message: "can't be blank")
    |> validate_format(:email, ~r/@/, message: "must look like an email address")
    |> validate_length(:bio, min: 3, message: "must be at least 3 characters")
    |> validate_length(:password, min: 6, message: "must be at least 6 characters")
    |> validate_format(:website, ~r/^https?:\/\//, message: "must start with http:// or https://")
    |> validate_number(:count,
      greater_than: 0,
      less_than: 99,
      message: "must be between 1 and 98"
    )
    |> validate_tags_present()
    |> validate_acceptance(:agree, message: "must be accepted to continue")
  end

  defp validate_tags_present(changeset) do
    tags = get_field(changeset, :tags) || []

    if tags == [] do
      add_error(changeset, :tags, "can't be blank")
    else
      changeset
    end
  end

  def valid_attrs(overrides \\ %{}) do
    Map.merge(
      %{
        "name" => "Ada",
        "email" => "ada@ex.com",
        "bio" => "Short bio here",
        "birth_date" => "1990-01-15",
        "datetime" => "2024-06-15T14:30",
        "reminder_time" => "09:00",
        "month" => "2024-06",
        "week" => "2024-W24",
        "website" => "https://example.com",
        "phone" => "+1234567890",
        "q" => "elixir",
        "color" => "#3b82f6",
        "count" => "5",
        "password" => "secret1",
        "role" => "admin",
        "tags" => ["elixir", "phoenix"],
        "size" => "l",
        "agree" => "true"
      },
      overrides
    )
  end

  @toast_fields ~W(
    name email bio birth_date datetime reminder_time month week website phone q
    color count role tags size agree
  )a

  def format_for_toast(%__MODULE__{} = data) do
    data |> Map.from_struct() |> format_for_toast()
  end

  def format_for_toast(data) when is_map(data) do
    data = normalize_atom_keys(data)

    lines =
      Enum.map(@toast_fields, fn field ->
        "#{field}=#{inspect(Map.get(data, field))}"
      end)

    (lines ++ ["password=***"])
    |> Enum.join(", ")
  end

  defp normalize_atom_keys(map) do
    Map.new(map, fn
      {key, value} when is_atom(key) ->
        {key, value}

      {key, value} when is_binary(key) ->
        {String.to_existing_atom(key), value}
    end)
  end
end
