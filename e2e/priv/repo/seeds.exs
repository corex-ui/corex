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
alias E2e.Tetrex
alias E2e.Tetrex.Store

IO.puts("Seeding cities and airports…")

Helper.fetch_and_insert_cities()
Helper.fetch_and_insert_airports()

cities = Enum.count(Place.list_cities())
airports = Enum.count(Place.list_airports())

IO.puts("Seeding Tetrex leaderboard…")

for {score, index} <- Enum.with_index([50, 45, 40, 35, 30, 25, 20, 15, 12, 10], 1) do
  id = "seed-top-#{index}"
  game = %{Tetrex.new() | score: score, status: :game_over}
  client = Tetrex.to_client(game)

  Store.finalize(id, score, [client], client)
end

tetrex_count = length(Store.list_top(10))

IO.puts(
  "Seeds finished: #{cities} cities, #{airports} airports, #{tetrex_count} Tetrex leaderboard games"
)
