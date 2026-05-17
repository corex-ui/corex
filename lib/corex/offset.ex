defmodule Corex.Offset do
  @moduledoc """
  Main-axis and cross-axis offset for floating UI placement.

  Set on [`Corex.Positioning`](Corex.Positioning.html) as `offset:` when you need
  extra nudging beyond `gutter` / `shift`. Values are serialized to
  `data-position-offset-main-axis` and `data-position-offset-cross-axis` for
  Zag.js popovers. Axes follow the active `placement` (for `bottom`, main axis is vertical).

  Use the same `positioning` attribute on any component that anchors a floating layer
  (select, combobox, menu, tooltip, date picker, color picker, and others).

  <!-- tabs-open -->

  ## Select

      <.select
        id="country-select"
        class="select"
        items={Corex.List.new([
          [label: "France", value: "fr"],
          [label: "Germany", value: "de"],
          [label: "Spain", value: "es"]
        ])}
        positioning={
          %Corex.Positioning{
            placement: "bottom-start",
            gutter: 8,
            same_width: true,
            offset: %Corex.Offset{main_axis: 4, cross_axis: 0}
          }
        }
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
      </.select>

  ## Combobox

      <.combobox
        id="country-combobox"
        class="combobox"
        items={Corex.List.new([
          [label: "France", value: "fr"],
          [label: "Germany", value: "de"],
          [label: "Spain", value: "es"]
        ])}
        positioning={
          %Corex.Positioning{
            placement: "bottom-start",
            gutter: 8,
            same_width: true,
            offset: %Corex.Offset{main_axis: 6, cross_axis: -4}
          }
        }
      >
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
      </.combobox>

  ## Menu

      <.menu
        id="actions-menu"
        class="menu"
        items={[
          %Corex.Tree.Item{value: "edit", label: "Edit"},
          %Corex.Tree.Item{value: "duplicate", label: "Duplicate"},
          %Corex.Tree.Item{value: "delete", label: "Delete"}
        ]}
        positioning={
          %Corex.Positioning{
            placement: "bottom-start",
            gutter: 4,
            offset: %Corex.Offset{main_axis: 2, cross_axis: 8}
          }
        }
      >
        <:trigger>Actions</:trigger>
        <:indicator>
          <.heroicon name="hero-chevron-down" />
        </:indicator>
      </.menu>

  ## Tooltip

      <.tooltip
        id="help-tooltip"
        class="tooltip"
        positioning={
          %Corex.Positioning{
            placement: "top",
            gutter: 6,
            offset: %Corex.Offset{main_axis: 0, cross_axis: 12}
          }
        }
      >
        <:trigger>Hover for help</:trigger>
        <:content>Extra offset shifts the tooltip along the cross axis.</:content>
      </.tooltip>

  ## Date picker

      <.date_picker
        id="due-date"
        class="date-picker"
        positioning={
          %Corex.Positioning{
            placement: "bottom-start",
            gutter: 8,
            offset: %Corex.Offset{main_axis: 4, cross_axis: 0}
          }
        }
      >
        <:label>Due date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
      </.date_picker>

  ## Color picker

      <.color_picker
        id="brand-color"
        class="color-picker"
        value="#3366cc"
        label="Brand color"
        presets={["#ff0000", "#00ff00", "#0000ff", "#3366cc"]}
        positioning={
          %Corex.Positioning{
            placement: "bottom-start",
            gutter: 8,
            offset: %Corex.Offset{main_axis: 4, cross_axis: 0}
          }
        }
      />

  <!-- tabs-close -->
  """

  defstruct main_axis: nil, cross_axis: nil

  @type t :: %__MODULE__{main_axis: number() | nil, cross_axis: number() | nil}
end
