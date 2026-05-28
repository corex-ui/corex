defmodule Corex.New.Generate do
  @moduledoc false

  alias Corex.New.{Patches, Templates}

  @default_themes ["neo", "uno", "duo", "leo"]

  @doc """
  Runs all Corex post-generation work on a freshly-scaffolded Phoenix app at
  `install_dir`, driven by the normalized `opts` keyword list:

    * `:otp_app` (atom, required)  -  e.g. `:my_app`
    * `:web_module` (atom, required)  -  e.g. `MyAppWeb`
    * `:app_module` (atom, required)  -  e.g. `MyApp`
    * `:mode`, `:theme`, `:lang`, `:design`, `:tailwind`, `:mcp` (bool, default true)
    * `:themes` (list of strings)  -  only used when `:theme` is true
    * `:dev` (string | nil)  -  path to local Corex checkout for `--dev PATH`
  """
  def run(install_dir, opts) do
    opts = normalize_opts(opts)

    write_layouts_ex(install_dir, opts)
    write_root_heex(install_dir, opts)
    write_home_heex(install_dir, opts)
    write_plugs(install_dir, opts)
    write_locale_helpers(install_dir, opts)
    write_app_js(install_dir, opts)
    write_app_css(install_dir, opts)

    Patches.patch_mix_exs(install_dir, opts)
    Patches.patch_web_module(install_dir, opts[:web_module], opts)
    Patches.patch_web_gettext_sigils(install_dir, opts[:web_module], opts)
    Patches.patch_live_view_for_lang(install_dir, opts[:web_module], opts)
    Patches.patch_router(install_dir, opts[:web_module], opts)
    Patches.patch_endpoint(install_dir, opts[:web_module], opts)
    Patches.patch_config_exs(install_dir, opts)
    Patches.patch_gettext_backend(install_dir, opts[:web_module], opts)
    Patches.patch_page_controller_test(install_dir, opts[:web_module])

    if opts[:design] do
      copy_design_tree(install_dir, opts)
    end

    if opts[:lang] do
      Patches.patch_verified_routes_path_prefixes!(install_dir, opts[:web_module], opts)
      copy_gettext_catalog(install_dir)
    end

    :ok
  end

  defp normalize_opts(opts) do
    otp_app = Keyword.fetch!(opts, :otp_app)
    web_module = Keyword.fetch!(opts, :web_module)
    app_module = Keyword.fetch!(opts, :app_module)

    themes =
      cond do
        Keyword.get(opts, :theme, false) -> Keyword.get(opts, :themes, @default_themes)
        true -> ["neo"]
      end

    default_theme = List.first(themes) || "neo"

    opts
    |> Keyword.put(:otp_app, otp_app)
    |> Keyword.put(:web_module, web_module)
    |> Keyword.put(:app_module, app_module)
    |> Keyword.put(:themes, themes)
    |> Keyword.put(:default_theme, default_theme)
    |> Keyword.put_new(:mode, false)
    |> Keyword.put_new(:theme, false)
    |> Keyword.put_new(:lang, false)
    |> Keyword.put_new(:mcp, true)
    |> Keyword.put_new(:design, true)
    |> Keyword.put_new(:tailwind, true)
  end

  defp write_layouts_ex(install_dir, opts) do
    target =
      Path.join([install_dir, "lib", web_underscore(opts), "components", "layouts.ex"])

    write!(target, Templates.layouts_ex(template_assigns(install_dir, opts)))
  end

  defp write_root_heex(install_dir, opts) do
    target =
      Path.join([
        install_dir,
        "lib",
        web_underscore(opts),
        "components",
        "layouts",
        "root.html.heex"
      ])

    write!(target, Templates.root_heex(template_assigns(install_dir, opts)))
  end

  defp write_home_heex(install_dir, opts) do
    target =
      Path.join([
        install_dir,
        "lib",
        web_underscore(opts),
        "controllers",
        "page_html",
        "home.html.heex"
      ])

    if File.exists?(target) do
      write!(target, Templates.home_heex(template_assigns(install_dir, opts)))
    end
  end

  defp write_plugs(install_dir, opts) do
    plugs_dir = Path.join([install_dir, "lib", web_underscore(opts), "plugs"])

    if opts[:mode] or opts[:theme] or opts[:lang] do
      File.mkdir_p!(plugs_dir)
    end

    if opts[:mode] do
      write!(
        Path.join(plugs_dir, "mode.ex"),
        Templates.plug_mode(template_assigns(install_dir, opts))
      )
    end

    if opts[:theme] do
      write!(
        Path.join(plugs_dir, "theme.ex"),
        Templates.plug_theme(template_assigns(install_dir, opts))
      )
    end
  end

  defp write_locale_helpers(install_dir, opts) do
    if opts[:lang] do
      web_dir = Path.join([install_dir, "lib", web_underscore(opts)])
      hooks_dir = Path.join(web_dir, "hooks")

      write!(
        Path.join(web_dir, "locale.ex"),
        Templates.locale_ex(template_assigns(install_dir, opts))
      )

      File.mkdir_p!(hooks_dir)

      write!(
        Path.join(hooks_dir, "layout.ex"),
        Templates.hooks_layout(template_assigns(install_dir, opts))
      )
    end
  end

  defp write_app_js(install_dir, opts) do
    target = Path.join([install_dir, "assets", "js", "app.js"])
    write!(target, Templates.app_js(template_assigns(install_dir, opts)))
  end

  defp write_app_css(install_dir, opts) do
    target = Path.join([install_dir, "assets", "css", "app.css"])
    write!(target, Templates.app_css(template_assigns(install_dir, opts)))
  end

  def bundled_design_root do
    case archive_priv_design_root() do
      nil -> Path.expand("../../priv/corex_design", __DIR__)
      path -> path
    end
  end

  defp archive_priv_design_root do
    case :code.which(Corex.New.Generate) do
      :non_existing ->
        nil

      :cover_compiled ->
        nil

      beam ->
        beam = beam_path_to_string(beam)

        root =
          beam
          |> Path.dirname()
          |> Path.join("../priv/corex_design")
          |> Path.expand()

        if File.dir?(Path.join(root, "corex")), do: root, else: nil
    end
  end

  defp beam_path_to_string(beam) when is_list(beam), do: List.to_string(beam)
  defp beam_path_to_string(beam) when is_binary(beam), do: beam

  defp copy_design_tree(install_dir, opts) do
    case resolve_design_source(opts, install_dir) do
      {:checkout_priv, priv_root} ->
        Mix.shell().info([:green, "* copying ", :reset, "Corex design → assets/corex/"])

        copy_priv_design_siblings!(
          install_dir,
          priv_root,
          ["design", "corex"],
          ["design", "design"],
          opts
        )

      {:bundled, bundled_root} ->
        Mix.shell().info([:green, "* copying ", :reset, "Corex design → assets/corex/"])

        copy_priv_design_siblings!(install_dir, bundled_root, ["corex"], ["design"], opts)

      :missing ->
        Mix.raise("""
        Corex design snapshot is missing (expected #{bundled_design_root()}/corex mirroring priv/design/corex).

        From the corex repository run:

            mix assets.build

        That copies priv/design into installer/priv/corex_design for the archive and local dev.
        Rebuild or reinstall the archive after that step.
        """)
    end
  end

  defp copy_priv_design_siblings!(install_dir, source_root, consumer_rel, designex_rel, opts) do
    dest = Path.join([install_dir, "assets", "corex"])
    copy_design_subtree!(source_root, consumer_rel, dest)
    write_design_version!(dest)

    rm_assets_corex_design_if_present!(install_dir)

    if opts[:designex] do
      copy_design_subtree!(
        source_root,
        designex_rel,
        Path.join([install_dir, "assets", "corex", "design"])
      )
    end
  end

  defp resolve_design_source(opts, install_dir) do
    checkout =
      case Keyword.get(opts, :dev) do
        path when is_binary(path) ->
          trimmed = String.trim(path)

          if trimmed != "" do
            abs = Path.expand(trimmed, install_dir)
            priv_root = Path.join(abs, "priv")
            corex_src = Path.join([priv_root, "design", "corex"])

            if File.dir?(corex_src) do
              {:checkout_priv, priv_root}
            else
              nil
            end
          else
            nil
          end

        _ ->
          nil
      end

    cond do
      match?({:checkout_priv, _}, checkout) ->
        checkout

      File.dir?(Path.join(bundled_design_root(), "corex")) ->
        {:bundled, bundled_design_root()}

      true ->
        :missing
    end
  end

  defp rm_assets_corex_design_if_present!(install_dir) do
    nested = Path.join([install_dir, "assets", "corex", "design"])

    if File.exists?(nested) do
      File.rm_rf!(nested)
    end
  end

  defp copy_design_subtree!(base, rel_segments, dest) do
    src = Path.join([base | rel_segments])

    unless File.dir?(src) do
      Mix.raise("Expected Corex design tree at #{src}")
    end

    File.mkdir_p!(Path.dirname(dest))
    File.cp_r!(src, dest)
  end

  defp write_design_version!(dest) do
    version =
      case Mix.Project.config()[:version] do
        nil -> "0.1.0"
        v -> to_string(v)
      end

    File.write!(Path.join(dest, "VERSION"), version <> "\n")
  end

  defp template_assigns(install_dir, opts) do
    [
      web_module: inspect(opts[:web_module]),
      app_module: inspect(opts[:app_module]),
      otp_app: opts[:otp_app],
      mode: !!opts[:mode],
      theme: !!opts[:theme],
      lang: !!opts[:lang],
      design: !!opts[:design],
      tailwind: Keyword.get(opts, :tailwind, true),
      themes: opts[:themes],
      default_theme: opts[:default_theme],
      corex_js_import: corex_js_import(install_dir, opts)
    ]
  end

  defp corex_js_import(install_dir, opts) do
    case Keyword.get(opts, :dev) do
      path when is_binary(path) ->
        trimmed = String.trim(path)

        if trimmed != "" do
          corex_root = Path.expand(trimmed, install_dir)
          mjs = Path.join([corex_root, "priv", "static", "corex.mjs"])

          unless File.exists?(mjs) do
            Mix.raise("""
            Expected Corex bundle at #{mjs}.

            From the Corex checkout run:

                mix assets.build

            Then re-run corex.new with --dev.
            """)
          end

          js_dir = Path.join([install_dir, "assets", "js"])
          relative_import_from(js_dir, mjs)
        else
          "corex"
        end

      _ ->
        "corex"
    end
  end

  defp relative_import_from(js_dir, target_file) do
    js_dir = Path.expand(js_dir)
    target_file = Path.expand(target_file)

    from_parts = Path.split(js_dir)
    to_parts = Path.split(target_file)

    {from_rest, to_rest} = drop_common_prefix(from_parts, to_parts)

    ups = List.duplicate("..", length(from_rest))
    rel = Path.join(ups ++ to_rest) |> String.replace("\\", "/")

    resolved = Path.expand(Path.join(js_dir, rel))

    if resolved != target_file do
      Mix.raise(
        "Could not resolve a relative import path from #{js_dir} to #{target_file}. Use paths on the same filesystem root."
      )
    end

    rel
  end

  defp drop_common_prefix([h | ta], [h | tb]), do: drop_common_prefix(ta, tb)
  defp drop_common_prefix(a, b), do: {a, b}

  defp web_underscore(opts), do: Atom.to_string(Keyword.fetch!(opts, :otp_app)) <> "_web"

  defp write!(path, contents) do
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, contents)
  end

  def bundled_gettext_catalog_root do
    case archive_priv_gettext_root() do
      nil -> Path.expand("../../priv/gettext", __DIR__)
      path -> path
    end
  end

  defp archive_priv_gettext_root do
    case :code.which(Corex.New.Generate) do
      :non_existing ->
        nil

      :cover_compiled ->
        nil

      beam ->
        beam = beam_path_to_string(beam)

        root =
          beam
          |> Path.dirname()
          |> Path.join("../priv/gettext")
          |> Path.expand()

        if File.exists?(Path.join(root, "default.pot")), do: root, else: nil
    end
  end

  defp copy_gettext_catalog(install_dir) do
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
    File.cp_r!(src, dest)
  end
end
