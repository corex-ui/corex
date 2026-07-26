defmodule Corex.New.Shared do
  @moduledoc false

  @version Mix.Project.config()[:version]
  @minor_constraint @version |> Version.parse!() |> then(&"~> #{&1.major}.#{&1.minor}")

  @default_themes ["neo", "uno", "duo", "leo"]

  def default_themes, do: @default_themes

  def version_constraint, do: @minor_constraint

  @doc """
  Resolves the theme list and the default theme from generator options.

  Without `--theme` a generated app ships one theme, so there is nothing to
  switch between and the toggle templates are skipped.
  """
  def resolve_themes(opts) do
    themes =
      if Keyword.get(opts, :theme, false) do
        Keyword.get(opts, :themes, @default_themes)
      else
        ["neo"]
      end

    {themes, List.first(themes) || "neo"}
  end

  def put_theme_opts(opts) do
    {themes, default_theme} = resolve_themes(opts)

    opts
    |> Keyword.put(:themes, themes)
    |> Keyword.put(:default_theme, default_theme)
  end

  @doc """
  Resolves the JavaScript import specifier for the Corex bundle.

  Returns `"corex"` for a Hex install. With `--dev PATH` it returns a relative
  path to the checkout's built `corex.mjs`, so the generated app imports the
  local bundle instead of the published one.
  """
  def corex_js_import(install_dir, opts, task) when is_binary(task) do
    case dev_path(opts) do
      nil ->
        "corex"

      path ->
        corex_root = Path.expand(path, install_dir)
        mjs = Path.join([corex_root, "priv", "static", "corex.mjs"])

        unless File.exists?(mjs) do
          Mix.raise("""
          Expected Corex bundle at #{mjs}.

          From the Corex checkout run:

              mix assets.build

          Then re-run #{task} with --dev.
          """)
        end

        relative_import_from(Path.join([install_dir, "assets", "js"]), mjs)
    end
  end

  def corex_dep_source(opts) do
    case dev_path(opts) do
      nil -> ~s("#{@minor_constraint}")
      path -> "[path: #{inspect(path)}, override: true]"
    end
  end

  def corex_design_dep_source(opts) do
    case dev_path(opts) do
      nil ->
        ~s("#{@minor_constraint}", runtime: false, only: :dev)

      path ->
        "[path: #{inspect(Path.join(path, "design"))}, runtime: false, only: :dev]"
    end
  end

  def corex_mcp_dep_source(opts) do
    case dev_path(opts) do
      nil -> ~s("#{@minor_constraint}", only: [:dev, :test])
      path -> "[path: #{inspect(Path.join(path, "mcp"))}, only: [:dev, :test]]"
    end
  end

  @doc """
  Returns the trimmed `--dev` path, or `nil` when generating from Hex.
  """
  def dev_path(opts) do
    with path when is_binary(path) <- Keyword.get(opts, :dev),
         trimmed when trimmed != "" <- String.trim(path) do
      Corex.New.Cli.validate_dev_path!(trimmed)
      trimmed
    else
      _ -> nil
    end
  end

  def write!(path, contents) do
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, contents)
  end

  def bundled_gettext_catalog_root do
    case archive_priv_gettext_root() do
      nil -> Path.expand("../../priv/gettext", __DIR__)
      path -> path
    end
  end

  def copy_gettext_catalog!(install_dir) do
    src = bundled_gettext_catalog_root()
    dest = Path.join(install_dir, "priv/gettext")

    unless File.dir?(src) do
      Mix.raise("""
      Corex gettext catalog template is missing at #{src}.

      Expected installer/priv/gettext with default.pot and en/fr/ar PO files.
      """)
    end

    Mix.shell().info([:green, "* copying ", :reset, "gettext catalog → priv/gettext/"])
    File.mkdir_p!(Path.dirname(dest))
    _copied = File.cp_r!(src, dest)
    :ok
  end

  defp archive_priv_gettext_root do
    case :code.which(__MODULE__) do
      beam when is_list(beam) ->
        root =
          beam
          |> to_beam_path()
          |> Path.dirname()
          |> Path.join("../priv/gettext")
          |> Path.expand()

        if File.exists?(Path.join(root, "default.pot")), do: root

      _ ->
        nil
    end
  end

  defp to_beam_path(beam) when is_list(beam), do: List.to_string(beam)

  defp relative_import_from(js_dir, target_file) do
    js_dir = Path.expand(js_dir)
    target_file = Path.expand(target_file)

    {from_rest, to_rest} =
      drop_common_prefix(Path.split(js_dir), Path.split(target_file))

    ups = List.duplicate("..", length(from_rest))

    rel =
      (ups ++ to_rest)
      |> Path.join()
      |> String.replace("\\", "/")

    if Path.expand(Path.join(js_dir, rel)) != target_file do
      Mix.raise(
        "Could not resolve a relative import path from #{js_dir} to #{target_file}. Use paths on the same filesystem root."
      )
    end

    rel
  end

  defp drop_common_prefix([h | ta], [h | tb]), do: drop_common_prefix(ta, tb)
  defp drop_common_prefix(a, b), do: {a, b}
end
