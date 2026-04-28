defmodule Mix.Corex.Install.Layouts do
  @moduledoc false

  alias Igniter.Code.{Common, Function}
  alias Igniter.Project.Module, as: ProjectModule
  alias Mix.Corex.Install.{Config, LayoutBuilder, Templates, Web}

  def patch_root_layout(igniter, web_mod, themes, opts) do
    dir = Web.web_ex_dir(igniter, web_mod)
    path = Path.join([dir, "components", "layouts", "root.html.heex"])

    first_theme = List.first(themes) || "neo"

    Igniter.update_file(igniter, path, fn source ->
      content = source.content
      content_after_script = patch_script_type(content)

      i18n? = Keyword.get(opts, :lang, false)

      if content_after_script == content and
           not (String.contains?(content, "type=\"module\"") or
                  String.contains?(content, "type='module'")) and
           not String.contains?(content, "<script defer phx-track-static ") do
        {:notice,
         "Could not find `<script defer phx-track-static` in root layout. Add `type=\"module\"` to the app script tag manually."}
      else
        pre_html = strip_stock_phx_daisy_theme_script(content_after_script)

        content =
          transform_root_html(pre_html, web_mod, themes, opts, i18n?, first_theme)
          |> maybe_insert_theme_mode_bridge(themes, opts)
          |> maybe_merge_design_body_class(opts)

        Rewrite.Source.update(source, :content, content)
      end
    end)
  end

  defp patch_script_type(content) do
    cond do
      String.contains?(content, "type=\"module\"") or
          String.contains?(content, "type='module'") ->
        content

      String.contains?(content, ~s(type="text/javascript")) ->
        String.replace(
          content,
          ~s(type="text/javascript"),
          ~s(type="module"),
          global: false
        )

      String.contains?(content, "<script defer phx-track-static ") ->
        String.replace(
          content,
          "<script defer phx-track-static ",
          ~s(<script defer phx-track-static type="module" ),
          global: false
        )

      true ->
        content
    end
  end

  defp transform_root_html(pre_html, web_mod, themes, opts, true, first_theme) do
    transform_root_html_when_i18n(pre_html, web_mod, themes, opts, first_theme)
  end

  defp transform_root_html(pre_html, _web_mod, themes, opts, false, first_theme) do
    transform_root_html_when_no_i18n(pre_html, themes, opts, first_theme)
  end

  defp transform_root_html_when_i18n(pre_html, web_mod, themes, opts, first_theme) do
    if String.contains?(pre_html, "LocalizeLayout.html_lang") do
      pre_html
    else
      merge_i18n_root_html_open_tag(pre_html, web_mod, themes, opts, first_theme)
    end
  end

  defp transform_root_html_when_no_i18n(pre_html, themes, opts, first_theme) do
    cond do
      opts[:mode] || themes != [] ->
        transform_root_html_for_mode_or_themes(pre_html, first_theme)

      Config.design_on?(opts) ->
        Regex.replace(
          ~r/<html[^>]*>/u,
          pre_html,
          "<html lang=\"en\" data-theme=\"neo\" data-mode=\"light\">",
          global: false
        )

      true ->
        pre_html
    end
  end

  defp merge_i18n_root_html_open_tag(pre_html, web_mod, themes, opts, first_theme) do
    mode_theme? = opts[:mode] == true or themes != []
    first_theme = first_theme || "neo"

    Regex.replace(
      ~r/<html([\s\S]*?)>/u,
      pre_html,
      fn _full, attrs_inner ->
        attrs_inner = attrs_inner || ""
        rest = strip_lang_dir_attrs(attrs_inner)
        rest = if mode_theme?, do: strip_data_theme_mode_attrs(rest), else: rest

        lang_dir =
          "lang={#{inspect(web_mod)}.LocalizeLayout.html_lang(@conn)} dir={#{inspect(web_mod)}.LocalizeLayout.html_dir(@conn)}"

        merged =
          if mode_theme? do
            lang_dir <>
              " data-theme={assigns[:theme] || \"#{first_theme}\"} data-mode={assigns[:mode] || \"light\"}"
          else
            lang_dir
          end

        inner = merged <> if rest == "", do: "", else: " " <> rest
        "<html " <> String.trim(inner) <> ">"
      end,
      global: false
    )
  end

  defp strip_lang_dir_attrs(attrs) do
    Enum.reduce(
      [
        ~r/\slang=\{[^\}]*\}/u,
        ~r/\slang="[^"]*"/u,
        ~r/\slang='[^']*'/u,
        ~r/\sdir=\{[^\}]*\}/u,
        ~r/\sdir="[^"]*"/u,
        ~r/\sdir='[^']*'/u
      ],
      attrs,
      fn re, acc -> Regex.replace(re, acc, "") end
    )
    |> String.replace(~r/\s+/u, " ")
    |> String.trim()
  end

  defp strip_data_theme_mode_attrs(attrs) do
    Enum.reduce(
      [
        ~r/\sdata-theme=\{[^\}]*\}/u,
        ~r/\sdata-theme="[^"]*"/u,
        ~r/\sdata-mode=\{[^\}]*\}/u,
        ~r/\sdata-mode="[^"]*"/u
      ],
      attrs,
      fn re, acc -> Regex.replace(re, acc, "") end
    )
    |> String.replace(~r/\s+/u, " ")
    |> String.trim()
  end

  defp transform_root_html_for_mode_or_themes(pre_html, first_theme) do
    if html_tag_has_assign_data_theme?(pre_html) do
      pre_html
    else
      Regex.replace(
        ~r/<html(\s[^>]*)?>/u,
        pre_html,
        fn _full, attrs -> html_open_tag_with_locale_assigns(attrs, first_theme) end,
        global: false
      )
    end
  end

  defp html_open_tag_with_locale_assigns(attrs, first_theme) do
    attrs = attrs || ""

    "#{String.trim_trailing("<html" <> attrs, ">")} lang={assigns[:locale] || \"en\"} dir={assigns[:dir] || \"ltr\"} data-theme={assigns[:theme] || \"#{first_theme}\"} data-mode={assigns[:mode] || \"light\"}>"
  end

  def insert_theme_mode_switchers(source) do
    content = source.content

    if String.contains?(content, "id=\"theme-select\"") or
         String.contains?(content, "id=\"mode-switcher\"") do
      source
    else
      snippet = """

      <div class="flex items-center gap-2">
        <.select
          id="theme-select"
          class="select select--sm w-4xs"
          items={[
            %{id: "neo", label: "Neo"},
            %{id: "uno", label: "Uno"},
            %{id: "duo", label: "Duo"},
            %{id: "leo", label: "Leo"}
          ]}
          value={[@theme]}
          on_value_change_client="phx:set-theme"
        >
          <:label class="sr-only">Theme</:label>
          <:item :let={item}>{item.label}</:item>
          <:trigger>Theme</:trigger>
        </.select>

        <.toggle_group
          id="mode-switcher"
          class="toggle-group toggle-group--sm toggle-group--circle"
          value={if @mode == "dark", do: ["dark"], else: []}
          on_value_change_client="phx:set-mode"
        >
          <:item value="dark">Mode</:item>
        </.toggle_group>
      </div>
      """

      cond do
        String.contains?(content, "<.flash_group") ->
          %{
            source
            | content:
                String.replace(content, ~r/(<\.flash_group[^\n]*\n)/, "\\1" <> snippet,
                  global: false
                )
          }

        String.contains?(content, "toast_group") and
            String.contains?(content, "toast_client_error") ->
          insert_switchers_after_toast_marker(source, content, snippet)

        String.contains?(content, "<main") ->
          %{
            source
            | content: String.replace(content, "<main", snippet <> "\n<main", global: false)
          }

        true ->
          {:notice,
           "Could not automatically add theme/mode switchers to the app layout. Add this near the top of your layout:\n\n#{String.trim(snippet)}\n"}
      end
    end
  end

  defp strip_stock_phx_daisy_theme_script(content) do
    if not String.contains?(content, "e.target.dataset.phxTheme") or
         not String.contains?(content, ~s(theme === "system")) do
      content
    else
      regex =
        ~r/^\s*<script>[\s\S]*?const setTheme = \(theme\) => \{[\s\S]*?theme === "system"[\s\S]*?e\.target\.dataset\.phxTheme[\s\S]*?\}\s*\)\(\);[\s\S]*?<\/script>[\s]*/m

      Regex.replace(regex, content, "", global: true)
    end
  end

  defp html_tag_has_assign_data_theme?(content) do
    case Regex.run(~r/<html[^>]*>/u, content) do
      [tag] -> String.contains?(tag, "data-theme=")
      _ -> false
    end
  end

  defp maybe_merge_design_body_class(content, opts) do
    if Config.design_on?(opts) do
      merge_body_typo_layout_class(content)
    else
      content
    end
  end

  def merge_body_typo_layout_class(html) when is_binary(html) do
    extra = "typo layout"

    cond do
      Regex.match?(~r/<body[^>]*\btypo\b[^>]*\blayout\b/u, html) ->
        html

      Regex.match?(~r/<body[^>]*class=\{/u, html) ->
        html

      Regex.match?(~r/<body\s*>/u, html) ->
        Regex.replace(~r/<body\s*>/u, html, ~s(<body class="#{extra}">), global: false)

      Regex.match?(~r/<body\s+class="/u, html) ->
        Regex.replace(
          ~r/(<body\s+class=")([^"]*)(")/u,
          html,
          fn _, a, classes, c ->
            merged =
              (classes <> " " <> extra)
              |> String.split(~r/\s+/, trim: true)
              |> Enum.uniq()
              |> Enum.join(" ")

            a <> merged <> c
          end,
          global: false
        )

      true ->
        Regex.replace(~r/<body(\s[^>]*)>/u, html, "<body\\1 class=\"#{extra}\"", global: false)
    end
  end

  defp maybe_insert_theme_mode_bridge(content, themes, opts) do
    need? = opts[:mode] || themes != []

    if !need? or String.contains?(content, "phx:set-mode") or
         String.contains?(content, "phx:set-theme") do
      content
    else
      first_theme = List.first(themes) || "neo"

      bridge = """

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

              setMode(
                localStorage.getItem("phx:mode") ||
                  document.documentElement.getAttribute("data-mode") ||
                  getSystemMode()
              );

              window.addEventListener(
                "storage",
                (e) => e.key === "phx:mode" && e.newValue && setMode(e.newValue)
              );

              window.addEventListener("phx:set-mode", (e) => {
                const value = e.detail?.value;
                const mode = Array.isArray(value) && value[0] ? value[0] : "light";
                setMode(mode);
              });

              const validThemes = ["neo", "uno", "duo", "leo"];
              const setTheme = (theme) => {
                const resolved = validThemes.includes(theme) ? theme : "#{first_theme}";
                localStorage.setItem("phx:theme", resolved);
                document.cookie = "phx_theme=" + resolved + "; path=/; max-age=31536000";
                document.documentElement.setAttribute("data-theme", resolved);
              };

              setTheme(
                localStorage.getItem("phx:theme") ||
                  document.documentElement.getAttribute("data-theme") ||
                "#{first_theme}"
              );

              window.addEventListener(
                "storage",
                (e) => e.key === "phx:theme" && e.newValue && setTheme(e.newValue)
              );

              window.addEventListener("phx:set-theme", (e) => {
                const value = e.detail?.value;
                const theme = Array.isArray(value) && value[0] ? value[0] : "#{first_theme}";
                setTheme(theme);
              });
            })();
          </script>
      """

      if String.contains?(content, "</head>") do
        String.replace(content, "</head>", bridge <> "\n  </head>", global: false)
      else
        content
      end
    end
  end

  defp insert_switchers_after_toast_marker(source, content, snippet) do
    marker = "      type={:error}\n      duration={:infinity}\n    />"

    if String.contains?(content, marker) do
      %{
        source
        | content: String.replace(content, marker, marker <> snippet, global: false)
      }
    else
      {:notice,
       "Could not add theme/mode switchers: expected Corex toast block before `~H\"\"\"`."}
    end
  end

  def patch_app_layout(igniter, web_mod, themes, opts, i18n?) do
    ldir = Path.join([Web.web_ex_dir(igniter, web_mod), "components", "layouts"])
    app_heex = Path.join(ldir, "app.html.heex")
    lay_ex = Path.join([Web.web_ex_dir(igniter, web_mod), "components", "layouts.ex"])

    igniter
    |> patch_layouts_ex_file(web_mod, lay_ex, themes, opts, i18n?)
    |> patch_app_heex_file(app_heex, themes, opts)
    |> patch_home(web_mod, themes, opts, i18n?)
  end

  defp patch_layouts_ex_file(igniter, web_mod, lay_ex, themes, opts, i18n?) do
    if Igniter.exists?(igniter, lay_ex) do
      layouts_module = Module.concat(web_mod, :Layouts)
      igniter = Igniter.include_existing_file(igniter, lay_ex)

      content =
        case Rewrite.source(igniter.rewrite, lay_ex) do
          {:ok, source} -> Rewrite.Source.get(source, :content)
          _ -> ""
        end

      if LayoutBuilder.stock_phx_app_def?(content) do
        full_replace_app_def(igniter, layouts_module, lay_ex, themes, opts, i18n?)
      else
        patch_app_def(igniter, layouts_module, lay_ex, themes, opts, i18n?)
      end
    else
      igniter
    end
  end

  defp full_replace_app_def(igniter, layouts_module, lay_ex, themes, opts, i18n?) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    parts = {has_theme?, has_mode?}

    igniter
    |> ProjectModule.find_and_update_module!(
      layouts_module,
      &full_replace_app_zipper(&1, themes, opts, i18n?, parts)
    )
    |> Igniter.update_file(lay_ex, fn source ->
      c =
        source.content
        |> remove_stock_phoenix_layouts_for_corex_replace(opts)
        |> LayoutBuilder.merge_layout_declarations(themes, opts, i18n?)

      %{source | content: c}
    end)
  end

  defp full_replace_app_zipper(zipper, themes, opts, i18n?, parts) do
    case Function.move_to_def(zipper, :app, 1, target: :at) do
      {:ok, z} ->
        new_def = LayoutBuilder.build_layout_def(themes, opts, i18n?)

        z2 =
          z
          |> Common.replace_code(new_def)
          |> then(&Sourceror.Zipper.topmost/1)
          |> LayoutBuilder.append_toggle_components(parts)

        {:ok, z2}

      :error ->
        {:ok, zipper}
    end
  end

  defp patch_app_def(igniter, layouts_module, lay_ex, themes, opts, i18n?) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    parts = {has_theme?, has_mode?}

    igniter
    |> ProjectModule.find_and_update_module!(
      layouts_module,
      fn zipper -> {:ok, LayoutBuilder.append_toggle_components(zipper, parts)} end
    )
    |> Igniter.update_file(lay_ex, fn source ->
      c =
        source.content
        |> remove_stock_phoenix_layouts_for_corex_replace(opts)
        |> apply_app_body_patch(themes, opts, i18n?)
        |> LayoutBuilder.merge_layout_declarations(themes, opts, i18n?)

      %{source | content: c}
    end)
  end

  defp apply_app_body_patch(content, themes, opts, i18n?) do
    case LayoutBuilder.patch_app_def_body(content, themes, opts, i18n?) do
      {:notice, _msg} -> content
      new_content when is_binary(new_content) -> new_content
    end
  end

  defp patch_app_heex_file(igniter, app_heex, themes, opts) do
    if Igniter.exists?(igniter, app_heex) do
      Igniter.update_file(
        igniter,
        app_heex,
        &app_heex_after_toast_and_switchers(&1, themes, opts)
      )
    else
      igniter
    end
  end

  defp app_heex_after_toast_and_switchers(source, themes, opts) do
    c = replace_flash_group_with_toast_in_app_heex(source.content)
    c = maybe_merge_switchers_into_app_heex(c, source, themes, opts)
    %{source | content: c}
  end

  defp maybe_merge_switchers_into_app_heex(c, source, themes, opts) do
    if (opts[:mode] || themes != []) and not String.contains?(c, "id=\"theme-select\"") do
      case insert_theme_mode_switchers(%{source | content: c}) do
        {:notice, _} -> c
        %{content: c2} -> c2
      end
    else
      c
    end
  end

  defp remove_stock_phoenix_layouts_for_corex_replace(c, opts) do
    c = if Config.design_on?(opts), do: remove_layouts_app_theme_toggle_li(c), else: c
    c = remove_layouts_flash_group_function_def(c)
    c = if Config.design_on?(opts), do: remove_layouts_theme_toggle_function_def(c), else: c
    c
  end

  defp remove_layouts_app_theme_toggle_li(c) do
    c
    |> String.replace(
      "\n          <li>\n            <.theme_toggle />\n          </li>\n",
      "\n"
    )
    |> String.replace(
      ~r/\n\s*<li>\s*\n\s*<\.theme_toggle\s*\/>\s*\n\s*<\/li>\s*\n?/m,
      "\n"
    )
  end

  defp remove_layouts_flash_group_function_def(c) do
    if c =~ "def flash_group" do
      Regex.replace(
        ~r/\n  @doc """\n  Shows the flash group[\s\S]*?\n  def flash_group\(assigns\) do\n    ~H"""[\s\S]*?^  end\n/m,
        c,
        "\n"
      )
    else
      c
    end
  end

  defp remove_layouts_theme_toggle_function_def(c) do
    if c =~ "def theme_toggle" do
      Regex.replace(
        ~r/\n  @doc """\n  Provides dark vs light theme toggle[\s\S]*?\n  def theme_toggle\(assigns\) do\n    ~H"""[\s\S]*?^  end\n/m,
        c,
        "\n"
      )
    else
      c
    end
  end

  defp replace_flash_group_with_toast_in_app_heex(c) do
    if not String.contains?(c, "flash_group") and String.contains?(c, "toast_group") do
      c
    else
      String.replace(
        c,
        ~r/<\.flash_group[^>]*\/>\s*/m,
        String.trim_leading(String.trim_trailing(Templates.app_level_toast_block())),
        global: false
      )
    end
  end

  def patch_home(igniter, web_mod, themes, opts, i18n?) do
    web_dir = Web.web_ex_dir(igniter, web_mod)
    web_dir_name = Path.basename(web_dir)
    home = Path.join([web_dir, "controllers", "page_html", "home.html.heex"])

    initial_body = build_replaced_home(themes, opts, i18n?, web_dir_name)

    igniter
    |> Igniter.include_or_create_file(home, initial_body)
    |> Igniter.update_file(home, fn source ->
      new_content = home_file_content(source.content, themes, opts, i18n?, web_dir_name)
      Rewrite.Source.update(source, :content, new_content)
    end)
  end

  defp home_file_content(content, themes, opts, i18n?, web_dir_name) do
    if LayoutBuilder.stock_phx_home?(content) do
      build_replaced_home(themes, opts, i18n?, web_dir_name)
    else
      case LayoutBuilder.patch_home_attrs(content, themes, opts, i18n?) do
        {:notice, _msg} -> content
        new when is_binary(new) -> new
      end
    end
  end

  def build_replaced_home(themes, opts, i18n?, web_dir_name) do
    attrs =
      ["flash={@flash}"]
      |> then(&if(i18n?, do: &1 ++ ["path={@path}"], else: &1))
      |> then(&if(opts[:mode], do: &1 ++ ["mode={@mode}"], else: &1))
      |> then(&if(themes != [], do: &1 ++ ["theme={@theme}"], else: &1))

    body =
      opts
      |> Templates.corex_starter_index_body()
      |> String.replace("{web}", web_dir_name)
      |> String.replace("corex.html.heex", "home.html.heex")
      |> String.trim()

    "<Layouts.app\n  " <>
      Enum.join(attrs, "\n  ") <> "\n>\n" <> body <> "\n</Layouts.app>\n"
  end
end
