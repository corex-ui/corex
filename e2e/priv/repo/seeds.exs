# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     E2e.Repo.insert!(%E2e.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias E2e.Place.Helper
alias E2e.Place

Helper.fetch_and_insert_airports()

Helper.fetch_and_insert_cities()

IO.inspect(Enum.count(Place.list_cities()), label: "number of Cities")
IO.inspect(Enum.count(Place.list_airports()), label: "number of Airports")
