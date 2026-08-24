defmodule Corex.Slider do
  @moduledoc ~S'''
  Linear slider for Phoenix LiveView forms. Behavior follows [Zag.js Slider](https://zagjs.com/components/react/slider)
  (the same machine powers [range slider](https://zagjs.com/components/react/range-slider)).
  Use `slider/1` with one value for a single thumb, or a list for multiple thumbs.

  ## Anatomy

  <!-- tabs-open -->

  ### Basic

  ```heex
  <.slider class="slider">
    <:label>Volume</:label>
  </.slider>
  ```

  ### Range

  ```heex
  <.slider class="slider" value={[20, 80]}>
    <:label>Price</:label>
  </.slider>
  ```

  ### With marks

  ```heex
  <.slider class="slider" markers marker_values={[0, 25, 50, 75, 100]}>
    <:label>Volume</:label>
  </.slider>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.slider>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set value (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set value (server) | `socket` |
  | [`set_thumb_value/3`](#set_thumb_value/3) | Set one thumb (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_thumb_value/4`](#set_thumb_value/4) | Set one thumb (server) | `socket` |
  | [`increment/1`](#increment/1) | Increment first thumb (client) | `%Phoenix.LiveView.JS{}` |
  | [`increment/2`](#increment/2) | Increment (client with index, or server) | `%Phoenix.LiveView.JS{}` or `socket` |
  | [`increment/3`](#increment/3) | Increment thumb (server) | `socket` |
  | [`decrement/1`](#decrement/1) | Decrement first thumb (client) | `%Phoenix.LiveView.JS{}` |
  | [`decrement/2`](#decrement/2) | Decrement (client with index, or server) | `%Phoenix.LiveView.JS{}` or `socket` |
  | [`decrement/3`](#decrement/3) | Decrement thumb (server) | `socket` |
  | [`value/1`](#value/1) | Read value (client) | `%Phoenix.LiveView.JS{}` |
  | [`value/2`](#value/2) | Read value (client, opts) | `%Phoenix.LiveView.JS{}` |
  | [`value/3`](#value/3) | Read value (server) | `socket` |

  For `value`, use `respond_to: :server | :client | :both`. LiveView receives `slider_value_response`; the DOM receives `slider-value`.

  ## Events

  Pick an event name and pass it to `on_*` on `<.slider>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="slider_changed"` | Value changes while dragging | `%{"id" => id, "value" => list}` |
  | `on_value_change_end="slider_changed_end"` | User releases a thumb | `%{"id" => id, "value" => list}` |

  <!-- tabs-open -->

  ### on_value_change

  ```heex
  <.slider
    class="slider"
    on_value_change="slider_changed"
    markers marker_values={[0, 25, 50, 75, 100]}
  >
    <:label>Volume</:label>
  </.slider>
  ```

  ```elixir
  def handle_event("slider_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="slider-changed"` | Value changes while dragging | `id`, `value` |
  | `on_value_change_end_client="slider-changed-end"` | User releases a thumb | `id`, `value` |

  ## Style

  Use data attributes to target elements:

  ```css
  [data-scope="slider"][data-part="root"] {}
  [data-scope="slider"][data-part="control"] {}
  [data-scope="slider"][data-part="track"] {}
  [data-scope="slider"][data-part="range"] {}
  [data-scope="slider"][data-part="thumb"] {}
  [data-scope="slider"][data-part="value-text"] {}
  [data-scope="slider"][data-part="marker-group"] {}
  [data-scope="slider"][data-part="marker"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `slider` on the component.
  This requires the `corex_design` dependency and `mix corex.design.build`; import the component css file.

  ```css
  @import "../corex/corex.css";
  ```

  Stack modifiers on the host (`class` on `<.slider>`). Combine axes, for example `slider ui-accent ui-size-lg` or `slider ui-info`.

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). No variant axis. See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on the track fill and thumb handle. Selection paint always fills; there is no variant axis.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for range fill and thumb ink.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `slider` |
  | Accent | `slider ui-accent` |
  | Brand | `slider ui-brand` |
  | Alert | `slider ui-alert` |
  | Info | `slider ui-info` |
  | Success | `slider ui-success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `slider ui-size-sm` |
  | MD | `slider ui-size-md` |
  | LG | `slider ui-size-lg` |
  | XL | `slider ui-size-xl` |

  <!-- tabs-close -->

  ## Patterns

  ### Async and skeleton

  Use `assign_async/3` with `<.async_result>` and show `slider_skeleton/1` while loading.

  ```elixir
  <.async_result :let={slider} assign={@slider}>
    <:loading>
      <.slider_skeleton class="slider" />
    </:loading>
    <:failed>Could not load.</:failed>
    <.slider id="async-slider" class="slider" value={slider.value} />
  </.async_result>
  ```

  ## Form

  When using with Phoenix forms, set the form `id` in `to_form/2` (for example `to_form(changeset, as: :name, id: "my-form")`) and use `<.form for={@form}>`.

  A single thumb submits one number. Two or more thumbs submit `name[]` list params.

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. With `field={@form[:…]}`, pass `auto_invalid` for alert borders from visible errors, or `invalid={true}` to force the alert state.

  ```elixir
  def slider_form_page(conn, _params) do
    form =
      %MyApp.Form.SliderForm{}
      |> MyApp.Form.SliderForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :slider_form, id: "slider-form")

    render(conn, :slider_form_page, form: form)
  end
  ```

  ```heex
  <.form :let={f} for={@form} action={@action} method="post">
    <.slider field={f[:volume]} class="slider" markers marker_values={[0, 25, 50, 75, 100]}>
      <:label>Volume</:label>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.slider>
    <button type="submit">Submit</button>
  </.form>
  ```
  '''

  @doc type: :component
  use Phoenix.Component

  use Corex.Component, [:api, :form]

  import Corex.Api.Doc

  alias Corex.Slider.Anatomy.{
    Control,
    HiddenInput,
    Label,
    Marker,
    MarkerGroup,
    Props,
    Range,
    Root,
    Thumb,
    Track,
    Value,
    ValueText
  }

  alias Corex.Slider.Connect

  alias Corex.Selectors

  alias Phoenix.LiveView

  alias Phoenix.LiveView.JS

  form_control_attrs(
    except: [:controlled],
    docs: [
      id: "The id of the slider",
      field:
        "A form field struct retrieved from the form, for example: @form[:volume]. Automatically sets id, name, value, and errors from the form field",
      name: "Name for form submission. Multi-thumb sliders append []",
      read_only: "Whether the slider is read-only"
    ]
  )

  attr(:value, :any,
    default: 0,
    doc: "Initial value. A number is one thumb; a list of numbers is a range (or N thumbs)"
  )

  attr(:min, :float, default: 0.0, doc: "Minimum value")
  attr(:max, :float, default: 100.0, doc: "Maximum value")
  attr(:step, :float, default: 1.0, doc: "Step value")
  attr(:large_step, :float, default: nil, doc: "Step when Shift or PageUp/PageDown is used")
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"], doc: "Direction")
  attr(:orientation, :string, default: "horizontal", values: ["horizontal", "vertical"])

  attr(:origin, :string,
    default: "start",
    values: ["start", "center", "end"],
    doc: "Where the range fill starts for a single thumb"
  )

  attr(:thumb_alignment, :string,
    default: nil,
    values: [nil, "contain", "center"],
    doc: "Thumb alignment relative to the track"
  )

  attr(:min_steps_between_thumbs, :integer,
    default: nil,
    doc: "Minimum steps between thumbs for a range slider"
  )

  attr(:thumb_collision_behavior, :string,
    default: nil,
    values: [nil, "none", "push", "swap"],
    doc: "How thumbs behave when they collide"
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
    doc: "Server event when the user releases a thumb"
  )

  attr(:on_value_change_end_client, :string,
    default: nil,
    doc: "Client event when the user releases a thumb"
  )

  attr(:markers, :boolean,
    default: false,
    doc: "Show tick marks on the track. Use marker_values to customize positions."
  )

  attr(:marker_values, :list,
    default: nil,
    doc: "Tick positions when markers is true (defaults to quarter steps between min and max)"
  )

  attr(:errors, :list, default: [], doc: "List of error messages to display")

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

  def slider(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    value = field_value(field.value)

    assigns
    |> Corex.FormField.assign_form_field(field)
    |> assign(:value, value)
    |> slider()
  end

  def slider(assigns) do
    assigns =
      assigns
      |> Corex.FormField.require_id!("Corex component (slider)")
      |> assign_new(:form_field, fn -> false end)
      |> assign_new(:field_used, fn -> false end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:required, fn -> false end)
      |> update(:value, &normalize_value/1)

    display_value = Connect.effective_values(assigns.value)
    submit_name = slider_submit_name(assigns.name, display_value)
    hidden_name = slider_hidden_input_name(assigns, submit_name)
    marker_values = effective_marker_values(assigns)

    ctx = %{
      id: assigns.id,
      dir: assigns.dir,
      orientation: assigns.orientation,
      origin: assigns.origin,
      thumb_alignment: assigns.thumb_alignment,
      markers: assigns.markers,
      value: display_value,
      min: assigns.min,
      max: assigns.max,
      step: assigns.step,
      disabled: assigns.disabled,
      read_only: assigns.read_only,
      invalid: assigns.invalid,
      required: assigns.required,
      name: hidden_name,
      form: assigns.form,
      marker_values: marker_values
    }

    assigns =
      assigns
      |> assign(:ctx, ctx)
      |> assign(:display_value, display_value)
      |> assign(:hidden_name, hidden_name)
      |> assign(:submit_name, submit_name)
      |> assign(:marker_values, marker_values)

    ~H"""
    <div
      id={@id}
      phx-hook="Slider"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        form_field: @form_field,
        field_used: @field_used,
        value: @display_value,
        min: @min,
        max: @max,
        step: @step,
        large_step: @large_step,
        disabled: @disabled,
        read_only: @read_only,
        invalid: @invalid,
        required: @required,
        name: @hidden_name,
        submit_name: @submit_name,
        form: @form,
        dir: @dir,
        orientation: @orientation,
        origin: @origin,
        thumb_alignment: @thumb_alignment,
        min_steps_between_thumbs: @min_steps_between_thumbs,
        thumb_collision_behavior: @thumb_collision_behavior,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client,
        on_value_change_end: @on_value_change_end,
        on_value_change_end_client: @on_value_change_end_client
      })}
    >
      {if @compound do render_slot(@inner_block, @ctx) end}

      <div
        :if={not @compound}
        {Connect.mounted_root(%Root{
          id: @id,
          dir: @dir,
          value: @display_value,
          min: @min,
          max: @max,
          origin: @origin,
          thumb_alignment: @thumb_alignment,
          disabled: @disabled,
          read_only: @read_only,
          invalid: @invalid,
          orientation: @orientation
        })}
      >
        <div
          :if={@label != []}
          {Connect.mounted_label(%Label{
            id: @id,
            dir: @dir,
            disabled: @disabled,
            read_only: @read_only,
            invalid: @invalid,
            orientation: @orientation
          })}
        >
          {render_slot(@label)}
        </div>
        <div
          {Connect.mounted_control(%Control{
            id: @id,
            dir: @dir,
            disabled: @disabled,
            read_only: @read_only,
            invalid: @invalid,
            orientation: @orientation
          })}
        >
          <div
            {Connect.mounted_track(%Track{
              id: @id,
              dir: @dir,
              disabled: @disabled,
              read_only: @read_only,
              invalid: @invalid,
              orientation: @orientation
            })}
          >
            <div
              {Connect.mounted_range(%Range{
                id: @id,
                dir: @dir,
                value: @display_value,
                min: @min,
                max: @max,
                origin: @origin,
                disabled: @disabled,
                read_only: @read_only,
                invalid: @invalid,
                orientation: @orientation
              })}
            />
          </div>
          <div
            :for={{thumb_value, index} <- Enum.with_index(@display_value)}
            {Connect.mounted_thumb(%Thumb{
              id: @id,
              dir: @dir,
              index: index,
              value: thumb_value,
              min: @min,
              max: @max,
              disabled: @disabled,
              read_only: @read_only,
              invalid: @invalid,
              orientation: @orientation
            })}
            title="Thumb"
          >
            <input
              {Connect.mounted_hidden_input(%HiddenInput{
                id: @id,
                name: @hidden_name,
                value: thumb_value,
                index: index,
                disabled: @disabled,
                dir: @dir,
                form: @form,
                required: @required,
                orientation: @orientation
              })}
            />
          </div>
          <div
            :if={@marker_values != []}
            {Connect.mounted_marker_group(%MarkerGroup{id: @id, dir: @dir, orientation: @orientation})}
          >
            <div
              :for={val <- @marker_values}
              {Connect.mounted_marker(%Marker{
                id: @id,
                value: val,
                slider_value: @display_value,
                min: @min,
                max: @max,
                thumb_alignment: @thumb_alignment,
                disabled: @disabled,
                dir: @dir,
                orientation: @orientation
              })}
            />
          </div>
        </div>
        <div
          {Connect.mounted_value_text(%ValueText{
            id: @id,
            dir: @dir,
            value: @display_value,
            orientation: @orientation
          })}
        >
          {render_slot(@value_text, Connect.value_text_string(@display_value))}
          <span
            :if={@value_text != []}
            class={Map.get(Enum.at(@value_text, 0), :class, nil)}
            {Connect.value(%Value{})}
          >
            {Connect.value_text_string(@display_value)}
          </span>
          <span :if={@value_text == []} {Connect.value(%Value{})}>
            {Connect.value_text_string(@display_value)}
          </span>
        </div>
      </div>

      <Corex.Component.Errors.field_errors :if={not @compound} scope="slider" errors={@errors} error={@error} />
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map,
    required: true,
    doc: "The context map yielded by the parent slider via :let={ctx}"
  )

  attr(:rest, :global)
  slot(:inner_block, required: true)

  def slider_root(assigns) do
    root =
      %Root{
        id: assigns.ctx.id,
        dir: assigns.ctx.dir,
        orientation: assigns.ctx.orientation,
        origin: Map.get(assigns.ctx, :origin, "start"),
        thumb_alignment: Map.get(assigns.ctx, :thumb_alignment),
        value: assigns.ctx.value,
        min: Map.get(assigns.ctx, :min, 0),
        max: Map.get(assigns.ctx, :max, 100),
        disabled: assigns.ctx.disabled,
        read_only: assigns.ctx.read_only,
        invalid: assigns.ctx.invalid
      }

    assigns = assign(assigns, :root, root)

    ~H"""
    <div {Connect.mounted_root(@root)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def slider_label(assigns) do
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
    <div {Connect.mounted_label(@label)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def slider_control(assigns) do
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
    <div {Connect.mounted_control(@control)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def slider_track(assigns) do
    track =
      %Track{
        id: assigns.ctx.id,
        dir: assigns.ctx.dir,
        orientation: assigns.ctx.orientation,
        disabled: assigns.ctx.disabled,
        read_only: assigns.ctx.read_only,
        invalid: assigns.ctx.invalid
      }

    assigns = assign(assigns, :track, track)

    ~H"""
    <div {Connect.mounted_track(@track)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)

  def slider_range(assigns) do
    range =
      %Range{
        id: assigns.ctx.id,
        dir: assigns.ctx.dir,
        orientation: assigns.ctx.orientation,
        origin: Map.get(assigns.ctx, :origin, "start"),
        value: assigns.ctx.value,
        min: Map.get(assigns.ctx, :min, 0),
        max: Map.get(assigns.ctx, :max, 100),
        disabled: assigns.ctx.disabled,
        read_only: assigns.ctx.read_only,
        invalid: assigns.ctx.invalid
      }

    assigns = assign(assigns, :range, range)

    ~H"""
    <div {Connect.mounted_range(@range)} {@rest} />
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:index, :integer, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def slider_thumb(assigns) do
    values = List.wrap(assigns.ctx.value)
    thumb_value = Enum.at(values, assigns.index) || 0

    thumb =
      %Thumb{
        id: assigns.ctx.id,
        dir: assigns.ctx.dir,
        orientation: assigns.ctx.orientation,
        index: assigns.index,
        value: thumb_value,
        min: Map.get(assigns.ctx, :min, 0),
        max: Map.get(assigns.ctx, :max, 100),
        disabled: assigns.ctx.disabled,
        read_only: assigns.ctx.read_only,
        invalid: assigns.ctx.invalid
      }

    assigns = assign(assigns, :thumb, thumb)

    ~H"""
    <div {Connect.mounted_thumb(@thumb)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)

  slot :value_text, required: false do
    attr(:class, :string, required: false)
  end

  def slider_value_text(assigns) do
    value_text_props = %ValueText{
      id: assigns.ctx.id,
      dir: assigns.ctx.dir,
      value: assigns.ctx.value,
      orientation: assigns.ctx.orientation
    }

    assigns = assign(assigns, :value_text_props, value_text_props)

    ~H"""
    <div {Connect.mounted_value_text(@value_text_props)} {@rest}>
      {render_slot(@value_text, Connect.value_text_string(@ctx.value))}
      <.slider_value :if={@value_text == []} ctx={@ctx}>
        {Connect.value_text_string(@ctx.value)}
      </.slider_value>
      <.slider_value
        :if={@value_text != []}
        ctx={@ctx}
        class={Map.get(Enum.at(@value_text, 0), :class, nil)}
      >
        {Connect.value_text_string(@ctx.value)}
      </.slider_value>
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def slider_value(assigns) do
    ~H"""
    <span {Connect.value(%Value{})} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def slider_marker_group(assigns) do
    marker_group = %MarkerGroup{
      id: assigns.ctx.id,
      dir: assigns.ctx.dir,
      orientation: assigns.ctx.orientation
    }

    assigns = assign(assigns, :marker_group, marker_group)

    ~H"""
    <div {Connect.mounted_marker_group(@marker_group)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:value, :float, required: true)
  attr(:disabled, :boolean, default: false)
  attr(:rest, :global)

  def slider_marker(assigns) do
    marker =
      %Marker{
        id: assigns.ctx.id,
        value: assigns.value,
        slider_value: List.wrap(assigns.ctx.value),
        min: Map.get(assigns.ctx, :min, 0),
        max: Map.get(assigns.ctx, :max, 100),
        thumb_alignment: Map.get(assigns.ctx, :thumb_alignment),
        disabled: assigns.disabled,
        dir: assigns.ctx.dir,
        orientation: assigns.ctx.orientation
      }

    assigns = assign(assigns, :marker, marker)

    ~H"""
    <div {Connect.mounted_marker(@marker)} {@rest} />
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:index, :integer, default: 0)
  attr(:rest, :global)

  def slider_hidden_input(assigns) do
    values = List.wrap(assigns.ctx.value)
    thumb_value = Enum.at(values, assigns.index) || 0

    hidden_input =
      %HiddenInput{
        id: assigns.ctx.id,
        name: assigns.ctx.name,
        value: thumb_value,
        index: assigns.index,
        disabled: assigns.ctx.disabled,
        dir: assigns.ctx.dir,
        form: Map.get(assigns.ctx, :form),
        required: Map.get(assigns.ctx, :required, false),
        orientation: assigns.ctx.orientation
      }

    assigns = assign(assigns, :hidden_input, hidden_input)

    ~H"""
    <input {Connect.mounted_hidden_input(@hidden_input)} {@rest} />
    """
  end

  @doc type: :component
  @doc """
  Renders a loading skeleton for the slider. No hook; static `data-part` markup for styling.
  """

  attr(:rest, :global)

  def slider_skeleton(assigns) do
    ~H"""
    <div {@rest}>
      <div data-scope="slider" data-part="root" data-loading data-orientation="horizontal">
        <div data-scope="slider" data-part="label" aria-hidden="true"></div>
        <div data-scope="slider" data-part="control" data-orientation="horizontal">
          <div data-scope="slider" data-part="track">
            <div data-scope="slider" data-part="range"></div>
          </div>
          <div data-scope="slider" data-part="thumb" data-index="0"></div>
          <div data-scope="slider" data-part="marker-group">
            <span data-scope="slider" data-part="marker" data-value="0"></span>
            <span data-scope="slider" data-part="marker" data-value="50"></span>
            <span data-scope="slider" data-part="marker" data-value="100"></span>
          </div>
        </div>
        <div data-scope="slider" data-part="value-text">
          <span data-scope="slider" data-part="value"></span>
        </div>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set the slider value from a control (`phx-click`). `value` is a number or a list of numbers.

  ```heex
  <.action phx-click={Corex.Slider.set_value("my-slider", 50)}>50</.action>
  <.slider id="my-slider" class="slider" value={0} name="volume" />
  ```

  ```javascript
  document.getElementById("my-slider")?.dispatchEvent(
    new CustomEvent("corex:slider:set-value", {
      bubbles: false,
      detail: { value: [50] },
    })
  );
  ```
  """)

  @spec set_value(String.t(), number() | [number()] | String.t()) :: Phoenix.LiveView.JS.t()
  @spec set_value(Phoenix.LiveView.Socket.t(), String.t(), term()) ::
          Phoenix.LiveView.Socket.t()
  def set_value(slider_id, value) when is_binary(slider_id) do
    JS.dispatch("corex:slider:set-value",
      to: Selectors.css_id(slider_id),
      detail: %{value: coerce_values(value)},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set the slider value from `handle_event`. Accepts a number, a list, or a numeric string.

  ```elixir
  def handle_event("set_volume", %{"value" => value}, socket) do
    {:noreply, Corex.Slider.set_value(socket, "my-slider", value)}
  end
  ```
  """)

  def set_value(socket, slider_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(slider_id) do
    LiveView.push_event(socket, "slider_set_value", %{
      id: slider_id,
      value: coerce_values(value)
    })
  end

  api_doc(~S"""
  Set one thumb from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Slider.set_thumb_value("my-slider", 0, 25)}>Min 25</.action>
  ```
  """)

  @spec set_thumb_value(String.t(), integer(), number()) :: Phoenix.LiveView.JS.t()
  @spec set_thumb_value(Phoenix.LiveView.Socket.t(), String.t(), integer(), term()) ::
          Phoenix.LiveView.Socket.t()
  def set_thumb_value(slider_id, index, value)
      when is_binary(slider_id) and is_integer(index) do
    JS.dispatch("corex:slider:set-thumb-value",
      to: Selectors.css_id(slider_id),
      detail: %{index: index, value: coerce_number(value)},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set one thumb from `handle_event`.

  ```elixir
  def handle_event("set_min", _, socket) do
    {:noreply, Corex.Slider.set_thumb_value(socket, "my-slider", 0, 25)}
  end
  ```
  """)

  def set_thumb_value(socket, slider_id, index, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(slider_id) and
             is_integer(index) do
    LiveView.push_event(socket, "slider_set_thumb_value", %{
      id: slider_id,
      index: index,
      value: coerce_number(value)
    })
  end

  api_doc(~S"""
  Increment the first thumb from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Slider.increment("my-slider")}>+</.action>
  ```
  """)

  @spec increment(String.t()) :: Phoenix.LiveView.JS.t()
  @spec increment(String.t(), integer()) :: Phoenix.LiveView.JS.t()
  @spec increment(Phoenix.LiveView.Socket.t(), String.t()) :: Phoenix.LiveView.Socket.t()
  @spec increment(Phoenix.LiveView.Socket.t(), String.t(), integer()) ::
          Phoenix.LiveView.Socket.t()
  def increment(slider_id) when is_binary(slider_id), do: increment(slider_id, 0)

  def increment(slider_id, index) when is_binary(slider_id) and is_integer(index) do
    JS.dispatch("corex:slider:increment",
      to: Selectors.css_id(slider_id),
      detail: %{index: index},
      bubbles: false
    )
  end

  api_doc(~S"""
  Increment from `handle_event`. Optional thumb `index` (default 0).

  ```elixir
  def handle_event("inc", _, socket) do
    {:noreply, Corex.Slider.increment(socket, "my-slider")}
  end
  ```
  """)

  def increment(socket, slider_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(slider_id) do
    increment(socket, slider_id, 0)
  end

  def increment(socket, slider_id, index)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(slider_id) and
             is_integer(index) do
    LiveView.push_event(socket, "slider_increment", %{id: slider_id, index: index})
  end

  api_doc(~S"""
  Decrement the first thumb from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Slider.decrement("my-slider")}>-</.action>
  ```
  """)

  @spec decrement(String.t()) :: Phoenix.LiveView.JS.t()
  @spec decrement(String.t(), integer()) :: Phoenix.LiveView.JS.t()
  @spec decrement(Phoenix.LiveView.Socket.t(), String.t()) :: Phoenix.LiveView.Socket.t()
  @spec decrement(Phoenix.LiveView.Socket.t(), String.t(), integer()) ::
          Phoenix.LiveView.Socket.t()
  def decrement(slider_id) when is_binary(slider_id), do: decrement(slider_id, 0)

  def decrement(slider_id, index) when is_binary(slider_id) and is_integer(index) do
    JS.dispatch("corex:slider:decrement",
      to: Selectors.css_id(slider_id),
      detail: %{index: index},
      bubbles: false
    )
  end

  api_doc(~S"""
  Decrement from `handle_event`. Optional thumb `index` (default 0).

  ```elixir
  def handle_event("dec", _, socket) do
    {:noreply, Corex.Slider.decrement(socket, "my-slider")}
  end
  ```
  """)

  def decrement(socket, slider_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(slider_id) do
    decrement(socket, slider_id, 0)
  end

  def decrement(socket, slider_id, index)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(slider_id) and
             is_integer(index) do
    LiveView.push_event(socket, "slider_decrement", %{id: slider_id, index: index})
  end

  @doc false
  @spec value(String.t()) :: Phoenix.LiveView.JS.t()
  @spec value(String.t(), keyword()) :: Phoenix.LiveView.JS.t()
  @spec value(Phoenix.LiveView.Socket.t(), String.t(), keyword()) :: Phoenix.LiveView.Socket.t()
  def value(slider_id) when is_binary(slider_id), do: value(slider_id, [])

  api_doc(~S"""
  Read the current value from `phx-click`. Optional `respond_to:` `:server` (default), `:client`, or `:both`.

  ```heex
  <.action phx-click={Corex.Slider.value("my-slider", respond_to: :both)}>Read</.action>
  <.slider id="my-slider" class="slider" value={45} name="volume" />
  ```

  ```javascript
  document.getElementById("my-slider")?.dispatchEvent(
    new CustomEvent("corex:slider:value", {
      bubbles: false,
      detail: { respond_to: "both" },
    })
  );
  ```
  """)

  def value(slider_id, opts) when is_binary(slider_id) and is_list(opts) do
    JS.dispatch("corex:slider:value",
      to: Selectors.css_id(slider_id),
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  api_doc(~S"""
  Read the value from `handle_event`. Same `respond_to` behavior as [`value/2`](#value/2).

  ```elixir
  def handle_event("read_volume", _, socket) do
    {:noreply, Corex.Slider.value(socket, "my-slider", respond_to: :server)}
  end
  ```
  """)

  def value(socket, slider_id, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(slider_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "slider_value",
      Map.merge(%{id: slider_id}, respond_to_fields(opts))
    )
  end

  defp field_value(nil), do: nil
  defp field_value(""), do: nil
  defp field_value(value), do: normalize_value(value)

  defp normalize_value(nil), do: nil
  defp normalize_value(value) when is_number(value), do: [to_float(value)]

  defp normalize_value(value) when is_binary(value) do
    trimmed = String.trim(value)

    cond do
      trimmed == "" ->
        nil

      String.starts_with?(trimmed, "[") ->
        case Corex.Json.decode(trimmed) do
          {:ok, list} when is_list(list) and list != [] -> Enum.map(list, &to_float/1)
          _ -> [parse_float(trimmed)]
        end

      true ->
        [parse_float(trimmed)]
    end
  end

  defp normalize_value(values) when is_list(values) do
    case Enum.map(values, &to_float/1) do
      [] -> nil
      nums -> nums
    end
  end

  defp normalize_value(_), do: nil

  defp slider_submit_name(nil, _values), do: nil

  defp slider_submit_name(name, values) when is_binary(name) and is_list(values) do
    if length(values) > 1, do: Corex.FormField.list_submit_name(name), else: name
  end

  defp slider_hidden_input_name(%{field_used: used}, submit_name)
       when used not in [nil, false],
       do: submit_name

  defp slider_hidden_input_name(%{value: value}, submit_name) when not is_nil(value),
    do: submit_name

  defp slider_hidden_input_name(_assigns, _submit_name), do: nil

  defp coerce_values(value) when is_list(value), do: Enum.map(value, &coerce_number/1)
  defp coerce_values(value), do: [coerce_number(value)]

  defp coerce_number(value) when is_number(value), do: value

  defp coerce_number(value) when is_binary(value) do
    case Float.parse(value) do
      {num, _rest} -> num
      :error -> fallback_number(value)
    end
  end

  defp coerce_number(value), do: fallback_number(value)

  defp fallback_number(value) do
    Corex.Dev.warn("Corex.Slider expected a number, got #{inspect(value)}, using 0")

    0
  end

  defp effective_marker_values(%{markers: markers, min: min, max: max} = assigns) do
    if markers != true do
      []
    else
      case Map.get(assigns, :marker_values) do
        values when is_list(values) and values != [] -> values
        _ -> default_marker_values(min, max)
      end
    end
  end

  defp default_marker_values(min, max) do
    span = max - min

    if span <= 0 do
      [min]
    else
      [
        min,
        min + span * 0.25,
        min + span * 0.5,
        min + span * 0.75,
        max
      ]
    end
  end

  defp to_float(value) when is_float(value), do: value
  defp to_float(value) when is_integer(value), do: value * 1.0
  defp to_float(value) when is_binary(value), do: parse_float(value)
  defp to_float(_), do: 0.0

  defp parse_float(value) when is_binary(value) do
    case Float.parse(value) do
      {num, _} -> num
      :error -> 0.0
    end
  end
end
