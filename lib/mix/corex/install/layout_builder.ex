defmodule Mix.Corex.Install.LayoutBuilder do
  @moduledoc false

  alias Igniter.Code.{Common, Function}
  alias Mix.Corex.Install.Config

  @toast_id "layout-toast"

  @stock_phx_app_markers ["phoenixframework.org", "<.flash_group flash={@flash}"]
  @stock_phx_home_markers ["Phoenix Framework", "Peace of mind from prototype to production"]

  def stock_phx_app_def?(content) when is_binary(content) do
    case extract_def_app_body(content) do
      nil ->
        false

      body ->
        Enum.all?(@stock_phx_app_markers, &String.contains?(body, &1))
    end
  end

  def stock_phx_home?(content) when is_binary(content) do
    Enum.all?(@stock_phx_home_markers, &String.contains?(content, &1))
  end

  defp extract_def_app_body(content) do
    case Regex.run(
           ~r/def\s+app\s*\(\s*assigns\s*\)\s+do\s*\n\s*~H\"\"\"([\s\S]*?)\"\"\"/m,
           content
         ) do
      [_, body] -> body
      _ -> nil
    end
  end

  def merge_layout_declarations(content, themes, opts, has_lang?) do
    zone = declaration_zone_before(content)
    chunks = declaration_chunks(themes, opts, has_lang?)
    missing = Enum.reject(chunks, fn chunk -> declaration_chunk_present?(zone, chunk) end)

    case missing do
      [] ->
        content

      _ ->
        block =
          missing |> Enum.map(&String.trim/1) |> Enum.reject(&(&1 == "")) |> Enum.join("\n\n")

        insert_declarations_before_def(content, block <> "\n")
    end
  end

  def append_toggle_components(zipper, parts) do
    case Function.move_to_def(zipper, :app, 1, target: :at) do
      {:ok, z2} ->
        top = Sourceror.Zipper.topmost(z2)

        has_tt? = match?({:ok, _}, Function.move_to_def(top, :theme_toggle, 1))
        has_mt? = match?({:ok, _}, Function.move_to_def(top, :mode_toggle, 1))

        t = toggle_components_string_filtered(parts, has_tt?, has_mt?)

        if t == "",
          do: z2,
          else: Common.add_code(z2, t, placement: :after)

      :error ->
        zipper
    end
  end

  defp declaration_zone_before(content) do
    strict = ~r/\n\s*def\s+app\s*\(\s*assigns\s*\)\s+do\b/m
    loose = ~r/\n\s*def\s+app\b/m

    start_pos =
      case Regex.scan(strict, content, return: :index) do
        [] ->
          case Regex.run(loose, content, return: :index) do
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

  defp insert_declarations_before_def(content, block) do
    block = String.trim_trailing(block)

    fun = fn _, nl, ind, def_rest ->
      nl <> indent_declaration_block_lines(block, ind) <> nl <> ind <> def_rest
    end

    strict = ~r/(\n)(\s*)(def\s+app\s*\(\s*assigns\s*\)\s+do\b)/m
    loose = ~r/(\n)(\s*)(def\s+app\b)/m

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

  def build_layout_def(themes, opts, has_lang?) do
    if Config.design_on?(opts) do
      build_layout_def_with_design(themes, opts, has_lang?)
    else
      build_layout_def_no_design(themes, opts, has_lang?)
    end
  end

  def build_declarations(themes, opts, has_lang?) do
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

  def declaration_chunks(themes, opts, has_lang?) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    any_ui? = has_mode? or has_theme? or has_lang?

    i18n_block = if has_lang?, do: i18n_attrs_only(), else: ""

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

  def flash_attr_chunk do
    ~s(attr :flash, :map, required: true, doc: "the map of flash messages")
  end

  def scope_attr_chunk do
    """
    attr :current_scope, :map,
      default: nil,
      doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"
    """
    |> String.trim()
  end

  def slot_inner_block_chunk do
    "slot :inner_block, required: true"
  end

  def i18n_attrs_only do
    """
    attr :path, :string,
      default: nil,
      doc: "locale-stripped path (from Plugs.Path)"
    """
    |> String.trim()
  end

  def extra_mode_theme_attrs(any_ui?, has_mode?, has_theme?, has_lang?) do
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

  def theme_toggle_source do
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

  def mode_toggle_source do
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

  def toggle_components_string_filtered(
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

  def logo_svg do
    ~S|<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 136 136" width="36" height="36"><path d="M70.573 1.67C33.94 1.67 4.243 31.367 4.243 68c0 36.634 29.697 66.33 66.33 66.33s66.33-29.696 66.33-66.33c0-36.633-29.697-66.33-66.33-66.33m.05 102.736c-20.117 0-36.427-16.308-36.427-36.427 0-20.118 16.31-36.427 36.427-36.427 17.055 0 31.37 11.723 35.333 27.55H89.845c-3.365-7.255-10.713-12.301-19.222-12.301-11.678 0-21.179 9.501-21.179 21.18s9.501 21.178 21.18 21.178c8.539 0 15.907-5.08 19.256-12.377h16.095c-3.939 15.864-18.269 27.624-35.352 27.624" fill="var(--color-brand)"/></svg>|
  end

  def header_switcher_markup_with_design(has_lang?, has_theme?, has_mode?) do
    switcher_inner = switcher_inner_lines(has_lang?, has_theme?, has_mode?)

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

  def header_switcher_markup_no_design(has_lang?, has_theme?, has_mode?) do
    switcher_inner = switcher_inner_lines(has_lang?, has_theme?, has_mode?)

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

  defp switcher_inner_lines(has_lang?, has_theme?, has_mode?) do
    [
      if(has_lang?, do: "          <.language_switch path={@path} />", else: nil),
      if(has_theme?, do: "          <.theme_toggle theme={@theme} />", else: nil),
      if(has_mode?, do: "          <.mode_toggle mode={@mode} />", else: nil)
    ]
    |> Enum.reject(&is_nil/1)
  end

  def patch_app_def_body(content, themes, opts, has_lang?) do
    case extract_def_app_body(content) do
      nil ->
        {:notice,
         "Could not locate `def app(assigns)` in `Layouts`. Add the missing switcher lines manually."}

      body ->
        case patch_body(body, themes, opts, has_lang?) do
          {:same, _} ->
            content

          {:ok, new_body} ->
            replace_def_app_body(content, body, new_body)

          :no_anchor ->
            {:notice,
             "Could not find an anchor in `def app/1` to insert the language/theme/mode switchers automatically. " <>
               "Add the appropriate `<.language_switch path={@path} />`, `<.theme_toggle theme={@theme} />`, " <>
               "and/or `<.mode_toggle mode={@mode} />` near the brand link in your `Layouts.app`."}
        end
    end
  end

  defp patch_body(body, themes, opts, has_lang?) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    design? = Config.design_on?(opts)

    targets = switcher_targets(has_lang?, has_theme?, has_mode?)
    missing = Enum.reject(targets, fn {_kind, line} -> body_has_switcher?(body, line) end)

    if missing == [] do
      {:same, body}
    else
      case insert_missing_switchers(body, missing, design?) do
        {:ok, new_body} -> {:ok, new_body}
        :no_anchor -> :no_anchor
      end
    end
  end

  defp switcher_targets(has_lang?, has_theme?, has_mode?) do
    [
      if(has_lang?, do: {:lang, ~s(<.language_switch path={@path} />)}, else: nil),
      if(has_theme?, do: {:theme, ~s(<.theme_toggle theme={@theme} />)}, else: nil),
      if(has_mode?, do: {:mode, ~s(<.mode_toggle mode={@mode} />)}, else: nil)
    ]
    |> Enum.reject(&is_nil/1)
  end

  defp body_has_switcher?(body, line) do
    cond do
      String.contains?(line, "<.language_switch") -> body =~ ~r/<\.language_switch\b/
      String.contains?(line, "<.theme_toggle") -> body =~ ~r/<\.theme_toggle\b/
      String.contains?(line, "<.mode_toggle") -> body =~ ~r/<\.mode_toggle\b/
      true -> String.contains?(body, line)
    end
  end

  defp insert_missing_switchers(body, missing, design?) do
    lines = Enum.map(missing, fn {_kind, l} -> l end)

    cond do
      result = insert_into_design_row(body, lines) -> {:ok, result}
      result = insert_into_no_design_switcher_div(body, lines) -> {:ok, result}
      result = insert_as_sibling_to_existing_switcher(body, lines) -> {:ok, result}
      result = insert_after_brand_anchor(body, lines, design?) -> {:ok, result}
      true -> :no_anchor
    end
  end

  defp insert_into_design_row(body, lines) do
    case find_div_block(body, ~r/<div\s+class="layout__row">/) do
      nil ->
        nil

      {open_start, _open_len, close_start, close_len} ->
        do_insert_before_close(body, lines, open_start, close_start, close_len)
    end
  end

  defp insert_into_no_design_switcher_div(body, lines) do
    case find_div_block_with_existing_switcher(body) do
      nil ->
        nil

      {open_start, _open_len, close_start, close_len} ->
        do_insert_before_close(body, lines, open_start, close_start, close_len)
    end
  end

  defp do_insert_before_close(body, lines, open_start, close_start, close_len) do
    open_line_indent = leading_indent_at(body, open_start)
    close_line_indent = leading_indent_at(body, close_start)
    inner_indent = open_line_indent <> "  "

    addition = Enum.map_join(lines, "\n", &(inner_indent <> &1))

    before_close = binary_part(body, 0, close_start - byte_size(close_line_indent))

    after_close =
      binary_part(body, close_start + close_len, byte_size(body) - close_start - close_len)

    String.trim_trailing(before_close) <>
      "\n" <>
      addition <>
      "\n" <>
      close_line_indent <>
      "</div>" <> after_close
  end

  defp leading_indent_at(body, pos) do
    line_start = find_line_start(body, pos)
    binary_part(body, line_start, pos - line_start)
  end

  defp find_line_start(_body, pos) when pos <= 0, do: 0

  defp find_line_start(body, pos) do
    case :binary.at(body, pos - 1) do
      ?\n -> pos
      _ -> find_line_start(body, pos - 1)
    end
  end

  defp find_div_block(body, open_re) do
    case Regex.run(open_re, body, return: :index) do
      nil ->
        nil

      [{open_start, open_len} | _] ->
        case find_matching_close_div(body, open_start + open_len) do
          nil -> nil
          {close_start, close_len} -> {open_start, open_len, close_start, close_len}
        end
    end
  end

  defp find_div_block_with_existing_switcher(body) do
    Regex.scan(~r/<div\s*>/m, body, return: :index)
    |> Enum.find_value(fn [{open_start, open_len} | _] ->
      div_block_if_contains_switcher(body, open_start, open_len)
    end)
  end

  defp div_block_if_contains_switcher(body, open_start, open_len) do
    case find_matching_close_div(body, open_start + open_len) do
      nil ->
        nil

      {close_start, close_len} ->
        inner = binary_part(body, open_start + open_len, close_start - open_start - open_len)

        if inner =~ ~r/<\.(?:language_switch|theme_toggle|mode_toggle)\b/ do
          {open_start, open_len, close_start, close_len}
        end
    end
  end

  defp find_matching_close_div(body, pos) do
    find_matching_close_div(body, pos, 1)
  end

  defp find_matching_close_div(body, pos, _depth) when pos >= byte_size(body), do: nil

  defp find_matching_close_div(body, pos, depth) do
    open_idx = first_match_index(body, "<div", pos)
    close_idx = first_match_index(body, "</div>", pos)
    resolve_div_close(body, pos, depth, open_idx, close_idx)
  end

  defp first_match_index(body, needle, pos) do
    case :binary.match(body, needle, scope: {pos, byte_size(body) - pos}) do
      :nomatch -> nil
      {i, _} -> i
    end
  end

  defp resolve_div_close(_body, _pos, _depth, _open_idx, nil), do: nil

  defp resolve_div_close(body, _pos, depth, open_idx, close_idx)
       when not is_nil(open_idx) and open_idx < close_idx do
    find_matching_close_div(body, open_idx + 4, depth + 1)
  end

  defp resolve_div_close(_body, _pos, 1, _open_idx, close_idx), do: {close_idx, 6}

  defp resolve_div_close(body, _pos, depth, _open_idx, close_idx) do
    find_matching_close_div(body, close_idx + 6, depth - 1)
  end

  defp insert_as_sibling_to_existing_switcher(body, lines) do
    re = ~r/(\n([ \t]*)<\.(?:language_switch|theme_toggle|mode_toggle)\b[^\n]*\/>)/m

    case Regex.run(re, body, return: :index) do
      nil ->
        nil

      [_full, _line_idx, {indent_pos, indent_len}] ->
        indent = binary_part(body, indent_pos, indent_len)
        block = "\n" <> Enum.map_join(lines, "\n", &(indent <> &1))

        Regex.replace(re, body, fn full, _ -> full <> block end, global: false)
    end
  end

  defp insert_after_brand_anchor(body, lines, true) do
    needle = ~r/(<a href="\/" class="ui-link ui-link--brand">[\s\S]*?<\/a>\n)/m

    if Regex.match?(needle, body) do
      block = build_switcher_block(lines, true)
      Regex.replace(needle, body, fn full, _ -> full <> block end, global: false)
    end
  end

  defp insert_after_brand_anchor(body, lines, false) do
    needle = ~r/(<a href="\/">[\s\S]*?<\/a>\n)/m

    if Regex.match?(needle, body) do
      block = build_switcher_block(lines, false)
      Regex.replace(needle, body, fn full, _ -> full <> block end, global: false)
    end
  end

  defp build_switcher_block(lines, design?) do
    inner = Enum.map_join(lines, "\n", &("          " <> &1))
    open = if design?, do: ~s(<div class="layout__row">), else: "<div>"

    """
        #{open}
    #{inner}
        </div>
    """
  end

  defp replace_def_app_body(content, old_body, new_body) do
    needle = "~H\"\"\"" <> old_body <> "\"\"\""
    replacement = "~H\"\"\"" <> new_body <> "\"\"\""

    case :binary.match(content, needle) do
      :nomatch ->
        content

      {start, len} ->
        before = binary_part(content, 0, start)
        rest = binary_part(content, start + len, byte_size(content) - start - len)
        before <> replacement <> rest
    end
  end

  def patch_home_attrs(content, themes, opts, has_lang?) do
    targets = home_attr_targets(themes, opts, has_lang?)

    case :binary.match(content, "<Layouts.app") do
      :nomatch ->
        {:notice,
         "Could not find a `<Layouts.app ...>` opening tag in `home.html.heex`. " <>
           "Add the missing attributes manually: " <>
           Enum.map_join(targets, ", ", &elem(&1, 1)) <> "."}

      _ ->
        {:ok, do_patch_home_attrs(content, targets)}
    end
  end

  defp home_attr_targets(themes, opts, has_lang?) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []

    [
      {:flash, ~s(flash={@flash})},
      if(has_lang?, do: {:path, ~s(path={@path})}, else: nil),
      if(has_mode?, do: {:mode, ~s(mode={@mode})}, else: nil),
      if(has_theme?, do: {:theme, ~s(theme={@theme})}, else: nil)
    ]
    |> Enum.reject(&is_nil/1)
  end

  defp do_patch_home_attrs(content, targets) do
    Regex.replace(
      ~r/<Layouts\.app([^>]*)>/m,
      content,
      &patch_home_open_tag(&1, &2, targets),
      global: false
    )
  end

  defp patch_home_open_tag(full, attrs, targets) do
    missing =
      Enum.reject(targets, fn {kind, _line} ->
        attr_present_in_tag?(attrs, kind)
      end)

    case missing do
      [] ->
        full

      _ ->
        additions = Enum.map_join(missing, "\n  ", fn {_, line} -> line end)
        existing = String.trim_trailing(attrs)
        joined = join_layout_app_attrs(existing, additions)
        "<Layouts.app" <> joined <> "\n>"
    end
  end

  defp join_layout_app_attrs("", additions), do: "\n  " <> additions

  defp join_layout_app_attrs(existing, additions), do: existing <> "\n  " <> additions

  defp attr_present_in_tag?(attrs, kind) do
    name =
      case kind do
        :flash -> "flash"
        :path -> "path"
        :mode -> "mode"
        :theme -> "theme"
      end

    Regex.match?(~r/\b#{name}\s*=/m, attrs)
  end

  defp build_layout_def_with_design(themes, opts, has_lang?) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    any_ui? = has_mode? or has_theme? or has_lang?

    switcher_html = header_switcher_markup_with_design(has_lang?, has_theme?, has_mode?)
    header_right = if any_ui?, do: switcher_html, else: ""

    """
    def app(assigns) do
      ~H\"""
      <header class="layout__header">
        <div class="layout__header__content">
          <a href="/" class="ui-link ui-link--brand">
            #{logo_svg()}
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
      <.toast_group id="#{@toast_id}" class="toast" flash={@flash}>
        <:loading>Loading…</:loading>
        <:close>Close</:close>
      </.toast_group>
      <.toast_client_error
        toast_group_id="#{@toast_id}"
        title="We lost the connection"
        description="We're trying to reconnect you..."
        type={:error}
        duration={:infinity}
      />
    \"""
    end
    """
  end

  defp build_layout_def_no_design(themes, opts, has_lang?) do
    has_mode? = opts[:mode] == true
    has_theme? = themes != []
    any_ui? = has_mode? or has_theme? or has_lang?

    switcher_html = header_switcher_markup_no_design(has_lang?, has_theme?, has_mode?)
    header_right = if any_ui?, do: switcher_html, else: ""

    """
    def app(assigns) do
      ~H\"""
      <header>
        <div>
          <a href="/">
            #{logo_svg()}
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
      <.toast_group id="#{@toast_id}" flash={@flash}>
        <:loading>Loading…</:loading>
        <:close>Close</:close>
      </.toast_group>
      <.toast_client_error
        toast_group_id="#{@toast_id}"
        title="We lost the connection"
        description="We're trying to reconnect you..."
        type={:error}
        duration={:infinity}
      />
    \"""
    end
    """
  end
end
