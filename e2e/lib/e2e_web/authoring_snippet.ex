defmodule E2eWeb.AuthoringSnippet do
  @moduledoc false

  alias E2eWeb.DocAuthoring

  @style_axes ~w(
    semantic size text radius width max_width height max_height
    variant shape gap align justify padding padding_inline padding_block
    wrap shrink grow direction orientation side modal
  )a

  @recipe_looks %{
    dialog: %{"modal" => "dialog-modal", "side" => "dialog-side"},
    tree_view: %{"treeview" => "tree-view", "navigation" => "tree-navigation"},
    action: %{"button" => "button", "link" => "link"},
    navigate: %{"link" => "link", "button" => "button"}
  }

  @playground_omit ~w(id value)a

  def snippets(component, attrs, opts \\ []) when is_atom(component) and is_list(attrs) do
    inner = Keyword.get(opts, :inner, "")
    slots = Keyword.get(opts, :slots, "")
    omit = Keyword.get(opts, :omit, [])
    attrs = Keyword.drop(attrs, omit)

    %{
      attr: format(component, attrs, inner, slots, :attr),
      class: format(component, attrs, inner, slots, :class),
      markup: format(component, attrs, inner, slots, :markup)
    }
  end

  def accordion_anatomy_snippets(attrs, opts \\ []) when is_list(attrs) do
    snippets(:accordion, attrs, opts)
  end

  def playground_snippets(component, attrs, opts \\ []) when is_atom(component) and is_list(attrs) do
    snippets(component, attrs, Keyword.put(opts, :omit, @playground_omit))
  end

  def playground_heex_snippets(code) when is_binary(code) do
    heex_snippets(code, omit: @playground_omit)
  end

  def heex_snippets(code, opts \\ []) when is_binary(code) do
    attr =
      code
      |> String.trim()
      |> strip_heex_attrs(Keyword.get(opts, :omit, []))

    %{
      attr: attr,
      class: heex_accordion_class(attr),
      markup: heex_accordion_markup(attr)
    }
  end

  def personalize_snippet(code, app_name \\ nil)

  def personalize_snippet(code, app_name) when is_binary(code) do
    substitute_app_name(code, app_name || DocAuthoring.get().app_name)
  end

  def personalize_snippet(%{attr: attr, class: class, markup: markup}, app_name) do
    app_name = app_name || DocAuthoring.get().app_name

    %{
      attr: substitute_app_name(attr, app_name),
      class: substitute_app_name(class, app_name),
      markup: substitute_app_name(markup, app_name)
    }
  end

  def personalize_snippet(%{attr: attr, class: class}, app_name) do
    app_name = app_name || DocAuthoring.get().app_name

    %{
      attr: substitute_app_name(attr, app_name),
      class: substitute_app_name(class, app_name)
    }
  end

  def personalize_snippet(code, _app_name), do: code

  def substitute_app_name(code, app_name) when is_binary(code) do
    app_name = DocAuthoring.normalize_app_name(app_name)

    if app_name == DocAuthoring.default_app_name() do
      code
    else
      module = DocAuthoring.module_name(app_name)
      web_module = DocAuthoring.web_module_name(app_name)

      code
      |> String.replace("MyAppWeb", web_module)
      |> String.replace("MyApp", module)
      |> String.replace("my_app", app_name)
    end
  end

  def substitute_app_name(%{attr: attr, class: class, markup: markup}, app_name) do
    %{
      attr: substitute_app_name(attr, app_name),
      class: substitute_app_name(class, app_name),
      markup: substitute_app_name(markup, app_name)
    }
  end

  def substitute_app_name(%{attr: attr, class: class}, app_name) do
    %{
      attr: substitute_app_name(attr, app_name),
      class: substitute_app_name(class, app_name)
    }
  end

  def substitute_app_name(code, _app_name), do: code

  def format(component, attrs, inner, slots, :attr) do
    attrs = drop_class(attrs)
    tag(component, attrs, inner, slots, nil)
  end

  def format(component, attrs, inner, slots, :class) do
    {attrs, extra_class} = split_class(attrs)
    style_attrs = attrs |> take_style_axes() |> drop_component_defaults(component)
    non_style_attrs = drop_style_axes(attrs)
    base = component_base(component, attrs)
    axis_names = Keyword.keys(style_attrs)

    assigns =
      style_attrs
      |> Map.new()
      |> then(fn map ->
        if extra_class, do: Map.put(map, :class, extra_class), else: map
      end)

    class = Corex.Variants.host_class(base, axis_names, %{}, assigns)
    tag(component, non_style_attrs, inner, slots, class)
  end

  def format(component, attrs, inner, slots, :markup) do
    {attrs, _extra_class} = split_class(attrs)
    non_style_attrs = drop_style_axes(attrs)
    tag(component, non_style_attrs, inner, slots, nil)
  end

  def accordion_styling(variants, opts \\ []) do
    variants
    |> accordion_styling_snippets(opts)
    |> Map.get(:attr)
  end

  def accordion_styling_snippets(variants, opts \\ []) do
    items = Keyword.get(opts, :items_code, styling_items_code())
    slot = Keyword.get(opts, :slot, indicator_slot())
    slots = items_attr(items)

    Enum.reduce(variants, %{attr: "", class: "", markup: ""}, fn attrs, acc ->
      %{attr: attr, class: class, markup: markup} =
        snippets(:accordion, attrs, inner: slot, slots: slots)

      %{
        attr: join_snippet_lines(acc.attr, attr),
        class: join_snippet_lines(acc.class, class),
        markup: join_snippet_lines(acc.markup, markup)
      }
    end)
  end

  def dialog_modal_snippets(attrs, opts \\ []) when is_list(attrs) do
    slots = Keyword.get(opts, :slots, dialog_modal_slots())

    attrs = Keyword.put_new(attrs, :modal, true)

    trigger = "<:trigger>Open (#{size_label(attrs)})</:trigger>"

    slots =
      slots
      |> String.replace("<:trigger>Open</:trigger>", trigger)

    snippets(:dialog, attrs, slots: slots)
  end

  defp join_snippet_lines(left, right) do
    [left, right]
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n")
  end

  defp size_label(attrs) do
    case Keyword.get(attrs, :size) do
      nil -> "default"
      size -> size
    end
  end

  defp dialog_modal_slots do
    ~s(
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
    )
  end

  def items_code, do: styling_items_code()

  def items_attr(code \\ nil, base_indent \\ "")

  def items_attr(code, base_indent) when is_binary(code) do
    expr = String.trim(code)
    attr_indent = base_indent <> "  "
    body_indent = base_indent <> "    "

    [head | tail] = String.split(expr, "\n", trim: true)

    lines =
      [attr_indent <> "items={" <> head] ++
        Enum.map(tail, fn
          "])" -> attr_indent <> "])}"
          line -> body_indent <> String.trim(line)
        end)

    Enum.join(lines, "\n")
  end

  def items_attr(nil, base_indent), do: items_attr(styling_items_code(), base_indent)

  defp styling_items_code,
    do: String.trim(E2eWeb.Demos.DocExamples.code_content_items_with_values())

  defp indicator_slot, do: ~s(
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    )

  defp drop_class(attrs) do
    Enum.reject(attrs, fn {k, _} -> k == :class end)
  end

  defp split_class(attrs) do
    case Keyword.pop(attrs, :class) do
      {nil, rest} -> {rest, nil}
      {class, rest} -> {rest, class}
    end
  end

  defp take_style_axes(attrs) do
    for {axis, value} <- attrs, axis in @style_axes, not is_nil(value), do: {axis, value}
  end

  defp drop_style_axes(attrs) do
    Enum.reject(attrs, fn {k, _} -> k in @style_axes or k == :class end)
  end

  defp drop_component_defaults(style_attrs, component) do
    defaults = E2eWeb.ComponentStyleDefaults.snippet_defaults(component)

    Enum.reject(style_attrs, fn {axis, value} ->
      Map.get(defaults, axis) == to_string(value)
    end)
  end

  defp component_base(component, attrs) do
    name = Atom.to_string(component)

    case Map.get(@recipe_looks, component) do
      nil ->
        name

      looks ->
        as = Keyword.get(attrs, :as) || default_as(component)
        Map.fetch!(looks, to_string(as))
    end
  end

  defp default_as(:dialog), do: "modal"
  defp default_as(:tree_view), do: "treeview"
  defp default_as(:action), do: "button"
  defp default_as(:navigate), do: "link"

  defp tag(component, attrs, inner, slots, class) do
    name = component_name(component)
    {host_suffix, body_slots} = split_host_attrs(slots)

    attr_str =
      attrs
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)
      |> Enum.map(&attr_pair/1)
      |> then(fn parts ->
        if class, do: parts ++ [~s(class="#{class}")], else: parts
      end)
      |> Enum.reject(&is_nil/1)
      |> Enum.join(" ")

    host_attrs = build_host_attrs(attr_str, host_suffix)
    body = String.trim("#{inner}#{body_slots}")

    if body == "" do
      format_opening_tag(name, host_attrs, true)
    else
      """
      #{format_opening_tag(name, host_attrs, false)}
      #{body}
      </.#{name}>
      """
      |> String.trim()
    end
  end

  defp build_host_attrs("", host_suffix), do: String.trim_trailing(host_suffix)

  defp build_host_attrs(attr_str, "") do
    String.trim(attr_str)
  end

  defp build_host_attrs(attr_str, host_suffix) do
    host_suffix = String.trim_trailing(host_suffix)

    if String.contains?(host_suffix, "\n") do
      attr_str
      |> String.split(" ", trim: true)
      |> Enum.map(&("  " <> &1))
      |> Kernel.++([host_suffix])
      |> Enum.join("\n")
    else
      String.trim(attr_str <> " " <> host_suffix)
    end
  end

  defp format_opening_tag(name, "", self_closing?) do
    if self_closing?, do: "<.#{name} />", else: "<.#{name}>"
  end

  defp format_opening_tag(name, host_attrs, self_closing?) do
    if String.contains?(host_attrs, "\n") do
      suffix = if self_closing?, do: "\n/>", else: "\n>"

      "<.#{name}\n#{host_attrs}#{suffix}"
    else
      if self_closing?, do: "<.#{name} #{host_attrs} />", else: "<.#{name} #{host_attrs}>"
    end
  end

  defp split_host_attrs(""), do: {"", ""}

  defp split_host_attrs(slots) do
    if host_attr_suffix?(slots) do
      {slots, ""}
    else
      {"", slots}
    end
  end

  defp host_attr_suffix?(slots) do
    slots
    |> String.trim_leading()
    |> then(fn trimmed ->
      Regex.match?(~r/^\w[\w-]*=\{/, trimmed) or Regex.match?(~r/^\w[\w-]*="/, trimmed)
    end)
  end

  defp attr_pair({key, value}) when is_boolean(value) do
    if value, do: Atom.to_string(key), else: nil
  end

  defp attr_pair({key, value}) when is_atom(value) do
    ~s(#{key}="#{value}")
  end

  defp attr_pair({key, value}) when is_binary(value) do
    ~s(#{key}="#{value}")
  end

  defp attr_pair({key, value}) do
    ~s(#{key}={#{inspect(value)}})
  end

  defp component_name(component) do
    component
    |> Atom.to_string()
    |> String.replace("-", "_")
  end

  defp heex_accordion_class(heex) do
    heex
    |> transform_accordion_skeleton(&add_class_attr(&1, "accordion"))
    |> transform_accordion_tags(&add_class_attr(&1, "accordion"))
  end

  defp heex_accordion_markup(heex) do
    heex
    |> transform_accordion_tags(fn attrs ->
      attrs
      |> strip_class_attr()
      |> add_unstyled_attr()
    end)
  end

  defp transform_accordion_tags(heex, fun) when is_function(fun, 1) do
    Regex.replace(~r/<\.accordion([^>]*?)(\/?>)/, heex, fn _, attrs, close ->
      "<.accordion#{fun.(attrs)}#{close}"
    end)
  end

  defp transform_accordion_skeleton(heex, fun) when is_function(fun, 1) do
    Regex.replace(~r/<\.accordion_skeleton([^>]*?)(\/?>)/, heex, fn _, attrs, close ->
      "<.accordion_skeleton#{fun.(attrs)}#{close}"
    end)
  end

  defp add_class_attr(attrs, class) do
    if String.contains?(attrs, "class=") do
      attrs
    else
      ~s( class="#{class}"#{attrs})
    end
  end

  defp strip_class_attr(attrs) do
    attrs
    |> String.replace(~r/\s+class="[^"]*"/, "")
    |> String.replace(~r/\s+class='[^']*'/, "")
  end

  defp add_unstyled_attr(attrs) do
    if String.contains?(attrs, "unstyled") do
      attrs
    else
      " unstyled#{attrs}"
    end
  end

  defp strip_heex_attrs(code, []), do: code

  defp strip_heex_attrs(code, omit) when is_list(omit) do
    Enum.reduce(omit, code, fn attr, acc ->
      name = Regex.escape(to_string(attr))

      acc
      |> String.replace(~r/\s+#{name}="[^"]*"/, "")
      |> String.replace(~r/\s+#{name}='[^']*'/, "")
      |> String.replace(~r/\s+#{name}=\{~W\([^)]*\)\}/, "")
      |> String.replace(~r/\s+#{name}=\{[^}]+\}/, "")
    end)
  end
end
