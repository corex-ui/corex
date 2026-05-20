Application.put_env(:corex_new, :silent_mix_output, true)

ExUnit.start(exclude: [integration: true])
