defmodule Corex.Design.Palette do
  @moduledoc false

  alias Corex.Design.Axes
  alias Corex.Design.Bem
  alias Corex.Design.Rule
  alias Corex.Design.Selector
  @disabled "&:disabled,\n  &[data-disabled],\n  &[disabled]"

  def semantic_atoms, do: Axes.semantic_atoms()
  def color_atoms, do: semantic_atoms()

  def paint_roles, do: [:implicit | semantic_atoms()]

  def paint_role(:implicit), do: :base
  def paint_role(role), do: role

  def solid_var(role), do: "--color-#{paint_role(role)}"

  def solid_hover_var(role), do: "--color-#{paint_role(role)}-hover"
  def solid_active_var(role), do: "--color-#{paint_role(role)}-active"
  def muted_var(role), do: "--color-#{paint_role(role)}-muted"

  def fg_var(role) when role in [:base, :implicit], do: on_solid_var(role)
  def fg_var(role), do: solid_var(role)

  def on_solid_var(role), do: "--color-on-#{paint_role(role)}"

  def outline_var(_role), do: "--color-focus"

  def disabled_bg_var, do: "--color-surface-control-muted"
  def disabled_fg_var, do: "--color-on-muted"
  def surface_var, do: "--color-surface-control-hover"
  def surface_active_var, do: "--color-surface-control-active"

  def inset_ring(role, kind) do
    var =
      case kind do
        :on_solid -> on_solid_var(role)
        :focus_ring -> fg_var(role)
        _ -> solid_var(role)
      end

    "inset 0 0 0 2px var(#{var})"
  end

  def ink_color_atom(role) when is_atom(role), do: paint_role(role)

  def ink_color_var(role) when is_atom(role), do: solid_var(role)

  def on_solid_color_atom(role) when is_atom(role), do: :"on_#{paint_role(role)}"

  def on_solid_color_var(role) when is_atom(role) do
    "--color-on-" <> Atom.to_string(paint_role(role))
  end

  def paint_sx(role) do
    r = paint_role(role)
    solid = "--color-#{r}"
    on = "--color-on-#{r}"
    ink = if r == :base, do: on, else: solid

    %{
      "--paint-bg": {:raw, "var(#{solid})"},
      "--paint-fg": {:raw, "var(#{on})"},
      "--paint-ink": {:raw, "var(#{ink})"},
      "--paint-bg-hover": {:raw, "var(#{solid}-hover)"},
      "--paint-bg-active": {:raw, "var(#{solid}-active)"},
      "--paint-ring": {:raw, "var(#{ink})"},
      "--paint-border": {:raw, "var(#{ink})"}
    }
  end

  def paint_decls(role) do
    paint_sx(role)
    |> Map.to_list()
  end

  def semantic_paint_sx(role), do: paint_sx(role)

  def semantic_host_marker, do: semantic_paint_sx(:base)

  def semantic_host_variants do
    for role <- semantic_atoms(), do: {role, semantic_paint_sx(role)}
  end

  def semantic_part_host_variants do
    for role <- semantic_atoms(), do: {role, [host: semantic_paint_sx(role)]}
  end

  def semantic_slot_host_variants, do: semantic_part_host_variants()

  def default_paint_host_rule(id) do
    Rule.new(implicit_host(id), decls: paint_decls(:implicit))
  end

  def variant_visual_apply_rules(id, opts \\ []) do
    name = Selector.class_name(id)
    part = Keyword.get(opts, :part)
    inherit = Keyword.get(opts, :inherit, [])

    inherit_children =
      Enum.map(inherit, fn sel ->
        Rule.new("& #{sel}", decls: [color: "inherit"])
      end) ++
        [Rule.new("& [data-icon]", decls: [color: "currentcolor"])]

    for visual <- Axes.visual_atoms() do
      utility = "visual-#{visual}"

      selector =
        if part do
          ".#{name}.#{name}--variant-#{visual} #{part}"
        else
          ".#{name}.#{name}--variant-#{visual}"
        end

      children = if inherit == [], do: [], else: inherit_children

      Rule.new(selector, decls: [{:apply, utility}], children: children)
    end
  end

  def variant_visual_on_apply_rules(id, scope, part, opts \\ []) do
    part_sel = ~s([data-scope="#{scope}"][data-part="#{part}"][data-state="on"])
    variant_visual_apply_rules(id, Keyword.merge(opts, part: part_sel))
  end

  def variant_paint_target(%{id: :button}), do: :host

  def variant_paint_target(%{id: :accordion, scope: scope}),
    do: {:part, scope, "item-trigger", ["item-text"]}

  def variant_paint_target(%{id: :toggle, scope: scope}),
    do: {:part_on, scope, "root"}

  def variant_paint_target(_), do: nil

  def open_closed_trigger_apply_rules(id, part_selector, opts \\ []) do
    inherit = Keyword.get(opts, :inherit, [])
    host = implicit_host(id)
    trigger = slot_selector(id, part_selector)

    inherit_children =
      Enum.map(inherit, fn sel ->
        Rule.new("& #{sel}", decls: [color: "inherit"])
      end) ++
        [Rule.new("& [data-icon]", decls: [color: "currentcolor"])]

    [
      Rule.new("#{host} #{trigger}[data-state=\"closed\"]",
        decls: [color: "var(--paint-ink)"]
      ),
      Rule.new("#{host} #{trigger}[data-state=\"open\"]",
        decls: [{:apply, "visual-solid"}],
        children: inherit_children
      )
    ]
  end

  def compound_visual_rules(id) do
    [default_paint_host_rule(id)]
  end

  def compound_visual_on_rules(id, _scope, _part) do
    [default_paint_host_rule(id)]
  end

  def compound_visual_open_closed_trigger_rules(id, _part_selector, _opts \\ []) do
    [default_paint_host_rule(id)]
  end

  def modifier_paint_rules(id), do: compound_visual_rules(id)

  def modifier_paint_on_rules(id, scope, part),
    do: compound_visual_on_rules(id, scope, part)

  def modifier_paint_open_closed_trigger_rules(id, part_selector, opts \\ []),
    do: compound_visual_open_closed_trigger_rules(id, part_selector, opts)

  def implicit_open_closed_trigger_rules(id, part_selector, opts \\ []),
    do: open_closed_trigger_apply_rules(id, part_selector, opts)

  def neutral_open_closed_trigger_rules(id, part_selector, opts \\ []),
    do: open_closed_trigger_apply_rules(id, part_selector, opts)

  def visual_decls(_role, :solid) do
    [
      background_color: "var(--paint-bg)",
      color: "var(--paint-fg)",
      border_color: "transparent"
    ]
  end

  def visual_decls(_role, :ghost) do
    [
      background_color: "transparent",
      color: "var(--paint-ink)",
      border_color: "transparent"
    ]
  end

  def visual_decls(_role, :outline) do
    [
      background_color: "transparent",
      color: "var(--paint-ink)",
      border_color: "var(--paint-border)"
    ]
  end

  def visual_decls(_role, :subtle) do
    [
      background_color: "var(#{surface_var()})",
      color: "var(--paint-ink)",
      border_color: "transparent"
    ]
  end

  def active_decls(_role) do
    [
      background_color: "var(--paint-bg)",
      color: "var(--paint-fg)"
    ]
  end

  def host_mod(id, role) when is_atom(role), do: Bem.host_selector(id, :semantic, role)

  def host_size_mod(id, size) when is_atom(size), do: Bem.host_selector(id, :size, size)

  def host_size_mod(id, size) when is_binary(size), do: host_size_mod(id, String.to_atom(size))

  def implicit_host(id), do: ".#{Selector.class_name(id)}"

  def neutral_host(id), do: implicit_host(id)

  def semantic_solid_part_rules(id, part_selector) do
    [
      Rule.new(
        "#{implicit_host(id)} #{slot_selector(id, part_selector)}",
        decls: [{:apply, "visual-solid"}]
      )
    ]
  end

  def semantic_ink_part_rules(id, part_selector, opts \\ []) do
    hover = Keyword.get(opts, :hover, true)

    children =
      [
        if(hover,
          do: Rule.new("&:hover", decls: [background_color: "var(#{surface_var()})"]),
          else: nil
        ),
        Rule.new("&:focus-visible",
          decls: [outline: "none", box_shadow: "inset 0 0 0 2px var(--paint-ring)"]
        ),
        Rule.new(@disabled,
          decls: [color: "var(#{disabled_fg_var()})", cursor: "not-allowed"]
        )
      ]
      |> Enum.reject(&is_nil/1)

    [
      Rule.new("#{implicit_host(id)} #{slot_selector(id, part_selector)}",
        decls: [color: "var(--paint-ink)"],
        children: children
      )
    ]
  end

  def semantic_focus_rules(id, part_selector, opts \\ []) do
    complete = Keyword.get(opts, :complete, false)

    focus_children = [
      Rule.new("&:focus, &:focus-visible",
        decls: [outline: "none", box_shadow: "inset 0 0 0 2px var(--paint-ring)"]
      )
    ]

    children =
      if complete do
        focus_children ++
          [
            Rule.new("&[data-complete]",
              decls: [border_color: "var(--paint-border)"],
              children: focus_children
            )
          ]
      else
        focus_children
      end

    [
      Rule.new("#{implicit_host(id)} #{slot_selector(id, part_selector)}",
        decls: [],
        children: children
      )
    ]
  end

  def semantic_ink_variant(role) when is_atom(role) do
    %{color: {:color, ink_color_atom(role)}}
  end

  def active_state_children(_role, _opts \\ []) do
    []
  end

  defp slot_selector(id, selector) do
    host = Selector.host(id)
    prefix = "#{host} "

    if String.starts_with?(selector, prefix) do
      String.replace_prefix(selector, prefix, "")
    else
      selector
    end
  end
end
