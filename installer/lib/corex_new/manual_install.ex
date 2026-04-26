defmodule Corex.New.ManualInstall do
  @moduledoc false

  @doc "Short hint to append to Mix.raise/compile errors for manual `mix igniter.install corex` and assets."
  @spec hint() :: String.t()
  def hint do
    """
    If automated install is not an option, add Corex to an app yourself:

      * Follow https://hexdocs.pm/corex/manual_installation.html (or guides/manual_installation.md in the repo) — add the dependency, `import corex` and hooks in `assets/js/app.js`, and esbuild ESM flags in `config/config.exs` as shown there.
    """
  end
end
