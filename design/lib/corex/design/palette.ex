defmodule Corex.Design.Palette do
  @moduledoc false

  alias Corex.Design.Axes
  alias Corex.Design.Bem
  alias Corex.Design.Rule
  alias Corex.Design.Selector
  alias Corex.Design.Semantics

  @disabled "&:disabled,\n  &[data-disabled],\n  &[disabled]"

  def semantic_atoms, do: Semantics.atoms()
  def color_atoms, do: semantic_atoms()

  def paint_roles, do: [:implicit | semantic_atoms()]

  def paint_role(:implicit), do: :base
  def paint_role(role), do: role

  def solid_var(role), do: "--color-#{paint_role(role)}"

  def solid_hover_var(role), do: "--color-#{paint_role(role)}-hover"
  def solid_active_var(role), do: "--color-#{paint_role(role)}-active"
  def muted_var(role), do: "--color-#{paint_role(role)}-muted"

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

  def compound_visual_rules(id), do: modifier_paint_rules(id)
  def compound_visual_on_rules(id, scope, part), do: modifier_paint_on_rules(id, scope, part)

  def compound_visual_open_closed_trigger_rules(id, part_selector, opts \\ []),
    do: modifier_paint_open_closed_trigger_rules(id, part_selector, opts)

  def modifier_paint_rules(id) do
    name = Selector.class_name(id)

    for role <- paint_roles(),
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

    for role <- paint_roles(),
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

    for role <- paint_roles(),
        visual <- Axes.visual_atoms() do
      host_sel = host_compound_selector(name, role, visual)

      Rule.new("#{host_sel} #{trigger}",
        decls: visual_decls(role, visual),
        children: visual_children(role, visual) ++ inherit_children
      )
    end
  end

  def implicit_open_closed_trigger_rules(id, part_selector, opts \\ []) do
    inherit = Keyword.get(opts, :inherit, [])
    role = :implicit
    host = implicit_host(id)
    muted = muted_var(role)

    closed =
      Rule.new("#{host} #{slot_selector(id, part_selector)}[data-state=\"closed\"]",
        decls: [color: "var(--color-on-page)"]
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

  def neutral_open_closed_trigger_rules(id, part_selector, opts \\ []),
    do: implicit_open_closed_trigger_rules(id, part_selector, opts)

  defp host_compound_selector(name, :implicit, visual),
    do: ".#{name}.#{name}--variant-#{visual}"

  defp host_compound_selector(name, role, visual),
    do: ".#{name}.#{name}--variant-#{visual}.#{name}--semantic-#{role}"

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

  def visual_children(role, visual) when visual in [:ghost, :outline, :subtle] do
    hover_active =
      case visual do
        :subtle ->
          [Rule.new("&:hover", decls: [background_color: "var(#{surface_active_var()})"])]

        _ ->
          [
            Rule.new("&:hover", decls: [background_color: "var(#{surface_var()})"]),
            Rule.new("&:active", decls: [background_color: "var(#{surface_active_var()})"])
          ]
      end

    disabled =
      case visual do
        :outline ->
          Rule.new(@disabled,
            decls: [
              background_color: "transparent",
              color: "var(#{disabled_fg_var()})",
              border_color: "var(#{disabled_bg_var()})",
              cursor: "not-allowed"
            ]
          )

        :ghost ->
          Rule.new(@disabled,
            decls: [
              background_color: "transparent",
              color: "var(#{disabled_fg_var()})",
              cursor: "not-allowed"
            ]
          )

        :subtle ->
          Rule.new(@disabled,
            decls: [
              background_color: "var(#{disabled_bg_var()})",
              color: "var(#{disabled_fg_var()})",
              cursor: "not-allowed"
            ]
          )
      end

    hover_active ++
      [
        Rule.new("&:focus-visible",
          decls: [outline: "none", box_shadow: inset_ring(role, :focus_ring)]
        ),
        disabled
      ]
  end

  def active_decls(role) do
    [
      background_color: "var(#{solid_var(role)})",
      color: "var(#{on_solid_var(role)})"
    ]
  end

  def host_mod(id, role) when is_atom(role), do: Bem.host_selector(id, :semantic, role)

  def host_size_mod(id, size) when is_atom(size), do: Bem.host_selector(id, :size, size)

  def host_size_mod(id, size) when is_binary(size), do: host_size_mod(id, String.to_atom(size))

  def implicit_host(id), do: ".#{Selector.class_name(id)}"

  def neutral_host(id), do: implicit_host(id)

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
