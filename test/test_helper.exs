Application.ensure_all_started(:phoenix_live_view)

exclude =
  if System.get_env("CI") && !System.get_env("RUN_INTEGRATION"), do: [integration: true], else: []

ExUnit.start(exclude: exclude)
