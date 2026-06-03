defmodule Corex.Design.Palette do
  @moduledoc false

  alias Corex.Design.Axes
  alias Corex.Design.Rule
  alias Corex.Design.Selector

  @disabled "&:disabled,\n  &[data-disabled],\n  &[disabled]"

  def semantic_atoms, do: Axes.semantic_atoms()
  def color_atoms, do: semantic_atoms()

  def solid_var(:neutral), do: "--color-ui"
  def solid_var(role), do: "--color-#{role}"

  def solid_hover_var(:neutral), do: "--color-ui-hover"
  def solid_hover_var(:selected), do: "--color-selected-hover"
  def solid_hover_var(role), do: "--color-#{role}-hover"

  def solid_active_var(:neutral), do: "--color-ui-active"
  def solid_active_var(:selected), do: "--color-selected-active"
  def solid_active_var(role), do: "--color-#{role}-active"

  def muted_var(role), do: "--color-#{role}-muted"

  def fg_var(:neutral), do: "--color-ui-ink"
  def fg_var(:selected), do: "--color-selected-ink"
  def fg_var(role), do: ink_color_var(role)

  def on_solid_var(:neutral), do: "--color-ui-ink"
  def on_solid_var(role), do: on_solid_color_var(role)

  def outline_var(:neutral), do: "--color-outline"
  def outline_var(_role), do: "--color-outline"

  def disabled_bg_var, do: "--color-ui-muted"
  def disabled_fg_var, do: "--color-ui-ink-muted"
  def surface_var, do: "--color-ui-hover"
  def surface_active_var, do: "--color-ui-active"

  def inset_ring(role, kind) do
    var =
      case kind do
        :on_solid -> on_solid_var(role)
        :focus_ring -> fg_var(role)
      end

    "inset 0 0 0 2px var(#{var})"
  end

  def selected_host_sx(color) when is_atom(color) do
    c = Atom.to_string(color)

    %{
      "--color-selected": {:raw, "var(--color-#{c})"},
      "--color-selected-hover": {:raw, "var(--color-#{c}-hover)"},
      "--color-selected-active": {:raw, "var(--color-#{c}-active)"},
      "--color-selected-ink": {:raw, "var(--color-#{c}-ink)"},
      "--color-selected-muted": {:raw, "var(--color-#{c}-muted)"}
    }
  end

  def ink_color_atom(:selected), do: :selected_ink

  def ink_color_atom(color) when is_atom(color) do
    :"ui_ink_#{color}"
  end

  def ink_color_var(role) when is_atom(role) do
    "--color-" <> (role |> ink_color_atom() |> Atom.to_string() |> String.replace("_", "-"))
  end

  def on_solid_color_atom(color) when is_atom(color) do
    String.to_atom("#{color}_ink")
  end

  def on_solid_color_var(role) when is_atom(role) do
    "--color-" <> (role |> on_solid_color_atom() |> Atom.to_string() |> String.replace("_", "-"))
  end

  def compound_visual_rules(id), do: modifier_paint_rules(id)
  def compound_visual_on_rules(id, scope, part), do: modifier_paint_on_rules(id, scope, part)

  def compound_visual_open_closed_trigger_rules(id, part_selector, opts \\ []),
    do: modifier_paint_open_closed_trigger_rules(id, part_selector, opts)

  def modifier_paint_rules(id) do
    name = Selector.class_name(id)

    for role <- [:neutral | semantic_atoms()],
        visual <- Axes.visual_atoms() do
      Rule.new(
        host_compound_selector(name, role, visual),
        decls: visual_decls(role, visual),
        children: visual_children(role, visual)
      )
    end
  end

  def modifier_paint_on_rules(id, scope, part) do
    name = Selector.class_name(id)
    part_sel = ~s([data-scope="#{scope}"][data-part="#{part}"][data-state="on"])

    for role <- [:neutral | semantic_atoms()],
        visual <- Axes.visual_atoms() do
      Rule.new(
        "#{host_compound_selector(name, role, visual)} #{part_sel}",
        decls: visual_decls(role, visual),
        children: visual_children(role, visual)
      )
    end
  end

  def modifier_paint_open_closed_trigger_rules(id, part_selector, opts \\ []) do
    inherit = Keyword.get(opts, :inherit, [])
    name = Selector.class_name(id)
    trigger = slot_selector(id, part_selector)

    inherit_children =
      Enum.map(inherit, fn sel ->
        Rule.new("& #{sel}", decls: [color: "inherit"])
      end) ++
        [Rule.new("& [data-icon]", decls: [color: "currentcolor"])]

    for role <- [:neutral | semantic_atoms()],
        visual <- Axes.visual_atoms() do
      host_sel = host_compound_selector(name, role, visual)

      Rule.new("#{host_sel} #{trigger}",
        decls: visual_decls(role, visual),
        children: visual_children(role, visual) ++ inherit_children
      )
    end
  end

  def neutral_open_closed_trigger_rules(id, part_selector, opts \\ []) do
    inherit = Keyword.get(opts, :inherit, [])
    role = :selected
    host = ".#{Selector.class_name(id)}"
    muted = muted_var(role)

    closed =
      Rule.new("#{host} #{slot_selector(id, part_selector)}[data-state=\"closed\"]",
        decls: [color: "var(--color-ui-ink)"]
      )

    open_children =
      active_state_children(role, muted: muted) ++
        Enum.map(inherit, fn sel ->
          Rule.new("& #{sel}", decls: [color: "inherit"])
        end) ++
        [Rule.new("& [data-icon]", decls: [color: "currentcolor"])]

    open =
      Rule.new("#{host} #{slot_selector(id, part_selector)}[data-state=\"open\"]",
        decls: active_decls(role),
        children: open_children
      )

    [closed, open]
  end

  defp host_compound_selector(name, :neutral, visual),
    do: ".#{name}.#{name}--#{visual}"

  defp host_compound_selector(name, role, visual),
    do: ".#{name}.#{name}--#{visual}.#{name}--#{role}"

  def visual_decls(role, :solid) do
    [
      background_color: "var(#{solid_var(role)})",
      color: "var(#{on_solid_var(role)})",
      border_color: "transparent"
    ]
  end

  def visual_decls(role, :ghost) do
    [
      background_color: "transparent",
      color: "var(#{fg_var(role)})",
      border_color: "transparent"
    ]
  end

  def visual_decls(role, :outline) do
    [
      background_color: "transparent",
      color: "var(#{fg_var(role)})",
      border_color: "var(#{solid_var(role)})"
    ]
  end

  def visual_decls(role, :subtle) do
    [
      background_color: "var(#{surface_var()})",
      color: "var(#{fg_var(role)})",
      border_color: "transparent"
    ]
  end

  def visual_children(role, :solid) do
    [
      Rule.new("&:hover", decls: [background_color: "var(#{solid_hover_var(role)})"]),
      Rule.new("&:active", decls: [background_color: "var(#{solid_active_var(role)})"]),
      Rule.new("&:focus-visible",
        decls: [outline: "none", box_shadow: inset_ring(role, :on_solid)]
      ),
      Rule.new(@disabled,
        decls: [
          background_color: "var(#{disabled_bg_var()})",
          color: "var(#{disabled_fg_var()})",
          cursor: "not-allowed"
        ]
      )
    ]
  end

  def visual_children(role, :ghost) do
    [
      Rule.new("&:hover", decls: [background_color: "var(#{surface_var()})"]),
      Rule.new("&:active", decls: [background_color: "var(#{surface_active_var()})"]),
      Rule.new("&:focus-visible",
        decls: [outline: "none", box_shadow: inset_ring(role, :focus_ring)]
      ),
      Rule.new(@disabled,
        decls: [
          background_color: "transparent",
          color: "var(#{disabled_fg_var()})",
          cursor: "not-allowed"
        ]
      )
    ]
  end

  def visual_children(role, :outline) do
    [
      Rule.new("&:hover", decls: [background_color: "var(#{surface_var()})"]),
      Rule.new("&:active", decls: [background_color: "var(#{surface_active_var()})"]),
      Rule.new("&:focus-visible",
        decls: [outline: "none", box_shadow: inset_ring(role, :focus_ring)]
      ),
      Rule.new(@disabled,
        decls: [
          background_color: "transparent",
          color: "var(#{disabled_fg_var()})",
          border_color: "var(#{disabled_bg_var()})",
          cursor: "not-allowed"
        ]
      )
    ]
  end

  def visual_children(role, :subtle) do
    [
      Rule.new("&:hover", decls: [background_color: "var(#{surface_active_var()})"]),
      Rule.new("&:focus-visible",
        decls: [outline: "none", box_shadow: inset_ring(role, :focus_ring)]
      ),
      Rule.new(@disabled,
        decls: [
          background_color: "var(#{disabled_bg_var()})",
          color: "var(#{disabled_fg_var()})",
          cursor: "not-allowed"
        ]
      )
    ]
  end

  def active_decls(role) do
    [
      background_color: "var(#{solid_var(role)})",
      color: "var(#{on_solid_var(role)})"
    ]
  end

  def host_mod(id, role) when is_atom(role) do
    name = Selector.class_name(id)
    ".#{name}.#{name}--#{role}"
  end

  def neutral_host(id), do: ".#{Selector.class_name(id)}"

  def semantic_host_marker, do: %{position: :relative}

  def semantic_host_variants do
    for role <- semantic_atoms(), do: {role, semantic_host_marker()}
  end

  def semantic_part_host_variants do
    for role <- semantic_atoms(), do: {role, [host: semantic_host_marker()]}
  end

  def semantic_slot_host_variants, do: semantic_part_host_variants()

  def semantic_solid_part_rules(id, part_selector) do
    for role <- semantic_atoms() do
      host = host_mod(id, role)

      Rule.new("#{host} #{slot_selector(id, part_selector)}",
        decls: active_decls(role),
        children: active_state_children(role)
      )
    end
  end

  def semantic_ink_part_rules(id, part_selector, opts \\ []) do
    hover = Keyword.get(opts, :hover, true)

    for role <- semantic_atoms() do
      host = host_mod(id, role)

      children =
        [
          if(hover,
            do: Rule.new("&:hover", decls: [background_color: "var(#{surface_var()})"]),
            else: nil
          ),
          Rule.new("&:focus-visible",
            decls: [outline: "none", box_shadow: inset_ring(role, :focus_ring)]
          ),
          Rule.new(@disabled,
            decls: [color: "var(#{disabled_fg_var()})", cursor: "not-allowed"]
          )
        ]
        |> Enum.reject(&is_nil/1)

      Rule.new("#{host} #{slot_selector(id, part_selector)}",
        decls: [color: "var(#{fg_var(role)})"],
        children: children
      )
    end
  end

  def semantic_focus_rules(id, part_selector, opts \\ []) do
    complete = Keyword.get(opts, :complete, false)

    for role <- semantic_atoms() do
      host = host_mod(id, role)
      ring = "var(#{fg_var(role)})"
      solid = "var(#{solid_var(role)})"

      focus_children = [
        Rule.new("&:focus, &:focus-visible",
          decls: [outline: "none", box_shadow: "inset 0 0 0 2px #{ring}"]
        )
      ]

      children =
        if complete do
          focus_children ++
            [
              Rule.new("&[data-complete]",
                decls: [border_color: solid],
                children: focus_children
              )
            ]
        else
          focus_children
        end

      Rule.new("#{host} #{slot_selector(id, part_selector)}", decls: [], children: children)
    end
  end

  def semantic_ink_variant(role) when is_atom(role) do
    %{color: {:color, ink_color_atom(role)}}
  end

  def active_state_children(role, opts \\ []) do
    muted = Keyword.get(opts, :muted)
    disabled_color = Keyword.get(opts, :disabled_color)

    disabled_decls =
      if muted do
        [background_color: muted, cursor: "not-allowed"] ++
          if(disabled_color, do: [color: disabled_color], else: [])
      else
        [background_color: "var(#{disabled_bg_var()})", cursor: "not-allowed"]
      end

    [
      Rule.new("&:hover", decls: [background_color: "var(#{solid_hover_var(role)})"]),
      Rule.new("&:active", decls: [background_color: "var(#{solid_active_var(role)})"]),
      Rule.new("&:focus-visible",
        decls: [
          outline: "none",
          box_shadow: "inset 0 0 0 2px var(#{on_solid_var(role)})"
        ]
      ),
      Rule.new(@disabled, decls: disabled_decls)
    ]
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
