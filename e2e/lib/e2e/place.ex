defmodule E2e.Place do
  @moduledoc """
  The Place context.
  """

  import Ecto.Query, warn: false
  alias E2e.Repo

  alias E2e.Place.City
  alias E2e.Place.Airport

  @doc """
  Returns the list of cities.

  ## Examples

      iex> list_cities()
      [%City{}, ...]

  """
  def list_cities do
    Repo.all(City)
  end

  @doc """
  Gets a single city.

  Raises `Ecto.NoResultsError` if the City does not exist.

  ## Examples

      iex> get_city!(123)
      %City{}

      iex> get_city!(456)
      ** (Ecto.NoResultsError)

  """
  def get_city!(id), do: Repo.get!(City, id)

  @doc """
  Creates a city.

  ## Examples

      iex> create_city(%{field: value})
      {:ok, %City{}}

      iex> create_city(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_city(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert(on_conflict: :nothing, conflict_target: :id)
  end

  @doc """
  Updates a city.

  ## Examples

      iex> update_city(city, %{field: new_value})
      {:ok, %City{}}

      iex> update_city(city, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_city(%City{} = city, attrs) do
    city
    |> City.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a city.

  ## Examples

      iex> delete_city(city)
      {:ok, %City{}}

      iex> delete_city(city)
      {:error, %Ecto.Changeset{}}

  """
  def delete_city(%City{} = city) do
    Repo.delete(city)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking city changes.

  ## Examples

      iex> change_city(city)
      %Ecto.Changeset{data: %City{}}

  """
  def change_city(%City{} = city, attrs \\ %{}) do
    City.changeset(city, attrs)
  end


  def list_cities(query) when is_binary(query) do
    City
    |> where([c], ilike(c.name, ^"#{query}%") or ilike(c.iata_code, ^"#{query}%"))
    |> limit(50)
    |> Repo.all()
  end

  def list_airports(query) when is_binary(query) do
    Airport
    |> where([a], ilike(a.name, ^"#{query}%") or ilike(a.iata_code, ^"#{query}%"))
    |> limit(50)
    |> Repo.all()
  end
  @doc """
  Returns the list of airports.

  ## Examples

      iex> list_airports()
      [%Airport{}, ...]

  """
  def list_airports do
    Repo.all(Airport)
  end

  def list_airports_first(count) when is_integer(count) do
    from(Airport, order_by: [asc: :name], limit: ^count) |> Repo.all()
  end

  def list_airports_first(count, offset) when is_integer(count) and is_integer(offset) do
    from(Airport, order_by: [asc: :name], limit: ^count, offset: ^offset) |> Repo.all()
  end

  @popular_iata_by_continent [
    {"Popular in Europe", ["CDG", "LHR", "FRA", "AMS", "MAD", "BCN", "FCO", "ZRH", "VIE"]},
    {"Popular in Asia", ["NRT", "HND", "ICN", "PVG", "HKG", "SIN", "BKK", "KUL"]},
    {"Popular in North America", ["JFK", "LAX", "ORD", "YYZ", "MIA", "SFO"]},
    {"Popular in Middle East", ["DXB", "AUH", "DOH"]},
    {"Popular in Oceania", ["SYD", "AKL", "MEL"]}
  ]

  def list_popular_airports_by_continent do
    all_codes = @popular_iata_by_continent |> Enum.flat_map(fn {_, codes} -> codes end)

    airports =
      from(a in Airport, where: a.iata_code in ^all_codes)
      |> Repo.all()

    airport_map = Map.new(airports, &{&1.iata_code, &1})

    for {continent, codes} <- @popular_iata_by_continent,
        code <- codes,
        airport = airport_map[code],
        !is_nil(airport) do
      {airport, continent}
    end
  end

  def search_airports(term, limit, offset) when is_binary(term) and is_integer(limit) and is_integer(offset) do
    search = "%#{term}%"

    Airport
    |> where([a], ilike(a.name, ^search) or ilike(a.iata_code, ^search))
    |> order_by([a], asc: a.name)
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
  end


  @doc """
  Gets a single airport.

  Raises `Ecto.NoResultsError` if the Airport does not exist.

  ## Examples

      iex> get_airport!(123)
      %Airport{}

      iex> get_airport!(456)
      ** (Ecto.NoResultsError)

  """
  def get_airport!(id), do: Repo.get!(Airport, id)

  @doc """
  Creates a airport.

  ## Examples

      iex> create_airport(%{field: value})
      {:ok, %Airport{}}

      iex> create_airport(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_airport(attrs \\ %{}) do
    %Airport{}
    |> Airport.changeset(attrs)
    |> Repo.insert(on_conflict: :nothing, conflict_target: :id)
  end

  @doc """
  Updates a airport.

  ## Examples

      iex> update_airport(airport, %{field: new_value})
      {:ok, %Airport{}}

      iex> update_airport(airport, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_airport(%Airport{} = airport, attrs) do
    airport
    |> Airport.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a airport.

  ## Examples

      iex> delete_airport(airport)
      {:ok, %Airport{}}

      iex> delete_airport(airport)
      {:error, %Ecto.Changeset{}}

  """
  def delete_airport(%Airport{} = airport) do
    Repo.delete(airport)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking airport changes.

  ## Examples

      iex> change_airport(airport)
      %Ecto.Changeset{data: %Airport{}}

  """
  def change_airport(%Airport{} = airport, attrs \\ %{}) do
    Airport.changeset(airport, attrs)
  end

  def list_random_city do
    Repo.one(
      from City,
        order_by: fragment("RANDOM()"),
        limit: 1
    )
  end

  def list_random_airport do
    Repo.one(
      from Airport,
        order_by: fragment("RANDOM()"),
        limit: 1
    )
  end

  def list_random_airports(count) when is_integer(count) do
    from(Airport, order_by: fragment("RANDOM()"), limit: ^count) |> Repo.all()
  end

  def search_airports(term) do
    search_airports(term, 20, 0)
  end
end
