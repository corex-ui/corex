defmodule Corex.ColorPicker do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Color Picker](https://zagjs.com/components/react/color-picker).

  ## Examples

  ### Basic

  ```heex
  <.color_picker
    id="my-color-picker"
    value="rgb(25, 9, 192, 0.9)"
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

  Use `set_value` for programmatic color updates.
  '''

  defmodule Translation do
    @moduledoc """
    Translation struct for ColorPicker component strings.

    Without gettext: `translation={%ColorPicker.Translation{ hex: "Hex color value" }}`

    With gettext: `translation={%ColorPicker.Translation{ hex: gettext("Hex color value") }}`
    """
    defstruct [:hex, :alpha]
  end

  @doc type: :component
  use Phoenix.Component

  import Corex.Gettext, only: [gettext: 1]

  alias Corex.ColorPicker.Anatomy.{
    Area,
    AreaBackground,
    AreaThumb,
    ChannelInput,
    ChannelSlider,
    ChannelSliderThumb,
    ChannelSliderTrack,
    Content,
    Control,
    HiddenInput,
    Label,
    Positioner,
    PresetSwatch,
    Props,
    Root,
    Swatch,
    SwatchGroup,
    SwatchTrigger,
    TransparencyGrid,
    Trigger
  }

  alias Corex.ColorPicker.Connect
  alias Corex.ColorPicker.Initial
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false, doc: "The id of the color picker")

  attr(:value, :string,
    default: "#000000",
    doc: "Initial color string sent as `data-default-value` for the hook"
  )

  attr(:name, :string, default: nil, doc: "The name attribute for form submission")
  attr(:label, :string, default: "Select Color", doc: "Label for the color picker trigger")
  attr(:close_on_select, :boolean, default: true)
  attr(:open_auto_focus, :boolean, default: true)
  attr(:disabled, :boolean, default: false)
  attr(:invalid, :boolean, default: false)
  attr(:read_only, :boolean, default: false)
  attr(:required, :boolean, default: false)
  attr(:dir, :string, default: "ltr", values: ["ltr", "rtl"])
  attr(:positioning, :map, default: %Corex.Positioning{})
  attr(:presets, :list, default: [])
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

  attr(:translation, Corex.ColorPicker.Translation,
    default: nil,
    doc: "Override translatable strings"
  )

  attr(:rest, :global)

  def color_picker(assigns) do
    default_translation = %Translation{
      hex: gettext("Hex color value"),
      alpha: gettext("Alpha (opacity) value")
    }

    assigns =
      assigns
      |> assign_new(:id, fn -> "color-picker-#{System.unique_integer([:positive])}" end)
      |> assign_new(:translation, fn -> default_translation end)
      |> assign(:translation, merge_translation(assigns.translation, default_translation))
      |> assign(:dir, assigns.dir || "ltr")

    initial_value = initial_value(assigns)
    initial = Initial.parse(initial_value)
    value_str = initial.hex_value || "#000000"

    assigns =
      assigns
      |> assign(:initial, initial)
      |> assign(:open?, false)
      |> assign(:value_str, value_str)

    ~H"""
    <div
      id={@id}
      phx-hook="ColorPicker"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      class={@class || "color-picker"}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        value: @value,
        name: @name,
        close_on_select: @close_on_select,
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
      data-presets={Corex.Json.encode!(@presets)}
    >
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, disabled: @disabled, invalid: @invalid, read_only: @read_only, value_style: @initial.value_rgba || @initial.swatch_style, dir: @dir})} {Connect.root(%Root{id: @id, disabled: @disabled, invalid: @invalid, read_only: @read_only, value_style: @initial.value_rgba || @initial.swatch_style, dir: @dir})}>
        <label phx-mounted={Connect.ignore_label(%Label{id: @id, disabled: @disabled, invalid: @invalid, read_only: @read_only, required: @required, dir: @dir})} {Connect.label(%Label{id: @id, disabled: @disabled, invalid: @invalid, read_only: @read_only, required: @required, dir: @dir})}>{@label}</label>
        <input phx-mounted={Connect.ignore_hidden_input(%HiddenInput{id: @id, name: @name || @id})} {Connect.hidden_input(%HiddenInput{id: @id, name: @name || @id})} />
        <div phx-mounted={Connect.ignore_control(%Control{id: @id, disabled: @disabled, invalid: @invalid, read_only: @read_only, open: @open?})} {Connect.control(%Control{id: @id, disabled: @disabled, invalid: @invalid, read_only: @read_only, open: @open?})}>
          <button phx-mounted={Connect.ignore_trigger(%Trigger{id: @id, disabled: @disabled, invalid: @invalid, read_only: @read_only, open: @open?, value_str: @value_str, content_id: "color-picker:#{@id}:content", label_id: "color-picker:#{@id}:label", dir: @dir})} {Connect.trigger(%Trigger{id: @id, disabled: @disabled, invalid: @invalid, read_only: @read_only, open: @open?, value_str: @value_str, content_id: "color-picker:#{@id}:content", label_id: "color-picker:#{@id}:label", dir: @dir})}>
            <div phx-mounted={Connect.ignore_transparency_grid(%TransparencyGrid{id: @id, size: "10px", variant: "trigger"})} {Connect.transparency_grid(%TransparencyGrid{id: @id, size: "10px", variant: "trigger"})}></div>
            <div
              phx-mounted={Connect.ignore_swatch(%Swatch{
                id: @id,
                color: @initial.value_rgba,
                value: @initial.hex_value,
                checked: @initial.hex_value != nil,
                variant: "main"
              })}
              {Connect.swatch(%Swatch{
                id: @id,
                color: @initial.value_rgba,
                value: @initial.hex_value,
                checked: @initial.hex_value != nil,
                variant: "main"
              })}
            ></div>
          </button>
          <input
            phx-mounted={Connect.ignore_channel_input(%ChannelInput{
              picker_id: @id,
              channel: "hex",
              qualifier: "control"
            })}
            {Connect.channel_input(%ChannelInput{picker_id: @id, channel: "hex", qualifier: "control"}, %{
              "name" => "channel-input-hex",
              "value" => @initial.hex_value,
              "aria-label" => @translation.hex
            })}
          />
          <input
            phx-mounted={Connect.ignore_channel_input(%ChannelInput{
              picker_id: @id,
              channel: "alpha",
              qualifier: "control-alpha"
            })}
            {Connect.channel_input(%ChannelInput{picker_id: @id, channel: "alpha", qualifier: "control-alpha"}, %{
              "name" => "channel-input-alpha",
              "value" => @initial.alpha_value,
              "aria-label" => @translation.alpha
            })}
          />
        </div>
        <div phx-mounted={Connect.ignore_positioner(%Positioner{id: @id, dir: @dir})} {Connect.positioner(%Positioner{id: @id, dir: @dir})}>
          <div phx-mounted={Connect.ignore_content(%Content{id: @id, open: @open?, dir: @dir})} {Connect.content(%Content{id: @id, open: @open?, dir: @dir})}>
            <div phx-mounted={Connect.ignore_area(%Area{picker_id: @id, dir: @dir})} {Connect.area(%Area{picker_id: @id, dir: @dir})}>
              <div phx-mounted={Connect.ignore_area_background(%AreaBackground{picker_id: @id})} {Connect.area_background(%AreaBackground{picker_id: @id})}></div>
              <div phx-mounted={Connect.ignore_area_thumb(%AreaThumb{picker_id: @id})} {Connect.area_thumb(%AreaThumb{picker_id: @id})}></div>
            </div>
            <div data-scope="color-picker" data-part="pickers">
              <div data-scope="color-picker" data-part="sliders">
                <div phx-mounted={Connect.ignore_channel_slider(%ChannelSlider{picker_id: @id, channel: "hue"})} {Connect.channel_slider(%ChannelSlider{picker_id: @id, channel: "hue"})}>
                  <div phx-mounted={Connect.ignore_channel_slider_track(%ChannelSliderTrack{picker_id: @id, channel: "hue"})} {Connect.channel_slider_track(%ChannelSliderTrack{picker_id: @id, channel: "hue"})}></div>
                  <div phx-mounted={Connect.ignore_channel_slider_thumb(%ChannelSliderThumb{picker_id: @id, channel: "hue"})} {Connect.channel_slider_thumb(%ChannelSliderThumb{picker_id: @id, channel: "hue"})}></div>
                </div>
                <div phx-mounted={Connect.ignore_channel_slider(%ChannelSlider{picker_id: @id, channel: "alpha"})} {Connect.channel_slider(%ChannelSlider{picker_id: @id, channel: "alpha"})}>
                  <div phx-mounted={Connect.ignore_transparency_grid(%TransparencyGrid{id: @id, size: "12px", variant: "alpha"})} {Connect.transparency_grid(%TransparencyGrid{id: @id, size: "12px", variant: "alpha"})}></div>
                  <div phx-mounted={Connect.ignore_channel_slider_track(%ChannelSliderTrack{picker_id: @id, channel: "alpha"})} {Connect.channel_slider_track(%ChannelSliderTrack{picker_id: @id, channel: "alpha"})}></div>
                  <div phx-mounted={Connect.ignore_channel_slider_thumb(%ChannelSliderThumb{picker_id: @id, channel: "alpha"})} {Connect.channel_slider_thumb(%ChannelSliderThumb{picker_id: @id, channel: "alpha"})}></div>
                </div>
              </div>
            </div>
            <div data-scope="color-picker" data-part="input-groups">
              <div data-scope="color-picker" data-part="input-group">
                <span>R</span>
                <input
                  phx-mounted={Connect.ignore_channel_input(%ChannelInput{picker_id: @id, channel: "red", qualifier: "panel-red"})}
                  {Connect.channel_input(%ChannelInput{picker_id: @id, channel: "red", qualifier: "panel-red"}, %{
                    "name" => "channel-red",
                    "value" => @initial.red_value
                  })}
                />
              </div>
              <div data-scope="color-picker" data-part="input-group">
                <span>G</span>
                <input
                  phx-mounted={Connect.ignore_channel_input(%ChannelInput{picker_id: @id, channel: "green", qualifier: "panel-green"})}
                  {Connect.channel_input(%ChannelInput{picker_id: @id, channel: "green", qualifier: "panel-green"}, %{
                    "name" => "channel-green",
                    "value" => @initial.green_value
                  })}
                />
              </div>
              <div data-scope="color-picker" data-part="input-group">
                <span>B</span>
                <input
                  phx-mounted={Connect.ignore_channel_input(%ChannelInput{picker_id: @id, channel: "blue", qualifier: "panel-blue"})}
                  {Connect.channel_input(%ChannelInput{picker_id: @id, channel: "blue", qualifier: "panel-blue"}, %{
                    "name" => "channel-blue",
                    "value" => @initial.blue_value
                  })}
                />
              </div>
              <div data-scope="color-picker" data-part="input-group">
                <span>A</span>
                <input
                  phx-mounted={Connect.ignore_channel_input(%ChannelInput{picker_id: @id, channel: "alpha", qualifier: "panel-alpha"})}
                  {Connect.channel_input(%ChannelInput{picker_id: @id, channel: "alpha", qualifier: "panel-alpha"}, %{
                    "name" => "channel-alpha",
                    "value" => @initial.alpha_value
                  })}
                />
              </div>
            </div>
            <div phx-mounted={Connect.ignore_swatch_group(%SwatchGroup{picker_id: @id})} {Connect.swatch_group(%SwatchGroup{picker_id: @id})}>
              <button
                :for={{preset, pidx} <- Enum.with_index(@presets)}
                phx-mounted={Connect.ignore_swatch_trigger(%SwatchTrigger{
                  id: @id,
                  value: normalize_preset_value(preset),
                  checked: preset_checked?(preset, @initial.hex_value),
                  index: pidx
                })}
                {Connect.swatch_trigger(%SwatchTrigger{
                  id: @id,
                  value: normalize_preset_value(preset),
                  checked: preset_checked?(preset, @initial.hex_value),
                  index: pidx
                })}
              >
                <div phx-mounted={Connect.ignore_transparency_grid(%TransparencyGrid{id: @id, size: "var(--spacing-mini)", variant: "preset-#{pidx}"})} {Connect.transparency_grid(%TransparencyGrid{id: @id, size: "var(--spacing-mini)", variant: "preset-#{pidx}"})}></div>
                <div
                  phx-mounted={Connect.ignore_preset_swatch(%PresetSwatch{
                    id: @id,
                    color: preset_color(preset),
                    value: normalize_preset_value(preset),
                    checked: preset_checked?(preset, @initial.hex_value),
                    index: pidx
                  })}
                  {Connect.preset_swatch(%PresetSwatch{
                    id: @id,
                    color: preset_color(preset),
                    value: normalize_preset_value(preset),
                    checked: preset_checked?(preset, @initial.hex_value),
                    index: pidx
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

  defp initial_value(%{value: v}) when is_binary(v) and v != "" do
    v
  end

  defp initial_value(_), do: nil

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
  Sets the color value from client-side. Returns a `Phoenix.LiveView.JS` command.
  Value can be any color string (e.g. `"#ff0000"`, `"rgba(255, 0, 0, 1)"`).
  """
  def set_value(color_picker_id, value) when is_binary(color_picker_id) and is_binary(value) do
    JS.dispatch("corex:color-picker:set-value",
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
    LiveView.push_event(socket, "color_picker_set_value", %{
      color_picker_id: color_picker_id,
      value: to_string(value)
    })
  end

  defp merge_translation(nil, default), do: default

  defp merge_translation(partial, default) do
    %Translation{
      hex: partial.hex || default.hex,
      alpha: partial.alpha || default.alpha
    }
  end
end
