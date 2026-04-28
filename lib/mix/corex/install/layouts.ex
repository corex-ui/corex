defmodule Mix.Corex.Install.Layouts do
  @moduledoc false

  alias Mix.Corex.Install.{Config, Templates, Web}

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
    cond do
      String.contains?(pre_html, "LocalizeLayout.html_lang") ->
        pre_html

      opts[:mode] || themes != [] ->
        root_html_tag_with_localize_mode_theme(pre_html, web_mod, first_theme)

      true ->
        root_html_tag_localize_only(pre_html, web_mod)
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

  defp root_html_tag_with_localize_mode_theme(pre_html, web_mod, first_theme) do
    Regex.replace(
      ~r/<html[^>]*>/u,
      pre_html,
      "<html lang={#{inspect(web_mod)}.LocalizeLayout.html_lang(@conn)} dir={#{inspect(web_mod)}.LocalizeLayout.html_dir(@conn)} data-theme={assigns[:theme] || \"#{first_theme}\"} data-mode={assigns[:mode] || \"light\"}>",
      global: false
    )
  end

  defp root_html_tag_localize_only(pre_html, web_mod) do
    Regex.replace(
      ~r/<html[^>]*>/u,
      pre_html,
      "<html lang={#{inspect(web_mod)}.LocalizeLayout.html_lang(@conn)} dir={#{inspect(web_mod)}.LocalizeLayout.html_dir(@conn)}>",
      global: false
    )
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

  def maybe_patch_replaced_or_stock_app_layout(igniter, web_mod, themes, opts, true, i18n?),
    do: patch_replaced_app_layout(igniter, web_mod, themes, opts, i18n?)

  def maybe_patch_replaced_or_stock_app_layout(igniter, _web_mod, _themes, _opts, false, _i18n),
    do: igniter

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
          value={[assigns[:theme] || "neo"]}
          on_value_change_client="phx:set-theme"
        >
          <:label class="sr-only">Theme</:label>
          <:item :let={item}>{item.label}</:item>
          <:trigger>Theme</:trigger>
        </.select>

        <.toggle_group
          id="mode-switcher"
          class="toggle-group toggle-group--sm toggle-group--circle"
          value={if (assigns[:mode] || "light") == "dark", do: ["dark"], else: []}
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

  defp patch_replaced_app_layout(igniter, web_mod, themes, opts, i18n?) do
    ldir = Path.join([Web.web_ex_dir(igniter, web_mod), "components", "layouts"])
    app_heex = Path.join(ldir, "app.html.heex")
    lay_ex = Path.join([Web.web_ex_dir(igniter, web_mod), "components", "layouts.ex"])

    igniter
    |> patch_replaced_layouts_ex_file(lay_ex, themes, opts, i18n?)
    |> patch_replaced_app_heex_file(app_heex, themes, opts)
    |> maybe_patch_replaced_home(web_mod, i18n?)
  end

  defp patch_replaced_layouts_ex_file(igniter, lay_ex, themes, opts, i18n?) do
    if Igniter.exists?(igniter, lay_ex) do
      Igniter.update_file(igniter, lay_ex, fn source ->
        c =
          source.content
          |> ensure_mode_theme_path_attrs_in_layouts_ex()
          |> remove_stock_phoenix_layouts_for_corex_replace(i18n?, opts)
          |> replace_flash_group_with_toast_in_layouts_source(:app)

        c = merge_theme_switchers_into_layouts_source(c, source, themes, opts)
        %{source | content: c}
      end)
    else
      igniter
    end
  end

  defp merge_theme_switchers_into_layouts_source(c, source, themes, opts) do
    if opts[:mode] || themes != [] do
      case insert_theme_mode_switchers(%{source | content: c}) do
        {:notice, _} -> c
        %{content: c2} -> c2
      end
    else
      c
    end
  end

  defp patch_replaced_app_heex_file(igniter, app_heex, themes, opts) do
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
    c = replace_flash_group_with_toast_in_layouts_source(source.content, :heex)
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

  defp ensure_mode_theme_path_attrs_in_layouts_ex(c) do
    path_mode_theme_prefix = """
      attr :path, :string, default: nil, doc: "the path after an optional /:locale prefix"
      attr :mode, :string, default: "light", doc: "the mode (dark or light) from session"
      attr :theme, :string, default: "neo", doc: "the theme (neo, uno, duo, leo) from session"
    """

    if c =~ "attr :mode" or c =~ "attr(:mode" do
      c
    else
      c2 =
        String.replace(
          c,
          "  attr :current_scope, :map,",
          path_mode_theme_prefix <> "  attr :current_scope, :map,",
          global: false
        )

      if c2 != c do
        c2
      else
        String.replace(
          c,
          "  attr :flash, :map,",
          path_mode_theme_prefix <> "  attr :flash, :map,",
          global: false
        )
      end
    end
  end

  defp remove_stock_phoenix_layouts_for_corex_replace(c, _i18n?, opts) do
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

  defp replace_flash_group_with_toast_in_layouts_source(c, :app) do
    if String.contains?(c, "toast_group") and not String.contains?(c, "<.flash_group") do
      c
    else
      b = String.trim_leading(String.trim_trailing(Templates.app_level_toast_block()))
      c2 = String.replace(c, "    <.flash_group flash={@flash} />", b, global: false)

      if c2 != c,
        do: c2,
        else: String.replace(c, ~r/\n\s*<\.flash_group[^>]*\/>\s*/m, b, global: false)
    end
  end

  defp replace_flash_group_with_toast_in_layouts_source(c, :heex) do
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

  defp strip_replaced_phoenix_home_layout_refs(c) when is_binary(c) do
    c
    |> then(fn b ->
      if String.starts_with?(b, <<0xEF, 0xBB, 0xBF>>), do: String.slice(b, 3..-1//1), else: b
    end)
    |> String.replace(~r/<Layouts\.flash_group[\s\S]*?\/>\s*/u, "")
    |> String.replace(~r/<\.flash_group[\s\S]*?\/>\s*/u, "")
    |> String.replace(~r/<Layouts\.theme_toggle[\s\S]*?\/>\s*/u, "")
  end

  def maybe_patch_replaced_home(igniter, web_mod, i18n?) do
    home =
      Path.join([
        Web.web_ex_dir(igniter, web_mod),
        "controllers",
        "page_html",
        "home.html.heex"
      ])

    igniter = Igniter.include_existing_file(igniter, home)

    if Igniter.exists?(igniter, home) do
      Igniter.update_file(igniter, home, &wrap_home_in_layouts_app(&1, i18n?))
    else
      igniter
    end
  end

  defp wrap_home_in_layouts_app(source, i18n?) do
    c0 = source.content
    c = c0 |> strip_replaced_phoenix_home_layout_refs() |> String.trim()

    new_content =
      if String.contains?(c, "<Layouts.app") do
        c
      else
        line =
          if i18n? do
            ~s(<Layouts.app flash={@flash} conn={@conn} current_scope={assigns[:current_scope]} mode={assigns[:mode] || "light"} theme={assigns[:theme] || "neo"} path={assigns[:path]}>)
          else
            ~s(<Layouts.app flash={@flash} current_scope={assigns[:current_scope]} mode={assigns[:mode] || "light"} theme={assigns[:theme] || "neo"} path={assigns[:path]}>)
          end

        line <> "\n" <> c <> "\n</Layouts.app>\n"
      end

    Rewrite.Source.update(source, :content, new_content)
  end
end
