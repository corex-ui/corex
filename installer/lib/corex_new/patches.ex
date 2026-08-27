defmodule Corex.New.Patches do
  @moduledoc false

  alias Corex.New.Shared

  @spec patch_failed!(String.t(), String.t(), String.t()) :: no_return()
  defp patch_failed!(what, path, expected) do
    Mix.raise("""
    Corex could not #{what} in #{Path.relative_to_cwd(path)}.

    Expected to find #{expected}.

    The generator output does not match what this version of corex_new knows how
    to patch. Update the archive and generate again:

        mix archive.install hex corex_new --force

    If the problem persists, open an issue at https://github.com/corex-ui/corex/issues
    with your Phoenix and corex_new versions.
    """)
  end

  @doc """
  Adds `{:corex, ...}` (and `{:localize_web, "~> 0.5"}` when `--lang`)
  to the `deps/0` list in `mix.exs`.
  When `--mcp`, adds `{:corex_mcp, ..., only: [:dev, :test]}`.
  When `--usage-rules` (default), adds `{:usage_rules, "~> 1.1", only: :dev}`
  and `usage_rules: usage_rules()` in `project/0`.
  When `--design`, adds `{:corex_design, ..., runtime: false}` and
  `corex.design.build` to `assets.build` / `assets.deploy`.
  Idempotent.
  """
  def patch_mix_exs(install_dir, opts) do
    path = Path.join(install_dir, "mix.exs")
    content = File.read!(path)

    updated =
      content
      |> ensure_corex_dep(opts)
      |> maybe_ensure_localize_web_dep(opts)
      |> maybe_ensure_gettext_sigils_dep(opts)
      |> maybe_ensure_design_dep(opts)
      |> maybe_ensure_mcp_dep(opts)
      |> maybe_ensure_usage_rules_dep(opts)
      |> maybe_add_design_aliases(opts)
      |> maybe_ensure_usage_rules_project(opts)
      |> strip_daisyui_dep()

    write_if_changed!(path, content, updated)
    Shared.format_elixir_source!(path)
  end

  def remove_daisyui_vendor!(install_dir) do
    for name <- ["daisyui.js", "daisyui-theme.js"] do
      path = Path.join([install_dir, "assets", "vendor", name])

      if File.exists?(path) do
        Mix.shell().info([:green, "* removing ", :reset, Path.relative_to_cwd(path)])
        File.rm!(path)
      end
    end

    :ok
  end

  @doc """
  Rewrites AGENTS.md daisyUI guidance to Corex Design / corex.gen. Idempotent.
  """
  def patch_agents_md(install_dir) do
    path = Path.join(install_dir, "AGENTS.md")

    if File.exists?(path) do
      content = File.read!(path)
      updated = rewrite_agents_daisy_guidance(content)
      write_if_changed!(path, content, updated)
    else
      :ok
    end
  end

  @doc """
  Deletes Phoenix `core_components.ex` when present. Idempotent.
  """
  def remove_core_components!(install_dir, web_module, opts \\ []) do
    path =
      Path.join([
        install_dir,
        "lib",
        web_lib_dir(web_module, opts),
        "components",
        "core_components.ex"
      ])

    if File.exists?(path) do
      Mix.shell().info([:green, "* removing ", :reset, Path.relative_to_cwd(path)])
      File.rm!(path)
    end

    :ok
  end

  @doc """
  Inserts `use Corex` inside the `html_helpers/0` quote block of `<app>_web.ex`,
  removes `import <Web>.CoreComponents`, and when `:lang` is true adds
  `path_prefixes` on `Phoenix.VerifiedRoutes`. Idempotent.
  """
  def patch_web_module(install_dir, web_module, opts \\ []) do
    path = web_module_path(install_dir, web_module, opts)
    content = File.read!(path)

    updated =
      content
      |> ensure_use_corex_in_html_helpers(path)
      |> remove_core_components_import(web_module)
      |> maybe_patch_verified_routes_for_lang(web_module, opts)

    write_if_changed!(path, content, updated)
  end

  @doc """
  When `:lang` or `:a11y` is true, inserts matching `on_mount` hooks after the first bare
  `use Phoenix.LiveView`. Idempotent.
  """
  def patch_live_view_hooks(install_dir, web_module, opts) do
    if Keyword.get(opts, :lang, false) or Keyword.get(opts, :a11y, false) do
      path = web_module_path(install_dir, web_module, opts)
      content = File.read!(path)

      updated =
        content
        |> maybe_insert_on_mount(web_module, :Hooks, :Layout, opts[:lang])
        |> maybe_insert_on_mount(web_module, :Hooks, :Accessibility, opts[:a11y])

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
      |> maybe_insert_localize_plugs(web_module, opts, path)
      |> maybe_insert_mode_plug(web_module, opts, path)
      |> maybe_insert_theme_plug(web_module, opts, path)
      |> maybe_insert_accessibility_plug(web_module, opts, path)
      |> maybe_duplicate_locale_scope(web_module, opts)
      |> normalize_router_whitespace()

    # Match phx_new / phx.gen.auth: inject plugs without Code.format_string!,
    # which would add parentheses and fail the app's Phoenix formatter check.
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
  Writes `.cursor/mcp.json` when `:mcp` is true. Port defaults to `4000` (Phoenix);
  pass `:mcp_port` (e.g. `4004` for Tableau Bandit). Idempotent overwrite.
  """
  def write_cursor_mcp_json!(install_dir, opts) do
    if Keyword.get(opts, :mcp, true) do
      port = Keyword.get(opts, :mcp_port, 4000)
      path = Path.join([install_dir, ".cursor", "mcp.json"])
      url = "http://localhost:#{port}/corex/mcp"

      contents = """
      {
        "mcpServers": {
          "corex": {
            "url": "#{url}"
          }
        }
      }
      """

      Shared.write!(path, contents)
      Mix.shell().info([:green, "* creating ", :reset, Path.relative_to_cwd(path)])
    else
      :ok
    end
  end

  @doc """
  When `:design` is true, ensures `.gitignore` ignores generated Corex Design CSS
  at `/assets/corex/`. Creates `.gitignore` when missing. Idempotent.
  """
  def patch_gitignore(install_dir, opts) do
    if Keyword.get(opts, :design, false) do
      path = Path.join(install_dir, ".gitignore")
      content = if File.exists?(path), do: File.read!(path), else: ""
      updated = ensure_assets_corex_ignored(content)
      write_if_changed!(path, content, updated)
    else
      :ok
    end
  end

  @doc """
  Ensures `config/config.exs` has:
    * `config :<otp_app>, themes: [...]` when `--theme`
    * `config :localize, default_locale: :en, supported_locales: [...]` when `--lang`
    * `config :corex_design` when `--design`
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
      |> maybe_add_corex_generators_config(opts)
      |> maybe_add_design_config(opts)
      |> patch_esbuild_for_esm(path)
      |> patch_env_path_lists()

    write_if_changed!(path, content, updated)
    Shared.format_elixir_source!(path)
  end

  @doc """
  In `html_helpers`, replaces `use Gettext, backend: ...` with `use GettextSigils, backend: ...`
  when `--lang` is on. Idempotent.
  """
  def patch_web_gettext_sigils(install_dir, web_module, opts) do
    if Keyword.get(opts, :lang, false) do
      path = web_module_path(install_dir, web_module, opts)
      content = File.read!(path)
      updated = replace_gettext_with_sigils(content, web_module)
      write_if_changed!(path, content, updated)
    else
      :ok
    end
  end

  @doc """
  Sets `locales: ~w(en fr ar)` on the `Gettext.Backend` use options when `--lang` is on.
  Idempotent.
  """
  def patch_gettext_backend(install_dir, web_module, opts) do
    if Keyword.get(opts, :lang, false) do
      path = Path.join([install_dir, "lib", underscore(web_module), "gettext.ex"])

      if File.exists?(path) do
        content = File.read!(path)
        updated = inject_locales_into_gettext_backend(content)
        write_if_changed!(path, content, updated)
        Shared.format_elixir_source!(path)
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
      new = "The Phoenix UI"

      updated =
        if String.contains?(content, old), do: String.replace(content, old, new), else: content

      write_if_changed!(path, content, updated)
    end

    :ok
  end

  @doc """
  When `--lang` installs a custom `404.html.heex`, update the stock ErrorHTML test
  to assert on the page heading instead of the plain status message. Idempotent.
  """
  def patch_error_html_test(install_dir, web_module, opts) do
    if Keyword.get(opts, :lang, false) do
      path =
        Path.join([
          install_dir,
          "test",
          underscore(web_module),
          "controllers",
          "error_html_test.exs"
        ])

      if File.exists?(path) do
        content = File.read!(path)

        updated =
          Regex.replace(
            ~r/assert render_to_string\(([\w.]+)\.ErrorHTML, "404", "html", \[\]\) == "Not Found"/,
            content,
            fn _, mod ->
              ~s|assert render_to_string(#{mod}.ErrorHTML, "404", "html", []) =~ "Page not found"|
            end
          )

        write_if_changed!(path, content, updated)
        Shared.format_elixir_source!(path)
      end
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

  defp maybe_ensure_gettext_sigils_dep(content, opts) do
    if Keyword.get(opts, :lang, false) do
      if Regex.match?(~r/\{:gettext_sigils\s*,/u, content) do
        content
      else
        insert_before_closing_deps(content, "      {:gettext_sigils, \"~> 0.5\"},\n")
      end
    else
      content
    end
  end

  defp maybe_ensure_design_dep(content, opts) do
    if Keyword.get(opts, :design, false) do
      if Regex.match?(~r/\{:corex_design\s*,/u, content) do
        content
      else
        insert_before_closing_deps(
          content,
          "      {:corex_design, #{corex_design_dep_source(opts)}},\n"
        )
      end
    else
      content
    end
  end

  defp maybe_ensure_mcp_dep(content, opts) do
    if Keyword.get(opts, :mcp, true) == false do
      content
    else
      if Regex.match?(~r/\{:corex_mcp\s*,/u, content) do
        content
      else
        insert_before_closing_deps(
          content,
          "      {:corex_mcp, #{corex_mcp_dep_source(opts)}},\n"
        )
      end
    end
  end

  defp maybe_ensure_usage_rules_dep(content, opts) do
    if Keyword.get(opts, :usage_rules, true) == false do
      content
    else
      if Regex.match?(~r/\{:usage_rules\s*,/u, content) do
        content
      else
        insert_before_closing_deps(
          content,
          "      {:usage_rules, \"~> 1.1\", only: :dev}\n"
        )
      end
    end
  end

  defp maybe_ensure_usage_rules_project(content, opts) do
    if Keyword.get(opts, :usage_rules, true) == false do
      content
    else
      content
      |> ensure_usage_rules_project_key()
      |> ensure_usage_rules_helper()
    end
  end

  defp ensure_usage_rules_project_key(content) do
    cond do
      Regex.match?(~r/\busage_rules:\s*usage_rules\(\)/u, content) ->
        content

      Regex.match?(~r/\busage_rules:/u, content) ->
        content

      true ->
        insert_usage_rules_into_project(content)
    end
  end

  defp insert_usage_rules_into_project(content) do
    multiline =
      Regex.replace(
        ~r/(deps:\s*deps\(\))(,?)(\s*\n)/u,
        content,
        fn _, deps, comma, nl ->
          "#{deps}#{if comma == "", do: ",", else: comma}#{nl}      usage_rules: usage_rules(),\n"
        end,
        global: false
      )

    cond do
      multiline != content ->
        multiline

      Regex.match?(~r/deps:\s*deps\(\)\s*\]/u, content) ->
        Regex.replace(
          ~r/(deps:\s*deps\(\))\s*\]/u,
          content,
          "\\1, usage_rules: usage_rules()]",
          global: false
        )

      true ->
        Regex.replace(
          ~r/(def project do\s*\n\s*\[\s*\n)/u,
          content,
          "\\1      usage_rules: usage_rules(),\n",
          global: false
        )
    end
  end

  defp ensure_usage_rules_helper(content) do
    if Regex.match?(~r/defp\s+usage_rules\s+do/u, content) do
      content
    else
      helper = """

        defp usage_rules do
          [
            skills: [
              location: ".cursor/skills",
              package_skills: [:corex]
            ]
          ]
        end
      """

      case Regex.run(~r/\nend\s*\z/u, content, return: :index) do
        [{s, _l}] ->
          before = binary_part(content, 0, s)
          rest = binary_part(content, s, byte_size(content) - s)
          before <> helper <> rest

        nil ->
          String.trim_trailing(content) <> helper <> "\n"
      end
    end
  end

  defp maybe_add_design_aliases(content, opts) do
    if not Keyword.get(opts, :design, false) do
      content
    else
      if not String.contains?(content, "\"assets.build\"") do
        Mix.shell().info([
          :yellow,
          "! ",
          :reset,
          "Could not locate assets.build alias in mix.exs. Add \"corex.design.build\" to assets.build and assets.deploy manually."
        ])

        content
      else
        content
        |> insert_design_into_assets_build()
        |> insert_design_into_assets_deploy()
      end
    end
  end

  defp insert_design_into_assets_build(content) do
    if Regex.match?(
         ~r/"assets\.build":\s*\[[\s\S]*?"compile"[\s\S]*?"corex.design.build"/u,
         content
       ) do
      content
    else
      replaced =
        Regex.replace(
          ~r/("assets\.build":\s*\[\s*"compile")\s*,/u,
          content,
          "\\1, \"corex.design.build\",",
          global: false
        )

      if replaced == content do
        Regex.replace(
          ~r/("assets\.build":\s*\[\s*\n\s*"compile")\s*,/u,
          content,
          "\\1,\n        \"corex.design.build\",",
          global: false
        )
      else
        replaced
      end
    end
  end

  defp insert_design_into_assets_deploy(content) do
    if Regex.match?(
         ~r/"assets\.deploy":\s*\[[\s\S]*?"corex.design.build"/u,
         content
       ) do
      content
    else
      content
      |> insert_design_deploy_after_compile()
      |> insert_design_deploy_before_tailwind_or_esbuild()
    end
  end

  defp insert_design_deploy_after_compile(content) do
    if Regex.match?(
         ~r/"assets\.deploy":\s*\[[\s\S]*?"compile"[\s\S]*?"corex.design.build"/u,
         content
       ) do
      content
    else
      replaced =
        Regex.replace(
          ~r/("assets\.deploy":\s*\[\s*"compile")\s*,\s*(?!\"corex.design.build")/u,
          content,
          "\\1, \"corex.design.build\", ",
          global: false
        )

      if replaced != content do
        replaced
      else
        Regex.replace(
          ~r/("assets\.deploy":\s*\[\s*\n\s*"compile")\s*,(\s*\n)(\s*)("(?:tailwind|esbuild))/u,
          content,
          "\\1,\\2\\3\"corex.design.build\",\\2\\3\\4",
          global: false
        )
      end
    end
  end

  defp insert_design_deploy_before_tailwind_or_esbuild(content) do
    if Regex.match?(
         ~r/"assets\.deploy":\s*\[[\s\S]*?"corex.design.build"/u,
         content
       ) do
      content
    else
      replaced =
        Regex.replace(
          ~r/("assets\.deploy":\s*\[\s*\n)(\s*)("(?:tailwind|esbuild))/u,
          content,
          "\\1\\2\"corex.design.build\",\n\\2\\3",
          global: false
        )

      if replaced != content do
        replaced
      else
        Regex.replace(
          ~r/("assets\.deploy":\s*\[\s*)("(?:tailwind|esbuild))/u,
          content,
          "\\1\"corex.design.build\", \\2",
          global: false
        )
      end
    end
  end

  defp maybe_add_design_config(content, opts) do
    cond do
      not Keyword.get(opts, :design, false) ->
        content

      String.contains?(content, "config :corex_design") ->
        content

      true ->
        themes = Keyword.get(opts, :themes, ["neo"])
        default_theme = Keyword.get(opts, :default_theme, List.first(themes) || "neo")

        themes_inline =
          "[" <> Enum.map_join(themes, ", ", &":#{&1}") <> "]"

        block = """
        config :corex_design,
          output: "assets/corex",
          default_theme: :#{default_theme},
          default_mode: :light,
          themes: #{themes_inline},
          modes: [:light, :dark],
          scales: [],
          components: #{inspect(installer_components(opts))},
          semantics: [:accent, :brand, :alert]#{if Keyword.get(opts, :a11y, false), do: ",\n          accessibility: [:text, :contrast, :motion, :cursor, :focus, :links]", else: ""}

        """

        marker = "import_config \"#{"#"}{config_env()}.exs\""

        if String.contains?(content, marker) do
          String.replace(content, marker, String.trim_trailing(block) <> "\n\n" <> marker,
            global: false
          )
        else
          String.trim_trailing(content) <> "\n\n" <> String.trim_trailing(block) <> "\n"
        end
    end
  end

  defp ensure_assets_corex_ignored(content) do
    if Regex.match?(~r{^/?assets/corex/?$}m, content) do
      content
    else
      entry = "/assets/corex/\n"

      cond do
        content == "" ->
          entry

        String.ends_with?(content, "\n") ->
          content <> "\n" <> entry

        true ->
          content <> "\n\n" <> entry
      end
    end
  end

  defp corex_design_dep_source(opts), do: Shared.corex_design_dep_source(opts)

  defp corex_mcp_dep_source(opts), do: Shared.corex_mcp_dep_source(opts)

  defp installer_components(opts) do
    Corex.New.Components.installer_components(opts)
  end

  defp corex_dep_source(opts), do: Shared.corex_dep_source(opts)

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
        patch_failed!(
          "add a dependency",
          "mix.exs",
          "a `defp deps do [ ... ] end` list. Corex and its companion packages cannot be added without it"
        )
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

  defp maybe_insert_on_mount(content, web_module, namespace, name, true) do
    hook_mod = Module.concat([web_module, namespace, name])
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

  defp maybe_insert_on_mount(content, _web_module, _namespace, _name, _), do: content

  defp ensure_use_corex_in_html_helpers(content, path) do
    cond do
      Regex.match?(~r/^\s*use\s+Corex\b/m, content) ->
        content

      Regex.match?(~r/defp\s+html_helpers\s+do\s*\n\s*quote\s+do\s*\n/u, content) ->
        Regex.replace(
          ~r/(defp\s+html_helpers\s+do\s*\n\s*quote\s+do\s*\n)/u,
          content,
          "\\1      use Corex\n",
          global: false
        )

      true ->
        patch_failed!(
          "add `use Corex`",
          path,
          "a `defp html_helpers do quote do` block. Without it no Corex component is imported into your templates"
        )
    end
  end

  defp remove_core_components_import(content, web_module) do
    web = Regex.escape(inspect(web_module))

    content
    |> String.replace(~r/^\s*#\s*Core UI components\s*\n/m, "")
    |> String.replace(~r/^\s*import\s+#{web}\.CoreComponents\s*\n/m, "")
  end

  defp strip_daisyui_dep(content) do
    Regex.replace(
      ~r/\n[ \t]*\{:daisyui,\n(?:[ \t]+[^\n]+\n)*?[ \t]+[^\n]+\},?/u,
      content,
      "\n"
    )
  end

  defp rewrite_agents_daisy_guidance(content) do
    daisy_bullet =
      "**Always** manually write your own tailwind-based components instead of using daisyUI for a unique, world-class design"

    corex_bullet =
      "**Prefer Corex components and Corex Design tokens** (`use Corex`, `ui-*` modifiers). Scaffold with `mix corex.gen.html` / `mix corex.gen.live` instead of `mix phx.gen.*`"

    cond do
      String.contains?(content, corex_bullet) ->
        content

      String.contains?(content, daisy_bullet) ->
        String.replace(content, daisy_bullet, corex_bullet)

      String.contains?(content, "daisyUI") ->
        String.replace(
          content,
          ~r/^- \*\*Always\*\*.*daisyUI.*$/m,
          "- #{corex_bullet}"
        )

      true ->
        content
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

  defp maybe_insert_localize_plugs(content, web_module, opts, path) do
    if Keyword.get(opts, :lang, false) and
         not String.contains?(content, "Localize.Plug.PutLocale") do
      plugs = """

          plug Localize.Plug.PutLocale,
            from: [:path, :session, :accept_language],
            gettext: #{inspect(web_module)}.Gettext

          plug Localize.Plug.PutSession, as: :string
      """

      insert_after_fetch_live_flash(content, plugs, path, "wire up the Localize plugs")
    else
      content
    end
  end

  defp maybe_insert_mode_plug(content, web_module, opts, path) do
    plug_mod = inspect(web_module) <> ".Plugs.Mode"
    line = "    plug " <> plug_mod <> "\n"

    cond do
      not Keyword.get(opts, :mode, false) ->
        content

      router_plug_present?(content, plug_mod) ->
        content

      true ->
        insert_after_localize_or_flash(content, line, path, "wire up the dark mode plug")
    end
  end

  defp maybe_insert_theme_plug(content, web_module, opts, path) do
    plug_mod = inspect(web_module) <> ".Plugs.Theme"
    line = "    plug " <> plug_mod <> "\n"

    cond do
      not Keyword.get(opts, :theme, false) ->
        content

      router_plug_present?(content, plug_mod) ->
        content

      true ->
        insert_after_localize_or_flash(content, line, path, "wire up the theme plug")
    end
  end

  defp maybe_insert_accessibility_plug(content, web_module, opts, path) do
    plug_mod = inspect(web_module) <> ".Plugs.Accessibility"
    line = "    plug " <> plug_mod <> "\n"

    cond do
      not Keyword.get(opts, :a11y, false) ->
        content

      router_plug_present?(content, plug_mod) ->
        content

      true ->
        insert_after_localize_or_flash(content, line, path, "wire up the accessibility plug")
    end
  end

  # Matches both `plug Mod` and formatter output `plug(Mod)`.
  defp router_plug_present?(content, plug_ref) do
    Regex.match?(~r/plug\s*\(?\s*#{Regex.escape(plug_ref)}\b/u, content)
  end

  # Drop blank lines immediately after `do` (e.g. phx.new --no-dashboard
  # leaves an empty line before `scope "/dev"`). Avoids bare Code.format_string!
  # which parenthesizes plugs and breaks `mix format --check-formatted`.
  defp normalize_router_whitespace(content) do
    Regex.replace(~r/ do\n\n(\s+\S)/u, content, " do\n\\1")
  end

  defp insert_after_fetch_live_flash(content, addition, path, what) do
    if Regex.match?(~r/plug\s*\(?\s*:fetch_live_flash\s*\)?\s*\n/u, content) do
      Regex.replace(
        ~r/(plug\s*\(?\s*:fetch_live_flash\s*\)?\s*\n)/u,
        content,
        "\\1" <> addition,
        global: false
      )
    else
      patch_failed!(what, path, "`plug :fetch_live_flash` in the `:browser` pipeline")
    end
  end

  defp insert_after_localize_or_flash(content, addition, path, what) do
    if Regex.match?(~r/plug\s*\(?\s*Localize\.Plug\.PutSession[^\n]*\n/u, content) do
      Regex.replace(
        ~r/(plug\s*\(?\s*Localize\.Plug\.PutSession[^\n]*\n)/u,
        content,
        "\\1" <> addition,
        global: false
      )
    else
      insert_after_fetch_live_flash(content, addition, path, what)
    end
  end

  defp maybe_duplicate_locale_scope(content, web_module, opts) do
    if Keyword.get(opts, :lang, false) and not Regex.match?(~r/scope\s+"\/:locale"/u, content) do
      web_str = inspect(web_module)

      pattern =
        ~r/scope\s+"\/",\s+#{Regex.escape(web_str)}\s+do\s*\n\s*pipe_through\s*\(?\s*:browser\s*\)?\s*\n[\s\S]*?\n\s*end/u

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

  @generators_layout_keys [
    {:locale, :lang},
    {:mode, :mode},
    {:theme, :theme},
    {:a11y, :a11y}
  ]

  defp maybe_add_corex_generators_config(content, opts) do
    layout =
      for {layout_key, opt_key} <- @generators_layout_keys,
          Keyword.get(opts, opt_key, false),
          do: {layout_key, true}

    gettext_opt =
      if Keyword.get(opts, :lang, false) do
        "gettext: :sigils"
      else
        nil
      end

    cond do
      layout == [] and is_nil(gettext_opt) ->
        content

      String.contains?(content, "config :corex") ->
        content

      true ->
        layout_line =
          if layout == [] do
            ""
          else
            "    layout: #{inspect(layout)},\n"
          end

        gettext_line =
          if gettext_opt do
            "    #{gettext_opt},\n"
          else
            ""
          end

        block = """

        config :corex,
          generators: [
        #{gettext_line}#{layout_line}  ]
        """

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

  defp maybe_add_localize_config(content, opts) do
    content =
      if Keyword.get(opts, :lang, false) do
        content
        |> String.replace("supported_locales: [:en, :ar]", "supported_locales: [:en, :fr, :ar]")
      else
        content
      end

    cond do
      not Keyword.get(opts, :lang, false) ->
        content

      String.contains?(content, "supported_locales: [:en, :fr, :ar]") ->
        content

      String.contains?(content, "config :localize") ->
        content

      true ->
        block =
          "\nconfig :localize,\n  default_locale: :en,\n  supported_locales: [:en, :fr, :ar]\n"

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

  defp patch_env_path_lists(content) do
    Regex.replace(
      ~r/"NODE_PATH"\s*=>\s*\[([^\]]+)\]/u,
      content,
      fn _, inner ->
        paths = inner |> String.split(",") |> Enum.map(&String.trim/1)
        ~s/"NODE_PATH" => Enum.join([#{Enum.join(paths, ", ")}], ":")/
      end
    )
  end

  defp patch_esbuild_for_esm(content, path) do
    cond do
      not String.contains?(content, "config :esbuild") ->
        content

      String.contains?(content, "--format=esm") ->
        content

      String.contains?(content, "js/app.js --bundle") ->
        ~r/(js\/app\.js)\s+--bundle/u
        |> Regex.replace(content, esm_args(content), global: false)
        |> patch_esbuild_outdir()

      true ->
        patch_failed!(
          "switch esbuild to ESM output",
          path,
          "an esbuild target whose args start with `js/app.js --bundle`. Corex hooks are code-split ES modules and cannot load from an IIFE bundle"
        )
    end
  end

  defp esm_args(content) do
    if String.contains?(content, "--target=es2022") do
      "\\1 --bundle --format=esm --splitting"
    else
      "\\1 --bundle --format=esm --splitting --target=es2022"
    end
  end

  defp patch_esbuild_outdir(content) do
    case Regex.run(~r/--outdir=\.\.\/priv\/static\/assets(?!\/js)/u, content) do
      [old] -> String.replace(content, old, "--outdir=../priv/static/assets/js", global: false)
      nil -> content
    end
  end

  defp inject_locales_into_gettext_backend(content) do
    content =
      String.replace(content, "locales: ~w(en ar)", "locales: ~w(en fr ar)", global: false)

    cond do
      Regex.match?(~r/\blocales:\s*~w\(en fr ar\)/m, content) ->
        content

      Regex.match?(~r/\blocales:\s*~w\(/m, content) ->
        content

      Regex.match?(~r/use\s+Gettext\.Backend\b/m, content) ->
        inject_gettext_locales_after_backend_use(content)

      true ->
        content
    end
  end

  defp inject_gettext_locales_after_backend_use(content) do
    Regex.replace(
      ~r/use\s+Gettext\.Backend\s*,\s*otp_app:\s*(:[a-z_0-9]+)(?:\s*,\s*default_locale:\s*"[^"]+")?/m,
      content,
      fn _, otp_app ->
        "use Gettext.Backend,\n    otp_app: #{otp_app},\n    default_locale: \"en\",\n    locales: ~w(en fr ar)"
      end,
      global: false
    )
  end

  defp replace_gettext_with_sigils(content, web_module) do
    if String.contains?(content, "GettextSigils") do
      content
    else
      web_str = inspect(web_module)
      old = "use Gettext, backend: #{web_str}.Gettext"
      new = "use GettextSigils, backend: #{web_str}.Gettext"

      if String.contains?(content, old) do
        String.replace(content, old, new, global: true)
      else
        content
      end
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
