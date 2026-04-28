defmodule Mix.Corex.Install.Starter do
  @moduledoc false

  alias Igniter.Code.{Common, Function}
  alias Igniter.Libs.Phoenix, as: IPhoenix
  alias Igniter.Project.Module, as: ProjectModule
  alias Mix.Corex.Install.{Config, Templates, Web}

  def add_corex_page_and_layout(igniter, web_mod, themes, opts, i18n?) do
    w = Web.web_ex_dir(igniter, web_mod)
    layout_mod = Module.concat(web_mod, :Layouts)

    page_controller = Module.concat(web_mod, PageController)
    layouts_module = layout_mod
    template_path = Path.join([w, "controllers", "page_html", "corex.html.heex"])

    web_dir_name = Path.basename(w)

    index =
      themes
      |> build_corex_starter_page_template(opts, i18n?)
      |> String.replace("{web}", web_dir_name)
      |> String.trim_trailing()
      |> Kernel.<>("\n")

    layouts_ex_path = ProjectModule.proper_location(igniter, layouts_module)

    igniter
    |> Igniter.include_existing_file(layouts_ex_path)
    |> Igniter.create_new_file(template_path, index, on_exists: :skip)
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
        if has_lang?, do: acc ++ ["path={assigns[:path]}"], else: acc
      end)
      |> then(fn acc ->
        if has_mode?, do: acc ++ ["mode={assigns[:mode] || \"light\"}"], else: acc
      end)
      |> then(fn acc ->
        if has_theme?, do: acc ++ ["theme={assigns[:theme] || \"neo\"}"], else: acc
      end)

    attr_block = Enum.join(attr_lines, "\n  ")

    inner = Templates.corex_starter_index_body(opts) |> String.trim()

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
    |> Igniter.include_existing_file(layouts_ex_path)
    |> Igniter.update_file(layouts_ex_path, fn source ->
      content = Rewrite.Source.get(source, :content)

      next = merge_corex_layout_declarations(content, opts, themes, has_lang?)

      %{source | content: next}
    end)
  end

  def merge_corex_layout_declarations(content, opts, themes, has_lang?) do
    zone = declaration_zone_before_corex(content)
    chunks = corex_declaration_chunks(opts, themes, has_lang?)
    missing = Enum.reject(chunks, fn chunk -> declaration_chunk_present?(zone, chunk) end)

    case missing do
      [] ->
        content

      _ ->
        block =
          missing |> Enum.map(&String.trim/1) |> Enum.reject(&(&1 == "")) |> Enum.join("\n\n")

        insert_declarations_before_def_corex(content, block <> "\n")
    end
  end

  defp declaration_chunk_present?(zone, chunk) do
    markers = declaration_markers_for_chunk(chunk)
    Enum.all?(markers, &marker_present_in_decl_zone?(zone, &1))
  end

  defp marker_present_in_decl_zone?(zone, marker) do
    case marker do
      "attr :conn" ->
        Regex.match?(~r/\battr\s*\(?\s*:conn\b/m, zone)

      "attr :path" ->
        Regex.match?(~r/\battr\s*\(?\s*:path\b/m, zone)

      "attr :mode" ->
        Regex.match?(~r/\battr\s*\(?\s*:mode\b/m, zone)

      "attr :theme" ->
        Regex.match?(~r/\battr\s*\(?\s*:theme\b/m, zone)

      "attr :flash" ->
        Regex.match?(~r/\battr\s*\(?\s*:flash\b/m, zone)

      "attr :current_scope" ->
        Regex.match?(~r/\battr\s*\(?\s*:current_scope\b/m, zone)

      "slot :inner_block" ->
        Regex.match?(~r/\bslot\s*\(?\s*:inner_block\b/m, zone)

      _ ->
        String.contains?(zone, marker)
    end
  end

  defp declaration_markers_for_chunk(chunk) do
    cond do
      String.contains?(chunk, "attr :conn") ->
        ["attr :conn", "attr :path"]

      String.contains?(chunk, "attr :mode") and String.contains?(chunk, "attr :theme") ->
        ["attr :mode", "attr :theme"]

      String.contains?(chunk, "attr :mode") ->
        ["attr :mode"]

      String.contains?(chunk, "attr :theme") ->
        ["attr :theme"]

      true ->
        lines =
          chunk
          |> String.split("\n")
          |> Enum.map(&String.trim/1)
          |> Enum.reject(&(&1 == ""))

        case lines do
          [first | _] -> [first]
          [] -> [""]
        end
    end
  end

  defp declaration_zone_before_corex(content) do
    strict = ~r/\n\s*def\s+corex\s*\(\s*assigns\s*\)\s+do\b/m

    start_pos =
      case Regex.scan(strict, content, return: :index) do
        [] ->
          case Regex.run(~r/\n\s*def\s+corex\b/m, content, return: :index) do
            [{pos, _}] -> pos
            _ -> nil
          end

        matches ->
          matches
          |> Enum.map(fn [{pos, _} | _] -> pos end)
          |> Enum.max()
      end

    case start_pos do
      nil -> ""
      pos -> binary_part(content, 0, pos)
    end
  end

  defp insert_declarations_before_def_corex(content, block) do
    block = String.trim_trailing(block)

    fun = fn _, nl, ind, def_rest ->
      nl <> indent_declaration_block_lines(block, ind) <> nl <> ind <> def_rest
    end

    strict = ~r/(\n)(\s*)(def\s+corex\s*\(\s*assigns\s*\)\s+do\b)/m
    loose = ~r/(\n)(\s*)(def\s+corex\b)/m

    replaced = Regex.replace(strict, content, fun, global: false)

    if replaced != content do
      replaced
    else
      Regex.replace(loose, content, fun, global: false)
    end
  end

  defp indent_declaration_block_lines(block, ind) do
    block
    |> String.split("\n")
    |> Enum.map(fn line ->
      if String.trim(line) == "" do
        nil
      else
        ind <> String.trim_leading(line)
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n")
  end

  defp corex_declaration_chunks(opts, themes, has_lang?) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    any_ui? = has_mode? or has_theme? or has_lang?

    i18n_block =
      if has_lang? do
        i18n_attrs_only()
      else
        ""
      end

    extra =
      extra_mode_theme_attrs(any_ui?, has_mode?, has_theme?, has_lang?)
      |> String.trim()

    []
    |> then(fn acc -> if i18n_block != "", do: acc ++ [i18n_block], else: acc end)
    |> then(fn acc -> if extra != "", do: acc ++ [extra], else: acc end)
    |> then(fn acc ->
      acc ++ [flash_attr_chunk(), scope_attr_chunk(), slot_inner_block_chunk()]
    end)
    |> Enum.reject(&(String.trim(&1) == ""))
  end

  defp flash_attr_chunk do
    ~s(attr :flash, :map, required: true, doc: "the map of flash messages")
  end

  defp scope_attr_chunk do
    """
    attr :current_scope, :map,
      default: nil,
      doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"
    """
    |> String.trim()
  end

  defp slot_inner_block_chunk do
    "slot :inner_block, required: true"
  end

  defp i18n_attrs_only do
    """
    attr :path, :string,
      default: nil,
      doc: "locale-stripped path (from Plugs.Path)"
    """
    |> String.trim()
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
        |> Common.replace_code(
          build_corex_def_only(ctx.themes, ctx.opts, ctx.has_lang?, ctx.web_mod)
        )
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
    decls = build_corex_declarations_only(themes, opts, has_lang?)
    def_only = build_corex_def_only(themes, opts, has_lang?, web_mod)
    decls <> "\n\n" <> def_only
  end

  defp build_corex_declarations_only(themes, opts, has_lang?) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    any_ui? = has_mode? or has_theme? or has_lang?

    extra =
      extra_mode_theme_attrs(any_ui?, has_mode?, has_theme?, has_lang?)
      |> String.trim()

    []
    |> then(fn acc -> if has_lang?, do: acc ++ [i18n_attrs_only()], else: acc end)
    |> then(fn acc -> if extra != "", do: acc ++ [extra], else: acc end)
    |> then(fn acc ->
      acc ++ [flash_attr_chunk(), scope_attr_chunk(), slot_inner_block_chunk()]
    end)
    |> Enum.join("\n\n")
  end

  defp build_corex_def_only(themes, opts, has_lang?, _web_mod) do
    if Config.design_on?(opts) do
      build_corex_def_with_design(themes, opts, has_lang?)
    else
      build_corex_def_no_design(themes, opts, has_lang?)
    end
  end

  defp build_corex_def_with_design(themes, opts, has_lang?) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    any_ui? = has_mode? or has_theme? or has_lang?

    switcher_html = corex_header_switcher_markup_with_design(has_lang?, has_theme?, has_mode?)
    header_right = if any_ui?, do: switcher_html, else: ""

    """
    def corex(assigns) do
      ~H\"""
      <header class="layout__header">
        <div class="layout__header__content">
          <a href="/" class="ui-link ui-link--brand">
            #{corex_logo_svg()}
            Corex
          </a>
    #{header_right}    </div>
      </header>
      <main class="layout__main">
        <div class="layout__content">
          {render_slot(@inner_block)}
        </div>
      </main>
      <footer class="layout__footer">
        <div class="layout__footer__content">
          <span>Powered by Corex</span>
        </div>
      </footer>
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

  defp build_corex_def_no_design(themes, opts, has_lang?) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    any_ui? = has_mode? or has_theme? or has_lang?

    switcher_html = corex_header_switcher_markup_no_design(has_lang?, has_theme?, has_mode?)
    header_right = if any_ui?, do: switcher_html, else: ""

    """
    def corex(assigns) do
      ~H\"""
      <header>
        <div>
          <a href="/">
            #{corex_logo_svg()}
            Corex
          </a>
    #{header_right}    </div>
      </header>
      <main>
        <div>
          {render_slot(@inner_block)}
        </div>
      </main>
      <footer>
        <div>
          <span>Powered by Corex</span>
        </div>
      </footer>
      <.toast_group id="corex-layout-toast" flash={@flash}>
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

  defp corex_logo_svg do
    ~S|<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 136 136" width="36" height="36"><path d="M70.573 1.67C33.94 1.67 4.243 31.367 4.243 68c0 36.634 29.697 66.33 66.33 66.33s66.33-29.696 66.33-66.33c0-36.633-29.697-66.33-66.33-66.33m.05 102.736c-20.117 0-36.427-16.308-36.427-36.427 0-20.118 16.31-36.427 36.427-36.427 17.055 0 31.37 11.723 35.333 27.55H89.845c-3.365-7.255-10.713-12.301-19.222-12.301-11.678 0-21.179 9.501-21.179 21.18s9.501 21.178 21.18 21.178c8.539 0 15.907-5.08 19.256-12.377h16.095c-3.939 15.864-18.269 27.624-35.352 27.624" fill="var(--color-brand)"/></svg>|
  end

  defp corex_header_switcher_markup_with_design(has_lang?, has_theme?, has_mode?) do
    switcher_inner =
      [
        if(has_lang?, do: "          <.language_switch path={@path} />", else: nil),
        if(has_theme?, do: "          <.theme_toggle theme={@theme} />", else: nil),
        if(has_mode?, do: "          <.mode_toggle mode={@mode} />", else: nil)
      ]
      |> Enum.reject(&is_nil/1)

    if switcher_inner == [] do
      ""
    else
      body = Enum.join(switcher_inner, "\n")

      """
          <div class="layout__row">
      #{body}
          </div>
      """
    end
  end

  defp corex_header_switcher_markup_no_design(has_lang?, has_theme?, has_mode?) do
    switcher_inner =
      [
        if(has_lang?, do: "          <.language_switch path={@path} />", else: nil),
        if(has_theme?, do: "          <.theme_toggle theme={@theme} />", else: nil),
        if(has_mode?, do: "          <.mode_toggle mode={@mode} />", else: nil)
      ]
      |> Enum.reject(&is_nil/1)

    if switcher_inner == [] do
      ""
    else
      body = Enum.join(switcher_inner, "\n")

      """
          <div>
      #{body}
          </div>
      """
    end
  end

  defp append_toggle_components_after_corex(z, parts) do
    case Function.move_to_def(z, :corex, 1, target: :at) do
      {:ok, z2} ->
        top = Sourceror.Zipper.topmost(z2)

        has_tt? = match?({:ok, _}, Function.move_to_def(top, :theme_toggle, 1))
        has_mt? = match?({:ok, _}, Function.move_to_def(top, :mode_toggle, 1))

        t = toggle_components_string_filtered(parts, has_tt?, has_mt?)

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

  defp toggle_components_string_filtered(
         {has_theme?, has_mode?},
         has_theme_toggle?,
         has_mode_toggle?
       ) do
    [
      if(has_theme? && !has_theme_toggle?, do: theme_toggle_source(), else: nil),
      if(has_mode? && !has_mode_toggle?, do: mode_toggle_source(), else: nil)
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
