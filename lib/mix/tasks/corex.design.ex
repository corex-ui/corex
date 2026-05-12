defmodule Mix.Tasks.Corex.Design do
  use Mix.Task

  @shortdoc "Copies the Corex design asset tree into assets/corex/"

  @moduledoc """
  Copies the Corex design asset tree from the `corex` package `priv/` directory
  into your app's `assets/corex/`.

  The copy is safe by default  -  it **skips any target that already exists**.
  Pass `--force` to overwrite.

  ## Options

    * `--designex`  -  also copy the design token source tree into `assets/corex/design/`
    * `--force`  -  overwrite the target(s) if they already exist

  ## Examples

      mix corex.design                   # first-time copy; no-op if already present
      mix corex.design --force           # overwrite existing assets/corex/
      mix corex.design --designex        # also copy the token source tree
      mix corex.design --designex --force
  """

  @impl true
  def run(argv) do
    {opts, _} =
      OptionParser.parse!(argv,
        strict: [designex: :boolean, force: :boolean],
        aliases: [f: :force]
      )

    priv = priv_dir!()
    force? = Keyword.get(opts, :force, false)
    designex? = Keyword.get(opts, :designex, false)

    copy_tree!(priv, ["design", "corex"], Path.expand(Path.join("assets", "corex")), force?)

    if designex? do
      copy_tree!(
        priv,
        ["design", "design"],
        Path.expand(Path.join(["assets", "corex", "design"])),
        force?
      )
    end

    :ok
  end

  defp priv_dir! do
    case :code.priv_dir(:corex) do
      {:error, _} ->
        Mix.raise(
          "Could not resolve :corex priv directory  -  is the corex dependency available?"
        )

      priv ->
        List.to_string(priv)
    end
  end

  defp copy_tree!(priv, rel_segments, dest, force?) do
    src = Path.join([priv | rel_segments])

    unless File.dir?(src) do
      Mix.raise("Expected Corex packaged tree at #{src}")
    end

    if File.exists?(dest) and not force? do
      Mix.shell().info([
        :yellow,
        "* ",
        :reset,
        "#{Path.relative_to_cwd(dest)} already exists, skipping (pass --force to overwrite)"
      ])
    else
      File.mkdir_p!(Path.dirname(dest))
      File.cp_r!(src, dest)

      Mix.shell().info([
        :green,
        "* copied ",
        :reset,
        "#{Path.relative_to_cwd(src)} → #{Path.relative_to_cwd(dest)}"
      ])
    end
  end
end
