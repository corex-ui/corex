Application.ensure_all_started(:phoenix_live_view)

exclude = if System.get_env("CI"), do: [integration: true], else: []
ExUnit.start(exclude: exclude)
