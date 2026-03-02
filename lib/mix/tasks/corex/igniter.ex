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

      if prefix = Keyword.get(opts, :prefix) do
        if prefix == "" or (is_binary(prefix) and String.trim(prefix) == "") do
          Mix.raise("--prefix must be non-empty, got: #{inspect(prefix)}")
        end
      end

      if only_str = Keyword.get(opts, :only) do
        parts = String.split(only_str, ":", trim: true)
        valid = Corex.component_keys() |> Enum.map(&to_string/1)
        invalid = Enum.reject(parts, &(&1 in valid))

        if invalid != [] do
          Mix.raise(
            "--only contains invalid components: #{inspect(invalid)}. Valid: #{inspect(valid)}"
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
      preserve? = Keyword.get(opts, :preserve, false)

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
      |> ensure_layouts_exist!(layouts_path, project_path)
      |> add_corex_config(web_namespace)
      |> add_rtl_config(opts)
      |> patch_app_js(app_js_path, opts)
      |> patch_esbuild_config(config_path, otp_app, preserve?)
      |> patch_root_layout(root_layout_path, web_app_str, design?, preserve?, opts)
      |> create_corex_root(web_path, web_app_str, project_path, otp_app, design?, preserve?, opts)
      |> add_corex_app_to_layouts(layouts_path, preserve?, design?)
      |> add_esbuild_corex_profile(config_path, otp_app, preserve?, design?)
      |> add_corex_mix_alias(otp_app, preserve?, design?)
      |> patch_html_helpers(web_ex_path, opts)
      |> patch_app_css(app_css_path, design?, preserve?, opts)
      |> create_corex_page(web_path, web_app_str, project_path, web_namespace, preserve?, design?)
      |> replace_root_route(web_path, web_app_str, project_path, web_namespace, preserve?)
      |> remove_daisy_vendor_files(web_path, project_path, preserve?, design?)
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

    def patch_app_js(igniter, app_js_path, opts) do
      if Keyword.get(opts, :preserve, false) do
        igniter
      else
        if Igniter.exists?(igniter, app_js_path) do
          igniter
          |> Igniter.include_existing_file(app_js_path, required?: false)
          |> Igniter.update_file(app_js_path, &patch_app_js_content(&1, app_js_path, opts))
        else
          igniter
        end
      end
    end

    defp patch_app_js_content(source, app_js_path, opts) do
      if source.content =~ ~r/from "corex"/ do
        source
      else
        only = Keyword.get(opts, :only)
        {import_line, hooks_line} = app_js_corex_lines(only)

        new_content =
          source.content
          |> String.replace(~r/(import topbar from)/, import_line <> "\n\\1")
          |> String.replace(~r/hooks: \{\.\.\.colocatedHooks\}/, hooks_line)

        update_app_js_or_warn(source, source.content, new_content, app_js_path, only)
      end
    end

    defp app_js_corex_lines(nil) do
      {~s|import corex from "corex"|, "hooks: {...colocatedHooks, ...corex}"}
    end

    defp app_js_corex_lines(only_str) do
      atoms =
        only_str
        |> String.split(":", trim: true)
        |> Enum.map(&String.to_atom/1)
        |> Enum.filter(&(&1 in Corex.component_keys()))

      pascal = Enum.map(atoms, &Phoenix.Naming.camelize(to_string(&1)))
      hooks_arg = inspect(pascal)
      {~s|import { hooks } from "corex"|, "hooks: {...colocatedHooks, ...hooks(#{hooks_arg})}"}
    end

    defp update_app_js_or_warn(source, content, new_content, app_js_path, only) do
      if new_content == content do
        {import_line, hooks_line} = app_js_corex_lines(only)

        {:warning,
         """
         Could not patch #{app_js_path} (structure may differ). Add manually:

           #{import_line}
           #{hooks_line}
         """}
      else
        Rewrite.Source.update(source, :content, new_content)
      end
    end

    def patch_esbuild_config(igniter, config_path, _otp_app, preserve?) do
      if preserve? do
        igniter
      else
        igniter
        |> Igniter.include_existing_file(config_path, required?: true)
        |> Igniter.update_file(config_path, &patch_esbuild_content(&1, config_path))
      end
    end

    defp patch_esbuild_content(source, config_path) do
      if source.content =~ ~r/--format=esm/ do
        source
      else
        new_content =
          String.replace(source.content, ~r/(--bundle )/, "\\1--format=esm --splitting ")

        update_esbuild_or_warn(source, source.content, new_content, config_path)
      end
    end

    defp update_esbuild_or_warn(source, content, new_content, config_path) do
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

    defp ensure_layouts_exist!(igniter, layouts_path, project_path) do
      abs_layouts = Path.join(project_path, layouts_path)

      if Igniter.exists?(igniter, layouts_path) or File.exists?(abs_layouts) do
        igniter
      else
        Mix.raise("""
        Layouts module not found. Create lib/<web_app>/components/layouts.ex first, then run:

            mix corex.install
        """)
      end
    end

    def add_corex_app_to_layouts(igniter, layouts_path, preserve?, design?) do
      if preserve? do
        igniter
      else
        if Igniter.exists?(igniter, layouts_path) do
          igniter
          |> Igniter.include_existing_file(layouts_path, required?: false)
          |> Igniter.update_elixir_file(
            layouts_path,
            &update_layouts_zipper(&1, layouts_path, preserve?, design?),
            required?: false
          )
        else
          igniter
        end
      end
    end

    defp update_layouts_zipper(zipper, layouts_path, preserve?, design?) do
      if preserve? do
        add_corex_app_zipper(zipper, layouts_path, design?)
      else
        replace_app_and_remove_theme_toggle_zipper(zipper, layouts_path, design?)
      end
    end

    defp add_corex_app_zipper(zipper, layouts_path, design?) do
      if has_corex_app?(zipper) do
        {:ok, zipper}
      else
        toast_block = toast_group_block(design?)

        corex_app_code = """
          attr :flash, :map, required: true, doc: "the map of flash messages"

          def corex_app(assigns) do
            ~H\"\"\"
            <div class="typo layout">
              #{toast_block}
              <main class="layout__main">
                <div class="layout__content">
                  {@inner_content}
                </div>
              </main>
            </div>
            \"\"\"
          end
        """

        with {:ok, zipper} <- Igniter.Code.Module.move_to_defmodule(zipper),
             {:ok, zipper} <- Igniter.Code.Common.move_to_do_block(zipper),
             zipper <- Igniter.Code.Common.rightmost(zipper),
             zipper <- Igniter.Code.Common.add_code(zipper, corex_app_code, placement: :after) do
          {:ok, zipper}
        else
          _ ->
            {:warning,
             Igniter.Util.Warning.formatted_warning(
               "Could not add corex_app to #{layouts_path}. Add manually before the final `end`:",
               corex_app_code
             )}
        end
      end
    end

    defp has_corex_app?(zipper) do
      str = Sourceror.Zipper.root(zipper) |> Sourceror.to_string()
      str =~ ~r/def corex_app\(/
    end

    defp toast_group_block(design?) do
      toast_class = if design?, do: ~s| class="toast"|, else: ""

      """
      <.toast_group id="layout-toast"#{toast_class} flash={@flash}>
        <:loading>
          <.icon name="hero-arrow-path" />
        </:loading>
      </.toast_group>
      <.toast_client_error
        toast_group_id="layout-toast"
        title={gettext("We can't find the internet")}
        description={gettext("Attempting to reconnect")}
        type={:error}
        duration={:infinity}
      />
      <.toast_server_error
        toast_group_id="layout-toast"
        title={gettext("Something went wrong!")}
        description={gettext("Attempting to reconnect")}
        type={:error}
        duration={:infinity}
      />
      """
    end

    defp replace_app_and_remove_theme_toggle_zipper(zipper, layouts_path, design?) do
      content = Sourceror.Zipper.root(zipper) |> Sourceror.to_string()

      if content =~ ~r/def app\(assigns\) do[\s\S]*?id="layout-toast"/ do
        {:ok, zipper}
      else
        do_replace_app_and_remove_theme_toggle_zipper(zipper, layouts_path, design?)
      end
    end

    defp do_replace_app_and_remove_theme_toggle_zipper(zipper, layouts_path, design?) do
      toast_block = toast_group_block(design?)

      corex_app_body =
        "    <div class=\"typo layout\">\n" <>
          toast_block <>
          "\n    <main class=\"layout__main\">\n" <>
          "      <div class=\"layout__content\">\n" <>
          "        {assigns[:inner_content] || render_slot(@inner_block)}\n" <>
          "      </div>\n" <>
          "    </main>\n" <>
          "    </div>"

      content = Sourceror.Zipper.root(zipper) |> Sourceror.to_string()
      content_without_flash = remove_flash_group(content)

      zipper =
        content_without_flash
        |> Sourceror.parse_string!()
        |> Sourceror.Zipper.zip()
        |> Igniter.Code.Common.remove(theme_toggle_predicate())

      result = apply_layout_replacements(zipper, corex_app_body)

      if result == content_without_flash do
        {:warning,
         Igniter.Util.Warning.formatted_warning(
           "Could not replace app and remove theme_toggle in #{layouts_path}.",
           ~s|# Replace def app/1 body with Corex layout|
         )}
      else
        {:ok, result |> Sourceror.parse_string!() |> Sourceror.Zipper.zip()}
      end
    end

    defp theme_toggle_predicate do
      fn z ->
        node = Sourceror.Zipper.node(z)

        cond do
          match?({:def, _, [{:theme_toggle, _, _} | _]}, node) -> true
          match?({:@, _, [{:doc, _, _} | _]}, node) -> next_def_name(z) == :theme_toggle
          true -> false
        end
      end
    end

    defp apply_layout_replacements(zipper, corex_app_body) do
      slot_regex = ~r/slot :inner_block, required: true/
      li_regex = ~r/\s*<li>\s*<\.theme_toggle \/>\s*<\/li>/
      app_def_regex = ~r/(def app\(assigns\) do\s*\n\s*~H""")[\s\S]*?("""\s*\n\s*end)/

      zipper
      |> Sourceror.Zipper.root()
      |> Sourceror.to_string()
      |> String.replace(slot_regex, "slot :inner_block")
      |> String.replace(li_regex, "")
      |> String.replace(app_def_regex, "\\1\n#{corex_app_body}\n\\2")
    end

    defp remove_flash_group(content) do
      zipper = Sourceror.parse_string!(content) |> Sourceror.Zipper.zip()
      pred = flash_group_predicate()
      updated_zipper = Igniter.Code.Common.remove(zipper, pred)
      Sourceror.Zipper.root(updated_zipper) |> Sourceror.to_string()
    end

    defp flash_group_predicate do
      fn z ->
        node = Sourceror.Zipper.node(z)

        cond do
          match?({:def, _, [{:flash_group, _, _} | _]}, node) -> true
          match?({:@, _, [{:doc, _, _} | _]}, node) -> next_def_name(z) == :flash_group
          match?({:attr, _, _}, node) -> next_def_name(z) == :flash_group
          true -> false
        end
      end
    end

    defp next_def_name(zipper) do
      case Sourceror.Zipper.right(zipper) do
        nil ->
          nil

        right_z ->
          case Sourceror.Zipper.node(right_z) do
            {:def, _, [{name, _, _} | _]} -> name
            _ -> next_def_name(right_z)
          end
      end
    end

    defp create_corex_page(
           igniter,
           web_path,
           web_app_str,
           project_path,
           web_namespace,
           preserve?,
           design?
         ) do
      create_corex_page_impl(
        igniter,
        web_path,
        web_app_str,
        project_path,
        web_namespace,
        preserve?,
        design?
      )
    end

    defp corex_landing_content(design?) do
      navigate_attrs =
        if design? do
          "      external\n      class=\"button button--brand button--sm md:button--md w-full md:w-auto\""
        else
          "external"
        end

      """
      <section class="gap-ui-sm sm:gap-ui md:gap-ui-lg py-ui sm:py-ui-lg md:py-ui-xl px-ui-padding-xl relative mx-auto flex max-w-(--container-ui-xl) flex-col justify-between">
        <h1 class="my-0 text-4xl md:text-6xl">
          Build <span class="text-root--success">fast</span>,
          <span class="text-root--success">accessible</span>
          and <span class="text-root--success">interactive</span>
          websites
          <span class="whitespace-nowrap">
            with <span class="text-root--brand rounded-full whitespace-nowrap">Corex</span>
          </span>
        </h1>

        <p class="md:text-ui-lg my-0">
          From design tokens to accessible, interactive components, Corex provides a complete foundation for creating beautiful, scalable, and performant websites.
        </p>
        <div class="gap-ui-gap p-ui-padding flex flex-wrap justify-start">
          <.navigate
            to="https://hexdocs.pm/corex"
            #{navigate_attrs}
          >
            Hex Documentation <.icon name="hero-arrow-top-right-on-square" />
          </.navigate>
        </div>
      </section>
      """
    end

    defp create_corex_page_impl(
           igniter,
           web_path,
           web_app_str,
           project_path,
           web_namespace,
           preserve?,
           design?
         ) do
      page_html_dir = Path.join([web_path, "lib", web_app_str, "controllers", "page_html"])
      corex_page_path = Path.join(page_html_dir, "corex_page.html.heex")
      rel_corex_page = Path.relative_to(corex_page_path, project_path)
      home_page_path = Path.join(page_html_dir, "home.html.heex")
      rel_home_page = Path.relative_to(home_page_path, project_path)

      page_controller_path =
        Path.join([web_path, "lib", web_app_str, "controllers", "page_controller.ex"])

      rel_page_controller = Path.relative_to(page_controller_path, project_path)
      content = corex_landing_content(design?)

      if preserve? do
        igniter
        |> Igniter.mkdir(page_html_dir)
        |> Igniter.create_or_update_file(
          rel_corex_page,
          content,
          fn source -> Rewrite.Source.update(source, :content, content) end
        )
        |> Igniter.add_notice("* creating corex_page.html.heex")
        |> add_corex_page_action(rel_page_controller, web_namespace, preserve?)
      else
        igniter
        |> Igniter.mkdir(page_html_dir)
        |> Igniter.create_or_update_file(
          rel_home_page,
          content,
          fn source -> Rewrite.Source.update(source, :content, content) end
        )
        |> maybe_add_home_overwrite_notice(project_path, rel_home_page, content)
        |> patch_home_action_for_corex_layout(
          rel_page_controller,
          web_namespace,
          design?,
          preserve?
        )
        |> patch_page_controller_test(web_path, web_app_str, project_path)
      end
    end

    defp maybe_add_home_overwrite_notice(igniter, project_path, rel_home_page, content) do
      abs_path = Path.join(project_path, rel_home_page)

      if not File.exists?(abs_path) or File.read!(abs_path) != content do
        Igniter.add_notice(igniter, "* overwriting home.html.heex with Corex landing")
      else
        igniter
      end
    end

    defp patch_page_controller_test(igniter, _web_path, web_app_str, project_path) do
      page_controller_test_path =
        Path.join([project_path, "test", web_app_str, "controllers", "page_controller_test.exs"])

      rel_test = Path.relative_to(page_controller_test_path, project_path)

      if Igniter.exists?(igniter, rel_test) do
        igniter
        |> Igniter.include_existing_file(rel_test, required?: false)
        |> Igniter.update_elixir_file(
          rel_test,
          &patch_page_controller_test_zipper/1,
          required?: false
        )
      else
        igniter
      end
    end

    defp patch_page_controller_test_zipper(zipper) do
      phoenix_assertion_str =
        ~s|assert html_response(conn, 200) =~ "Peace of mind from prototype to production"|

      corex_assertions_code = """
      assert html_response(conn, 200) =~ "Build"
      assert html_response(conn, 200) =~ "Corex"
      """

      pred = fn z ->
        str = Sourceror.to_string(z)
        str == phoenix_assertion_str or String.trim(str) == phoenix_assertion_str
      end

      fun = fn _z ->
        new_ast = Sourceror.parse_string!(corex_assertions_code)
        {:code, new_ast}
      end

      case Igniter.Code.Common.update_all_matches(zipper, pred, fun) do
        {:ok, updated} -> {:ok, updated}
        other -> other
      end
    end

    defp patch_home_action_for_corex_layout(
           igniter,
           page_controller_path,
           web_namespace,
           design?,
           preserve?
         ) do
      if preserve? do
        igniter
      else
        if Igniter.exists?(igniter, page_controller_path) and design? do
          layout_module = Module.concat([web_namespace, Layouts])
          layout_name = if preserve?, do: :corex_app, else: :app

          igniter
          |> Igniter.include_existing_file(page_controller_path, required?: false)
          |> Igniter.update_elixir_file(
            page_controller_path,
            &patch_home_action_zipper(&1, layout_module, layout_name),
            required?: false
          )
        else
          igniter
        end
      end
    end

    defp patch_home_action_zipper(zipper, layout_module, layout_name) do
      content = Sourceror.Zipper.root(zipper) |> Sourceror.to_string()
      layout_pattern = ~r/put_layout\(html: \{[^}]+, :#{layout_name}\}\)/

      if content =~ layout_pattern do
        {:ok, zipper}
      else
        insert =
          "conn\n    |> put_layout(html: {#{inspect(layout_module)}, #{inspect(layout_name)}})\n    |> render(:home)"

        new_content =
          content
          |> String.replace(
            ~r/(def home\(conn, _params\) do)\s*\n\s*conn\s*\n\s*\|>\s*render\(:home\)/s,
            "\\1\n    " <> insert
          )
          |> String.replace(
            ~r/(def home\(conn, _params\) do)\s*\n\s*render\(conn,\s*:home\)/s,
            "\\1\n    " <> insert
          )
          |> String.replace(
            ~r/(def home\(conn, _params\) do)\s*\n\s*render\(conn, :home\)/s,
            "\\1\n    " <> insert
          )

        if new_content != content do
          {:ok, Sourceror.parse_string!(new_content) |> Sourceror.Zipper.zip()}
        else
          {:ok, zipper}
        end
      end
    end

    defp add_corex_page_action(igniter, page_controller_path, web_namespace, preserve?) do
      if Igniter.exists?(igniter, page_controller_path) do
        igniter
        |> Igniter.include_existing_file(page_controller_path, required?: false)
        |> Igniter.update_elixir_file(
          page_controller_path,
          &add_corex_page_action_zipper(&1, page_controller_path, web_namespace, preserve?),
          required?: false
        )
      else
        igniter
      end
    end

    defp add_corex_page_action_zipper(zipper, page_controller_path, web_namespace, preserve?) do
      layout_module = Module.concat([web_namespace, Layouts])

      has_corex_page? =
        case Igniter.Code.Function.move_to_def(zipper, :corex_page, 2) do
          {:ok, _} -> true
          :error -> false
        end

      if has_corex_page? do
        {:ok, zipper}
      else
        content = Sourceror.Zipper.root(zipper) |> Sourceror.to_string()
        insert = corex_page_action_insert(layout_module, preserve?)
        manual_example = corex_page_action_manual(layout_module, preserve?)

        new_content =
          if content =~ ~r/def home\(conn, _params\) do/ do
            String.replace(
              content,
              ~r/(def home\(conn, _params\) do)/,
              insert <> "\\1"
            )
          else
            content
          end

        if new_content != content do
          new_ast = Sourceror.parse_string!(new_content)
          {:ok, Sourceror.Zipper.zip(new_ast)}
        else
          {:warning,
           Igniter.Util.Warning.formatted_warning(
             "Could not add corex_page to #{page_controller_path}. Add manually:",
             manual_example
           )}
        end
      end
    end

    defp corex_page_action_insert(layout_module, true) do
      [web_ns | _] = Module.split(layout_module)
      corex_layouts = Module.concat([web_ns, "CorexLayouts"])

      "  def corex_page(conn, _params) do\n    conn\n    |> put_root_layout(html: {#{inspect(corex_layouts)}, :corex_root})\n    |> put_layout(html: {#{inspect(corex_layouts)}, :root})\n    |> render(:corex_page)\n  end\n\n  "
    end

    defp corex_page_action_insert(layout_module, false) do
      "  def corex_page(conn, _params) do\n    conn\n    |> put_layout(html: {#{inspect(layout_module)}, :corex_app})\n    |> render(:corex_page)\n  end\n\n  "
    end

    defp corex_page_action_manual(layout_module, true) do
      [web_ns | _] = Module.split(layout_module)
      corex_layouts = Module.concat([web_ns, "CorexLayouts"])

      "def corex_page(conn, _params) do\n  conn\n  |> put_root_layout(html: {#{inspect(corex_layouts)}, :corex_root})\n  |> put_layout(html: {#{inspect(corex_layouts)}, :root})\n  |> render(:corex_page)\nend"
    end

    defp corex_page_action_manual(layout_module, false) do
      "def corex_page(conn, _params) do\n  conn\n  |> put_layout(html: {#{inspect(layout_module)}, :corex_app})\n  |> render(:corex_page)\nend"
    end

    defp replace_root_route(
           igniter,
           web_path,
           web_app_str,
           project_path,
           web_namespace,
           _preserve?
         ) do
      router_path = Path.join([web_path, "lib", web_app_str, "router.ex"])
      rel_router = Path.relative_to(router_path, project_path)
      router = Module.concat([web_namespace, Router])

      if Igniter.exists?(igniter, rel_router) do
        igniter
        |> Igniter.include_existing_file(rel_router, required?: false)
        |> replace_root_route_with_append(rel_router, router, web_namespace)
      else
        igniter
      end
    end

    defp replace_root_route_with_append(igniter, _rel_router, router, web_namespace) do
      {igniter, has_route?} = has_corex_route?(igniter, router)

      if has_route? do
        igniter
      else
        Igniter.Libs.Phoenix.append_to_scope(
          igniter,
          "/",
          ~s|get "/corex", PageController, :corex_page|,
          router: router,
          arg2: web_namespace,
          with_pipelines: [:browser]
        )
      end
    end

    defp has_corex_route?(igniter, router) do
      case Igniter.Project.Module.find_module(igniter, router) do
        {:ok, {igniter, _source, zipper}} ->
          case Igniter.Code.Function.move_to_function_call(zipper, :get, 3, fn zipper ->
                 Igniter.Code.Function.argument_equals?(zipper, 0, "/corex")
               end) do
            {:ok, _} -> {igniter, true}
            :error -> {igniter, false}
          end

        {:error, igniter} ->
          {igniter, false}
      end
    end

    def patch_root_layout(igniter, root_layout_path, _web_app_str, design?, preserve?, opts) do
      if design? and not preserve? do
        replace_root_with_corex_template(igniter, root_layout_path, opts)
      else
        igniter
      end
    end

    defp replace_root_with_corex_template(igniter, root_layout_path, opts) do
      if Igniter.exists?(igniter, root_layout_path) do
        igniter
        |> Igniter.include_existing_file(root_layout_path, required?: false)
        |> Igniter.update_file(
          root_layout_path,
          fn source -> Rewrite.Source.update(source, :content, corex_root_template(opts)) end,
          required?: false
        )
      else
        igniter
      end
    end

    def create_corex_root(
          igniter,
          web_path,
          web_app_str,
          project_path,
          otp_app,
          design?,
          preserve?,
          opts
        ) do
      if design? and preserve? do
        web_namespace = Module.concat([Macro.camelize(to_string(otp_app)) <> "Web"])

        igniter
        |> create_corex_layouts_module(web_path, web_app_str, project_path, web_namespace)
        |> create_corex_layouts_templates(web_path, web_app_str, project_path, opts)
        |> create_corex_app_css(web_path, web_app_str, project_path)
        |> create_corex_app_js(web_path, project_path, otp_app)
        |> Igniter.add_notice("* creating CorexLayouts, corex_app.css, corex_app.js")
      else
        igniter
      end
    end

    defp create_corex_layouts_module(igniter, web_path, web_app_str, project_path, web_namespace) do
      components_dir = Path.join(web_path, "lib/#{web_app_str}/components")

      core_layouts_path =
        Path.relative_to(Path.join(components_dir, "core_layouts.ex"), project_path)

      content = """
      defmodule #{inspect(Module.concat([web_namespace, CorexLayouts]))} do
        @moduledoc false
        use #{inspect(web_namespace)}, :html

        embed_templates "core_layouts/*"
      end
      """

      Igniter.create_or_update_file(
        igniter,
        core_layouts_path,
        content,
        fn source -> Rewrite.Source.update(source, :content, content) end
      )
    end

    defp create_corex_layouts_templates(igniter, web_path, web_app_str, project_path, opts) do
      core_layouts_dir = Path.join(web_path, "lib/#{web_app_str}/components/core_layouts")

      corex_root_path =
        Path.relative_to(Path.join(core_layouts_dir, "corex_root.html.heex"), project_path)

      root_path = Path.relative_to(Path.join(core_layouts_dir, "root.html.heex"), project_path)

      corex_root_content = corex_root_template_for_preserve(opts)
      root_content = corex_layout_root_content()

      igniter
      |> Igniter.mkdir(core_layouts_dir)
      |> Igniter.create_or_update_file(corex_root_path, corex_root_content, fn s ->
        Rewrite.Source.update(s, :content, corex_root_content)
      end)
      |> Igniter.create_or_update_file(root_path, root_content, fn s ->
        Rewrite.Source.update(s, :content, root_content)
      end)
    end

    defp corex_root_template_for_preserve(opts) do
      mode_script_block = if Keyword.get(opts, :mode), do: mode_script(), else: ""
      theme_script_block = if theme = Keyword.get(opts, :theme), do: theme_script(theme), else: ""
      scripts = mode_script_block <> theme_script_block

      """
      <!DOCTYPE html>
      <html lang="en" data-theme="neo" data-mode="light">
        <head>
          <meta charset="utf-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <meta name="csrf-token" content={get_csrf_token()} />
          <.live_title default="" suffix="">
            {assigns[:page_title]}
          </.live_title>
          <link phx-track-static rel="stylesheet" href={~p"/assets/css/corex_app.css"} />
          <script defer phx-track-static type="module" src={~p"/assets/js/corex_app.js"}>
          </script>
          #{String.trim(scripts)}
        </head>
        <body class="typo layout">
          {@inner_content}
        </body>
      </html>
      """
    end

    defp corex_layout_root_content do
      """
      <div class="typo layout">
        <.toast_group id="layout-toast" class="toast" flash={@flash}>
          <:loading>
            <.icon name="hero-arrow-path" />
          </:loading>
        </.toast_group>
        <.toast_client_error
          toast_group_id="layout-toast"
          title={gettext("We can't find the internet")}
          description={gettext("Attempting to reconnect")}
          type={:error}
          duration={:infinity}
        />
        <.toast_server_error
          toast_group_id="layout-toast"
          title={gettext("Something went wrong!")}
          description={gettext("Attempting to reconnect")}
          type={:error}
          duration={:infinity}
        />
        <main class="layout__main">
          <div class="layout__content">
            {assigns[:inner_content] || render_slot(@inner_block)}
          </div>
        </main>
      </div>
      """
    end

    defp create_corex_app_css(igniter, web_path, web_app_str, project_path) do
      corex_app_css_path =
        Path.relative_to(Path.join(web_path, "assets/css/corex_app.css"), project_path)

      content = """
      @import "tailwindcss" source(none);
      @source "../css";
      @source "../js";
      @source "../../lib/#{web_app_str}";

      @import "../corex/main.css";
      @import "../corex/tokens/themes/neo/light.css";
      @import "../corex/components/typo.css";
      @import "../corex/components/button.css";
      @import "../corex/components/toast.css";

      @plugin "../vendor/heroicons";
      @custom-variant phx-click-loading (.phx-click-loading&, .phx-click-loading &);
      @custom-variant phx-submit-loading (.phx-submit-loading&, .phx-submit-loading &);
      @custom-variant phx-change-loading (.phx-change-loading&, .phx-change-loading &);
      @custom-variant dark (&:where([data-mode=dark], [data-mode=dark] *));
      [data-phx-session], [data-phx-teleported-src] { display: contents }
      """

      Igniter.create_or_update_file(
        igniter,
        corex_app_css_path,
        content,
        fn source -> Rewrite.Source.update(source, :content, content) end
      )
    end

    defp create_corex_app_js(igniter, web_path, project_path, otp_app) do
      corex_app_js_path =
        Path.relative_to(Path.join(web_path, "assets/js/corex_app.js"), project_path)

      app_str = to_string(otp_app)

      content = """
      import "phoenix_html"
      import {Socket} from "phoenix"
      import {LiveSocket} from "phoenix_live_view"
      import {hooks as colocatedHooks} from "phoenix-colocated/#{app_str}"
      import corex from "corex"
      import topbar from "../vendor/topbar"

      const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
      const liveSocket = new LiveSocket("/live", Socket, {
        longPollFallbackMs: 2500,
        params: {_csrf_token: csrfToken},
        hooks: {...colocatedHooks, ...corex},
      })

      topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
      window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
      window.addEventListener("phx:page-loading-stop", _info => topbar.hide())
      liveSocket.connect()
      window.liveSocket = liveSocket

      if (process.env.NODE_ENV === "development") {
        window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
          reloader.enableServerLogs()
        })
      }
      """

      Igniter.create_or_update_file(
        igniter,
        corex_app_js_path,
        content,
        fn source -> Rewrite.Source.update(source, :content, content) end
      )
    end

    def add_esbuild_corex_profile(igniter, config_path, otp_app, preserve?, design?) do
      if design? and preserve? do
        profile_name = String.to_atom("#{otp_app}_corex")

        igniter
        |> Igniter.include_existing_file(config_path, required?: true)
        |> Igniter.update_elixir_file(config_path, &add_esbuild_profile_zipper(&1, profile_name))
      else
        igniter
      end
    end

    defp add_esbuild_profile_zipper(zipper, profile_name) do
      if Igniter.Project.Config.configures_key?(zipper, :esbuild, profile_name) do
        {:ok, zipper}
      else
        profile_value =
          Sourceror.parse_string!("""
          [
            args:
              ~w(js/corex_app.js --bundle --format=esm --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
            cd: Path.expand("../assets", __DIR__),
            env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
          ]
          """)

        with {:ok, zipper} <-
               Igniter.Code.Function.move_to_function_call_in_current_scope(
                 zipper,
                 :config,
                 [2, 3],
                 &Igniter.Code.Function.argument_equals?(&1, 0, :esbuild)
               ),
             {:ok, zipper} <- Igniter.Code.Function.move_to_nth_argument(zipper, 1),
             true <- Igniter.Code.List.list?(zipper),
             {:ok, zipper} <-
               Igniter.Code.Keyword.put_in_keyword(
                 zipper,
                 [profile_name],
                 profile_value,
                 nil
               ) do
          {:ok, zipper}
        else
          _ -> {:ok, zipper}
        end
      end
    end

    def add_corex_mix_alias(igniter, otp_app, preserve?, design?) do
      if design? and preserve? do
        mix_exs_path = "mix.exs"
        profile_name = "#{otp_app}_corex"

        igniter
        |> Igniter.include_existing_file(mix_exs_path, required?: true)
        |> Igniter.update_elixir_file(mix_exs_path, &add_corex_alias_zipper(&1, profile_name))
      else
        igniter
      end
    end

    defp add_corex_alias_zipper(zipper, profile_name) do
      esbuild_build = Sourceror.parse_string!("\"esbuild #{profile_name}\"")
      esbuild_deploy = Sourceror.parse_string!("\"esbuild #{profile_name} --minify\"")

      with {:ok, zipper} <- Igniter.Code.Module.move_to_module_using(zipper, Mix.Project),
           {:ok, zipper} <- Igniter.Code.Function.move_to_defp(zipper, :aliases, 0),
           zipper <- Igniter.Code.Common.maybe_move_to_single_child_block(zipper),
           true <- Igniter.Code.List.list?(zipper),
           {:ok, _} <- Igniter.Code.Keyword.get_key(zipper, :"assets.build"),
           {:ok, zipper} <-
             Igniter.Code.Keyword.put_in_keyword(zipper, [:"assets.build"], nil, fn zipper ->
               Igniter.Code.List.append_new_to_list(zipper, esbuild_build)
             end),
           {:ok, _} <- Igniter.Code.Keyword.get_key(zipper, :"assets.deploy"),
           {:ok, zipper} <-
             Igniter.Code.Keyword.put_in_keyword(zipper, [:"assets.deploy"], nil, fn zipper ->
               Igniter.Code.List.append_new_to_list(zipper, esbuild_deploy)
             end) do
        {:ok, zipper}
      else
        _ -> {:ok, zipper}
      end
    end

    defp simple_root_attrs?(opts) when is_list(opts) do
      [
        Keyword.get(opts, :mode),
        Keyword.get(opts, :theme),
        Keyword.get(opts, :languages),
        Keyword.get(opts, :rtl)
      ]
      |> Enum.all?(&is_nil/1)
    end

    defp simple_root_attrs?(_), do: true

    defp corex_root_html_attrs_dynamic do
      """
      lang={assigns[:locale] || "en"}
        dir={
          assigns[:dir] ||
            if(assigns[:locale] in Application.get_env(:corex, :rtl_locales, []),
              do: "rtl",
              else: "ltr"
            )
        }
        data-theme={assigns[:theme] || "neo"}
        data-mode={assigns[:mode] || "light"}
      """
    end

    defp corex_root_template(opts) do
      mode_script_block = if Keyword.get(opts, :mode), do: mode_script(), else: ""
      theme_script_block = if theme = Keyword.get(opts, :theme), do: theme_script(theme), else: ""
      scripts = mode_script_block <> theme_script_block

      html_open =
        if simple_root_attrs?(opts) do
          "<html lang=\"en\" data-theme=\"neo\" data-mode=\"light\">"
        else
          html_attrs = corex_root_html_attrs_dynamic()

          """
          <html
            #{html_attrs}
          >
          """
          |> String.trim()
        end

      """
      <!DOCTYPE html>
      #{html_open}
        <head>
          <meta charset="utf-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <meta name="csrf-token" content={get_csrf_token()} />
          <.live_title default="" suffix="">
            {assigns[:page_title]}
          </.live_title>
          <link phx-track-static rel="stylesheet" href={~p"/assets/css/app.css"} />
          <script defer phx-track-static type="module" src={~p"/assets/js/app.js"}>
          </script>
          #{String.trim(scripts)}
        </head>
        <body class="typo layout">
          {@inner_content}
        </body>
      </html>
      """
    end

    defp mode_script do
      """
          <script>
            (() => {
              const getSystemMode = () =>
                window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";

              const setMode = (mode) => {
                const resolved = mode === "dark" || mode === "light" ? mode : getSystemMode();
                localStorage.setItem("phx:mode", resolved);
                document.cookie = "phx_mode=" + resolved + "; path=/; max-age=31536000";
                document.documentElement.setAttribute("data-mode", resolved);
              };

              setMode(localStorage.getItem("phx:mode") || document.documentElement.getAttribute("data-mode") || getSystemMode());

              window.addEventListener("storage", (e) => e.key === "phx:mode" && e.newValue && setMode(e.newValue));

              window.addEventListener("phx:set-mode", (e) => {
                const value = e.detail?.value;
                const mode = Array.isArray(value) && value[0] ? value[0] : "light";
                setMode(mode);
              });
            })();
          </script>
      """
    end

    defp theme_script(theme_opts) when is_binary(theme_opts) do
      themes = theme_opts |> String.split(":", trim: true)
      themes_json = themes |> Enum.map(&("\"" <> &1 <> "\"")) |> Enum.join(", ")

      """
          <script>
            (() => {
              const validThemes = [#{themes_json}];
              const defaultTheme = "#{List.first(themes)}";
              const setTheme = (theme) => {
                const resolved = validThemes.includes(theme) ? theme : defaultTheme;
                localStorage.setItem("phx:theme", resolved);
                document.cookie = "phx_theme=" + resolved + "; path=/; max-age=31536000";
                document.documentElement.setAttribute("data-theme", resolved);
              };

              setTheme(localStorage.getItem("phx:theme") || document.documentElement.getAttribute("data-theme") || defaultTheme);

              window.addEventListener("storage", (e) => e.key === "phx:theme" && e.newValue && setTheme(e.newValue));

              window.addEventListener("phx:set-theme", (e) => {
                const value = e.detail?.value;
                const theme = Array.isArray(value) && value[0] ? value[0] : defaultTheme;
                setTheme(theme);
              });
            })();
          </script>
      """
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

    def patch_html_helpers(igniter, web_ex_path, opts) do
      if Igniter.exists?(igniter, web_ex_path) do
        igniter
        |> Igniter.include_existing_file(web_ex_path, required?: false)
        |> Igniter.update_elixir_file(
          web_ex_path,
          &patch_html_helpers_zipper(&1, web_ex_path, opts),
          required?: false
        )
      else
        igniter
      end
    end

    defp patch_html_helpers_zipper(zipper, web_ex_path, opts) do
      use_corex? =
        Igniter.Code.Common.move_to(zipper, fn z ->
          Igniter.Code.Function.function_call?(z, :use, [1, 2]) and
            Igniter.Code.Function.argument_equals?(z, 0, Corex)
        end) != :error

      if use_corex? do
        {:ok, zipper}
      else
        add_use_corex_or_warn(zipper, web_ex_path, opts)
      end
    end

    defp add_use_corex_or_warn(zipper, web_ex_path, opts) do
      use_corex_code = build_use_corex(opts)

      import_predicate = fn z ->
        Igniter.Code.Function.function_call?(z, :import, 1) and
          Igniter.Code.Function.argument_matches_predicate?(z, 0, fn arg_z ->
            str = Sourceror.to_string(Sourceror.Zipper.node(arg_z))
            is_binary(str) and str =~ ~r/\.CoreComponents/
          end)
      end

      case Igniter.Code.Common.move_to(zipper, import_predicate) do
        {:ok, import_zipper} ->
          {:ok, Igniter.Code.Common.add_code(import_zipper, use_corex_code, placement: :after)}

        :error ->
          {:warning,
           Igniter.Util.Warning.formatted_warning(
             "Could not patch #{web_ex_path}. Add manually in html/0 block:",
             use_corex_code
           )}
      end
    end

    defp build_use_corex(opts) do
      prefix = Keyword.get(opts, :prefix)
      only_str = Keyword.get(opts, :only)

      cond do
        prefix != nil and only_str != nil ->
          atoms =
            only_str
            |> String.split(":", trim: true)
            |> Enum.map(&String.to_atom/1)
            |> Enum.filter(&(&1 in Corex.component_keys()))

          ~s|use Corex, only: #{inspect(atoms)}, prefix: "#{prefix}"|

        only_str != nil ->
          atoms =
            only_str
            |> String.split(":", trim: true)
            |> Enum.map(&String.to_atom/1)
            |> Enum.filter(&(&1 in Corex.component_keys()))

          ~s|use Corex, only: #{inspect(atoms)}|

        prefix != nil and prefix != "" ->
          ~s|use Corex, prefix: "#{prefix}"|

        true ->
          "use Corex"
      end
    end

    def patch_app_css(igniter, app_css_path, design?, preserve?, _opts) do
      if preserve? do
        igniter
      else
        if Igniter.exists?(igniter, app_css_path) and design? do
          igniter
          |> Igniter.include_existing_file(app_css_path, required?: false)
          |> Igniter.update_file(
            app_css_path,
            &patch_app_css_content(&1, design?, preserve?),
            required?: false
          )
        else
          igniter
        end
      end
    end

    defp patch_app_css_content(source, design?, preserve?) do
      case add_corex_imports(source.content, design?) do
        {:warning, _} = warn ->
          warn

        content ->
          updated =
            content
            |> patch_data_mode(design?)
            |> remove_daisy_css(preserve?)

          Rewrite.Source.update(source, :content, updated)
      end
    end

    def remove_daisy_vendor_files(igniter, web_path, project_path, preserve?, design?) do
      if design? and not preserve? do
        vendor_path = Path.join(web_path, "assets/vendor")
        daisyui_js = Path.relative_to(Path.join(vendor_path, "daisyui.js"), project_path)

        daisyui_theme_js =
          Path.relative_to(Path.join(vendor_path, "daisyui-theme.js"), project_path)

        igniter
        |> maybe_rm(project_path, daisyui_js)
        |> maybe_rm(project_path, daisyui_theme_js)
      else
        igniter
      end
    end

    defp maybe_rm(igniter, project_path, rel_path) do
      abs_path = Path.join(project_path, rel_path)
      if File.exists?(abs_path), do: Igniter.rm(igniter, rel_path), else: igniter
    end

    defp remove_daisy_css(content, true), do: content

    defp remove_daisy_css(content, false) do
      content
      |> String.replace(~r/\s*@import "daisyui";\s*\n/, "")
      |> String.replace(~r/\s*@import "daisyui\/css\/unstyled";\s*\n/, "")
      |> String.replace(~r/\s*@import "daisyui\/css\/styled";\s*\n/, "")
      |> remove_daisy_plugin_blocks()
    end

    defp remove_daisy_plugin_blocks(content) do
      content
      |> String.replace(
        ~r/\n\s*\/\* daisyUI Tailwind Plugin[\s\S]*?@plugin "\.\.\/vendor\/daisyui" \{\s*themes: false;\s*\}\s*\n/,
        "\n"
      )
      |> String.replace(
        ~r/\n\s*\/\* daisyUI theme plugin[\s\S]*?@plugin "\.\.\/vendor\/daisyui-theme" \{\n[\s\S]*?\n\}\s*\n/,
        "\n"
      )
      |> String.replace(
        ~r/\n\s*@plugin "\.\.\/vendor\/daisyui-theme" \{\n[\s\S]*?\n\}\s*\n/,
        "\n",
        global: true
      )
    end

    defp add_corex_imports(content, true) do
      if content =~ ~r/@import "\.\.\/corex\/main\.css"/ do
        content
      else
        imports = """
        @import "../corex/main.css";
        @import "../corex/tokens/themes/neo/light.css";
        @import "../corex/components/typo.css";
        @import "../corex/components/button.css";
        @import "../corex/components/toast.css";

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
          {project_path, web_path, otp_app, web_namespace, web_app_str}
        )

      %{igniter | assigns: assigns}
    end

    def run_config_phase(igniter, opts) do
      {_project_path, _web_path, _otp_app, web_namespace, _web_app_str} =
        assigns_map(igniter)[:corex_project_paths]

      igniter
      |> add_corex_config(web_namespace)
      |> add_rtl_config(opts)
    end

    def run_assets_phase(igniter, opts) do
      {project_path, web_path, otp_app, _web_namespace, _web_app_str} =
        assigns_map(igniter)[:corex_project_paths]

      app_js_path = Path.relative_to(Path.join(web_path, "assets/js/app.js"), project_path)
      config_path = Path.join("config", "config.exs")
      preserve? = Keyword.get(opts, :preserve, false)

      igniter
      |> patch_app_js(app_js_path, opts)
      |> patch_esbuild_config(config_path, otp_app, preserve?)
    end

    def run_layout_phase(igniter, opts) do
      {project_path, web_path, otp_app, web_namespace, web_app_str} =
        assigns_map(igniter)[:corex_project_paths]

      design? = Keyword.get(opts, :design, true)
      preserve? = Keyword.get(opts, :preserve, false)
      config_path = Path.join("config", "config.exs")

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
      |> patch_root_layout(root_layout_path, web_app_str, design?, preserve?, opts)
      |> create_corex_root(web_path, web_app_str, project_path, otp_app, design?, preserve?, opts)
      |> add_corex_app_to_layouts(layouts_path, preserve?, design?)
      |> add_esbuild_corex_profile(config_path, otp_app, preserve?, design?)
      |> add_corex_mix_alias(otp_app, preserve?, design?)
      |> patch_html_helpers(web_ex_path, opts)
      |> create_corex_page(web_path, web_app_str, project_path, web_namespace, preserve?, design?)
      |> replace_root_route(web_path, web_app_str, project_path, web_namespace, preserve?)
      |> remove_daisy_vendor_files(web_path, project_path, preserve?, design?)
    end

    def run_css_phase(igniter, opts) do
      {project_path, web_path, _otp_app, _web_namespace, _web_app_str} =
        assigns_map(igniter)[:corex_project_paths]

      app_css_path = Path.relative_to(Path.join(web_path, "assets/css/app.css"), project_path)
      design? = Keyword.get(opts, :design, true)
      preserve? = Keyword.get(opts, :preserve, false)

      igniter
      |> patch_app_css(app_css_path, design?, preserve?, opts)
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
        |> maybe_add_gettext_dep()
      else
        igniter
      end
    end

    defp maybe_add_gettext_dep(igniter) do
      if Igniter.Project.Deps.has_dep?(igniter, :gettext) do
        igniter
      else
        Igniter.Project.Deps.add_dep(igniter, {:gettext, "~> 1.0"},
          append?: true,
          on_exists: :skip
        )
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
