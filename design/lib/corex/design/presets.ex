defmodule Corex.Design.Presets do
  @moduledoc false

  alias Corex.Design.Rule
  alias Corex.Design.Tokens.Scales

  alias Corex.Design.Emit.Tokens, as: Var

  @host_sizing_axes ~W(width max_width height max_height)a
  @define_sizing_axes ~W(width max_width height max_height)a

  def host_sizing_axes do
    [
      width: host_axis_variants(width_blocks()),
      max_width: host_axis_variants(max_width_blocks()),
      height: host_axis_variants(height_blocks()),
      max_height: host_axis_variants(max_height_blocks())
    ]
  end

  def host_width_sizing_axes do
    [
      width: host_axis_variants(width_blocks()),
      max_width: host_axis_variants(max_width_blocks())
    ]
  end

  def slot_axis_variants(blocks, slot) do
    Enum.map(blocks, fn {key, block} -> {key, [{slot, block}]} end)
  end

  def define_sizing_axes do
    [
      width: width_blocks(),
      max_width: max_width_blocks(),
      height: height_blocks(),
      max_height: max_height_blocks()
    ]
  end

  def merge_host_sizing_variants(variants) do
    host_sizing_axes()
    |> Keyword.drop(Keyword.keys(variants))
    |> Keyword.merge(variants)
  end

  def merge_define_sizing_variants(variants) do
    define_sizing_axes()
    |> Keyword.drop(Keyword.keys(variants))
    |> Keyword.merge(variants)
  end

  def default_host_sizing do
    [width: :fit, max_width: :none, height: :auto, max_height: :none]
  end

  def default_block_host_sizing do
    [width: :full, max_width: :none, height: :auto, max_height: :none]
  end

  def inline_host_sizing do
    [width: :auto, max_width: :none, height: :auto, max_height: :none]
  end

  def host_sizing_keys, do: @host_sizing_axes
  def define_sizing_keys, do: @define_sizing_axes

  def width_blocks do
    [auto: %{width: :auto}, fit: %{width: "fit-content"}, full: %{width: "100%"}]
  end

  def max_width_blocks do
    container =
      for {step, _} <- Scales.container(), do: {step, %{max_width: {:container, step}}}

    [none: %{max_width: :none}, full: %{max_width: "100%"}] ++ container
  end

  def height_blocks do
    [auto: %{height: :auto}, fit: %{height: "fit-content"}, full: %{height: "100%"}]
  end

  def max_height_blocks do
    container =
      for {step, _} <- Scales.container(), do: {step, %{max_height: {:container, step}}}

    [none: %{max_height: :none}, full: %{max_height: "100%"}] ++ container
  end

  defp host_axis_variants(blocks) do
    Enum.map(blocks, fn {key, block} -> {key, [host: block]} end)
  end

  def strip_host_sizing_base(base, keys \\ @host_sizing_axes) when is_list(base) do
    case Keyword.get(base, :host) do
      nil ->
        base

      host ->
        host = Map.drop(host, keys)
        if host == %{}, do: Keyword.delete(base, :host), else: Keyword.put(base, :host, host)
    end
  end

  def strip_define_sizing_base(base, keys \\ @define_sizing_axes) when is_map(base) do
    Map.drop(base, keys)
  end

  def icon_part do
    %{
      display: :flex,
      align_items: :center,
      justify_content: :center,
      height: {:raw, "1em !important"},
      width: {:raw, "1em !important"},
      color: {:raw, "currentcolor"},
      flex_shrink: {:raw, "0"},
      rtl: %{transform: {:raw, "scaleX(-1)"}}
    }
  end

  def icon_child_selector, do: ~S(& [data-icon])

  def icon_child_selector_with_icon_class, do: ~S(& [data-icon],\n  & .icon)

  def trigger_indicator_part do
    %{
      display: :inline_flex,
      align_items: :center,
      justify_content: :center,
      flex_shrink: {:raw, "0"},
      width: {:raw, "1em"},
      height: {:raw, "1em"},
      color: {:raw, "currentcolor"}
    }
  end

  def item_text do
    %{
      flex: {:raw, "1 1 0%"},
      min_width: {:raw, "0"},
      max_width: {:raw, "100%"},
      width: :auto,
      overflow: :hidden,
      text_overflow: :ellipsis,
      white_space: :nowrap,
      display: :block,
      text_align: :start
    }
  end

  def item_row_text do
    %{
      flex: {:raw, "1 1 0%"},
      min_width: {:raw, "0"},
      max_width: {:raw, "100%"},
      width: :auto,
      overflow: :hidden,
      text_overflow: :ellipsis,
      white_space: :nowrap,
      display: :flex,
      flex_direction: :row,
      align_items: :center,
      gap: {:space, :md},
      text_align: :start
    }
  end

  def item_row_indicator do
    %{
      display: :flex,
      align_items: :center,
      justify_content: :center,
      flex: {:raw, "0 0 auto"},
      flex_shrink: {:raw, "0"},
      min_width: {:raw, "1em"},
      min_height: {:raw, "1em"},
      margin_inline_start: :auto
    }
  end

  def item_row_indicator_hidden do
    %{display: {:raw, "flex !important"}, visibility: :hidden}
  end

  def link_base do
    %{
      display: :inline_flex,
      align_items: :center,
      gap: {:space, :md},
      width: :auto,
      cursor: :pointer,
      background_color: :transparent,
      color: {:color, :link},
      text_decoration_line: :underline,
      text_underline_offset: {:raw, "0.15em"},
      text_decoration_thickness: {:raw, "from-font"},
      overflow: :visible,
      border: :none,
      padding: 0,
      appearance: :none,
      transition: {:raw, "color 120ms ease, box-shadow 120ms ease"},
      hover: %{color: {:color, :ui_ink}},
      active: %{color: {:color, :ui_ink_muted}},
      visited: %{color: {:color, :ui_ink_muted}},
      focus_visible: %{
        outline: :none,
        box_shadow: inset_ring(:focus_ring)
      },
      disabled:
        lock_disabled_interaction(%{
          color: {:color, :ui_ink_muted},
          cursor: :not_allowed,
          text_decoration_line: :none,
          box_shadow: :none
        })
    }
  end

  def trigger_part_square do
    [
      aspect_ratio: {:raw, "1 / 1"},
      padding: 0,
      justify_content: :center,
      width: :auto
    ]
  end

  def trigger_part_circle do
    trigger_part_square() ++ [border_radius: {:raw, "var(--radius-full) !important"}]
  end

  def trigger_base do
    %{
      display: :inline_flex,
      align_items: :center,
      justify_content: :center,
      text_align: :center,
      cursor: :pointer,
      width: :auto,
      font_weight: :normal,
      text_decoration_line: :none,
      border: {:raw, "1px solid transparent"},
      border_radius: {:radius, :md},
      appearance: :none,
      transition:
        {:raw,
         "background-color 120ms ease, color 120ms ease, border-color 120ms ease, box-shadow 120ms ease"}
    }
    |> Map.merge(trigger_interaction(:focus_ring))
  end

  def trigger_interaction(ring_role) do
    ring =
      case ring_role do
        :on_solid -> "inset 0 0 0 2px var(--color-ui-ink)"
        :focus_ring -> "inset 0 0 0 2px var(--color-ui-ink)"
      end

    %{
      focus_visible: %{outline: :none, box_shadow: {:raw, ring}}
    }
  end

  def inset_ring(:on_solid), do: {:raw, "inset 0 0 0 2px var(--color-ui-ink)"}
  def inset_ring(:focus_ring), do: {:raw, "inset 0 0 0 2px var(--color-ui-ink)"}

  def lock_disabled_interaction(decls) when is_map(decls) do
    frozen =
      decls
      |> Map.take([:background_color, :color, :border_color])
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)
      |> Map.new()

    frozen_active = Map.merge(%{box_shadow: :none}, frozen)

    decls
    |> Map.put(:hover, frozen)
    |> Map.put(:active, frozen_active)
    |> Map.put(:open, frozen)
    |> Map.put(:focus_visible, Map.merge(%{outline: :none, box_shadow: :none}, frozen))
  end

  def visual_solid do
    %{
      background_color: {:color, :ui},
      color: {:color, :ui_ink},
      border_color: :transparent,
      hover: %{background_color: {:color, :ui_hover}},
      active: %{background_color: {:color, :ui_active}},
      focus_visible: %{outline: :none, box_shadow: inset_ring(:on_solid)},
      disabled:
        lock_disabled_interaction(%{
          background_color: {:color, :ui_muted},
          color: {:color, :ui_ink_muted},
          cursor: :not_allowed,
          box_shadow: :none
        })
    }
  end

  def visual_ghost do
    %{
      background_color: :transparent,
      color: {:color, :ui_ink},
      border_color: :transparent,
      hover: %{background_color: {:color, :ui_hover}},
      active: %{background_color: {:color, :ui_active}},
      focus_visible: %{outline: :none, box_shadow: inset_ring(:focus_ring)},
      disabled:
        lock_disabled_interaction(%{
          background_color: :transparent,
          color: {:color, :ui_ink_muted},
          cursor: :not_allowed,
          box_shadow: :none
        })
    }
  end

  def visual_outline do
    %{
      background_color: :transparent,
      color: {:color, :ui_ink},
      border_color: {:color, :outline},
      hover: %{background_color: {:color, :ui_hover}},
      active: %{background_color: {:color, :ui_active}},
      focus_visible: %{outline: :none, box_shadow: inset_ring(:focus_ring)},
      disabled: %{
        background_color: :transparent,
        color: {:color, :ui_ink_muted},
        border_color: {:color, :ui_muted},
        cursor: :not_allowed,
        box_shadow: :none
      }
    }
  end

  def visual_trigger do
    %{
      background_color: {:color, :ui},
      color: {:color, :ui_ink},
      border_color: {:color, :border},
      hover: %{background_color: {:color, :ui_hover}},
      active: %{background_color: {:color, :ui_active}},
      focus_visible: %{outline: :none, box_shadow: inset_ring(:focus_ring)},
      disabled:
        lock_disabled_interaction(%{
          background_color: {:color, :ui_muted},
          color: {:color, :ui_ink_muted},
          border_color: {:color, :border},
          cursor: :not_allowed,
          box_shadow: :none
        })
    }
  end

  def visual_subtle do
    %{
      background_color: {:color, :ui_hover},
      color: {:color, :ui_ink},
      border_color: :transparent,
      hover: %{background_color: {:color, :ui_active}},
      active: %{background_color: {:color, :ui_active}},
      focus_visible: %{outline: :none, box_shadow: inset_ring(:focus_ring)},
      disabled:
        lock_disabled_interaction(%{
          background_color: {:color, :ui_muted},
          color: {:color, :ui_ink_muted},
          cursor: :not_allowed,
          box_shadow: :none
        })
    }
  end

  def size_block(size) do
    text = size_text_step(size)

    %{
      font_size: {:text, text},
      line_height: {:leading, text},
      padding_inline: {:space, size},
      gap: {:space, size},
      min_height: {:size, size}
    }
  end

  def text_block(step) do
    %{font_size: {:text, step}, line_height: {:leading, step}}
  end

  def rounded_block(radius) do
    %{border_radius: {:radius, radius}}
  end

  def scrollbar_sm_children do
    [
      Rule.new("&::-webkit-scrollbar",
        decls: [
          {:raw,
           "width: calc(#{Var.ref([:space, :sm])} * 0.6); height: calc(#{Var.ref([:space, :sm])} * 0.6)"}
        ]
      ),
      Rule.new("&::-webkit-scrollbar-track",
        decls: [background: {:color, :ui}]
      ),
      Rule.new("&::-webkit-scrollbar-thumb",
        decls: [background: {:color, :border}]
      ),
      Rule.new("&::-webkit-scrollbar-corner",
        decls: [background: {:color, :border}]
      )
    ]
  end

  defp size_text_step(:md), do: :base
  defp size_text_step(step), do: step
end
