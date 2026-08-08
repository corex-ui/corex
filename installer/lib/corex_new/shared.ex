defmodule Corex.New.Shared do
  @moduledoc false

  @version Mix.Project.config()[:version]
  @minor_constraint @version |> Version.parse!() |> then(&"~> #{&1.major}.#{&1.minor}")

  @default_themes ["neo", "uno", "duo", "leo"]

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
    a11y = Keyword.get(opts, :a11y, false)

    case {dev_path(opts), a11y} do
      {nil, true} ->
        ~s("#{@minor_constraint}", runtime: false)

      {nil, false} ->
        ~s("#{@minor_constraint}", runtime: false, only: :dev)

      {path, true} ->
        "[path: #{inspect(Path.join(path, "design"))}, runtime: false]"

      {path, false} ->
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

    if elixir_source_path?(path) do
      format_elixir_source!(path)
    end

    :ok
  end

  @doc """
  Formats an `.ex`/`.exs` file in place with `Code.format_string!/1`.

  Incomplete Mix stubs in unit tests may not parse; those are left as written.
  """
  def format_elixir_source!(path) do
    original = File.read!(path)

    case Code.string_to_quoted(original, file: path) do
      {:ok, _} ->
        formatted =
          original
          |> Code.format_string!()
          |> IO.iodata_to_binary()
          |> then(fn source ->
            if String.ends_with?(source, "\n"), do: source, else: source <> "\n"
          end)

        if formatted != original do
          File.write!(path, formatted)
        end

      {:error, _} ->
        :ok
    end

    :ok
  end

  defp elixir_source_path?(path) do
    ext = Path.extname(path)
    ext in [".ex", ".exs"]
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

  def bundled_corex_export_root do
    [
      archive_priv_dir("static/corex"),
      # installer/lib/corex_new → installer/priv/static/corex
      Path.expand("../../priv/static/corex", __DIR__)
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.find(&File.dir?/1)
  end

  @doc """
  Path to a static Tableau scaffold asset under `priv/tableau/` (archive-safe).
  """
  def bundled_tableau_asset!(rel) when is_binary(rel) do
    candidates = [
      archive_priv_file(Path.join("tableau", rel)),
      # installer/lib/corex_new → installer/priv/tableau/<rel>
      Path.expand(Path.join(["../../priv/tableau", rel]), __DIR__)
    ]

    case Enum.find(candidates, &(is_binary(&1) and File.exists?(&1))) do
      nil ->
        Mix.raise("""
        Corex Tableau scaffold asset is missing: #{rel}

        Expected installer/priv/tableau/#{rel}.
        """)

      path ->
        path
    end
  end

  @doc """
  Copies the static neo/light Design export into `assets/corex/` for `--no-design` apps.
  """
  def copy_corex_export!(install_dir) do
    src = bundled_corex_export_root()

    unless is_binary(src) and File.dir?(src) do
      Mix.raise("""
      Corex static design export is missing.

      Expected installer/priv/static/corex (neo/light snapshot). From the Corex checkout run:

          mix assets.build
      """)
    end

    dest = Path.join([install_dir, "assets", "corex"])
    Mix.shell().info([:green, "* copying ", :reset, "corex design export → assets/corex/"])
    _ = File.rm_rf!(dest)
    File.mkdir_p!(Path.dirname(dest))
    _copied = File.cp_r!(src, dest)
    :ok
  end

  defp archive_priv_dir(rel) do
    case archive_priv_file(Path.join(rel, "corex.css")) do
      nil -> nil
      css -> Path.dirname(css)
    end
  end

  defp archive_priv_file(rel) do
    case :code.which(__MODULE__) do
      beam when is_list(beam) ->
        path =
          beam
          |> to_beam_path()
          |> Path.dirname()
          |> Path.join("../priv")
          |> Path.join(rel)
          |> Path.expand()

        if File.exists?(path), do: path

      _ ->
        nil
    end
  end

  defp archive_priv_gettext_root do
    case archive_priv_file("gettext/default.pot") do
      nil -> nil
      pot -> Path.dirname(pot)
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
