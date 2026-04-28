defmodule Mix.Corex.Install.Assets do
  @moduledoc false

  @default_js_import "import corex from \"corex\"\n"

  def insert_esm_into_config(content) when is_binary(content) do
    if String.contains?(content, "--format=esm") do
      content
    else
      if String.contains?(content, "config :esbuild") and String.contains?(content, "--bundle") do
        String.replace(content, "--bundle", "--bundle --format=esm --splitting", global: false)
      else
        content
      end
    end
  end

  def js_patch_opts do
    case corex_root_for_relative_import() do
      nil -> []
      abs -> [import_line: import_line_for_mjs(abs)]
    end
  end

  defp corex_root_for_relative_import do
    dev_corex_root() ||
      if(path_dep_declared_in_workspace?(), do: deps_corex_root(), else: nil)
  end

  defp path_dep_declared_in_workspace? do
    Enum.any?(mix_exs_files(File.cwd!()), fn mix_exs ->
      path_dep_from_content(mix_exs) != nil
    end)
  end

  defp deps_corex_root do
    root = File.cwd!()
    cand = Path.join([root, "deps", "corex"]) |> Path.expand()
    mix = Path.join(cand, "mix.exs")

    with true <- File.exists?(mix),
         {:ok, body} <- File.read(mix),
         true <- String.match?(body, ~r/\bapp:\s*:corex\b/) do
      cand
    else
      _ -> nil
    end
  end

  def patch_app_js_source(content) when is_binary(content), do: patch_app_js_source(content, [])

  def patch_app_js_source(content, opts) when is_binary(content) and is_list(opts) do
    import_line = Keyword.get(opts, :import_line, @default_js_import)

    content
    |> patch_js_import_line(import_line)
    |> maybe_add_corex_hooks()
  end

  def patch_esbuild_config(igniter, _app) do
    path = "config/config.exs"

    Igniter.update_file(igniter, path, fn source ->
      content = Rewrite.Source.get(source, :content)
      patched = insert_esm_into_config(content)

      if patched == content and String.contains?(content, "config :esbuild") and
           not String.contains?(content, "--format=esm") do
        {:warning,
         "Could not add esbuild ESM flags automatically. Ensure your esbuild args include `--format=esm --splitting`."}
      else
        Rewrite.Source.update(source, :content, patched)
      end
    end)
  end

  def patch_assets_js(igniter) do
    path = "assets/js/app.js"
    js_opts = js_patch_opts()

    Igniter.update_file(igniter, path, fn source ->
      content = Rewrite.Source.get(source, :content)
      patched = patch_app_js_source(content, js_opts)

      if patched == content and not import_corex_present?(content) do
        {:notice,
         "Could not patch `assets/js/app.js` automatically. Add a line `import corex from ...` to load Corex, and ensure your LiveSocket hooks include `...corex`."}
      else
        Rewrite.Source.update(source, :content, patched)
      end
    end)
  end

  @doc """
  Copies the Corex SVG logo to `priv/static/images/logo.svg`, but only if no logo exists yet
  or the existing file is the stock Phoenix logo. Existing user logos are preserved.
  """
  def maybe_install_corex_logo(igniter) do
    target_rel = "priv/static/images/logo.svg"
    source_path = Path.join([:code.priv_dir(:corex), "installer", "images", "logo.svg"])

    case File.read(source_path) do
      {:ok, corex_svg} ->
        maybe_write_corex_logo(igniter, target_rel, corex_svg)

      _ ->
        igniter
    end
  end

  defp maybe_write_corex_logo(igniter, target_rel, corex_svg) do
    target_abs = Path.expand(target_rel)
    existing = if File.exists?(target_abs), do: File.read!(target_abs), else: nil

    cond do
      is_nil(existing) ->
        Igniter.create_new_file(igniter, target_rel, corex_svg, on_exists: :overwrite)

      existing == corex_svg ->
        igniter

      stock_phoenix_logo?(existing) ->
        overwrite_logo_file(igniter, target_rel, corex_svg)

      true ->
        igniter
    end
  end

  defp overwrite_logo_file(igniter, target_rel, corex_svg) do
    Igniter.update_file(igniter, target_rel, fn source ->
      Rewrite.Source.update(source, :content, corex_svg)
    end)
  end

  defp stock_phoenix_logo?(svg) when is_binary(svg) do
    String.contains?(svg, "phoenix") or String.contains?(svg, "Phoenix") or
      String.contains?(svg, "phx") or
      String.contains?(svg, "M71.8 60.3c-15.9-7.4")
  end

  defp import_corex_present?(content) do
    Regex.match?(~r/^\s*import\s+corex\s+from\s+/m, content)
  end

  defp import_line_for_mjs(expanded_corex) do
    app_js_dir = File.cwd!() |> Path.join("assets/js") |> Path.expand()

    mjs =
      expanded_corex
      |> Path.join("priv/static/corex.mjs")
      |> Path.expand()

    rel = mjs |> Path.relative_to(app_js_dir) |> String.replace("\\", "/")
    ~s'import corex from "#{rel}"' <> "\n"
  end

  defp dev_corex_root do
    root = File.cwd!()

    Enum.find_value(mix_exs_files(root), fn mix ->
      case path_dep_from_content(mix) do
        nil -> nil
        rel -> expand_corex_dep(mix, rel)
      end
    end)
  end

  defp mix_exs_files(root) do
    [Path.join(root, "mix.exs") | Path.wildcard(Path.join(root, "apps/*/mix.exs"))]
    |> Enum.filter(&File.exists?/1)
  end

  defp path_dep_from_content(mix_exs) do
    case File.read(mix_exs) do
      {:ok, c} ->
        cond do
          m = Regex.run(~r/:corex\s*,\s*\[\s*path:\s*"([^"]+)"/u, c) -> Enum.at(m, 1)
          m = Regex.run(~r/:corex\s*,\s*\[\s*path:\s*'([^']+)'/u, c) -> Enum.at(m, 1)
          m = Regex.run(~r/:corex\s*,\s*path:\s*"((?:\.\.|\\.|\/|[^"\\])*)"/u, c) -> Enum.at(m, 1)
          m = Regex.run(~r/:corex\s*,\s*path:\s*'((?:\.\.|\\.|\/|[^'\\])*)'/u, c) -> Enum.at(m, 1)
          m = Regex.run(~r/:corex\s*,\s*path:\s*([^\s,}\]]+)/, c) -> Enum.at(m, 1)
          true -> nil
        end

      _ ->
        nil
    end
  end

  defp expand_corex_dep(mix_exs, rel) do
    base = mix_exs |> Path.dirname() |> Path.expand()
    abs = rel |> Path.expand(base)
    mix = Path.join(abs, "mix.exs")

    with true <- File.exists?(mix),
         {:ok, body} <- File.read(mix),
         true <- String.match?(body, ~r/\bapp:\s*:corex\b/) do
      abs
    else
      _ -> nil
    end
  end

  defp patch_js_import_line(content, import_line) do
    if import_corex_present?(content) do
      content
    else
      insert_corex_import_unless_present(content, import_line)
    end
  end

  defp insert_corex_import_unless_present(content, import_line) do
    c = insert_after_liveview(content, import_line)
    if c == content, do: insert_after_phoenix_html(content, import_line), else: c
  end

  defp insert_after_liveview(content, import_line) do
    Regex.replace(
      ~r/(import\s+\{[^}]*LiveSocket[^}]*\}\s+from\s+['"]phoenix_live_view['"]\n)/m,
      content,
      "\\1#{import_line}",
      global: false
    )
  end

  defp insert_after_phoenix_html(content, import_line) do
    Regex.replace(
      ~r/^(import\s+['"]phoenix_html['"]\n)/m,
      content,
      "\\1#{import_line}",
      global: false
    )
  end

  defp colocated_install?(content), do: String.contains?(content, "colocatedHooks")

  defp hooks_has_corex?(content) do
    Regex.match?(~r/hooks:\s*\{[^}]*\.\.\.corex\b/um, content)
  end

  defp maybe_add_corex_hooks(content) do
    if hooks_has_corex?(content) or not colocated_install?(content) do
      content
    else
      c = add_hooks_multiline(content)
      if c == content, do: add_hooks_oneline(content), else: c
    end
  end

  defp add_hooks_multiline(content) do
    Regex.replace(
      ~r/(hooks:\s*\{)(\s*)(\.\.\.colocatedHooks,)([\n\s]*)\}/um,
      content,
      "\\1\\2\\3 ...corex,\\4}",
      global: false
    )
  end

  defp add_hooks_oneline(content) do
    Regex.replace(
      ~r/(hooks:\s*\{\s*)(\.\.\.colocatedHooks)\s*\}/u,
      content,
      "\\1\\2, ...corex}",
      global: false
    )
  end
end
