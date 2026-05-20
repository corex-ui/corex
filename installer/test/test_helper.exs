Mix.shell(Mix.Shell.Process)

Application.put_env(:corex_new, :silent_mix_output, true)

Code.ensure_compiled!(Corex.New.MixHelper)
Code.ensure_compiled!(Corex.New.ScaffoldHelper)

if Version.match?(System.version(), "~> 1.18") do
  case Process.whereis(Corex.New.VersionCheck.Supervisor) do
    pid when is_pid(pid) ->
      unless Process.alive?(pid) do
        {:ok, _} = Task.Supervisor.start_link(name: Corex.New.VersionCheck.Supervisor)
      end

    nil ->
      {:ok, _} = Task.Supervisor.start_link(name: Corex.New.VersionCheck.Supervisor)
  end
end

ExUnit.start(exclude: [integration: true])
