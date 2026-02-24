defmodule E2e.Place.Helper do
  @moduledoc false
  alias E2e.Repo
  require Logger

  def country_name_from_code(country_code) do
    {:ok, country_name} = Cldr.Territory.display_name(country_code)
    country_name
  end

  def fetch_and_insert_cities() do
    read_compressed("cities.tar.gz")
    |> Jason.decode!()
    |> Enum.chunk_every(500)
    |> Enum.each(fn batch ->
      entries =
        Enum.map(batch, fn city ->
          %{
            id: city["id"],
            name: city["name"],
            iata_code: city["iata_code"],
            iata_country_code: city["iata_country_code"],
            # embedded airports stored as jsonb
            airports: city["airports"] |> encode_embed()
          }
        end)

      Repo.insert_all("cities", entries, on_conflict: :nothing, conflict_target: :id)
    end)
  end

  def fetch_and_insert_airports() do
    read_compressed("airports.tar.gz")
    |> Jason.decode!()
    |> Enum.chunk_every(500)
    |> Enum.each(fn batch ->
      entries =
        Enum.map(batch, fn airport ->
          %{
            id: airport["id"],
            name: airport["name"],
            iata_code: airport["iata_code"],
            city_name: airport["city_name"],
            iata_city_code: airport["iata_city_code"],
            iata_country_code: airport["iata_country_code"],
            icao_code: airport["icao_code"],
            latitude: airport["latitude"],
            longitude: airport["longitude"],
            time_zone: airport["time_zone"],
            # embedded city stored as jsonb
            city: airport["city"] |> encode_embed()
          }
        end)

      Repo.insert_all("airports", entries, on_conflict: :nothing, conflict_target: :id)
    end)
  end

  defp read_compressed(filename) do
    priv_dir = :code.priv_dir(:corex_web)
    file_path = Path.join([priv_dir, "repo", "seeds", filename])
    {:ok, file} = File.open(file_path, [:read, :utf8, :compressed])
    data = IO.read(file, :eof)
    File.close(file)
    data
  end

  defp encode_embed(nil), do: nil
  defp encode_embed(data) when is_list(data), do: data
  defp encode_embed(data) when is_map(data), do: data
end
