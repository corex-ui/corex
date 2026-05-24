defmodule Corex.New.Patches do
  @moduledoc false

  @doc """
  Adds `{:corex, ...}` (and `{:localize_web, "~> 0.5"}` when `--lang`)
  to the `deps/0` list in `mix.exs`. When `--lang` and Erlang `:json` is not
  loaded, adds `{:json_polyfill, ...}` like `localize_web`. Idempotent.
  """
  def patch_mix_exs(install_dir, opts) do
    path = Path.join(install_dir, "mix.exs")
    content = File.read!(path)

    updated =
      content
      |> ensure_corex_dep(opts)
      |> maybe_ensure_localize_web_dep(opts)
      |> maybe_ensure_designex_dep(opts)
      |> maybe_add_designex_aliases(opts)
      |> maybe_ensure_json_polyfill_dep(opts)

    write_if_changed!(path, content, updated)
  end

  @doc """
  Inserts `use Corex` inside the `html_helpers/0` quote block of `<app>_web.ex`.
  When `:lang` is true, also adds `path_prefixes` on `Phoenix.VerifiedRoutes`. Idempotent.
  """
  def patch_web_module(install_dir, web_module, opts \\ []) do
    path = web_module_path(install_dir, web_module, opts)
    content = File.read!(path)

    updated =
      content
      |> ensure_use_corex_in_html_helpers()
      |> maybe_patch_verified_routes_for_lang(web_module, opts)

    write_if_changed!(path, content, updated)
  end

  @doc """
  When `:lang` is true, inserts `on_mount Web.Hooks.Layout` on the line after the first bare `use Phoenix.LiveView`.
  Normalizes `use Phoenix.LiveView, on_mount: [Web.Hooks.Layout]` to that shape. Idempotent.
  """
  def patch_live_view_for_lang(install_dir, web_module, opts) do
    if Keyword.get(opts, :lang, false) do
      path = web_module_path(install_dir, web_module, opts)
      content = File.read!(path)
      updated = maybe_insert_hooks_layout_on_mount(content, web_module)
      write_if_changed!(path, content, updated)
    else
      :ok
    end
  end

  @doc """
  Adds `path_prefixes: [{Web.Locale, :current, []}]` to `Phoenix.VerifiedRoutes` in
  `<web_module>.ex`. Idempotent. Raises when the patch cannot be applied.
  """
  def patch_verified_routes_path_prefixes!(install_dir, web_module, opts) do
    if Keyword.get(opts, :lang, false) do
      path = web_module_path(install_dir, web_module, opts)
      content = File.read!(path)
      web_str = inspect(web_module)
      needle = "path_prefixes: [{#{web_str}.Locale, :current, []}]"

      if String.contains?(content, needle) do
        :ok
      else
        updated = maybe_insert_verified_routes_path_prefixes(content, web_module)

        if updated == content do
          Mix.raise("""
          Could not add path_prefixes to #{path}.

          Expected a verified_routes/0 block with statics: #{web_str}.static_paths().
          Re-run after updating corex_new: cd corex/installer && mix local.corex --force
          """)
        else
          Mix.shell().info([
            :green,
            "* adding path_prefixes to ",
            :reset,
            Path.relative_to_cwd(path)
          ])

          File.write!(path, updated)
          :ok
        end
      end
    else
      :ok
    end
  end

  defp maybe_patch_verified_routes_for_lang(content, web_module, opts) do
    if Keyword.get(opts, :lang, false) do
      maybe_insert_verified_routes_path_prefixes(content, web_module)
    else
      content
    end
  end

  @doc """
  Inserts Corex plugs into the `:browser` pipeline in `router.ex`,
  plus (when lang?) `use Localize.Routes` and a locale scope. Idempotent.
  """
  def patch_router(install_dir, web_module, opts) do
    path = router_path(install_dir, web_module, opts)
    content = File.read!(path)

    updated =
      content
      |> maybe_insert_localize_routes_use(web_module, opts)
      |> maybe_insert_localize_plugs(web_module, opts)
      |> maybe_insert_mode_plug(web_module, opts)
      |> maybe_insert_theme_plug(web_module, opts)
      |> maybe_duplicate_locale_scope(web_module, opts)

    write_if_changed!(path, content, updated)
  end

  @doc """
  After the first `plug Plug.Static`, inserts `plug Corex.MCP` in `:dev` / `:test` when `:mcp` is true.
  Idempotent.
  """
  def patch_endpoint(install_dir, web_module, opts) do
    path = endpoint_path(install_dir, web_module, opts)
    content = File.read!(path)
    updated = maybe_insert_corex_mcp_plug(content, opts)
    write_if_changed!(path, content, updated)
  end

  @doc """
  Ensures `config/config.exs` has:
    * `config :<otp_app>, themes: [...]` when `--theme`
    * `config :localize, default_locale: :en, supported_locales: [...]` when `--lang`
    * `config :designex, ...` when `--designex`
    * esbuild args contain `--format=esm --splitting --target=es2022`
      and `--outdir=../priv/static/assets/js`.
  Idempotent.
  """
  def patch_config_exs(install_dir, opts) do
    path = Path.join([install_dir, "config", "config.exs"])
    content = File.read!(path)

    updated =
      content
      |> maybe_add_themes_to_app_config(opts)
      |> maybe_add_localize_config(opts)
      |> maybe_add_designex_config(opts)
      |> patch_esbuild_for_esm()

    write_if_changed!(path, content, updated)
  end

  @doc """
  Sets `locales: ~w(en ar)` on the `Gettext.Backend` use options when `--lang` is on.
  Idempotent.
  """
  def patch_gettext_backend(install_dir, web_module, opts) do
    if Keyword.get(opts, :lang, false) do
      path = Path.join([install_dir, "lib", underscore(web_module), "gettext.ex"])

      if File.exists?(path) do
        content = File.read!(path)
        updated = inject_locales_into_gettext_backend(content)
        write_if_changed!(path, content, updated)
      end
    end

    :ok
  end

  def patch_page_controller_test(install_dir, web_module) do
    path =
      Path.join([
        install_dir,
        "test",
        underscore(web_module),
        "controllers",
        "page_controller_test.exs"
      ])

    if File.exists?(path) do
      content = File.read!(path)
      old = "Peace of mind from prototype to production"
      new = "Corex for Phoenix"

      updated =
        if String.contains?(content, old), do: String.replace(content, old, new), else: content

      write_if_changed!(path, content, updated)
    end

    :ok
  end

  defp ensure_corex_dep(content, opts) do
    if Regex.match?(~r/\{:corex\s*,/u, content) do
      content
    else
      insert_before_closing_deps(content, "      {:corex, #{corex_dep_source(opts)}},\n")
    end
  end

  defp maybe_ensure_localize_web_dep(content, opts) do
    if Keyword.get(opts, :lang, false) do
      if Regex.match?(~r/\{:localize_web\s*,/u, content) do
        content
      else
        insert_before_closing_deps(content, "      {:localize_web, \"~> 0.5\"},\n")
      end
    else
      content
    end
  end

  defp maybe_ensure_designex_dep(content, opts) do
    if Keyword.get(opts, :designex, false) do
      if Regex.match?(~r/\{:designex\s*,/u, content) do
        content
      else
        insert_before_closing_deps(
          content,
          "      {:designex, \"~> 1.0\", runtime: Mix.env() == :dev},\n"
        )
      end
    else
      content
    end
  end

  defp maybe_ensure_json_polyfill_dep(content, opts) do
    if not Keyword.get(opts, :lang, false) do
      content
    else
      cond do
        Regex.match?(~r/\{:json_polyfill\s*,/u, content) ->
          content

        Code.ensure_loaded?(:json) ->
          content

        true ->
          insert_before_closing_deps(
            content,
            "      {:json_polyfill, \"~> 0.2 or ~> 1.0\"},\n"
          )
      end
    end
  end

  defp maybe_add_designex_aliases(content, opts) do
    if not Keyword.get(opts, :designex, false) do
      content
    else
      if not String.contains?(content, "\"assets.build\"") do
        Mix.shell().info([
          :yellow,
          "! ",
          :reset,
          "Could not locate assets.build alias in mix.exs. Add \"designex corex\" to assets.build and assets.deploy manually."
        ])

        content
      else
        content
        |> insert_designex_into_assets_build()
        |> insert_designex_into_assets_deploy()
      end
    end
  end

  defp insert_designex_into_assets_build(content) do
    if Regex.match?(
         ~r/"assets\.build":\s*\[[\s\S]*?"compile"[\s\S]*?"designex corex"/u,
         content
       ) do
      content
    else
      replaced =
        Regex.replace(
          ~r/("assets\.build":\s*\[\s*"compile")\s*,/u,
          content,
          "\\1, \"designex corex\",",
          global: false
        )

      if replaced == content do
        Regex.replace(
          ~r/("assets\.build":\s*\[\s*\n\s*"compile")\s*,/u,
          content,
          "\\1,\n        \"designex corex\",",
          global: false
        )
      else
        replaced
      end
    end
  end

  defp insert_designex_into_assets_deploy(content) do
    if Regex.match?(
         ~r/"assets\.deploy":\s*\[[\s\S]*?"designex corex"/u,
         content
       ) do
      content
    else
      content
      |> insert_designex_deploy_after_compile()
      |> insert_designex_deploy_before_tailwind_or_esbuild()
    end
  end

  defp insert_designex_deploy_after_compile(content) do
    if Regex.match?(
         ~r/"assets\.deploy":\s*\[[\s\S]*?"compile"[\s\S]*?"designex corex"/u,
         content
       ) do
      content
    else
      replaced =
        Regex.replace(
          ~r/("assets\.deploy":\s*\[\s*"compile")\s*,\s*(?!\"designex corex")/u,
          content,
          "\\1, \"designex corex\", ",
          global: false
        )

      if replaced != content do
        replaced
      else
        Regex.replace(
          ~r/("assets\.deploy":\s*\[\s*\n\s*"compile")\s*,(\s*\n)(\s*)("(?:tailwind|esbuild))/u,
          content,
          "\\1,\\2\\3\"designex corex\",\\2\\3\\4",
          global: false
        )
      end
    end
  end

  defp insert_designex_deploy_before_tailwind_or_esbuild(content) do
    if Regex.match?(
         ~r/"assets\.deploy":\s*\[[\s\S]*?"designex corex"/u,
         content
       ) do
      content
    else
      replaced =
        Regex.replace(
          ~r/("assets\.deploy":\s*\[\s*\n)(\s*)("(?:tailwind|esbuild))/u,
          content,
          "\\1\\2\"designex corex\",\n\\2\\3",
          global: false
        )

      if replaced != content do
        replaced
      else
        Regex.replace(
          ~r/("assets\.deploy":\s*\[\s*)("(?:tailwind|esbuild))/u,
          content,
          "\\1\"designex corex\", \\2",
          global: false
        )
      end
    end
  end

  defp maybe_add_designex_config(content, opts) do
    cond do
      not Keyword.get(opts, :designex, false) ->
        content

      String.contains?(content, "config :designex") ->
        content

      true ->
        block = """
        config :designex,
          version: "1.0.2",
          commit: "1da4b31",
          cd: Path.expand("../assets", __DIR__),
          dir: "corex",
          corex: [
            build_args: ~W(--dir=design --script=build.mjs --tokens=tokens)
          ]

        """

        marker = "import_config \"#{"#"}{config_env()}.exs\""

        if String.contains?(content, marker) do
          String.replace(content, marker, String.trim_trailing(block) <> "\n" <> marker,
            global: false
          )
        else
          String.trim_trailing(content) <> "\n\n" <> String.trim_trailing(block) <> "\n"
        end
    end
  end

  defp corex_dep_source(opts) do
    case Keyword.get(opts, :dev) do
      path when is_binary(path) ->
        trimmed = String.trim(path)

        if trimmed != "" do
          ~s([path: "#{trimmed}", override: true])
        else
          corex_dep_constraint()
        end

      _ ->
        corex_dep_constraint()
    end
  end

  defp corex_dep_constraint do
    version = Mix.Project.config()[:version] || "0.1.0"
    "\"~> #{version}\""
  end

  defp insert_before_closing_deps(content, extra_line) do
    case Regex.run(
           ~r/defp\s+deps\s+do\s*\[[\s\S]*?(\n\s*\])\s*\n\s*end/u,
           content,
           return: :index
         ) do
      [{_full_s, _full_l}, {insert_s, _insert_l}] ->
        before = binary_part(content, 0, insert_s)
        rest = binary_part(content, insert_s, byte_size(content) - insert_s)
        before_with_comma = ensure_trailing_comma(before)
        before_with_comma <> "\n" <> extra_line <> String.trim_leading(rest, "\n")

      _ ->
        Mix.shell().info([
          :yellow,
          "! ",
          :reset,
          "Could not locate `defp deps do [ ... ]` in mix.exs. Add the Corex dependency manually."
        ])

        content
    end
  end

  defp ensure_trailing_comma(before) do
    trimmed = String.trim_trailing(before)

    cond do
      trimmed == "" -> before
      String.ends_with?(trimmed, ",") -> before
      String.ends_with?(trimmed, "[") -> before
      true -> trimmed <> "," <> String.slice(before, String.length(trimmed)..-1//1)
    end
  end

  defp maybe_insert_hooks_layout_on_mount(content, web_module) do
    hook_mod = Module.concat([web_module, :Hooks, :Layout])
    mod_txt = inspect(hook_mod)
    standalone = "on_mount #{mod_txt}"

    content =
      Regex.replace(
        ~r/^(\s*)use Phoenix\.LiveView,\s*on_mount:\s*\[\s*#{Regex.escape(mod_txt)}\s*\]\s*$/m,
        content,
        "\\1use Phoenix.LiveView\n\\1#{standalone}",
        global: false
      )

    if String.contains?(content, standalone) do
      content
    else
      Regex.replace(
        ~r/^(\s*)use Phoenix\.LiveView\s*$/m,
        content,
        "\\1use Phoenix.LiveView\n\\1#{standalone}",
        global: false
      )
    end
  end

  defp ensure_use_corex_in_html_helpers(content) do
    if Regex.match?(~r/^\s*use\s+Corex\b/m, content) do
      content
    else
      Regex.replace(
        ~r/(defp\s+html_helpers\s+do\s*\n\s*quote\s+do\s*\n)/u,
        content,
        "\\1      use Corex\n",
        global: false
      )
    end
  end

  defp maybe_insert_localize_routes_use(content, web_module, opts) do
    if Keyword.get(opts, :lang, false) and not String.contains?(content, "use Localize.Routes") do
      router_use = "use " <> inspect(web_module) <> ", :router"

      content
      |> String.replace(
        router_use <> "\n",
        router_use <>
          "\n\n  use Localize.Routes, gettext: " <>
          inspect(web_module) <> ".Gettext, helpers: false\n",
        global: false
      )
    else
      content
    end
  end

  defp maybe_insert_localize_plugs(content, web_module, opts) do
    if Keyword.get(opts, :lang, false) and
         not String.contains?(content, "Localize.Plug.PutLocale") do
      plugs = """

          plug Localize.Plug.PutLocale,
            from: [:path, :session, :accept_language],
            gettext: #{inspect(web_module)}.Gettext

          plug Localize.Plug.PutSession, as: :string
      """

      insert_after_fetch_live_flash(content, plugs)
    else
      content
    end
  end

  defp maybe_insert_mode_plug(content, web_module, opts) do
    line = "    plug " <> inspect(web_module) <> ".Plugs.Mode\n"

    cond do
      not Keyword.get(opts, :mode, false) -> content
      String.contains?(content, String.trim_trailing(line)) -> content
      true -> insert_after_localize_or_flash(content, line)
    end
  end

  defp maybe_insert_theme_plug(content, web_module, opts) do
    line = "    plug " <> inspect(web_module) <> ".Plugs.Theme\n"

    cond do
      not Keyword.get(opts, :theme, false) -> content
      String.contains?(content, String.trim_trailing(line)) -> content
      true -> insert_after_localize_or_flash(content, line)
    end
  end

  defp insert_after_fetch_live_flash(content, addition) do
    Regex.replace(
      ~r/(plug :fetch_live_flash\s*\n)/u,
      content,
      "\\1" <> addition,
      global: false
    )
  end

  defp insert_after_localize_or_flash(content, addition) do
    cond do
      Regex.match?(~r/plug Localize\.Plug\.PutSession[^\n]*\n/u, content) ->
        Regex.replace(
          ~r/(plug Localize\.Plug\.PutSession[^\n]*\n)/u,
          content,
          "\\1" <> addition,
          global: false
        )

      true ->
        insert_after_fetch_live_flash(content, addition)
    end
  end

  defp maybe_duplicate_locale_scope(content, web_module, opts) do
    if Keyword.get(opts, :lang, false) and not Regex.match?(~r/scope\s+"\/:locale"/u, content) do
      web_str = inspect(web_module)

      pattern =
        ~r/scope\s+"\/",\s+#{Regex.escape(web_str)}\s+do\s*\n\s*pipe_through\s+:browser\s*\n[\s\S]*?\n\s*end/u

      case Regex.run(pattern, content) do
        [full] ->
          locale_scope =
            String.replace(full, ~S(scope "/"), ~S(scope "/:locale"), global: false)

          String.replace(content, full, full <> "\n\n  " <> locale_scope, global: false)

        _ ->
          content
      end
    else
      content
    end
  end

  defp maybe_add_themes_to_app_config(content, opts) do
    otp_app = Keyword.fetch!(opts, :otp_app)

    cond do
      not Keyword.get(opts, :theme, false) ->
        content

      String.contains?(content, "themes:") ->
        content

      true ->
        themes = Keyword.get(opts, :themes, ["neo"])
        themes_inline = "[" <> Enum.map_join(themes, ", ", &inspect/1) <> "]"

        app_config_regex =
          ~r/config :#{Regex.escape(to_string(otp_app))}\s*,[^\n]*\n(?:\s*[a-z_]+:[^\n]*\n)+/u

        case Regex.run(app_config_regex, content) do
          [block] ->
            replacement = String.trim_trailing(block, "\n") <> ",\n  themes: #{themes_inline}\n"

            String.replace(content, block, replacement, global: false)

          _ ->
            content
        end
    end
  end

  defp maybe_add_localize_config(content, opts) do
    cond do
      not Keyword.get(opts, :lang, false) ->
        content

      String.contains?(content, "config :localize") ->
        content

      true ->
        block = "\nconfig :localize,\n  default_locale: :en,\n  supported_locales: [:en, :ar]\n"
        marker = "import_config \"#{"#"}{config_env()}.exs\""

        if String.contains?(content, marker) do
          String.replace(content, marker, String.trim_leading(block) <> "\n" <> marker,
            global: false
          )
        else
          content <> block
        end
    end
  end

  defp patch_esbuild_for_esm(content) do
    cond do
      String.contains?(content, "--format=esm") ->
        content

      String.contains?(content, "js/app.js --bundle") ->
        replacement =
          if String.contains?(content, "--target=es2022") do
            "\\1 --bundle --format=esm --splitting"
          else
            "\\1 --bundle --format=esm --splitting --target=es2022"
          end

        replaced =
          Regex.replace(
            ~r/(js\/app\.js)\s+--bundle/u,
            content,
            replacement,
            global: false
          )

        patch_esbuild_outdir(replaced)

      true ->
        content
    end
  end

  defp patch_esbuild_outdir(content) do
    cond do
      String.contains?(content, "--outdir=../priv/static/assets/js") ->
        content

      match = Regex.run(~r/--outdir=\.\.\/priv\/static\/assets(?!\/js)/u, content) ->
        [old] = match
        String.replace(content, old, "--outdir=../priv/static/assets/js", global: false)

      true ->
        content
    end
  end

  defp inject_locales_into_gettext_backend(content) do
    cond do
      Regex.match?(~r/\blocales:\s*~w\(/m, content) ->
        content

      Regex.match?(~r/use\s+Gettext\.Backend\b/m, content) ->
        Regex.replace(
          ~r/(use\s+Gettext\.Backend\s*,\s*[\s\S]*?default_locale:\s*"[^"]+")/m,
          content,
          "\\1,\n    locales: ~w(en ar)",
          global: false
        )

      true ->
        content
    end
  end

  defp write_if_changed!(_path, old, new) when old == new, do: :ok

  defp write_if_changed!(path, _old, new) do
    File.write!(path, new)
    :ok
  end

  defp maybe_insert_verified_routes_path_prefixes(content, web_module) do
    web_str = inspect(web_module)
    needle = "path_prefixes: [{#{web_str}.Locale, :current, []}]"

    if String.contains?(content, needle) do
      content
    else
      statics = "statics: #{web_str}.static_paths()"
      suffix = ",\n        path_prefixes: [{#{web_str}.Locale, :current, []}]"

      updated =
        if String.contains?(content, statics) do
          String.replace(content, statics, statics <> suffix, global: false)
        else
          content
        end

      if updated != content do
        updated
      else
        insertion = ",\n          path_prefixes: [{#{web_str}.Locale, :current, []}]"

        regex_updated =
          Regex.replace(
            ~r/(statics:\s+#{Regex.escape(web_str)}\.static_paths\(\))(\s*\n\s*end)/u,
            content,
            "\\1#{insertion}\\2",
            global: false
          )

        if regex_updated != content do
          regex_updated
        else
          replace_verified_routes_def(content, web_module)
        end
      end
    end
  end

  defp web_lib_dir(web_module, opts) do
    case Keyword.fetch(opts, :otp_app) do
      {:ok, app} -> Atom.to_string(app) <> "_web"
      :error -> web_module |> inspect() |> Macro.underscore()
    end
  end

  defp replace_verified_routes_def(content, web_module) do
    web_str = inspect(web_module)

    verified_routes_def = """
      def verified_routes do
        quote do
          use Phoenix.VerifiedRoutes,
            endpoint: #{web_str}.Endpoint,
            router: #{web_str}.Router,
            statics: #{web_str}.static_paths(),
            path_prefixes: [{#{web_str}.Locale, :current, []}]
        end
      end
    """

    pattern =
      ~r/\n  def(?:p)? verified_routes do\n    quote do\n      use Phoenix\.VerifiedRoutes,[\s\S]*?\n    end\n  end/u

    case Regex.run(pattern, content) do
      [_match] -> Regex.replace(pattern, content, "\n" <> verified_routes_def)
      _ -> content
    end
  end

  defp web_module_path(install_dir, web_module, opts) do
    Path.join([install_dir, "lib", web_lib_dir(web_module, opts) <> ".ex"])
  end

  defp router_path(install_dir, web_module, opts) do
    Path.join([install_dir, "lib", web_lib_dir(web_module, opts), "router.ex"])
  end

  defp endpoint_path(install_dir, web_module, opts) do
    Path.join([install_dir, "lib", web_lib_dir(web_module, opts), "endpoint.ex"])
  end

  defp maybe_insert_corex_mcp_plug(content, opts) do
    if Keyword.get(opts, :mcp, true) == false do
      content
    else
      if String.contains?(content, "plug Corex.MCP") do
        content
      else
        insertion = "\n  if Mix.env() in [:dev, :test] do\n    plug Corex.MCP\n  end"

        replaced =
          String.replace(
            content,
            ~r/(  plug Plug\.Static,\n(?:    [^\n]+\n)+)/u,
            "\\1#{insertion}\n",
            global: false
          )

        if replaced == content do
          content
        else
          replaced
        end
      end
    end
  end

  defp underscore(atom_or_mod) when is_atom(atom_or_mod),
    do: atom_or_mod |> inspect() |> Macro.underscore()

  defp underscore(str) when is_binary(str), do: Macro.underscore(str)
end
