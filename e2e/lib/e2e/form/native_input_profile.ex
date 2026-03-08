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

  def format_for_toast(data) when is_map(data) do
    [
      "name=#{inspect(Map.get(data, :name) || Map.get(data, "name"))}",
      "email=#{inspect(Map.get(data, :email) || Map.get(data, "email"))}",
      "bio=#{inspect(Map.get(data, :bio) || Map.get(data, "bio"))}",
      "birth_date=#{inspect(Map.get(data, :birth_date) || Map.get(data, "birth_date"))}",
      "datetime=#{inspect(Map.get(data, :datetime) || Map.get(data, "datetime"))}",
      "reminder_time=#{inspect(Map.get(data, :reminder_time) || Map.get(data, "reminder_time"))}",
      "month=#{inspect(Map.get(data, :month) || Map.get(data, "month"))}",
      "week=#{inspect(Map.get(data, :week) || Map.get(data, "week"))}",
      "website=#{inspect(Map.get(data, :website) || Map.get(data, "website"))}",
      "phone=#{inspect(Map.get(data, :phone) || Map.get(data, "phone"))}",
      "q=#{inspect(Map.get(data, :q) || Map.get(data, "q"))}",
      "color=#{inspect(Map.get(data, :color) || Map.get(data, "color"))}",
      "count=#{inspect(Map.get(data, :count) || Map.get(data, "count"))}",
      "password=***",
      "role=#{inspect(Map.get(data, :role) || Map.get(data, "role"))}",
      "tags=#{inspect(Map.get(data, :tags) || Map.get(data, "tags"))}",
      "size=#{inspect(Map.get(data, :size) || Map.get(data, "size"))}",
      "agree=#{inspect(Map.get(data, :agree) || Map.get(data, "agree"))}"
    ]
    |> Enum.join(", ")
  end
end
