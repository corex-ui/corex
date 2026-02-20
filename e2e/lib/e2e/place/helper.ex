defmodule E2e.Place.Helper do
  @moduledoc false
  alias E2e.Place

  require Logger

  def country_name_from_code(country_code) do
    {:ok, country_name} = Cldr.Territory.display_name(country_code)
    country_name
  end

  # Save from seeds
  def fetch_and_insert_cities() do
    priv_dir = :code.priv_dir(:e2e)
    file_path = Path.join([priv_dir, "repo", "seeds", "cities.tar.gz"])

    {:ok, file} = File.open(file_path, [:read, :utf8, :compressed])

    all_cities = IO.read(file, :eof)

    File.close(file)

    for city <- Jason.decode!(all_cities) do
      case Place.create_city(city) do
        {:error, changeset} -> Logger.debug(changeset)
        {:ok, _city} -> :ok
      end
    end
  end

  def fetch_and_insert_airports() do
    priv_dir = :code.priv_dir(:e2e)
    file_path = Path.join([priv_dir, "repo", "seeds", "airports.tar.gz"])

    {:ok, file} = File.open(file_path, [:read, :utf8, :compressed])

    all_airports = IO.read(file, :eof)

    File.close(file)

    for airport <- Jason.decode!(all_airports) do
      case Place.create_airport(airport) do
        {:error, changeset} -> Logger.debug(changeset)
        {:ok, _airport} -> :ok
      end
    end
  end



end
