Mix.shell(Mix.Shell.Process)

Application.put_env(:corex_new, :silent_mix_output, true)

Code.ensure_compiled!(MixHelper)
Code.ensure_compiled!(Corex.New.ScaffoldHelper)

ExUnit.start(exclude: [integration: true])
