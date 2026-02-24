defmodule Corex.ColorPicker do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Color Picker](https://zagjs.com/components/react/color-picker).

  ## Examples

  ### Basic

  ```heex
  <.color_picker
    id="my-color-picker"
    default_value="rgb(25, 9, 192, 0.9)"
    label="Select Color (RGBA)"
    presets={["#ff0000", "#00ff00", "#0000ff", "rgb(25, 9, 192, 0.9)"]}
    class="color-picker"
  />
  ```

  ## Styling

  Target elements via data attributes:

  ```css
  [data-scope="color-picker"][data-part="root"] {}
  [data-scope="color-picker"][data-part="label"] {}
  [data-scope="color-picker"][data-part="control"] {}
  [data-scope="color-picker"][data-part="trigger"] {}
  [data-scope="color-picker"][data-part="content"] {}
  [data-scope="color-picker"][data-part="area"] {}
  [data-scope="color-picker"][data-part="channel-slider"] {}
  [data-scope="color-picker"][data-part="swatch-trigger"] {}
  ```

  Import the Corex design:

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/color-picker.css";
  ```

  ## Events

  - `on_value_change` / `on_value_change_end` - when color changes (detail: `%{valueAsString: string}`)
  - `on_value_change_client` / `on_value_change_end_client` - client-only variants
  - `on_open_change` - when open state changes (detail: `%{open: boolean}`)
  - `on_open_change_client` - client-only variant
  - `on_format_change` - when format changes (detail: `%{format: string}`)
  - `on_pointer_down_outside` / `on_focus_outside` / `on_interact_outside` - when interacting outside

  ## API Control

  Use `set_open`, `set_value`, `set_format` for programmatic control.
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.ColorPicker.Anatomy.{
    Props,
    Root,
    Label,
    HiddenInput,
    Control,
    Trigger,
    Positioner,
    Content,
    TransparencyGrid,
    Swatch,
    SwatchTrigger,
    PresetSwatch
  }

  alias Corex.ColorPicker.Connect
  alias Corex.ColorPicker.Initial

  attr(:id, :string, required: false)

  attr(:default_value, :string,
    default: nil,
    doc: "Initial color value (e.g. rgb(25, 9, 192, 0.9) or #ff0000)"
  )

  attr(:value, :string, default: nil, doc: "Controlled value when controlled is true")
  attr(:controlled, :boolean, default: false)
  attr(:name, :string, default: nil)
  attr(:label, :string, default: "Select Color")
  attr(:format, :string, default: "rgba", values: ["rgba", "hsla", "hsba", "hex"])
  attr(:default_format, :string, default: nil, values: [nil, "rgba", "hsla", "hsba", "hex"])
  attr(:close_on_select, :boolean, default: true)
  attr(:default_open, :boolean, default: false)
  attr(:open, :boolean, default: nil)
  attr(:open_auto_focus, :boolean, default: true)
  attr(:disabled, :boolean, default: false)
  attr(:invalid, :boolean, default: false)
  attr(:read_only, :boolean, default: false)
  attr(:required, :boolean, default: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:positioning, :map, default: %Corex.Positioning{})
  attr(:presets, :list, default: ["#ff0000", "#00ff00", "#0000ff"])
  attr(:class, :string, default: nil)
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:on_value_change_end, :string, default: nil)
  attr(:on_value_change_end_client, :string, default: nil)
  attr(:on_open_change, :string, default: nil)
  attr(:on_open_change_client, :string, default: nil)
  attr(:on_format_change, :string, default: nil)
  attr(:on_pointer_down_outside, :string, default: nil)
  attr(:on_focus_outside, :string, default: nil)
  attr(:on_interact_outside, :string, default: nil)
  attr(:rest, :global)

  def color_picker(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "color-picker-#{System.unique_integer([:positive])}" end)
      |> assign(:default_format, assigns[:default_format] || assigns.format)
      |> assign(:dir, assigns.dir || "ltr")

    initial_value = initial_value(assigns)
    initial = Initial.parse(initial_value)
    open? = opened?(assigns)
    value_str = initial.hex_value || "#000000"

    assigns =
      assigns
      |> assign(:initial, initial)
      |> assign(:open?, open?)
      |> assign(:value_str, value_str)

    ~H"""
    <div
      id={@id}
      phx-hook="ColorPicker"
      class={@class || "color-picker"}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        default_value: @default_value,
        value: @value,
        name: @name,
        format: @format,
        default_format: @default_format,
        controlled: @controlled,
        close_on_select: @close_on_select,
        default_open: @default_open,
        open: @open,
        open_auto_focus: @open_auto_focus,
        disabled: @disabled,
        invalid: @invalid,
        read_only: @read_only,
        required: @required,
        dir: @dir,
        positioning: @positioning,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client,
        on_value_change_end: @on_value_change_end,
        on_value_change_end_client: @on_value_change_end_client,
        on_open_change: @on_open_change,
        on_open_change_client: @on_open_change_client,
        on_format_change: @on_format_change,
        on_pointer_down_outside: @on_pointer_down_outside,
        on_focus_outside: @on_focus_outside,
        on_interact_outside: @on_interact_outside
      })}
      data-label={@label}
      data-presets={Jason.encode!(@presets)}
    >
      <div {Connect.root(%Root{id: @id, disabled: @disabled, invalid: @invalid, read_only: @read_only, value_style: @initial.value_rgba || @initial.swatch_style, dir: @dir})}>
        <label {Connect.label(%Label{id: @id, disabled: @disabled, invalid: @invalid, read_only: @read_only, required: @required, dir: @dir})}>{@label}</label>
        <input {Connect.hidden_input(%HiddenInput{id: @id, name: @name || @id})} />
        <div {Connect.control(%Control{id: @id, disabled: @disabled, invalid: @invalid, read_only: @read_only, open: @open?})}>
          <button {Connect.trigger(%Trigger{id: @id, disabled: @disabled, invalid: @invalid, read_only: @read_only, open: @open?, value_str: @value_str, content_id: "color-picker:#{@id}:content", label_id: "color-picker:#{@id}:label", dir: @dir})}>
            <div {Connect.transparency_grid(%TransparencyGrid{size: "10px"})}></div>
            <div
              {Connect.swatch(%Swatch{
                color: @initial.value_rgba,
                value: @initial.hex_value,
                checked: @initial.hex_value != nil
              })}
            ></div>
          </button>
          <input
            data-scope="color-picker"
            data-part="channel-input"
            data-channel="hex"
            name="channel-input-hex"
            value={@initial.hex_value}
            style={Connect.channel_input_style()}
            aria-label="Hex color value"
          />
          <input
            data-scope="color-picker"
            data-part="channel-input"
            data-channel="alpha"
            name="channel-input-alpha"
            value={@initial.alpha_value}
            style={Connect.channel_input_style()}
            aria-label="Alpha (opacity) value"
          />
        </div>
        <div {Connect.positioner(%Positioner{id: @id, dir: @dir})}>
          <div {Connect.content(%Content{id: @id, open: @open?, dir: @dir})}>
            <div data-scope="color-picker" data-part="area" dir={@dir}>
              <div data-scope="color-picker" data-part="area-background"></div>
              <div data-scope="color-picker" data-part="area-thumb"></div>
            </div>
            <div data-scope="color-picker" data-part="pickers">
              <div data-scope="color-picker" data-part="sliders">
                <div data-scope="color-picker" data-part="channel-slider" data-channel="hue">
                  <div data-scope="color-picker" data-part="channel-slider-track" data-channel="hue"></div>
                  <div data-scope="color-picker" data-part="channel-slider-thumb" data-channel="hue"></div>
                </div>
                <div data-scope="color-picker" data-part="channel-slider" data-channel="alpha">
                  <div {Connect.transparency_grid(%TransparencyGrid{size: "12px"})}></div>
                  <div data-scope="color-picker" data-part="channel-slider-track" data-channel="alpha"></div>
                  <div data-scope="color-picker" data-part="channel-slider-thumb" data-channel="alpha"></div>
                </div>
              </div>
            </div>
            <div data-scope="color-picker" data-part="input-groups">
              <div data-scope="color-picker" data-part="input-group">
                <span>R</span>
                <input
                  data-scope="color-picker"
                  data-part="channel-input"
                  data-channel="red"
                  name="channel-red"
                  value={@initial.red_value}
                  style={Connect.channel_input_style()}
                />
              </div>
              <div data-scope="color-picker" data-part="input-group">
                <span>G</span>
                <input
                  data-scope="color-picker"
                  data-part="channel-input"
                  data-channel="green"
                  name="channel-green"
                  value={@initial.green_value}
                  style={Connect.channel_input_style()}
                />
              </div>
              <div data-scope="color-picker" data-part="input-group">
                <span>B</span>
                <input
                  data-scope="color-picker"
                  data-part="channel-input"
                  data-channel="blue"
                  name="channel-blue"
                  value={@initial.blue_value}
                  style={Connect.channel_input_style()}
                />
              </div>
              <div data-scope="color-picker" data-part="input-group">
                <span>A</span>
                <input
                  data-scope="color-picker"
                  data-part="channel-input"
                  data-channel="alpha"
                  name="channel-alpha"
                  value={@initial.alpha_value}
                  style={Connect.channel_input_style()}
                />
              </div>
            </div>
            <div data-scope="color-picker" data-part="swatch-group">
              <button
                :for={preset <- @presets}
                {Connect.swatch_trigger(%SwatchTrigger{
                  value: normalize_preset_value(preset),
                  checked: preset_checked?(preset, @initial.hex_value)
                })}
              >
                <div {Connect.transparency_grid(%TransparencyGrid{size: "var(--spacing-mini)"})}></div>
                <div
                  {Connect.preset_swatch(%PresetSwatch{
                    color: preset_color(preset),
                    value: normalize_preset_value(preset),
                    checked: preset_checked?(preset, @initial.hex_value)
                  })}
                ></div>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp initial_value(%{controlled: true, value: value}), do: value
  defp initial_value(%{default_value: value}), do: value
  defp initial_value(_), do: nil

  defp opened?(assigns) do
    cond do
      assigns.controlled and assigns.open -> true
      not assigns.controlled and assigns.default_open -> true
      true -> false
    end
  end

  defp normalize_preset_value(preset) when is_binary(preset) do
    case Initial.parse(preset) do
      %{hex_value: hex} when is_binary(hex) -> hex
      _ -> preset
    end
  end

  defp preset_color(preset) when is_binary(preset) do
    case Initial.parse(preset) do
      %{value_rgba: rgba} when is_binary(rgba) -> rgba
      %{swatch_style: style} when is_binary(style) -> style
      _ -> nil
    end
  end

  defp preset_checked?(preset, current_hex) when is_binary(preset) do
    preset_hex = normalize_preset_value(preset)
    current = current_hex || ""
    String.downcase(preset_hex) == String.downcase(current)
  end

  @doc type: :api
  @doc """
  Opens or closes the color picker from client-side. Returns a `Phoenix.LiveView.JS` command.
  """
  def set_open(color_picker_id, open)
      when is_binary(color_picker_id) and is_boolean(open) do
    Phoenix.LiveView.JS.dispatch("phx:color-picker:set-open",
      to: "##{color_picker_id}",
      detail: %{open: open},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Opens or closes the color picker from server-side.
  """
  def set_open(socket, color_picker_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(color_picker_id) do
    Phoenix.LiveView.push_event(socket, "color_picker_set_open", %{
      color_picker_id: color_picker_id,
      open: open
    })
  end

  @doc type: :api
  @doc """
  Sets the color value from client-side. Returns a `Phoenix.LiveView.JS` command.
  Value can be any color string (e.g. `"#ff0000"`, `"rgba(255, 0, 0, 1)"`).
  """
  def set_value(color_picker_id, value) when is_binary(color_picker_id) and is_binary(value) do
    Phoenix.LiveView.JS.dispatch("phx:color-picker:set-value",
      to: "##{color_picker_id}",
      detail: %{value: value},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the color value from server-side.
  """
  def set_value(socket, color_picker_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(color_picker_id) do
    Phoenix.LiveView.push_event(socket, "color_picker_set_value", %{
      color_picker_id: color_picker_id,
      value: to_string(value)
    })
  end

  @doc type: :api
  @doc """
  Sets the color format from client-side. Returns a `Phoenix.LiveView.JS` command.
  Format must be one of: `"rgba"`, `"hsla"`, `"hsba"`, `"hex"`.
  """
  def set_format(color_picker_id, format)
      when is_binary(color_picker_id) and format in ["rgba", "hsla", "hsba", "hex"] do
    Phoenix.LiveView.JS.dispatch("phx:color-picker:set-format",
      to: "##{color_picker_id}",
      detail: %{format: format},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the color format from server-side.
  """
  def set_format(socket, color_picker_id, format)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(color_picker_id) do
    Phoenix.LiveView.push_event(socket, "color_picker_set_format", %{
      color_picker_id: color_picker_id,
      format: to_string(format)
    })
  end
end
