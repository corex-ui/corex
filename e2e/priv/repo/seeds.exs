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
alias E2e.Tetrex.ReplaySeed
alias E2e.Tetrex.Store

IO.puts("Seeding cities and airports…")

Helper.fetch_and_insert_cities()
Helper.fetch_and_insert_airports()

cities = Enum.count(Place.list_cities())
airports = Enum.count(Place.list_airports())

IO.puts("Seeding Tetrex leaderboard…")

tetrex_seed_scores = [
  50_000,
  45_000,
  40_000,
  35_000,
  30_000,
  25_000,
  20_000,
  15_000,
  10_000,
  5_000
]

for {target_score, index} <- Enum.with_index(tetrex_seed_scores, 1) do
  id = "seed-top-#{index}"
  %{frames: frames, client: client, score: score} = ReplaySeed.build(target_score, index)

  Store.finalize(id, score, frames, client)
end

tetrex_count = length(Store.list_top(10))

IO.puts(
  "Seeds finished: #{cities} cities, #{airports} airports, #{tetrex_count} Tetrex leaderboard games"
)
