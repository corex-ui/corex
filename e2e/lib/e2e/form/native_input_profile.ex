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

  def changeset(profile, attrs \\ %{}) do
    profile
    |> cast(attrs, [
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
    ])
    |> validate_required([:name, :email, :agree])
    |> validate_acceptance(:agree)
  end

  def changeset_validate(profile, attrs \\ %{}) do
    profile
    |> cast(attrs, [
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
    ])
    |> validate_required([:name, :email, :role, :count, :agree], message: "can't be blank")
    |> validate_format(:email, ~r/@/, message: "must look like an email address")
    |> validate_length(:bio, min: 3, message: "must be at least 3 characters")
    |> validate_number(:count,
      greater_than: 0,
      less_than: 99,
      message: "must be between 1 and 98"
    )
    |> validate_acceptance(:agree, message: "must be accepted to continue")
  end

  @toast_fields ~w(
    name email bio birth_date datetime reminder_time month week website phone q
    color count role tags size agree
  )a

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
