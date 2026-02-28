if Code.ensure_loaded?(Igniter) do
  defmodule Corex.Igniter do
    @moduledoc false

    defp assigns_map(igniter) do
      case Map.get(igniter, :assigns) do
        m when is_map(m) -> m
        _ -> %{}
      end
    end

    defp path_under_root?(path, root) do
      abs_path = Path.absname(path)
      abs_root = Path.absname(root) |> String.trim_trailing("/")
      String.starts_with?(abs_path, abs_root <> "/") or abs_path == abs_root
    end

    # sobelow_skip ["DOS.StringToAtom"]
    defp safe_to_atom(str) when is_binary(str) do
      cond do
        byte_size(str) > 128 ->
          Mix.raise("App name too long: #{inspect(str)}")

        str =~ ~r/[^a-z0-9_]/ ->
          Mix.raise(
            "Invalid app name (lowercase letters, digits, underscore only): #{inspect(str)}"
          )

        true ->
          String.to_atom(str)
      end
    end

    def validate_opts!(opts) do
      if theme = Keyword.get(opts, :theme) do
        themes = String.split(theme, ":", trim: true)

        if length(themes) < 2 do
          Mix.raise("--theme requires at least 2 values (e.g. neo:uno), got: #{inspect(theme)}")
        end
      end

      if languages = Keyword.get(opts, :languages) do
        list = String.split(languages, ":", trim: true)

        if length(list) < 2 do
          Mix.raise(
            "--languages requires at least 2 values (e.g. en:fr:ar), got: #{inspect(languages)}"
          )
        end
      end
    end

    def install(igniter, opts) do
      ensure_phoenix_project!()

      {project_path, web_path, otp_app, web_namespace, web_app_str} =
        project_paths!(igniter)

      design? = Keyword.get(opts, :design, true)
      designex? = Keyword.get(opts, :designex, false)

      igniter
      |> add_gettext_if_missing(project_path, web_path, otp_app, web_app_str, web_namespace)
      |> then(fn igniter ->
        if design?,
          do: run_corex_design(igniter, project_path, web_path, designex?),
          else: igniter
      end)
      |> copy_generator_templates(project_path, web_path, otp_app)
      |> copy_plugs_and_hooks(web_path, web_namespace, web_app_str, opts)

      app_js_path = Path.relative_to(Path.join(web_path, "assets/js/app.js"), project_path)
      config_path = Path.join("config", "config.exs")

      root_layout_path =
        Path.relative_to(
          Path.join(web_path, "lib/#{web_app_str}/components/layouts/root.html.heex"),
          project_path
        )

      web_ex_path = Path.relative_to(Path.join(web_path, "lib/#{web_app_str}.ex"), project_path)
      app_css_path = Path.relative_to(Path.join(web_path, "assets/css/app.css"), project_path)

      layouts_path =
        Path.relative_to(
          Path.join(web_path, "lib/#{web_app_str}/components/layouts.ex"),
          project_path
        )

      igniter
      |> add_corex_config(web_namespace)
      |> add_rtl_config(opts)
      |> patch_app_js(app_js_path)
      |> patch_esbuild_config(config_path)
      |> patch_root_layout(root_layout_path, web_app_str, design?, opts)
      |> patch_layouts(layouts_path, design?, opts)
      |> patch_html_helpers(web_ex_path)
      |> patch_app_css(app_css_path, design?, opts)
      |> remove_daisy_vendor(web_path, design?)
    end

    def add_corex_config(igniter, web_namespace) do
      gettext_backend = Module.concat([web_namespace, Gettext])

      failure_message = """
      Could not add Corex config to config/config.exs. Add manually:

          config :corex,
            gettext_backend: #{inspect(gettext_backend)},
            json_library: Jason
      """

      if Igniter.Project.Config.configures_root_key?(igniter, "config.exs", :corex) do
        igniter
      else
        igniter
        |> Igniter.Project.Config.configure_new(
          "config.exs",
          :corex,
          [:gettext_backend],
          gettext_backend,
          failure_message: failure_message
        )
        |> Igniter.Project.Config.configure_new(
          "config.exs",
          :corex,
          [:json_library],
          Jason,
          failure_message: failure_message
        )
      end
    end

    def add_rtl_config(igniter, opts) do
      case Keyword.get(opts, :rtl) do
        nil ->
          igniter

        rtl ->
          rtl_list = String.split(rtl, ~r/[:,]/, trim: true)

          failure_message =
            "Could not add rtl_locales to config :corex. Add manually: rtl_locales: #{inspect(rtl_list)}"

          Igniter.Project.Config.configure(
            igniter,
            "config.exs",
            :corex,
            [:rtl_locales],
            rtl_list,
            failure_message: failure_message
          )
      end
    end

    def patch_app_js(igniter, app_js_path) do
      if Igniter.exists?(igniter, app_js_path) do
        igniter
        |> Igniter.include_existing_file(app_js_path, required?: false)
        |> Igniter.update_file(app_js_path, &patch_app_js_content(&1, app_js_path))
      else
        igniter
      end
    end

    defp patch_app_js_content(source, app_js_path) do
      if source.content =~ ~r/from "corex"/ do
        source
      else
        new_content =
          source.content
          |> String.replace(~r/(import topbar from)/, ~s|import corex from "corex"\n\\1|)
          |> String.replace(
            ~r/hooks: \{\.\.\.colocatedHooks\}/,
            "hooks: {...colocatedHooks, ...corex}"
          )

        maybe_update_app_js(source, source.content, new_content, app_js_path)
      end
    end

    defp maybe_update_app_js(source, content, new_content, app_js_path) do
      if new_content == content do
        {:warning,
         """
         Could not patch #{app_js_path} (structure may differ). Add manually:

           import corex from "corex"
           hooks: {...colocatedHooks, ...corex}
         """}
      else
        Rewrite.Source.update(source, :content, new_content)
      end
    end

    def patch_esbuild_config(igniter, config_path) do
      igniter
      |> Igniter.include_existing_file(config_path, required?: true)
      |> Igniter.update_file(config_path, &patch_esbuild_content(&1, config_path))
    end

    defp patch_esbuild_content(source, config_path) do
      if source.content =~ ~r/--format=esm/ do
        source
      else
        new_content =
          String.replace(source.content, ~r/(--bundle )/, "\\1--format=esm --splitting ")

        maybe_update_esbuild(source, source.content, new_content, config_path)
      end
    end

    defp maybe_update_esbuild(source, content, new_content, config_path) do
      if new_content == content do
        {:warning,
         Igniter.Util.Warning.formatted_warning(
           "Could not patch esbuild config in #{config_path}. Add manually to esbuild args:",
           ~s|# --format=esm --splitting --bundle|
         )}
      else
        Rewrite.Source.update(source, :content, new_content)
      end
    end

    def patch_root_layout(igniter, root_layout_path, _web_app_str, design?, _opts) do
      if Igniter.exists?(igniter, root_layout_path) do
        igniter
        |> Igniter.include_existing_file(root_layout_path, required?: false)
        |> Igniter.update_file(
          root_layout_path,
          &patch_root_layout_content(&1, root_layout_path, design?),
          required?: false
        )
      else
        igniter
      end
    end

    defp patch_root_layout_content(source, root_layout_path, design?) do
      content = source.content

      new_content =
        content
        |> replace_type_script()
        |> maybe_replace_html_attrs(design?)
        |> maybe_theme_script(design?)

      maybe_update_root_layout(source, content, new_content, root_layout_path, design?)
    end

    defp maybe_replace_html_attrs(content, true), do: replace_html_attrs(content)
    defp maybe_replace_html_attrs(content, _), do: content

    defp maybe_theme_script(content, true), do: remove_theme_script(content)
    defp maybe_theme_script(content, _), do: content

    defp maybe_update_root_layout(source, content, new_content, root_layout_path, design?) do
      if new_content == content do
        if design? and not already_patched_root_layout?(content) do
          {:warning,
           Igniter.Util.Warning.formatted_warning(
             "Could not patch #{root_layout_path}. Apply manually: set type=\"module\" on script, add data-theme=\"neo\" data-mode=\"light\" to <html>",
             ~s|# <html lang="en" data-theme="neo" data-mode="light">|
           )}
        else
          Rewrite.Source.update(source, :content, content)
        end
      else
        Rewrite.Source.update(source, :content, new_content)
      end
    end

    defp already_patched_root_layout?(content) do
      (content =~ ~r/type="module"/ or not (content =~ ~r/type="text\/javascript"/)) and
        (content =~ ~r/data-theme=/ or content =~ ~r/data-mode=/)
    end

    defp replace_type_script(content) do
      if content =~ ~r/type="text\/javascript"/ and not (content =~ ~r/type="module"/) do
        String.replace(content, ~r/type="text\/javascript"/, ~s|type="module"|)
      else
        content
      end
    end

    defp replace_html_attrs(content) do
      if content =~ ~r/<html lang=/ and not (content =~ ~r/data-theme=/) do
        String.replace(
          content,
          ~r/<html lang="[^"]*"/,
          ~s|<html lang="en" data-theme="neo" data-mode="light"|
        )
      else
        content
      end
    end

    defp remove_theme_script(content) do
      regex = ~r/\s*<script>\s*\(\(\) => \{[\s\S]*?phx:set-theme[\s\S]*?\}\)\(\);\s*<\/script>/
      String.replace(content, regex, "")
    end

    def patch_layouts(igniter, layouts_path, design?, opts) do
      if Igniter.exists?(igniter, layouts_path) and design? do
        igniter
        |> Igniter.include_existing_file(layouts_path, required?: false)
        |> Igniter.update_file(
          layouts_path,
          &patch_layouts_content(&1, design?, opts),
          required?: false
        )
      else
        igniter
      end
    end

    defp patch_layouts_content(source, design?, opts) do
      content = source.content

      updated =
        content
        |> remove_daisy_theme_toggle(design?)
        |> add_layout_toggle(Keyword.get(opts, :mode), :mode_toggle)
        |> add_layout_toggle(Keyword.get(opts, :theme), :theme_toggle)

      Rewrite.Source.update(source, :content, updated)
    end

    defp remove_daisy_theme_toggle(content, true) do
      li_regex = ~r/\s*<li>\s*<\.theme_toggle \/>\s*<\/li>/

      theme_toggle_fn =
        ~r/\n  @doc """\s*\n  Provides dark vs light theme toggle[\s\S]*?def theme_toggle\(assigns\) do\s*\n    ~H"""\s*\n[\s\S]*?data-phx-theme[\s\S]*?"""\s*\n  end/

      content
      |> String.replace(li_regex, "")
      |> String.replace(theme_toggle_fn, "")
    end

    defp remove_daisy_theme_toggle(content, _), do: content

    defp add_layout_toggle(content, nil, _), do: content
    defp add_layout_toggle(content, false, _), do: content

    defp add_layout_toggle(content, _value, :mode_toggle) do
      if content =~ ~r/<\.mode_toggle/ do
        content
      else
        li = """
          <li>
            <.mode_toggle />
          </li>
        """

        mode_toggle_fn =
          "\n  @doc \"\"\"\n  Provides dark vs light mode toggle. See root.html.heex script for phx:set-mode.\n  \"\"\"\n  def mode_toggle(assigns) do\n    ~H\"\"\"\n    <div class=\"card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full\">\n      <div class=\"absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-mode=light]_&]:left-1/3 [[data-mode=dark]_&]:left-2/3 transition-[left]\" />\n      <button\n        type=\"button\"\n        class=\"flex p-2 cursor-pointer w-1/3\"\n        data-phx-mode=\"system\"\n        onclick=\"this.dispatchEvent(new CustomEvent('phx:set-mode', {bubbles: true}))\"\n      >\n        <.icon name=\"hero-computer-desktop-micro\" class=\"size-4 opacity-75 hover:opacity-100\" />\n      </button>\n      <button\n        type=\"button\"\n        class=\"flex p-2 cursor-pointer w-1/3\"\n        data-phx-mode=\"light\"\n        onclick=\"this.dispatchEvent(new CustomEvent('phx:set-mode', {bubbles: true}))\"\n      >\n        <.icon name=\"hero-sun-micro\" class=\"size-4 opacity-75 hover:opacity-100\" />\n      </button>\n      <button\n        type=\"button\"\n        class=\"flex p-2 cursor-pointer w-1/3\"\n        data-phx-mode=\"dark\"\n        onclick=\"this.dispatchEvent(new CustomEvent('phx:set-mode', {bubbles: true}))\"\n      >\n        <.icon name=\"hero-moon-micro\" class=\"size-4 opacity-75 hover:opacity-100\" />\n      </button>\n    </div>\n    \"\"\"\n  end\n"

        content
        |> String.replace(
          ~r/(<li>\s*<a href="https:\/\/github\.com\/phoenixframework\/phoenix")/,
          li <> "\n          \\1"
        )
        |> String.replace(~r/\nend\s*\z/, mode_toggle_fn <> "end\n")
      end
    end

    defp add_layout_toggle(content, themes, :theme_toggle) when is_binary(themes) do
      if content =~ ~r/<\.theme_toggle/ do
        content
      else
        themes_list = String.split(themes, ":", trim: true)

        li = """
          <li>
            <.theme_toggle theme={assigns[:theme] || "neo"} />
          </li>
        """

        collection = Enum.map(themes_list, fn t -> %{id: t, label: String.capitalize(t)} end)

        theme_toggle_fn =
          "\n  attr :theme, :string, default: \"neo\", doc: \"current theme from cookie/session\"\n\n  @doc \"\"\"\n  Provides theme selection. Requires ThemePlug and phx:set-theme script in root.\n  \"\"\"\n  def theme_toggle(assigns) do\n    ~H\"\"\"\n    <.select\n      id=\"theme-select\"\n      class=\"select select--sm select--micro\"\n      collection={" <>
            inspect(collection) <>
            "}\n      value={[@theme]}\n      on_value_change_client=\"phx:set-theme\"\n    >\n      <:label class=\"sr-only\">Theme</:label>\n      <:item :let={item}>{item.label}</:item>\n      <:trigger>\n        <.icon name=\"hero-swatch\" />\n      </:trigger>\n      <:item_indicator>\n        <.icon name=\"hero-check\" />\n      </:item_indicator>\n    </.select>\n    \"\"\"\n  end\n"

        content
        |> String.replace(
          ~r/(<li>\s*<a href="https:\/\/github\.com\/phoenixframework\/phoenix")/,
          li <> "\n          \\1"
        )
        |> String.replace(~r/\nend\s*\z/, theme_toggle_fn <> "end\n")
      end
    end

    def patch_html_helpers(igniter, web_ex_path) do
      if Igniter.exists?(igniter, web_ex_path) do
        igniter
        |> Igniter.include_existing_file(web_ex_path, required?: false)
        |> Igniter.update_elixir_file(web_ex_path, &patch_html_helpers_zipper(&1, web_ex_path),
          required?: false
        )
      else
        igniter
      end
    end

    defp patch_html_helpers_zipper(zipper, web_ex_path) do
      use_corex? =
        Igniter.Code.Common.move_to(zipper, fn z ->
          Igniter.Code.Function.function_call?(z, :use, [1, 2]) and
            Igniter.Code.Function.argument_equals?(z, 0, Corex)
        end) != :error

      if use_corex? do
        {:ok, zipper}
      else
        add_use_corex_or_warn(zipper, web_ex_path)
      end
    end

    defp add_use_corex_or_warn(zipper, web_ex_path) do
      import_predicate = fn z ->
        Igniter.Code.Function.function_call?(z, :import, 1) and
          Igniter.Code.Function.argument_matches_predicate?(z, 0, fn arg_z ->
            str = Sourceror.to_string(Sourceror.Zipper.node(arg_z))
            is_binary(str) and str =~ ~r/\.CoreComponents/
          end)
      end

      case Igniter.Code.Common.move_to(zipper, import_predicate) do
        {:ok, import_zipper} ->
          {:ok, Igniter.Code.Common.add_code(import_zipper, "use Corex", placement: :after)}

        :error ->
          {:warning,
           Igniter.Util.Warning.formatted_warning(
             "Could not patch #{web_ex_path}. Add manually in html/0 block:",
             "use Corex"
           )}
      end
    end

    def patch_app_css(igniter, app_css_path, design?, _opts) do
      if Igniter.exists?(igniter, app_css_path) and design? do
        igniter
        |> Igniter.include_existing_file(app_css_path, required?: false)
        |> Igniter.update_file(
          app_css_path,
          &patch_app_css_content(&1, design?),
          required?: false
        )
      else
        igniter
      end
    end

    defp patch_app_css_content(source, design?) do
      case add_corex_imports(source.content, design?) do
        {:warning, _} = warn ->
          warn

        content ->
          updated =
            content
            |> patch_data_mode(design?)
            |> remove_daisy_css(design?)

          Rewrite.Source.update(source, :content, updated)
      end
    end

    defp add_corex_imports(content, true) do
      if content =~ ~r/@import "\.\.\/corex\/main\.css"/ do
        content
      else
        imports = """
        @import "../corex/main.css";
        @import "../corex/tokens/themes/neo/light.css";
        @import "../corex/components/typo.css";

        """

        new_content = String.replace(content, ~r/((?:@source "[^"]+";\s*\n)+)/, "\\1\n#{imports}")

        if new_content == content do
          {:warning,
           """
           Could not patch app.css. Add manually after @source:

           #{String.trim(imports)}
           """}
        else
          new_content
        end
      end
    end

    defp add_corex_imports(content, _), do: content

    defp patch_data_mode(content, true) do
      if content =~ ~r/\[data-theme=dark\]/ do
        String.replace(content, ~r/\[data-theme=dark\]/, "[data-mode=dark]", global: true)
      else
        content
      end
    end

    defp patch_data_mode(content, _), do: content

    defp remove_daisy_css(content, true) do
      daisyui_plugin =
        ~r/\n\s*\/\* daisyUI Tailwind Plugin[\s\S]*?@plugin "\.\.\/vendor\/daisyui" \{[^}]*\}\s*/

      daisyui_theme_block =
        ~r/\n\s*\/\* daisyUI theme plugin[\s\S]*?@plugin "\.\.\/vendor\/daisyui-theme" \{[^}]*\}\s*/

      daisyui_theme_any = ~r/@plugin "\.\.\/vendor\/daisyui-theme" \{[^}]*\}\s*/

      content
      |> String.replace(daisyui_plugin, "")
      |> String.replace(daisyui_theme_block, "")
      |> String.replace(daisyui_theme_any, "", global: true)
    end

    defp remove_daisy_css(content, _), do: content

    def remove_daisy_vendor(igniter, web_path, design?) do
      if design? do
        remove_daisy_vendor_files(web_path)
      end

      igniter
    end

    # sobelow_skip ["Traversal.FileModule"]
    defp remove_daisy_vendor_files(web_path) do
      vendor_path = Path.join([web_path, "assets", "vendor"])

      for file <- ~w(daisyui.js daisyui-theme.js) do
        path = Path.join(vendor_path, file)
        if path_under_root?(path, web_path) and File.exists?(path), do: File.rm(path)
      end
    end

    def run_setup_phase(igniter, opts) do
      ensure_phoenix_project!()
      {project_path, web_path, otp_app, web_namespace, web_app_str} = project_paths!(igniter)
      add_gettext_if_missing(igniter, project_path, web_path, otp_app, web_app_str, web_namespace)
      design? = Keyword.get(opts, :design, true)
      designex? = Keyword.get(opts, :designex, false)
      if design?, do: run_corex_design(igniter, project_path, web_path, designex?)
      copy_generator_templates(igniter, project_path, web_path, otp_app)
      copy_plugs_and_hooks(igniter, web_path, web_namespace, web_app_str, opts)

      assigns =
        Map.put(
          assigns_map(igniter),
          :corex_project_paths,
          {project_path, web_path, web_namespace, web_app_str}
        )

      %{igniter | assigns: assigns}
    end

    def run_config_phase(igniter, opts) do
      {_project_path, _web_path, web_namespace, _web_app_str} =
        assigns_map(igniter)[:corex_project_paths]

      igniter
      |> add_corex_config(web_namespace)
      |> add_rtl_config(opts)
    end

    def run_assets_phase(igniter, _opts) do
      {project_path, web_path, _web_namespace, _web_app_str} =
        assigns_map(igniter)[:corex_project_paths]

      app_js_path = Path.relative_to(Path.join(web_path, "assets/js/app.js"), project_path)
      config_path = Path.join("config", "config.exs")

      igniter
      |> patch_app_js(app_js_path)
      |> patch_esbuild_config(config_path)
    end

    def run_layout_phase(igniter, opts) do
      {project_path, web_path, _web_namespace, web_app_str} =
        assigns_map(igniter)[:corex_project_paths]

      design? = Keyword.get(opts, :design, true)

      root_layout_path =
        Path.relative_to(
          Path.join(web_path, "lib/#{web_app_str}/components/layouts/root.html.heex"),
          project_path
        )

      layouts_path =
        Path.relative_to(
          Path.join(web_path, "lib/#{web_app_str}/components/layouts.ex"),
          project_path
        )

      web_ex_path = Path.relative_to(Path.join(web_path, "lib/#{web_app_str}.ex"), project_path)

      igniter
      |> patch_root_layout(root_layout_path, web_app_str, design?, opts)
      |> patch_layouts(layouts_path, design?, opts)
      |> patch_html_helpers(web_ex_path)
    end

    def run_css_phase(igniter, opts) do
      {project_path, web_path, _web_namespace, _web_app_str} =
        assigns_map(igniter)[:corex_project_paths]

      app_css_path = Path.relative_to(Path.join(web_path, "assets/css/app.css"), project_path)
      design? = Keyword.get(opts, :design, true)

      igniter
      |> patch_app_css(app_css_path, design?, opts)
      |> remove_daisy_vendor(web_path, design?)
    end

    defp ensure_phoenix_project! do
      unless Code.ensure_loaded?(Phoenix) do
        Mix.raise("""
        Corex install requires a Phoenix project.
        Create one first with:

            mix phx.new my_app
        """)
      end
    end

    defp project_paths!(igniter) do
      if igniter && Map.get(assigns_map(igniter), :test_mode?) do
        project_paths_from_igniter(igniter)
      else
        project_paths_from_mix!()
      end
    end

    defp project_paths_from_igniter(igniter) do
      web_ex_path =
        igniter.rewrite.sources
        |> Map.keys()
        |> Enum.find(fn path ->
          path =~ ~r/lib\/[^\/]+_web\.ex\z/ and not String.contains?(path, "/components/")
        end)

      if web_ex_path do
        web_app_str = Path.basename(web_ex_path, ".ex")
        app_str = String.replace_suffix(web_app_str, "_web", "")
        otp_app = safe_to_atom(app_str)
        web_namespace_str = Macro.camelize(app_str) <> "Web"
        web_namespace = Module.concat([web_namespace_str])
        project_root = "."
        {project_root, project_root, otp_app, web_namespace, web_app_str}
      else
        project_paths_from_mix!()
      end
    end

    defp project_paths_from_mix! do
      project_root = File.cwd!()

      if Mix.Project.umbrella?() do
        apps_path = Path.join(project_root, "apps")
        web_apps = File.ls!(apps_path) |> Enum.filter(&String.ends_with?(&1, "_web"))
        web_app_name = List.first(web_apps) || Mix.raise("No *_web app found in apps/")
        web_path = Path.join(apps_path, web_app_name)

        web_namespace =
          web_app_name
          |> String.replace_suffix("_web", "")
          |> Macro.camelize()
          |> Kernel.<>("Web")

        web_namespace_mod = Module.concat([web_namespace])
        web_app_atom = safe_to_atom(web_app_name)
        {project_root, web_path, web_app_atom, web_namespace_mod, web_app_name}
      else
        app_name = Mix.Project.config()[:app]
        web_namespace_str = app_name |> to_string() |> Macro.camelize() |> Kernel.<>("Web")
        web_namespace = Module.concat([web_namespace_str])
        web_app_dir = to_string(app_name) <> "_web"
        {project_root, project_root, app_name, web_namespace, web_app_dir}
      end
    end

    defp add_gettext_if_missing(
           igniter,
           project_path,
           web_path,
           otp_app,
           web_app_str,
           web_namespace
         ) do
      gettext_path =
        Path.relative_to(Path.join([web_path, "lib", web_app_str, "gettext.ex"]), project_path)

      if Igniter.exists?(igniter, gettext_path) do
        igniter
      else
        igniter
        |> add_gettext_dep(project_path, web_path)
        |> create_gettext_module(project_path, web_path, web_app_str, web_namespace)
        |> create_gettext_files(project_path, otp_app)
        |> add_gettext_config(project_path, web_namespace)
        |> then(&Igniter.add_notice(&1, "* adding gettext"))
      end
    end

    defp add_gettext_dep(igniter, project_path, web_path) do
      mix_path = Path.relative_to(Path.join(web_path, "mix.exs"), project_path)

      if Igniter.exists?(igniter, mix_path) do
        igniter
        |> Igniter.include_existing_file(mix_path, required?: true)
        |> Igniter.update_file(mix_path, &patch_mix_gettext_dep/1)
      else
        igniter
      end
    end

    defp patch_mix_gettext_dep(source) do
      if source.content =~ ~r/:gettext,/ do
        source
      else
        insert = ~s/      {:gettext, "~> 1.0"},/

        new_content =
          String.replace(
            source.content,
            ~r/\{:telemetry_poller, "~> 1\.0"\}/,
            insert <> "\n      {:telemetry_poller, \"~> 1.0\"}"
          )

        Rewrite.Source.update(source, :content, new_content)
      end
    end

    defp create_gettext_module(igniter, project_path, web_path, web_app_str, web_namespace) do
      lib_web = Path.relative_to(Path.join([web_path, "lib", web_app_str]), project_path)
      gettext_path = Path.join(lib_web, "gettext.ex")

      igniter
      |> Igniter.mkdir(lib_web)
      |> Igniter.create_new_file(gettext_path, """
      defmodule #{inspect(web_namespace)}.Gettext do
        @moduledoc false
        use Gettext.Backend, otp_app: #{inspect(safe_to_atom(web_app_str))}
      end
      """)
    end

    defp create_gettext_files(igniter, project_path, otp_app) do
      gettext_priv = Path.join(Path.relative_to(:code.priv_dir(otp_app), project_path), "gettext")
      errors_pot = Path.join(gettext_priv, "errors.pot")
      en_po = Path.join(gettext_priv, "en/LC_MESSAGES/errors.po")

      igniter
      |> Igniter.mkdir(Path.join(gettext_priv, "en/LC_MESSAGES"))
      |> Igniter.create_new_file(errors_pot, """
      ## This is a PO Template file.
      ## Run `mix gettext.extract` to bring this file up to date.
      msgid ""
      msgstr ""
      """)
      |> Igniter.create_new_file(en_po, """
      msgid ""
      msgstr ""
      "Language: en\\n"
      """)
    end

    defp add_gettext_config(igniter, _project_path, _web_namespace), do: igniter

    defp run_corex_design(igniter, project_path, web_path, designex?) do
      if Map.get(assigns_map(igniter), :test_mode?) do
        igniter
      else
        target = Path.relative_to(Path.join([web_path, "assets", "corex"]), project_path)
        args = [target, "--force"]
        args = if designex?, do: ["--designex" | args], else: args
        suffix = if designex?, do: " --designex", else: ""
        Mix.Task.run("corex.design", args)
        Igniter.add_notice(igniter, "* running mix corex.design#{suffix}")
      end
    end

    defp copy_generator_templates(igniter, _project_path, web_path, otp_app) do
      if Map.get(assigns_map(igniter), :test_mode?) do
        igniter
      else
        copy_generator_templates_impl(igniter, web_path, otp_app)
      end
    end

    defp priv_templates_path(web_path, otp_app) do
      case :code.priv_dir(otp_app) do
        path when is_binary(path) or is_list(path) -> Path.join(path, "templates")
        {:error, _} -> Path.join(web_path, "priv/templates")
      end
    end

    # sobelow_skip ["Traversal.FileModule"]
    defp copy_generator_templates_impl(igniter, web_path, otp_app) do
      corex_priv = Path.join(:code.priv_dir(:corex), "templates")
      phoenix_priv = Path.join(:code.priv_dir(:phoenix), "templates")
      templates_root = priv_templates_path(web_path, otp_app)

      Enum.reduce(
        [
          {"phx.gen.html", "phx.gen.html"},
          {"phx.gen.live", "phx.gen.live"},
          {"phx.gen.auth", "phx.gen.auth"}
        ],
        igniter,
        &copy_generator_template(&1, &2, corex_priv, phoenix_priv, templates_root)
      )
    end

    defp copy_generator_template(
           {gen_name, phoenix_dir},
           igniter,
           corex_priv,
           phoenix_priv,
           templates_root
         ) do
      corex_src = Path.join(corex_priv, String.replace(gen_name, "phx.", "corex."))
      phoenix_src = Path.join(phoenix_priv, phoenix_dir)
      dst = Path.join(templates_root, phoenix_dir)
      src = if File.exists?(corex_src), do: corex_src, else: phoenix_src
      src_root = if src == phoenix_src, do: phoenix_priv, else: corex_priv

      if File.exists?(src) do
        path_under_root?(src, src_root) || Mix.raise("Path traversal blocked: #{inspect(src)}")

        path_under_root?(dst, templates_root) ||
          Mix.raise("Path traversal blocked: #{inspect(dst)}")

        File.mkdir_p!(dst)
        File.cp_r!(src, dst)
        Igniter.add_notice(igniter, "* copying #{phoenix_dir} templates")
      else
        igniter
      end
    end

    defp copy_plugs_and_hooks(igniter, web_path, web_namespace, web_app_str, opts) do
      if Map.get(assigns_map(igniter), :test_mode?) do
        igniter
      else
        copy_plugs_and_hooks_impl(igniter, web_path, web_namespace, web_app_str, opts)
      end
    end

    defp copy_plugs_and_hooks_impl(igniter, web_path, web_namespace, web_app_str, opts) do
      corex_root = :code.lib_dir(:corex) |> Path.dirname()
      installer_templates = Path.join([corex_root, "installer", "templates"])

      if File.exists?(installer_templates) do
        binding = [
          web_namespace: web_namespace,
          web_app_name: web_app_str
        ]

        lib_web = Path.join([web_path, "lib", web_app_str])

        igniter =
          if Keyword.get(opts, :mode) do
            copy_eex(
              Path.join([installer_templates, "phx_web", "plugs", "mode.ex.eex"]),
              Path.join([lib_web, "plugs", "mode.ex"]),
              binding,
              installer_templates,
              web_path
            )

            copy_eex(
              Path.join([installer_templates, "phx_web", "live", "hooks", "mode_live.ex.eex"]),
              Path.join([lib_web, "live", "hooks", "mode_live.ex"]),
              binding,
              installer_templates,
              web_path
            )

            Igniter.add_notice(igniter, "* adding mode plug and hook")
          else
            igniter
          end

        igniter =
          if themes = Keyword.get(opts, :theme) do
            themes_list = String.split(themes, ":", trim: true)

            binding =
              Keyword.merge(binding, themes: themes_list, default_locale: List.first(themes_list))

            copy_eex(
              Path.join([installer_templates, "phx_web", "plugs", "theme.ex.eex"]),
              Path.join([lib_web, "plugs", "theme.ex"]),
              binding,
              installer_templates,
              web_path
            )

            copy_eex(
              Path.join([installer_templates, "phx_web", "live", "hooks", "theme_live.ex.eex"]),
              Path.join([lib_web, "live", "hooks", "theme_live.ex"]),
              binding,
              installer_templates,
              web_path
            )

            Igniter.add_notice(igniter, "* adding theme plug and hook")
          else
            igniter
          end

        igniter =
          if languages = Keyword.get(opts, :languages) do
            langs_list = String.split(languages, ":", trim: true)

            binding =
              Keyword.merge(binding,
                languages: langs_list,
                default_locale: List.first(langs_list)
              )

            copy_eex(
              Path.join([installer_templates, "phx_web", "plugs", "locale.ex.eex"]),
              Path.join([lib_web, "plugs", "locale.ex"]),
              binding,
              installer_templates,
              web_path
            )

            copy_eex(
              Path.join([installer_templates, "phx_web", "live", "shared_events.ex.eex"]),
              Path.join([lib_web, "live", "shared_events.ex"]),
              binding,
              installer_templates,
              web_path
            )

            Igniter.add_notice(igniter, "* adding locale plug and shared events")
          else
            igniter
          end

        igniter
      else
        igniter
      end
    end

    # sobelow_skip ["Traversal.FileModule", "RCE.EEx"]
    defp copy_eex(src, dst, binding, src_root, dst_root) do
      unless path_under_root?(src, src_root),
        do: Mix.raise("Path traversal blocked: #{inspect(src)}")

      unless path_under_root?(dst, dst_root),
        do: Mix.raise("Path traversal blocked: #{inspect(dst)}")

      if File.exists?(src) do
        content = EEx.eval_file(src, binding: binding)
        File.mkdir_p!(Path.dirname(dst))
        File.write!(dst, content)
      end
    end
  end
end
