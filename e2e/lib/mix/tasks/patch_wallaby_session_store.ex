defmodule Mix.Tasks.PatchWallabySessionStore do
  use Mix.Task

  @shortdoc "Increases Wallaby SessionStore monitor call timeout for slow CI teardown"

  def run(_) do
    with wallaby_root when is_binary(wallaby_root) <- Mix.Project.deps_paths()[:wallaby],
         path <- Path.join(wallaby_root, "lib/wallaby/session_store.ex"),
         true <- File.exists?(path),
         content when is_binary(content) <- File.read(path),
         needle = "GenServer.call(store, {:monitor, session}, 10_000)",
         true <- String.contains?(content, needle) do
      replacement = "GenServer.call(store, {:monitor, session}, 120_000)"
      File.write!(path, String.replace(content, needle, replacement, global: false))
    end

    :ok
  end
end
