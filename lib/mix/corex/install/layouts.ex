defmodule Mix.Corex.Install.Layouts do
  @moduledoc false

  alias Mix.Corex.Install.{Design, Options, Paths, Templates}

  def patch_root_layout(igniter, web_mod, themes, opts) do
    dir = Paths.web_ex_dir(igniter, web_mod)
    path = Path.join([dir, "components", "layouts", "root.html.heex"])

    first_theme = List.first(themes) || "neo"

    Igniter.update_file(igniter, path, fn source ->
      content = source.content

      content_after_script =
        cond do
          String.contains?(content, "type=\"module\"") or
              String.contains?(content, "type='module'") ->
            content

          Regex.match?(
            ~r/<script\s+defer\s+phx-track-static[^>]*\btype="text\/javascript"/u,
            content
          ) ->
            Regex.replace(
              ~r/(<script\s+defer\s+phx-track-static[^>]*?)\s*type="text\/javascript"/u,
              content,
              "\\1 type=\"module\"",
              global: false
            )

          String.contains?(content, "<script defer phx-track-static ") ->
            String.replace(
              content,
              "<script defer phx-track-static ",
              "<script defer phx-track-static type=\"module\" ",
              global: false
            )

          true ->
            content
        end

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
          cond do
            i18n? && String.contains?(pre_html, "LocalizeLayout.html_lang") ->
              pre_html

            i18n? && (opts[:mode] || themes != []) ->
              Regex.replace(
                ~r/<html[^>]*>/u,
                pre_html,
                "<html lang={#{inspect(web_mod)}.LocalizeLayout.html_lang(@conn)} dir={#{inspect(web_mod)}.LocalizeLayout.html_dir(@conn)} data-theme={assigns[:theme] || \"#{first_theme}\"} data-mode={assigns[:mode] || \"light\"}>",
                global: false
              )

            i18n? ->
              Regex.replace(
                ~r/<html[^>]*>/u,
                pre_html,
                "<html lang={#{inspect(web_mod)}.LocalizeLayout.html_lang(@conn)} dir={#{inspect(web_mod)}.LocalizeLayout.html_dir(@conn)}>",
                global: false
              )

            opts[:mode] || themes != [] ->
              if html_tag_has_assign_data_theme?(pre_html) do
                pre_html
              else
                Regex.replace(
                  ~r/<html(\s[^>]*)?>/u,
                  pre_html,
                  fn _full, attrs ->
                    attrs = attrs || ""

                    "#{String.trim_trailing("<html" <> attrs, ">")} lang={assigns[:locale] || \"en\"} dir={assigns[:dir] || \"ltr\"} data-theme={assigns[:theme] || \"#{first_theme}\"} data-mode={assigns[:mode] || \"light\"}>"
                  end,
                  global: false
                )
              end

            Options.design_on?(opts) ->
              Regex.replace(
                ~r/<html[^>]*>/u,
                pre_html,
                "<html lang=\"en\" data-theme=\"neo\" data-mode=\"light\">",
                global: false
              )

            true ->
              pre_html
          end

        content = maybe_insert_theme_mode_bridge(content, themes, opts)
        %{source | content: content}
      end
    end)
  end

  def maybe_patch_replaced_or_stock_app_layout(igniter, web_mod, themes, opts, true, i18n?),
    do:
      igniter
      |> patch_replaced_app_layout(web_mod, themes, opts, i18n?)
      |> then(fn i ->
        if Options.design_on?(opts) do
          i
          |> Design.patch_assets_app_css_for_corex_design()
          |> then(&Design.delete_phx_daisyui_vendor_if_present/1)
        else
          i
        end
      end)

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

  defp patch_replaced_app_layout(igniter, web_mod, themes, opts, i18n?) do
    ldir = Path.join([Paths.web_ex_dir(igniter, web_mod), "components", "layouts"])
    app_heex = Path.join(ldir, "app.html.heex")
    lay_ex = Path.join([Paths.web_ex_dir(igniter, web_mod), "components", "layouts.ex"])

    igniter
    |> then(fn i ->
      if Igniter.exists?(i, lay_ex) do
        Igniter.update_file(i, lay_ex, fn source ->
          c = source.content
          c = ensure_mode_theme_path_attrs_in_layouts_ex(c)
          c = remove_stock_phoenix_layouts_for_corex_replace(c, i18n?, opts)
          c = replace_flash_group_with_toast_in_layouts_source(c, :app)

          c =
            if opts[:mode] || themes != [] do
              case insert_theme_mode_switchers(%{source | content: c}) do
                {:notice, _} -> c
                %{content: c2} -> c2
              end
            else
              c
            end

          %{source | content: c}
        end)
      else
        i
      end
    end)
    |> then(fn i ->
      if Igniter.exists?(i, app_heex) do
        Igniter.update_file(i, app_heex, fn source ->
          c = source.content
          c = replace_flash_group_with_toast_in_layouts_source(c, :heex)

          c =
            if (opts[:mode] || themes != []) and not String.contains?(c, "id=\"theme-select\"") do
              case insert_theme_mode_switchers(%{source | content: c}) do
                {:notice, _} -> c
                %{content: c2} -> c2
              end
            else
              c
            end

          %{source | content: c}
        end)
      else
        i
      end
    end)
    |> maybe_patch_replaced_home(web_mod, i18n?)
  end

  defp ensure_mode_theme_path_attrs_in_layouts_ex(c) do
    if c =~ "attr :mode" or c =~ "attr(:mode" do
      c
    else
      c2 =
        String.replace(
          c,
          "  attr :current_scope, :map,",
          "  attr :path, :string, default: nil, doc: \"the path after an optional /:locale prefix\"\n  " <>
            "attr :mode, :string, default: \"light\", doc: \"the mode (dark or light) from session\"\n  " <>
            "attr :theme, :string, default: \"neo\", doc: \"the theme (neo, uno, duo, leo) from session\"\n  " <>
            "attr :current_scope, :map,",
          global: false
        )

      if c2 != c do
        c2
      else
        String.replace(
          c,
          "  attr :flash, :map,",
          "  attr :path, :string, default: nil, doc: \"the path after an optional /:locale prefix\"\n  " <>
            "attr :mode, :string, default: \"light\", doc: \"the mode (dark or light) from session\"\n  " <>
            "attr :theme, :string, default: \"neo\", doc: \"the theme (neo, uno, duo, leo) from session\"\n  " <>
            "attr :flash, :map,",
          global: false
        )
      end
    end
  end

  defp remove_stock_phoenix_layouts_for_corex_replace(c, _i18n?, opts) do
    c = if Options.design_on?(opts), do: remove_layouts_app_theme_toggle_li(c), else: c
    c = remove_layouts_flash_group_function_def(c)
    c = if Options.design_on?(opts), do: remove_layouts_theme_toggle_function_def(c), else: c
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

  defp remove_home_layouts_theme_toggle_line(body) do
    Regex.replace(~r/\n\s*<Layouts\.theme_toggle[^>]*\/>\s*/m, body, "\n", global: true)
  end

  def maybe_patch_replaced_home(igniter, web_mod, i18n?) do
    home =
      Path.join([
        Paths.web_ex_dir(igniter, web_mod),
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
    c = source.content

    if String.contains?(c, "<Layouts.app") do
      source
    else
      line =
        if i18n? do
          ~s(<Layouts.app flash={@flash} conn={@conn} current_scope={assigns[:current_scope]} mode={assigns[:mode] || "light"} theme={assigns[:theme] || "neo"} path={assigns[:path]}>)
        else
          ~s(<Layouts.app flash={@flash} current_scope={assigns[:current_scope]} mode={assigns[:mode] || "light"} theme={assigns[:theme] || "neo"} path={assigns[:path]}>)
        end

      c =
        c
        |> then(fn s ->
          Regex.replace(~r/^\s*<Layouts\.flash_group[^>]*\/>\s*\n?/m, s, "", global: false)
        end)
        |> remove_home_layouts_theme_toggle_line()
        |> String.trim()

      %{source | content: line <> "\n" <> c <> "\n</Layouts.app>\n"}
    end
  end
end
