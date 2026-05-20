Application.ensure_all_started(:phoenix_live_view)

Code.ensure_compiled!(MixGenHelpers)

ExUnit.start(exclude: [integration: true])
