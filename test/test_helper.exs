Application.ensure_all_started(:phoenix_live_view)

Code.ensure_compiled!(MixGenHelpers)

ExUnit.start(capture_log: true, exclude: [integration: true, parity_report: true])
