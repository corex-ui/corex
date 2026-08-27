defmodule CorexAdmin.Export do
  @moduledoc false

  alias CorexAdmin.Field
  alias CorexAdmin.Resource.Field, as: FieldSpec

  @max_rows 10_000

  def max_rows, do: @max_rows

  @doc "CSV or JSON body as an iodata stream of chunks."
  def encode(format, fields, records) when format in [:csv, "csv"] do
    headers = Enum.map(fields, & &1.label)
    rows = Enum.map(records, fn record -> Enum.map(fields, &csv_cell(&1, record)) end)

    [headers | rows]
    |> NimbleCSV.RFC4180.dump_to_stream()
    |> Stream.map(&IO.iodata_to_binary/1)
  end

  def encode(format, fields, records) when format in [:json, "json"] do
    maps =
      Enum.map(records, fn record ->
        Map.new(fields, fn field -> {Atom.to_string(field.name), Field.export(field, record)} end)
      end)

    [Jason.encode!(maps)]
  end

  def filename(spec, format) when format in [:csv, "csv"], do: "#{spec.slug}.csv"
  def filename(spec, format) when format in [:json, "json"], do: "#{spec.slug}.json"

  def content_type(format) when format in [:csv, "csv"], do: "text/csv; charset=utf-8"
  def content_type(format) when format in [:json, "json"], do: "application/json; charset=utf-8"

  def token_salt, do: "corex_admin.export"
  def token_max_age, do: 300

  def parse_format("json"), do: :json
  def parse_format(:json), do: :json
  def parse_format(_), do: :csv

  defp csv_cell(%FieldSpec{} = field, record) do
    case Field.export(field, record) do
      nil -> ""
      true -> "true"
      false -> "false"
      list when is_list(list) -> Jason.encode!(list)
      value -> to_string(value)
    end
  end
end
