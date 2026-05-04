defmodule Mix.Tasks.PatchWallabySessionStore do
  use Mix.Task

  @shortdoc "Increases Wallaby SessionStore monitor call timeout for slow CI teardown"

  def run(_) do
    case Mix.Project.deps_paths()[:wallaby] do
      nil ->
        :ok

      wallaby_root ->
        path = Path.join(wallaby_root, "lib/wallaby/session_store.ex")

        if File.exists?(path) do
          content = File.read!(path)
          needle = "GenServer.call(store, {:monitor, session}, 10_000)"
          replacement = "GenServer.call(store, {:monitor, session}, 120_000)"

          if String.contains?(content, needle) do
            File.write!(path, String.replace(content, needle, replacement, global: false))
          end
        end
    end
  end
end
