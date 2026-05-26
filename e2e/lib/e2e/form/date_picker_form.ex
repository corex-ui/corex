defmodule E2e.Form.DatePickerForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :date, :date
    field :dates, {:array, :date}
    field :date_range, {:array, :date}
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(normalize_range_attrs(attrs), [:date, :dates, :date_range])
  end

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:date])
    |> validate_required([:date], message: "can't be blank")
  end

  def changeset_validate_dates(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:dates])
    |> validate_required([:dates], message: "can't be blank")
    |> validate_length(:dates, min: 1, message: "can't be blank")
  end

  def changeset_validate_range(form, attrs \\ %{}) do
    form
    |> cast(normalize_range_attrs(attrs), [:date_range])
    |> validate_required([:date_range], message: "can't be blank")
    |> validate_length(:date_range, min: 2, max: 2, message: "must be a start and end date")
  end

  defp normalize_range_attrs(%{"date_range" => range} = attrs) when is_binary(range) do
    %{attrs | "date_range" => split_date_list(range)}
  end

  defp normalize_range_attrs(%{date_range: range} = attrs) when is_binary(range) do
    Map.put(attrs, :date_range, split_date_list(range))
  end

  defp normalize_range_attrs(attrs), do: attrs

  defp split_date_list(value) when is_binary(value) do
    value
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
