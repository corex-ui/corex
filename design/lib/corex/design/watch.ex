defmodule Corex.Design.Watch do
  @moduledoc false

  @compile {:no_warn_undefined, [FileSystem]}

  require Logger

  @debounce_ms 200

  def start do
    unless Code.ensure_loaded?(FileSystem) do
      Logger.error(
        "Corex design watch requires the :file_system dependency (included with phoenix_live_reload)"
      )

      exit(:shutdown)
    end

    IO.puts("[watch] Corex design watching config changes...")

    dirs =
      [Path.join(File.cwd!(), "config")]
      |> Enum.filter(&File.dir?/1)

    case FileSystem.start_link(dirs: dirs, name: __MODULE__) do
      {:ok, _pid} ->
        FileSystem.subscribe(__MODULE__)
        loop(%{timer: nil})

      {:error, reason} ->
        Logger.error("Corex design watch failed to start FileSystem: #{inspect(reason)}")
        exit({:shutdown, reason})
    end
  end

  defp relevant?(path) do
    Path.extname(path) == ".exs" and String.contains?(path, "/config/")
  end

  defp loop(state) do
    receive do
      {:file_event, _pid, {path, _events}} ->
        if relevant?(path), do: send(self(), :compile)
        loop(state)

      {:file_event, _pid, :stop} ->
        loop(state)

      :compile ->
        loop(schedule(state))

      :run_compile ->
        Mix.Task.run("app.config")
        Corex.Design.compile(log: :watch_rebuild)
        loop(%{state | timer: nil})
    end
  end

  defp schedule(%{timer: nil} = state) do
    ref = Process.send_after(self(), :run_compile, @debounce_ms)
    %{state | timer: ref}
  end

  defp schedule(state), do: state
end
