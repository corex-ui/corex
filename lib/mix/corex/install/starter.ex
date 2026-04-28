defmodule Mix.Corex.Install.Starter do
  @moduledoc false

  alias Igniter.Code.{Common, Function}
  alias Igniter.Libs.Phoenix, as: IPhoenix
  alias Igniter.Project.Module, as: ProjectModule
  alias Mix.Corex.Install.{Templates, Web}

  def add_corex_page_and_layout(igniter, web_mod, themes, opts, i18n?) do
    w = Web.web_ex_dir(igniter, web_mod)
    layout_mod = Module.concat(web_mod, :Layouts)

    page_controller = Module.concat(web_mod, PageController)
    layouts_module = layout_mod
    template_path = Path.join([w, "controllers", "page_html", "corex.html.heex"])
    index = String.trim_trailing(build_corex_starter_page_template(themes, opts, i18n?)) <> "\n"
    layouts_ex_path = ProjectModule.proper_location(igniter, layouts_module)

    on_exists =
      if Keyword.get(opts, :refresh_templates, false) do
        :overwrite
      else
        :skip
      end

    igniter
    |> Igniter.include_existing_file(layouts_ex_path)
    |> Igniter.create_new_file(template_path, index, on_exists: on_exists)
    |> add_corex_layout_function(layouts_module, layouts_ex_path, themes, opts, i18n?, web_mod)
    |> add_corex_action(page_controller, layout_mod)
    |> ensure_corex_action_is_render_only(page_controller, layout_mod)
    |> add_corex_route(web_mod)
  end

  def build_corex_starter_page_template(themes, opts, i18n?) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    has_lang? = i18n? == true

    attr_lines =
      [
        "flash={@flash}",
        "current_scope={assigns[:current_scope]}"
      ]
      |> then(fn acc ->
        if has_lang?, do: acc ++ ["conn={@conn}", "path={assigns[:path]}"], else: acc
      end)
      |> then(fn acc ->
        if has_mode?, do: acc ++ ["mode={assigns[:mode] || \"light\"}"], else: acc
      end)
      |> then(fn acc ->
        if has_theme?, do: acc ++ ["theme={assigns[:theme] || \"neo\"}"], else: acc
      end)

    attr_block = Enum.join(attr_lines, "\n  ")

    inner = Templates.corex_starter_index_body() |> String.trim()

    """
    <Layouts.corex
      #{attr_block}
    >
    #{inner}
    </Layouts.corex>
    """
  end

  defp add_corex_layout_function(
         igniter,
         layouts_module,
         layouts_ex_path,
         themes,
         opts,
         i18n?,
         web_mod
       ) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    has_lang? = i18n? == true
    any_ui? = has_mode? or has_theme? or has_lang?
    parts = {has_theme?, has_mode?}

    has_lang_in_corex? =
      has_language_switch_in_corex_def_from_disk?(igniter, layouts_ex_path, has_lang?)

    ctx = %{
      themes: themes,
      opts: opts,
      has_lang?: has_lang?,
      web_mod: web_mod,
      parts: parts,
      any_ui?: any_ui?,
      has_lang_in_corex?: has_lang_in_corex?
    }

    igniter
    |> ProjectModule.find_and_update_module!(layouts_module, &layouts_zipper_for_corex(&1, ctx))
  end

  defp layouts_zipper_for_corex(zipper, ctx) do
    has_theme_toggle? = match?({:ok, _}, Function.move_to_def(zipper, :theme_toggle, 1))
    has_mode_toggle? = match?({:ok, _}, Function.move_to_def(zipper, :mode_toggle, 1))

    toggles_complete? =
      toggles_fully_present?(
        ctx.any_ui?,
        ctx.parts,
        has_theme_toggle?,
        has_mode_toggle?,
        ctx.has_lang?,
        ctx.has_lang_in_corex?
      )

    case Function.move_to_def(zipper, :corex, 1, target: :at) do
      {:ok, z} ->
        {:ok, corex_zipper_when_def_exists(z, ctx, toggles_complete?)}

      :error ->
        {:ok, corex_zipper_when_def_missing(zipper, ctx)}
    end
  end

  defp toggles_fully_present?(false, _, _, _, _, _), do: true

  defp toggles_fully_present?(true, parts, has_tt, has_mt, has_lang?, lang_in_corex?) do
    {has_theme?, has_mode?} = parts
    theme_ok? = if has_theme?, do: has_tt, else: true
    mode_ok? = if has_mode?, do: has_mt, else: true
    lang_ok? = if has_lang?, do: lang_in_corex?, else: true
    theme_ok? and mode_ok? and lang_ok?
  end

  defp corex_zipper_when_def_exists(zipper, ctx, toggles_complete?) do
    cond do
      not ctx.any_ui? ->
        zipper

      toggles_complete? ->
        zipper

      true ->
        zipper
        |> Common.replace_code(build_corex_body(ctx.themes, ctx.opts, ctx.has_lang?, ctx.web_mod))
        |> then(&Sourceror.Zipper.topmost/1)
        |> append_toggle_components_after_corex(ctx.parts)
    end
  end

  defp corex_zipper_when_def_missing(zipper, ctx) do
    zipper
    |> Common.add_code(
      build_corex_body(ctx.themes, ctx.opts, ctx.has_lang?, ctx.web_mod),
      placement: :after
    )
    |> then(&Sourceror.Zipper.topmost/1)
    |> maybe_append_toggle_components_after_corex(ctx.parts, ctx.any_ui?)
  end

  defp has_language_switch_in_corex_def_from_disk?(_igniter, _layouts_ex_path, false), do: true

  defp has_language_switch_in_corex_def_from_disk?(igniter, layouts_ex_path, true) do
    case Rewrite.source(igniter.rewrite, layouts_ex_path) do
      {:ok, s} ->
        c = Rewrite.Source.get(s, :content) || ""
        Regex.match?(~r/def\s+corex[\s\S]+?language_switch/m, c)

      _ ->
        false
    end
  end

  defp build_corex_body(themes, opts, has_lang?, web_mod) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    any_ui? = has_mode? or has_theme? or has_lang?

    path_mod = Module.concat(web_mod, :Path) |> inspect()

    switcher_html =
      corex_header_switcher_markup(has_lang?, has_theme?, has_mode?, any_ui?)

    i18n_attrs =
      if has_lang? do
        """
        attr :conn, Plug.Conn, default: nil, doc: "the current connection, for i18n links"
        attr :path, :string,
          default: nil,
          doc: "the path after an optional /:locale prefix (from Plug.Conn or from assigns)"

        """
      else
        ""
      end

    extra_mode_theme = extra_mode_theme_attrs(any_ui?, has_mode?, has_theme?, has_lang?)

    path_prefix =
      if has_lang? do
        """
        path =
          case assigns do
            %{path: p} when is_binary(p) -> p
            %{conn: %Plug.Conn{} = c} -> #{path_mod}.strip_after_locale(c.request_path)
            _ -> ""
          end

        assigns = assign(assigns, :path, path)

        """
      else
        ""
      end

    """
    #{i18n_attrs}#{extra_mode_theme}attr :flash, :map, required: true, doc: "the map of flash messages"

    attr :current_scope, :map,
      default: nil,
      doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

    slot :inner_block, required: true

    def corex(assigns) do
      #{path_prefix}      ~H\"""
      <header class="navbar px-4 sm:px-6 lg:px-8">
        <div class="flex-1">
          <a href="/" class="flex-1 flex w-fit items-center gap-2">
            <img src={~p"/images/logo.svg"} width="36" />
          </a>
        </div>
    #{switcher_html}  </header>
      <main class="px-4 py-8 sm:px-6">
        <div class="mx-auto max-w-2xl space-y-4">
          {render_slot(@inner_block)}
        </div>
      </main>
      <.toast_group id="corex-layout-toast" class="toast" flash={@flash}>
        <:loading>Loading…</:loading>
        <:close>Close</:close>
      </.toast_group>
      <.toast_client_error
        toast_group_id="corex-layout-toast"
        title="We lost the connection"
        description="We're trying to reconnect you..."
        type={:error}
        duration={:infinity}
      />
    \"""
    end
    """
  end

  defp corex_header_switcher_markup(has_lang?, has_theme?, has_mode?, any_ui?) do
    switcher_inner =
      [
        if(has_lang?, do: "            <.language_switch conn={@conn} />", else: nil),
        if(has_theme?, do: "            <.theme_toggle theme={@theme} />", else: nil),
        if(has_mode?, do: "            <.mode_toggle mode={@mode} />", else: nil)
      ]
      |> Enum.reject(&is_nil/1)

    n = length(switcher_inner)

    row_class =
      if n == 1, do: "layout__row gap-2 sm:gap-4 justify-end", else: "layout__row gap-2 sm:gap-4"

    if n == 0 or not any_ui? do
      ""
    else
      body = Enum.join(switcher_inner, "\n")

      """
          <div class="#{row_class}">
      #{body}
          </div>
      """
    end
  end

  defp append_toggle_components_after_corex(z, parts) do
    case Function.move_to_def(z, :corex, 1, target: :at) do
      {:ok, z2} ->
        t = toggle_components_string(parts)

        if t == "",
          do: z2,
          else: Common.add_code(z2, t, placement: :after)

      :error ->
        z
    end
  end

  defp maybe_append_toggle_components_after_corex(z, _parts, false), do: z

  defp maybe_append_toggle_components_after_corex(z, parts, true) do
    append_toggle_components_after_corex(z, parts)
  end

  defp extra_mode_theme_attrs(any_ui?, has_mode?, has_theme?, has_lang?) do
    cond do
      not any_ui? ->
        ""

      has_mode? and has_theme? ->
        """
        attr :mode, :string, default: "light", doc: "the current mode (dark or light)"
        attr :theme, :string, default: "neo", doc: "the current theme"
        """

      has_mode? ->
        """
        attr :mode, :string, default: "light", doc: "the current mode (dark or light)"
        """

      has_theme? ->
        """
        attr :theme, :string, default: "neo", doc: "the current theme"
        """

      has_lang? ->
        ""

      true ->
        ""
    end
  end

  defp toggle_components_string({has_theme?, has_mode?}) do
    [
      if(has_theme?, do: theme_toggle_source(), else: nil),
      if(has_mode?, do: mode_toggle_source(), else: nil)
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n\n")
  end

  defp theme_toggle_source do
    """
    @doc \"\"\"
    Provides theme selection using the select component.
    \"\"\"

    attr :theme, :string,
      default: "neo",
      values: ["neo", "uno", "duo", "leo"],
      doc: "the theme from cookie/session"

    def theme_toggle(assigns) do
      ~H\"\"\"
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
        <:label class="sr-only">
          Theme
        </:label>
        <:item :let={item}>
          {item.label}
        </:item>
        <:trigger>
          <.heroicon name="hero-swatch" class="icon" />
        </:trigger>
        <:item_indicator>
          <.heroicon name="hero-check" class="icon" />
        </:item_indicator>
      </.select>
      \"\"\"
    end
    """
  end

  defp mode_toggle_source do
    """
    @doc \"\"\"
    Provides dark vs light mode toggle using toggle_group.
    \"\"\"

    attr :mode, :string,
      default: "light",
      values: ["light", "dark"],
      doc: "the mode (dark or light) from cookie/session"

    def mode_toggle(assigns) do
      ~H\"\"\"
      <.toggle_group
        id="mode-switcher"
        class="toggle-group toggle-group--sm toggle-group--duo toggle-group--circle"
        value={if @mode == "dark", do: ["dark"], else: []}
        on_value_change_client="phx:set-mode"
      >
        <:item value="dark">
          <.heroicon name="hero-sun" class="icon state-on" />
          <.heroicon name="hero-moon" class="icon state-off" />
        </:item>
      </.toggle_group>
      \"\"\"
    end
    """
  end

  defp add_corex_action(igniter, page_controller, _layout_mod) do
    action = """
    def corex(conn, _params) do
      render(conn, :corex)
    end
    """

    ProjectModule.find_and_update_module!(igniter, page_controller, fn zipper ->
      case Function.move_to_def(zipper, :corex, 2) do
        {:ok, _} -> {:ok, zipper}
        :error -> {:ok, Common.add_code(zipper, action, placement: :after)}
      end
    end)
  end

  def migrate_corex_action_to_render_only(source, layout_mod) when is_binary(source) do
    esc = Regex.escape(inspect(layout_mod))

    re =
      ~r/def\s+corex\(conn,\s*_params\)\s+do[\s\n]+conn[\s\n]*\|[\s\n]*>[\s\n]*put_layout\(\{#{esc},\s*:corex\}\)[\s\n]*\|[\s\n]*>[\s\n]*render\(:corex\)[\s\n]+end/m

    Regex.replace(
      re,
      source,
      "def corex(conn, _params) do\n  render(conn, :corex)\nend",
      global: false
    )
  end

  defp ensure_corex_action_is_render_only(igniter, page_controller, layout_mod) do
    path = ProjectModule.proper_location(igniter, page_controller)

    igniter
    |> Igniter.include_existing_file(path)
    |> Igniter.update_file(path, fn source ->
      %{source | content: migrate_corex_action_to_render_only(source.content, layout_mod)}
    end)
  end

  defp add_corex_route(igniter, web_mod) do
    router = Module.concat(web_mod, Router)
    router_path = ProjectModule.proper_location(igniter, router)

    igniter
    |> Igniter.include_existing_file(router_path)
    |> then(fn igniter ->
      source = Rewrite.source!(igniter.rewrite, router_path)
      content = Rewrite.Source.get(source, :content)

      if Regex.match?(
           ~r/get\s+"[^"]*"\s*,\s*PageController\s*,\s*:corex/,
           content
         ) do
        igniter
      else
        IPhoenix.append_to_scope(
          igniter,
          "/",
          ~s[get "/home", PageController, :corex],
          arg2: web_mod,
          with_pipelines: [:browser],
          router: router
        )
      end
    end)
  end
end
