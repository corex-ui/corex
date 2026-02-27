if Code.ensure_loaded?(Igniter) do
  defmodule Corex.Igniter do
    @moduledoc false

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
      {project_path, web_path, _web_app, web_namespace, web_app_str} = project_paths!()
      add_gettext_if_missing(igniter, project_path, web_path, web_app_str, web_namespace)
      design? = Keyword.get(opts, :design, true)
      designex? = Keyword.get(opts, :designex, false)
      if design?, do: run_corex_design(igniter, project_path, web_path, designex?)
      copy_generator_templates(igniter, web_path)
      copy_plugs_and_hooks(igniter, web_path, web_namespace, web_app_str, opts)

      app_js_path = Path.relative_to(Path.join(web_path, "assets/js/app.js"), project_path)
      config_path = Path.join("config", "config.exs")

      root_layout_path =
        Path.relative_to(
          Path.join(web_path, "lib/#{web_app_str}/components/layouts/root.html.heex"),
          project_path
        )

      web_ex_path = Path.relative_to(Path.join(web_path, "lib/#{web_app_str}.ex"), project_path)
      app_css_path = Path.relative_to(Path.join(web_path, "assets/css/app.css"), project_path)

      igniter
      |> add_corex_config(web_namespace)
      |> add_rtl_config(opts)
      |> patch_app_js(app_js_path)
      |> patch_esbuild_config(config_path)
      |> patch_root_layout(root_layout_path, web_app_str, opts)
      |> patch_html_helpers(web_ex_path)
      |> patch_app_css(app_css_path, design?, opts)
      |> remove_daisy_vendor(web_path, opts)
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
         Igniter.Util.Warning.formatted_warning(
           "Could not patch #{app_js_path} (structure may differ). Add manually:",
           ~s|import corex from "corex"\nhooks: {...colocatedHooks, ...corex}|
         )}
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

    def patch_root_layout(igniter, root_layout_path, _web_app_str, opts) do
      if Igniter.exists?(igniter, root_layout_path) do
        remove_theme_script? =
          opts[:daisy] == false || Keyword.get(opts, :mode) || Keyword.get(opts, :theme)

        igniter
        |> Igniter.include_existing_file(root_layout_path, required?: false)
        |> Igniter.update_file(
          root_layout_path,
          &patch_root_layout_content(&1, root_layout_path, remove_theme_script?),
          required?: false
        )
      else
        igniter
      end
    end

    defp patch_root_layout_content(source, root_layout_path, remove_theme_script?) do
      content = source.content

      new_content =
        content
        |> replace_type_script()
        |> replace_html_attrs()
        |> maybe_theme_script(remove_theme_script?)

      maybe_update_root_layout(source, content, new_content, root_layout_path)
    end

    defp maybe_theme_script(content, true), do: remove_theme_script(content)
    defp maybe_theme_script(content, _), do: patch_theme_script_to_data_mode(content)

    defp maybe_update_root_layout(source, content, new_content, root_layout_path) do
      if new_content == content do
        {:warning,
         Igniter.Util.Warning.formatted_warning(
           "Could not patch #{root_layout_path}. Apply manually: set type=\"module\" on script, add data-theme=\"neo\" data-mode=\"light\" to <html>",
           ~s|# <html lang="en" data-theme="neo" data-mode="light">|
         )}
      else
        Rewrite.Source.update(source, :content, new_content)
      end
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

    defp patch_theme_script_to_data_mode(content) do
      if content =~ ~r/removeAttribute\("data-theme"\)/ do
        content
        |> String.replace(~r/removeAttribute\("data-theme"\)/, ~s|removeAttribute("data-mode")|)
        |> String.replace(
          ~r/setAttribute\("data-theme", theme\)/,
          ~s|setAttribute("data-mode", theme)|
        )
        |> String.replace(~r/hasAttribute\("data-theme"\)/, ~s|hasAttribute("data-mode")|)
        |> String.replace(~r/phx:theme/, "phx:mode")
        |> String.replace(~r/phxTheme/, "phxMode")
      else
        content
      end
    end

    defp remove_theme_script(content) do
      regex = ~r/\s*<script>\s*\(\(\) => \{[\s\S]*?phx:set-theme[\s\S]*?\}\)\(\);\s*<\/script>/
      String.replace(content, regex, "")
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
          Igniter.Code.Function.function_call?(z, :use, 2) and
            Igniter.Code.Function.argument_equals?(z, 1, Corex)
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

    def patch_app_css(igniter, app_css_path, design?, opts) do
      edit_theme_script? =
        !(opts[:daisy] == false || Keyword.get(opts, :mode) || Keyword.get(opts, :theme))

      remove_daisy? = opts[:daisy] == false
      needs_patch? = design? || edit_theme_script? || remove_daisy?

      if Igniter.exists?(igniter, app_css_path) and needs_patch? do
        igniter
        |> Igniter.include_existing_file(app_css_path, required?: false)
        |> Igniter.update_file(
          app_css_path,
          &patch_app_css_content(&1, design?, edit_theme_script?, remove_daisy?),
          required?: false
        )
      else
        igniter
      end
    end

    defp patch_app_css_content(source, design?, edit_theme_script?, remove_daisy?) do
      case add_corex_imports(source.content, design?) do
        {:warning, _} = warn ->
          warn

        content ->
          updated =
            content
            |> patch_data_mode(edit_theme_script?)
            |> remove_daisy_css(remove_daisy?)

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
           Igniter.Util.Warning.formatted_warning(
             "Could not patch app.css. Add manually after @source:",
             String.trim(imports)
           )}
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

      daisyui_theme_light = ~r/\n\s*@plugin "\.\.\/vendor\/daisyui-theme" \{[^}]*\}\s*/

      content
      |> String.replace(daisyui_plugin, "")
      |> String.replace(daisyui_theme_block, "")
      |> String.replace(daisyui_theme_light, "")
    end

    defp remove_daisy_css(content, _), do: content

    def remove_daisy_vendor(igniter, web_path, opts) do
      if opts[:daisy] == false do
        remove_daisy_vendor_files(web_path)
      end

      igniter
    end

    defp remove_daisy_vendor_files(web_path) do
      vendor_path = Path.join([web_path, "assets", "vendor"])

      for file <- ~w(daisyui.js daisyui-theme.js) do
        path = Path.join(vendor_path, file)
        File.exists?(path) && File.rm(path)
      end
    end

    def run_setup_phase(igniter, opts) do
      ensure_phoenix_project!()
      {project_path, web_path, _web_app, web_namespace, web_app_str} = project_paths!()
      add_gettext_if_missing(igniter, project_path, web_path, web_app_str, web_namespace)
      design? = Keyword.get(opts, :design, true)
      designex? = Keyword.get(opts, :designex, false)
      if design?, do: run_corex_design(igniter, project_path, web_path, designex?)
      copy_generator_templates(igniter, web_path)
      copy_plugs_and_hooks(igniter, web_path, web_namespace, web_app_str, opts)

      assigns =
        Map.put(
          igniter.assigns || %{},
          :corex_project_paths,
          {project_path, web_path, web_namespace, web_app_str}
        )

      %{igniter | assigns: assigns}
    end

    def run_config_phase(igniter, opts) do
      {_project_path, _web_path, web_namespace, _web_app_str} =
        (igniter.assigns || %{})[:corex_project_paths]

      igniter
      |> add_corex_config(web_namespace)
      |> add_rtl_config(opts)
    end

    def run_assets_phase(igniter, _opts) do
      {project_path, web_path, _web_namespace, _web_app_str} =
        (igniter.assigns || %{})[:corex_project_paths]

      app_js_path = Path.relative_to(Path.join(web_path, "assets/js/app.js"), project_path)
      config_path = Path.join("config", "config.exs")

      igniter
      |> patch_app_js(app_js_path)
      |> patch_esbuild_config(config_path)
    end

    def run_layout_phase(igniter, opts) do
      {project_path, web_path, _web_namespace, web_app_str} =
        (igniter.assigns || %{})[:corex_project_paths]

      root_layout_path =
        Path.relative_to(
          Path.join(web_path, "lib/#{web_app_str}/components/layouts/root.html.heex"),
          project_path
        )

      web_ex_path = Path.relative_to(Path.join(web_path, "lib/#{web_app_str}.ex"), project_path)

      igniter
      |> patch_root_layout(root_layout_path, web_app_str, opts)
      |> patch_html_helpers(web_ex_path)
    end

    def run_css_phase(igniter, opts) do
      {project_path, web_path, _web_namespace, _web_app_str} =
        (igniter.assigns || %{})[:corex_project_paths]

      app_css_path = Path.relative_to(Path.join(web_path, "assets/css/app.css"), project_path)
      design? = Keyword.get(opts, :design, true)

      igniter
      |> patch_app_css(app_css_path, design?, opts)
      |> remove_daisy_vendor(web_path, opts)
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

    defp project_paths! do
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
        web_app_atom = String.to_atom(web_app_name)
        {project_root, web_path, web_app_atom, web_namespace_mod, web_app_name}
      else
        app_name = Mix.Project.config()[:app]
        web_namespace_str = app_name |> to_string() |> Macro.camelize() |> Kernel.<>("Web")
        web_namespace = Module.concat([web_namespace_str])
        web_app_dir = to_string(app_name) <> "_web"
        {project_root, project_root, app_name, web_namespace, web_app_dir}
      end
    end

    defp add_gettext_if_missing(_igniter, project_path, web_path, web_app_str, web_namespace) do
      gettext_path = Path.join([web_path, "lib", web_app_str, "gettext.ex"])

      if not File.exists?(gettext_path) do
        Mix.shell().info([:green, "* adding gettext", :reset])
        add_gettext_dep(web_path)
        create_gettext_module(web_path, web_app_str, web_namespace)
        create_gettext_files(web_path)
        add_gettext_config(project_path, web_namespace)
      end
    end

    defp add_gettext_dep(web_path) do
      mix_path = Path.join(web_path, "mix.exs")
      content = File.read!(mix_path)

      unless content =~ ~r/:gettext,/ do
        insert = ~s/      {:gettext, "~> 1.0"},/

        new_content =
          String.replace(
            content,
            ~r/\{:telemetry_poller, "~> 1\.0"\}/,
            insert <> "\n      {:telemetry_poller, \"~> 1.0\"}"
          )

        File.write!(mix_path, new_content)
      end
    end

    defp create_gettext_module(web_path, web_app_str, web_namespace) do
      lib_path = Path.join([web_path, "lib", web_app_str, "gettext.ex"])
      File.mkdir_p!(Path.dirname(lib_path))

      content = """
      defmodule #{inspect(web_namespace)}.Gettext do
        @moduledoc false
        use Gettext.Backend, otp_app: #{inspect(String.to_atom(web_app_str))}
      end
      """

      File.write!(lib_path, content)
    end

    defp create_gettext_files(web_path) do
      gettext_priv = Path.join([web_path, "priv", "gettext"])
      errors_pot = Path.join(gettext_priv, "errors.pot")
      en_po = Path.join([gettext_priv, "en", "LC_MESSAGES", "errors.po"])
      File.mkdir_p!(Path.dirname(en_po))

      File.write!(errors_pot, """
      ## This is a PO Template file.
      ## Run `mix gettext.extract` to bring this file up to date.
      msgid ""
      msgstr ""
      """)

      File.write!(en_po, """
      msgid ""
      msgstr ""
      "Language: en\\n"
      """)
    end

    defp add_gettext_config(_project_path, _web_namespace), do: :ok

    defp run_corex_design(_igniter, project_path, web_path, designex?) do
      target = Path.relative_to(Path.join([web_path, "assets", "corex"]), project_path)
      args = [target, "--force"]
      args = if designex?, do: ["--designex" | args], else: args
      suffix = if designex?, do: " --designex", else: ""
      Mix.shell().info([:green, "* running mix corex.design#{suffix}", :reset])
      Mix.Task.run("corex.design", args)
    end

    defp copy_generator_templates(_igniter, web_path) do
      corex_priv = Path.join([:code.lib_dir(:corex) |> Path.dirname(), "priv", "templates"])
      phoenix_priv = Path.join([:code.lib_dir(:phoenix), "priv", "templates"])
      templates_root = Path.join([web_path, "priv", "templates"])

      for {gen_name, phoenix_dir} <- [
            {"phx.gen.html", "phx.gen.html"},
            {"phx.gen.live", "phx.gen.live"},
            {"phx.gen.auth", "phx.gen.auth"}
          ] do
        corex_src = Path.join(corex_priv, String.replace(gen_name, "phx.", "corex."))
        phoenix_src = Path.join(phoenix_priv, phoenix_dir)
        dst = Path.join(templates_root, phoenix_dir)
        src = if File.exists?(corex_src), do: corex_src, else: phoenix_src

        if File.exists?(src) do
          Mix.shell().info([:green, "* copying #{phoenix_dir} templates", :reset])
          File.mkdir_p!(dst)
          File.cp_r!(src, dst)
        end
      end
    end

    defp copy_plugs_and_hooks(_igniter, web_path, web_namespace, web_app_str, opts) do
      corex_root = :code.lib_dir(:corex) |> Path.dirname()
      installer_templates = Path.join([corex_root, "installer", "templates"])

      if File.exists?(installer_templates) do
        binding = [
          web_namespace: web_namespace,
          web_app_name: web_app_str
        ]

        lib_web = Path.join([web_path, "lib", web_app_str])

        if Keyword.get(opts, :mode) do
          Mix.shell().info([:green, "* adding mode plug and hook", :reset])

          copy_eex(
            Path.join([installer_templates, "phx_web", "plugs", "mode.ex.eex"]),
            Path.join([lib_web, "plugs", "mode.ex"]),
            binding
          )

          copy_eex(
            Path.join([installer_templates, "phx_web", "live", "hooks", "mode_live.ex.eex"]),
            Path.join([lib_web, "live", "hooks", "mode_live.ex"]),
            binding
          )
        end

        if themes = Keyword.get(opts, :theme) do
          themes_list = String.split(themes, ":", trim: true)

          binding =
            Keyword.merge(binding, themes: themes_list, default_locale: List.first(themes_list))

          Mix.shell().info([:green, "* adding theme plug and hook", :reset])

          copy_eex(
            Path.join([installer_templates, "phx_web", "plugs", "theme.ex.eex"]),
            Path.join([lib_web, "plugs", "theme.ex"]),
            binding
          )

          copy_eex(
            Path.join([installer_templates, "phx_web", "live", "hooks", "theme_live.ex.eex"]),
            Path.join([lib_web, "live", "hooks", "theme_live.ex"]),
            binding
          )
        end

        if languages = Keyword.get(opts, :languages) do
          langs_list = String.split(languages, ":", trim: true)

          binding =
            Keyword.merge(binding, languages: langs_list, default_locale: List.first(langs_list))

          Mix.shell().info([:green, "* adding locale plug and shared events", :reset])

          copy_eex(
            Path.join([installer_templates, "phx_web", "plugs", "locale.ex.eex"]),
            Path.join([lib_web, "plugs", "locale.ex"]),
            binding
          )

          copy_eex(
            Path.join([installer_templates, "phx_web", "live", "shared_events.ex.eex"]),
            Path.join([lib_web, "live", "shared_events.ex"]),
            binding
          )
        end
      end
    end

    defp copy_eex(src, dst, binding) do
      if File.exists?(src) do
        content = EEx.eval_file(src, binding: binding)
        File.mkdir_p!(Path.dirname(dst))
        File.write!(dst, content)
      end
    end
  end
end
