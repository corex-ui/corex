defmodule Corex.AngleSlider do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Angle Slider](https://zagjs.com/components/react/angle-slider).

  ## Examples

  ### Basic

  ```heex
  <.angle_slider id="angle" class="angle-slider">
    <:label>Angle</:label>
  </.angle_slider>
  ```

  ### Controlled

  ```heex
  <.angle_slider
    id="angle"
    controlled
    value={@angle}
    on_value_change="angle_changed"
    class="angle-slider">
    <:label>Angle</:label>
  </.angle_slider>
  ```

  ## Styling

  Use data attributes: `[data-scope="angle-slider"][data-part="root"]`, `control`, `thumb`, `value-text`, `marker-group`, `marker`.
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.AngleSlider.Anatomy.{Props, Root, Label, HiddenInput, Control, Thumb, ValueText, MarkerGroup, Marker}
  alias Corex.AngleSlider.Connect

  attr(:id, :string, required: false, doc: "The id of the angle slider")
  attr(:value, :float, default: 0.0, doc: "The value or controlled value in degrees")
  attr(:controlled, :boolean, default: false, doc: "Whether the value is controlled")
  attr(:step, :float, default: 1.0, doc: "Step value")
  attr(:disabled, :boolean, default: false, doc: "Whether the slider is disabled")
  attr(:read_only, :boolean, default: false, doc: "Whether the slider is read-only")
  attr(:invalid, :boolean, default: false, doc: "Whether the slider is invalid")
  attr(:name, :string, default: nil, doc: "Name for form submission")
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"], doc: "Direction")
  attr(:on_value_change, :string, default: nil, doc: "Server event when value changes")
  attr(:on_value_change_client, :string, default: nil, doc: "Client event when value changes")
  attr(:marker_values, :list, default: [], doc: "List of angle values to show as markers (e.g. [0, 90, 180, 270])")
  attr(:rest, :global)

  slot(:label, required: false)

  def angle_slider(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "angle-slider-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)

    ~H"""
    <div
      id={@id}
      phx-hook="AngleSlider"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        value: @value,
        controlled: @controlled,
        step: @step,
        disabled: @disabled,
        read_only: @read_only,
        invalid: @invalid,
        name: @name,
        dir: @dir,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id, dir: @dir})}>
        <label :if={@label != []} {Connect.label(%Label{id: @id, dir: @dir})}>
          {render_slot(@label)}
        </label>
        <input {Connect.hidden_input(%HiddenInput{id: @id, name: @name, value: @value, disabled: @disabled})} />
        <div {Connect.control(%Control{id: @id, dir: @dir})}>
          <div {Connect.thumb(%Thumb{id: @id, dir: @dir})} />
          <span {Connect.value_text(%ValueText{id: @id, dir: @dir})} />
        </div>
        <div :if={@marker_values != []} {Connect.marker_group(%MarkerGroup{id: @id, dir: @dir})}>
          <span :for={val <- @marker_values} {Connect.marker(%Marker{id: @id, value: val})} />
        </div>
      </div>
    </div>
    """
  end
end
