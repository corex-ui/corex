defmodule Corex.AngleSlider do
  @moduledoc ~S'''
  Circular angle control for Phoenix LiveView forms. Behavior follows [Zag.js Angle Slider](https://zagjs.com/components/react/angle-slider).
  WAI-ARIA circular angle control. Use `angle_slider/1` with an optional label slot and marks.

  ## Anatomy

  <!-- tabs-open -->

  ### Basic

  ```heex
  <.angle_slider class="angle-slider">
    <:label>Angle</:label>
  </.angle_slider>
  ```

  ### With marks

  ```heex
  <.angle_slider class="angle-slider" marker_values={[0, 90, 180, 270]}>
    <:label>Angle</:label>
  </.angle_slider>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.angle_slider>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set angle in degrees (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set angle in degrees (server) | `socket` |
  | [`value/2`](#value/2) | Read angle (client) | `%Phoenix.LiveView.JS{}` |
  | [`value/3`](#value/3) | Read angle (server) | `socket` |

  For `value`, use `respond_to: :server | :client | :both`. LiveView receives `angle_slider_value_response`; the DOM receives `angle-slider-value`.

  ## Events

  Pick an event name and pass it to `on_*` on `<.angle_slider>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="angle_changed"` | Value changes while dragging | `%{"id" => id, "value" => number, "valueAsDegree" => number}` |
  | `on_value_change_end="angle_changed_end"` | User releases thumb | `%{"id" => id, "value" => number, "valueAsDegree" => number}` |

  <!-- tabs-open -->

  ### on_value_change

  ```heex
  <.angle_slider
    class="angle-slider"
    on_value_change="angle_changed"
    marker_values={[0, 90, 180, 270]}
  >
    <:label>Angle</:label>
  </.angle_slider>
  ```

  ```elixir
  def handle_event("angle_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="angle-changed"` | Value changes while dragging | `id`, `value`, `valueAsDegree` |
  | `on_value_change_end_client="angle-changed-end"` | User releases thumb | `id`, `value`, `valueAsDegree` |

  ## Style

  Use data attributes to target elements:

  ```css
  [data-scope="angle-slider"][data-part="root"] {}
  [data-scope="angle-slider"][data-part="control"] {}
  [data-scope="angle-slider"][data-part="thumb"] {}
  [data-scope="angle-slider"][data-part="value-text"] {}
  [data-scope="angle-slider"][data-part="marker-group"] {}
  [data-scope="angle-slider"][data-part="marker"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `angle-slider` on the component.
  This requires the `corex_design` dependency and `mix corex.design.build`; import the component css file.

  ```css
  @import "../corex/corex.css";
  ```

  Stack modifiers on the host (`class` on `<.angle_slider>`). Combine axes, for example `angle-slider ui-accent ui-size-lg` or `angle-slider ui-info ui-solid`.

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on the control and thumb handle. Variant modifiers control surface treatment. Default is subtle: a neutral control ring with semantic thumb color. Add `angle-slider ui-solid` for a filled control and matching handle.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for control fill and thumb ink. Does not change surface treatment by itself.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `angle-slider` |
  | Accent | `angle-slider ui-accent` |
  | Brand | `angle-slider ui-brand` |
  | Alert | `angle-slider ui-alert` |
  | Info | `angle-slider ui-info` |
  | Success | `angle-slider ui-success` |

  ### Variant

  Visual treatment of the control ring and thumb handle. Combine with a semantic modifier for palette-driven ink and fill.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `angle-slider` or `angle-slider ui-accent` |
  | Solid | `angle-slider ui-accent ui-solid` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `angle-slider ui-size-sm` |
  | MD | `angle-slider ui-size-md` |
  | LG | `angle-slider ui-size-lg` |
  | XL | `angle-slider ui-size-xl` |

  <!-- tabs-close -->

  ## Patterns

  ### Async and skeleton

  Use `assign_async/3` with `<.async_result>` and show `angle_slider_skeleton/1` while loading.

  ```elixir
  <.async_result :let={slider} assign={@slider}>
    <:loading>
      <.angle_slider_skeleton class="angle-slider" />
    </:loading>
    <:failed>Could not load.</:failed>
    <.angle_slider id="async-angle" class="angle-slider" value={slider.value} />
  </.async_result>
  ```

  ## Form

  When using with Phoenix forms, set the form `id` in `to_form/2` (for example `to_form(changeset, as: :name, id: "my-form")`) and use `<.form for={@form}>`.

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. With `field={@form[:…]}`, pass `auto_invalid` for alert borders from visible errors, or `invalid={true}` to force the alert state.

  ```elixir
  def angle_slider_form_page(conn, _params) do
    form =
      %MyApp.Form.AngleSliderForm{}
      |> MyApp.Form.AngleSliderForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :angle_slider_form, id: "angle-slider-form")

    render(conn, :angle_slider_form_page, form: form)
  end
  ```

  ```heex
  <.form :let={f} for={@form} action={@action} method="post">
    <.angle_slider field={f[:angle]} class="angle-slider" marker_values={[0, 90, 180, 270]}>
      <:label>Angle</:label>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.angle_slider>
    <button type="submit">Submit</button>
  </.form>
  ```
  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.AngleSlider.Anatomy.{
    Control,
    HiddenInput,
    Label,
    Marker,
    MarkerGroup,
    Props,
    Root,
    Text,
    Thumb,
    Value,
    ValueText
  }

  alias Corex.AngleSlider.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  import Corex.Helpers, only: [respond_to_fields: 1]

  attr(:id, :string, required: false, doc: "The id of the angle slider")
  attr(:value, :float, default: 0.0, doc: "The initial value in degrees")
  attr(:step, :float, default: 1.0, doc: "Step value")
  attr(:disabled, :boolean, default: false, doc: "Whether the slider is disabled")
  attr(:read_only, :boolean, default: false, doc: "Whether the slider is read-only")
  attr(:invalid, :boolean, default: nil, doc: "Whether the slider is invalid")

  attr(:auto_invalid, :boolean,
    default: false,
    doc: "When true with `field`, set invalid from visible changeset errors"
  )

  attr(:name, :string, default: nil, doc: "Name for form submission")
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"], doc: "Direction")
  attr(:orientation, :string, default: "vertical", values: ["horizontal", "vertical"])

  attr(:value_text_as, :string,
    default: "degree",
    values: ["raw", "degree"],
    doc: "Displayed value format: raw (api.value) or degree (api.valueAsDegree)"
  )

  attr(:compound, :boolean,
    default: false,
    doc:
      "Enable compound mode. Use with :let={ctx} and sub-components to fully control structure."
  )

  attr(:on_value_change, :string,
    default: nil,
    doc: "Server event when value changes during drag"
  )

  attr(:on_value_change_client, :string,
    default: nil,
    doc: "Client event when value changes during drag"
  )

  attr(:on_value_change_end, :string,
    default: nil,
    doc: "Server event when the user releases the thumb"
  )

  attr(:on_value_change_end_client, :string,
    default: nil,
    doc: "Client event when the user releases the thumb"
  )

  attr(:marker_values, :list,
    default: [],
    doc: "List of angle values to show as markers (e.g. [0, 90, 180, 270])"
  )

  attr(:errors, :list, default: [], doc: "List of error messages to display")

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field struct retrieved from the form, for example: @form[:angle]. Automatically sets id, name, value, and errors from the form field"
  )

  attr(:rest, :global)

  slot(:inner_block, required: false)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :value_text, required: false do
    attr(:class, :string, required: false)
  end

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  def angle_slider(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    value = field.value |> angle_value_to_float() |> clamp_angle()

    assigns
    |> Corex.FormField.assign_form_field(field)
    |> assign(:value, value)
    |> angle_slider()
  end

  def angle_slider(assigns) do
    assigns =
      assigns
      |> Corex.FormField.require_id!("Corex component (angle-slider)")
      |> assign_new(:form_field, fn -> false end)
      |> update(:value, &clamp_angle/1)

    ctx = %{
      id: assigns.id,
      dir: assigns.dir,
      orientation: assigns.orientation,
      value: assigns.value,
      step: assigns.step,
      disabled: assigns.disabled,
      read_only: assigns.read_only,
      invalid: assigns.invalid,
      name: assigns.name,
      marker_values: assigns.marker_values,
      value_text_as: assigns.value_text_as
    }

    assigns = assign(assigns, :ctx, ctx)

    ~H"""
    <div
      id={@id}
      phx-hook="AngleSlider"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        form_field: @form_field,
        value: @value,
        step: @step,
        disabled: @disabled,
        read_only: @read_only,
        invalid: @invalid,
        name: @name,
        dir: @dir,
        orientation: @orientation,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client,
        on_value_change_end: @on_value_change_end,
        on_value_change_end_client: @on_value_change_end_client,
        value_text_as: @value_text_as
      })}
    >
      {if @compound do render_slot(@inner_block, @ctx) end}

      <div
        :if={not @compound}
        phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, value: @value, disabled: @disabled, read_only: @read_only, invalid: @invalid, orientation: @orientation})}
        {Connect.root(%Root{id: @id, dir: @dir, value: @value, disabled: @disabled, read_only: @read_only, invalid: @invalid, orientation: @orientation})}
      >
        <div
          :if={@label != []}
          phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, disabled: @disabled, read_only: @read_only, invalid: @invalid, orientation: @orientation})}
          {Connect.label(%Label{id: @id, dir: @dir, disabled: @disabled, read_only: @read_only, invalid: @invalid, orientation: @orientation})}
        >
          {render_slot(@label)}
        </div>
        <div
          phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir, disabled: @disabled, read_only: @read_only, invalid: @invalid, orientation: @orientation})}
          {Connect.control(%Control{id: @id, dir: @dir, disabled: @disabled, read_only: @read_only, invalid: @invalid, orientation: @orientation})}
        >
          <div
            phx-mounted={Connect.ignore_thumb(%Thumb{id: @id, dir: @dir, disabled: @disabled, read_only: @read_only, invalid: @invalid, orientation: @orientation})}
            {Connect.thumb(%Thumb{id: @id, dir: @dir, disabled: @disabled, read_only: @read_only, invalid: @invalid, orientation: @orientation})}
            title="Thumb"
            />
          <div
            :if={@marker_values != []}
            phx-mounted={Connect.ignore_marker_group(%MarkerGroup{id: @id, dir: @dir, orientation: @orientation})}
            {Connect.marker_group(%MarkerGroup{id: @id, dir: @dir, orientation: @orientation})}
          >
            <div
              :for={val <- @marker_values}
              phx-mounted={Connect.ignore_marker(%Marker{id: @id, value: val, slider_value: @value, disabled: @disabled, dir: @dir, orientation: @orientation})}
              {Connect.marker(%Marker{id: @id, value: val, slider_value: @value, disabled: @disabled, dir: @dir, orientation: @orientation})}
            />
          </div>
        </div>
        <div
          phx-mounted={Connect.ignore_value_text(%ValueText{id: @id, dir: @dir, value: @value, orientation: @orientation})}
          {Connect.value_text(%ValueText{id: @id, dir: @dir, value: @value, orientation: @orientation})}
        >
          {render_slot(@value_text, value_text_string(@value, @value_text_as))}
          <span
            :if={@value_text != []}
            class={Map.get(Enum.at(@value_text, 0), :class, nil)}
            {Connect.value(%Value{})}
          >
            {value_text_string(@value, @value_text_as)}
          </span>
          <span :if={@value_text == []} {Connect.value(%Value{})}>{value_text_string(@value, @value_text_as)}</span>
        </div>
        <input
          phx-mounted={Connect.ignore_hidden_input(%HiddenInput{id: @id, name: @name, value: @value, disabled: @disabled, dir: @dir, orientation: @orientation})}
          {Connect.hidden_input(%HiddenInput{id: @id, name: @name, value: @value, disabled: @disabled, dir: @dir, orientation: @orientation})}
        />
      </div>

      <div :if={not @compound and @error != []} :for={msg <- @errors} data-scope="angle-slider" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map,
    required: true,
    doc: "The context map yielded by the parent angle_slider via :let={ctx}"
  )

  attr(:rest, :global)
  slot(:inner_block, required: true)

  def angle_slider_root(assigns) do
    root =
      %Root{
        id: assigns.ctx.id,
        dir: assigns.ctx.dir,
        orientation: assigns.ctx.orientation,
        value: assigns.ctx.value,
        disabled: assigns.ctx.disabled,
        read_only: assigns.ctx.read_only,
        invalid: assigns.ctx.invalid
      }

    assigns = assign(assigns, :root, root)

    ~H"""
    <div phx-mounted={Connect.ignore_root(@root)} {Connect.root(@root)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def angle_slider_label(assigns) do
    label =
      %Label{
        id: assigns.ctx.id,
        dir: assigns.ctx.dir,
        orientation: assigns.ctx.orientation,
        disabled: assigns.ctx.disabled,
        read_only: assigns.ctx.read_only,
        invalid: assigns.ctx.invalid
      }

    assigns = assign(assigns, :label, label)

    ~H"""
    <div phx-mounted={Connect.ignore_label(@label)} {Connect.label(@label)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def angle_slider_control(assigns) do
    control =
      %Control{
        id: assigns.ctx.id,
        dir: assigns.ctx.dir,
        orientation: assigns.ctx.orientation,
        disabled: assigns.ctx.disabled,
        read_only: assigns.ctx.read_only,
        invalid: assigns.ctx.invalid
      }

    assigns = assign(assigns, :control, control)

    ~H"""
    <div phx-mounted={Connect.ignore_control(@control)} {Connect.control(@control)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)

  def angle_slider_thumb(assigns) do
    thumb =
      %Thumb{
        id: assigns.ctx.id,
        dir: assigns.ctx.dir,
        orientation: assigns.ctx.orientation,
        disabled: assigns.ctx.disabled,
        read_only: assigns.ctx.read_only,
        invalid: assigns.ctx.invalid
      }

    assigns = assign(assigns, :thumb, thumb)

    ~H"""
    <div phx-mounted={Connect.ignore_thumb(@thumb)} {Connect.thumb(@thumb)} {@rest} />
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)

  slot :value_text, required: false do
    attr(:class, :string, required: false)
  end

  def angle_slider_value_text(assigns) do
    value_text_props = %ValueText{
      id: assigns.ctx.id,
      dir: assigns.ctx.dir,
      value: assigns.ctx.value,
      orientation: assigns.ctx.orientation
    }

    assigns = assign(assigns, :value_text_props, value_text_props)

    ~H"""
    <div
      phx-mounted={Connect.ignore_value_text(@value_text_props)}
      {Connect.value_text(@value_text_props)}
      {@rest}
    >
      {render_slot(@value_text, value_text_string(@ctx.value, @ctx.value_text_as))}
      <.angle_slider_value :if={@value_text == []} ctx={@ctx}>
        {value_text_string(@ctx.value, @ctx.value_text_as)}
      </.angle_slider_value>
      <.angle_slider_value
        :if={@value_text != []}
        ctx={@ctx}
        class={Map.get(Enum.at(@value_text, 0), :class, nil)}
      >
        {value_text_string(@ctx.value, @ctx.value_text_as)}
      </.angle_slider_value>
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def angle_slider_value(assigns) do
    ~H"""
    <span {Connect.value(%Value{})} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc type: :compound
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def angle_slider_text(assigns) do
    ~H"""
    <span {Connect.text(%Text{})} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def angle_slider_marker_group(assigns) do
    marker_group = %MarkerGroup{
      id: assigns.ctx.id,
      dir: assigns.ctx.dir,
      orientation: assigns.ctx.orientation
    }

    assigns = assign(assigns, :marker_group, marker_group)

    ~H"""
    <div phx-mounted={Connect.ignore_marker_group(@marker_group)} {Connect.marker_group(@marker_group)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:value, :float, required: true)
  attr(:disabled, :boolean, default: false)
  attr(:rest, :global)

  def angle_slider_marker(assigns) do
    marker =
      %Marker{
        id: assigns.ctx.id,
        value: assigns.value,
        slider_value: assigns.ctx.value,
        disabled: assigns.disabled,
        dir: assigns.ctx.dir,
        orientation: assigns.ctx.orientation
      }

    assigns = assign(assigns, :marker, marker)

    ~H"""
    <div phx-mounted={Connect.ignore_marker(@marker)} {Connect.marker(@marker)} {@rest} />
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)

  def angle_slider_hidden_input(assigns) do
    hidden_input =
      %HiddenInput{
        id: assigns.ctx.id,
        name: assigns.ctx.name,
        value: assigns.ctx.value,
        disabled: assigns.ctx.disabled,
        dir: assigns.ctx.dir,
        orientation: assigns.ctx.orientation
      }

    assigns = assign(assigns, :hidden_input, hidden_input)

    ~H"""
    <input phx-mounted={Connect.ignore_hidden_input(@hidden_input)} {Connect.hidden_input(@hidden_input)} {@rest} />
    """
  end

  @doc type: :component
  @doc """
  Renders a loading skeleton for the angle slider. No hook; static `data-part` markup for styling.
  """

  attr(:rest, :global)

  def angle_slider_skeleton(assigns) do
    ~H"""
    <div {@rest}>
      <div data-scope="angle-slider" data-part="root" data-loading>
        <div data-scope="angle-slider" data-part="label" aria-hidden="true"></div>
        <div data-scope="angle-slider" data-part="control">
          <div data-scope="angle-slider" data-part="thumb"></div>
          <div data-scope="angle-slider" data-part="marker-group">
            <span data-scope="angle-slider" data-part="marker" data-value="0"></span>
            <span data-scope="angle-slider" data-part="marker" data-value="90"></span>
            <span data-scope="angle-slider" data-part="marker" data-value="180"></span>
            <span data-scope="angle-slider" data-part="marker" data-value="270"></span>
          </div>
        </div>
        <div data-scope="angle-slider" data-part="value-text">
          <span data-scope="angle-slider" data-part="value"></span>
          <span data-scope="angle-slider" data-part="text"></span>
        </div>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set the angle from a control (`phx-click`). `value` is degrees (number).

  ```heex
  <.action phx-click={Corex.AngleSlider.set_value("my-angle-slider", 90.0)}>90°</.action>
  <.angle_slider id="my-angle-slider" class="angle-slider" value={0.0} name="angle" />
  ```

  ```javascript
  document.getElementById("my-angle-slider")?.dispatchEvent(
    new CustomEvent("corex:angle-slider:set-value", {
      bubbles: false,
      detail: { value: 90 },
    })
  );
  ```
  """)

  def set_value(angle_slider_id, value) when is_binary(angle_slider_id) and is_number(value) do
    JS.dispatch("corex:angle-slider:set-value",
      to: "##{angle_slider_id}",
      detail: %{value: value},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set the angle from `handle_event`. Accepts a number or a numeric string.

  ```heex
  <.action phx-click="set_angle" phx-value-value="90">90°</.action>
  <.angle_slider id="my-angle-slider" class="angle-slider" value={0.0} name="angle" />
  ```

  ```elixir
  def handle_event("set_angle", %{"value" => v}, socket) do
    {:noreply, Corex.AngleSlider.set_value(socket, "my-angle-slider", v)}
  end
  ```
  """)

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

    LiveView.push_event(socket, "angle_slider_set_value", %{
      id: angle_slider_id,
      value: angle
    })
  end

  @doc false
  def value(angle_slider_id) when is_binary(angle_slider_id), do: value(angle_slider_id, [])

  api_doc(~S"""
  Read the current value from `phx-click`. Optional `respond_to:` `:server` (default), `:client`, or `:both`.

  ```heex
  <.action phx-click={Corex.AngleSlider.value("my-angle-slider", respond_to: :both)}>Read</.action>
  <.angle_slider id="my-angle-slider" class="angle-slider" value={45.0} name="angle" />
  ```

  ```javascript
  document.getElementById("my-angle-slider")?.dispatchEvent(
    new CustomEvent("corex:angle-slider:value", {
      bubbles: false,
      detail: { respond_to: "both" },
    })
  );
  ```
  """)

  def value(angle_slider_id, opts) when is_binary(angle_slider_id) and is_list(opts) do
    JS.dispatch("corex:angle-slider:value",
      to: "##{angle_slider_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  api_doc(~S"""
  Read the value from `handle_event`. Same `respond_to` behavior as [`value/2`](#value/2).

  ```heex
  <.action phx-click="read_angle">Read</.action>
  <.angle_slider id="my-angle-slider" class="angle-slider" value={45.0} name="angle" />
  ```

  ```elixir
  def handle_event("read_angle", _, socket) do
    {:noreply, Corex.AngleSlider.value(socket, "my-angle-slider", respond_to: :server)}
  end
  ```
  """)

  def value(socket, angle_slider_id, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(angle_slider_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "angle_slider_value",
      Map.merge(%{id: angle_slider_id}, respond_to_fields(opts))
    )
  end

  defp angle_value_to_float(value) when is_float(value), do: value

  defp angle_value_to_float(value) when is_integer(value), do: value * 1.0

  defp angle_value_to_float(value) when is_binary(value) do
    case Float.parse(value) do
      {num, _} -> num
      :error -> 0.0
    end
  end

  defp angle_value_to_float(_), do: 0.0

  defp clamp_angle(value) when is_float(value), do: min(max(value, 0.0), 359.0)

  defp clamp_angle(value) when is_integer(value), do: min(max(value * 1.0, 0.0), 359.0)

  defp clamp_angle(_), do: 0.0

  defp value_text_string(value, value_text_as) do
    formatted = Connect.format_number(value)

    case value_text_as do
      "raw" -> formatted
      "degree" -> formatted <> "deg"
    end
  end
end
