defmodule Corex.AngleSlider do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Angle Slider](https://zagjs.com/components/react/angle-slider).

  ## Examples

  <!-- tabs-open -->

  ### Basic

  ```heex
  <.angle_slider id="angle" class="angle-slider">
    <:label>Angle</:label>
  </.angle_slider>
  ```

  ### With marks

  ```heex
  <.angle_slider id="angle" class="angle-slider" marker_values={[0, 90, 180, 270]}>
    <:label>Angle</:label>
  </.angle_slider>
  ```

  ### Controlled

  In controlled mode, use `on_value_change` and `on_value_change_client` so the thumb moves
  during drag. Use `on_value_change_end` and `on_value_change_end_client` if you only need
  to react when the user releases.

  ```elixir
  defmodule MyAppWeb.AngleSliderLive do
    use MyAppWeb, :live_view

    def mount(_params, _session, socket) do
      {:ok, assign(socket, :angle, 0)}
    end

    def handle_event("angle_changed", %{"value" => value}, socket) do
      {:noreply, assign(socket, :angle, value)}
    end

    def render(assigns) do
      ~H"""
      <.angle_slider
        id="angle"
        controlled
        value={@angle}
        on_value_change="angle_changed"
        marker_values={[0, 90, 180, 270]}
        class="angle-slider">
        <:label>Angle</:label>
      </.angle_slider>
      """
    end
  end
  ```

  ## API Control

  In order to use the API, you must use an id on the component.

  ***Client-side***

  ```heex
  <button phx-click={Corex.AngleSlider.set_value("my-angle-slider", 90)}>
    Set to 90°
  </button>
  ```

  ***Server-side***

  ```elixir
  def handle_event("set_angle", %{"value" => value}, socket) do
    {:noreply, Corex.AngleSlider.set_value(socket, "my-angle-slider", String.to_float(value))}
  end
  ```

  ## Machine API

  The slider API exposes the following methods:

  | Method | Type | Description |
  |--------|------|-------------|
  | value | number | The current value of the angle slider |
  | valueAsDegree | string | The current value as a degree string |
  | setValue | (value: number) => void | Sets the value of the angle slider |
  | dragging | boolean | Whether the slider is being dragged |

  ## Styling

  Use data attributes: `[data-scope="angle-slider"][data-part="root"]`, `control`, `thumb`, `value-text` (with `value` and `text` spans), `marker-group`, `marker`.
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.AngleSlider.Anatomy.{
    Props,
    Root,
    Label,
    HiddenInput,
    Control,
    Thumb,
    ValueText,
    Value,
    Text,
    MarkerGroup,
    Marker
  }

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

  attr(:on_value_change, :string,
    default: nil,
    doc: "Server event when value changes (uncontrolled)"
  )

  attr(:on_value_change_client, :string,
    default: nil,
    doc: "Client event when value changes (uncontrolled)"
  )

  attr(:on_value_change_end, :string,
    default: nil,
    doc: "Server event when value change ends (controlled)"
  )

  attr(:on_value_change_end_client, :string,
    default: nil,
    doc: "Client event when value change ends (controlled)"
  )

  attr(:marker_values, :list,
    default: [],
    doc: "List of angle values to show as markers (e.g. [0, 90, 180, 270])"
  )

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
        on_value_change_client: @on_value_change_client,
        on_value_change_end: @on_value_change_end,
        on_value_change_end_client: @on_value_change_end_client
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id, dir: @dir, value: @value})}>
        <div :if={@label != []} {Connect.label(%Label{id: @id, dir: @dir})}>
          {render_slot(@label)}
        </div>
        <div {Connect.control(%Control{id: @id, dir: @dir})}>
          <div {Connect.thumb(%Thumb{id: @id, dir: @dir})} />
          <div :if={@marker_values != []} {Connect.marker_group(%MarkerGroup{id: @id, dir: @dir})}>
            <div :for={val <- @marker_values} {Connect.marker(%Marker{id: @id, value: val, slider_value: @value})} />
          </div>
        </div>
        <div {Connect.value_text(%ValueText{id: @id, dir: @dir, value: @value})}>
          <span {Connect.value(%Value{})}><%= @value %></span>
          <span {Connect.text(%Text{})}>°</span>
        </div>
        <input {Connect.hidden_input(%HiddenInput{id: @id, name: @name, value: @value, disabled: @disabled})} />
      </div>
    </div>
    """
  end

  @doc type: :api
  @doc """
  Sets the angle slider value from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.AngleSlider.set_value("my-angle-slider", 90)}>
        Set to 90°
      </button>
  """
  def set_value(angle_slider_id, value) when is_binary(angle_slider_id) and is_number(value) do
    Phoenix.LiveView.JS.dispatch("phx:angle-slider:set-value",
      to: "##{angle_slider_id}",
      detail: %{value: value},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the angle slider value from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("set_angle", %{"value" => value}, socket) do
        angle = String.to_float(value)
        {:noreply, Corex.AngleSlider.set_value(socket, "my-angle-slider", angle)}
      end
  """
  def set_value(socket, angle_slider_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(angle_slider_id) do
    angle =
      if is_binary(value) do
        case Float.parse(value) do
          {num, _} -> num
          :error -> 0
        end
      else
        value
      end

    Phoenix.LiveView.push_event(socket, "angle_slider_set_value", %{
      angle_slider_id: angle_slider_id,
      value: angle
    })
  end
end
