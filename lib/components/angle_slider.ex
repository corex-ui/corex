defmodule Corex.AngleSlider do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Angle Slider](https://zagjs.com/components/react/angle-slider).

  WAI-ARIA circular angle control. Use `angle_slider/1` with an optional label slot, marks, and controlled or uncontrolled mode.

  ## Anatomy

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
      {:ok, assign(socket, :value, 0)}
    end

    def handle_event("angle_changed", %{"value" => value}, socket) do
      {:noreply, assign(socket, :value, value)}
    end

    def render(assigns) do
      ~H"""
      <.angle_slider
        id="angle"
        controlled
        value={@value}
        on_value_change="angle_changed"
        marker_values={[0, 90, 180, 270]}
        class="angle-slider">
        <:label>Angle</:label>
      </.angle_slider>
      """
    end
  end
  ```

  <!-- tabs-close -->

  ## API

  ### LiveView

  The API targets one angle slider via its DOM `id` (the same `id` you pass to `angle_slider/1`).

  - `set_value/2` and `set_value/3`
  - `value/2` and `value/3`

  For `value`, use `respond_to: :server | :client | :both` to control whether the response is pushed to LiveView, dispatched as a DOM event, or both.

  ```heex
  <.action phx-click={Corex.AngleSlider.set_value("my-angle-slider", 90)}>Set 90°</.action>
  <.action phx-click={Corex.AngleSlider.value("my-angle-slider")}>Read value</.action>
  <.action phx-click={Corex.AngleSlider.value("my-angle-slider", respond_to: :client)}>
    Read value (client only)
  </.action>
  ```

  ```elixir
  def handle_event("set_angle", %{"value" => value}, socket) do
    {:noreply, Corex.AngleSlider.set_value(socket, "my-angle-slider", String.to_float(value))}
  end
  ```

  **From LiveView**, `Corex.AngleSlider.set_value/3` and `value/3` use `push_event/3` to the hook; optional `respond_to: :server | :client | :both` controls where the answer goes for `value/3`.

  **Responses to LiveView** (`push_event` from the hook; handle in `handle_event/3`):

  - `angle_slider_value_response` — `%{"id" => ..., "value" => number, "valueAsDegree" => number, "dragging" => boolean}`

  ### Client (DOM)

  **From the client**, dispatch `CustomEvent`s on the hook root (the element with `id`, e.g. `#my-angle-slider`):

  | Dispatch (type) | `detail` |
  |-----------------|----------|
  | `corex:angle-slider:set-value` | `value` — number in degrees |
  | `corex:angle-slider:value` | optional `respond_to`: `"server"`, `"client"`, or `"both"` |

  **Responses to the DOM** (listen on the hook root element):

  - `angle-slider-value` — `detail` with `id`, `value`, `valueAsDegree`, and `dragging`

  ## Events

  ### Server (LiveView)

  When `phx-hook="AngleSlider"` is active, Zag maps drag and value updates to your LiveView:

  - **`on_value_change`** — `pushEvent/3` with the name you set. Params include `%{"id" => dom_id, "value" => number, "valueAsDegree" => number}`.
  - **`on_value_change_end`** — same for the release event when you only care about the final value.

  ### Client (CustomEvent / DOM)

  - **`on_value_change_client`** — browser `CustomEvent` **type** is the string you set. `event.detail` matches the same shape (camelCase in JS; bubbles).
  - **`on_value_change_end_client`** — same pattern for the release event.

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
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/angle-slider.css";
  ```

  You can then use modifiers

  ```heex
  <.angle_slider class="angle-slider angle-slider--accent angle-slider--lg" value={0} />
  ```

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

  When using with Phoenix forms, set the form `id` in `to_form/2` (for example `to_form(changeset, as: :name, id: "my-form")`) and use `id={@form.id}` on `<.form>`.

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
  <.form :let={f} for={@form} id={@form.id} action={@action} method="post">
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
  attr(:value, :float, default: 0.0, doc: "The value or controlled value in degrees")
  attr(:controlled, :boolean, default: false, doc: "Whether the value is controlled")
  attr(:step, :float, default: 1.0, doc: "Step value")
  attr(:disabled, :boolean, default: false, doc: "Whether the slider is disabled")
  attr(:read_only, :boolean, default: false, doc: "Whether the slider is read-only")
  attr(:invalid, :boolean, default: false, doc: "Whether the slider is invalid")
  attr(:name, :string, default: nil, doc: "Name for form submission")
  attr(:dir, :string, default: "ltr", values: ["ltr", "rtl"], doc: "Direction")
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
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    value = field.value |> angle_value_to_float() |> clamp_angle()

    assigns
    |> assign(field: nil)
    |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:value, value)
    |> angle_slider()
  end

  def angle_slider(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "angle-slider-#{System.unique_integer([:positive])}" end)
      |> update(:value, &clamp_angle/1)

    ctx = %{
      id: assigns.id,
      dir: assigns.dir,
      orientation: assigns.orientation,
      value: assigns.value,
      controlled: assigns.controlled,
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
        value: @value,
        controlled: @controlled,
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

      <div :if={not @compound and @error} :for={msg <- @errors} data-scope="angle-slider" data-part="error">
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

  @doc type: :api
  @doc """
  Sets the angle slider value from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.AngleSlider.set_value("my-angle-slider", 90)}>
        Set to 90°
      </button>
  """
  def set_value(angle_slider_id, value) when is_binary(angle_slider_id) and is_number(value) do
    JS.dispatch("corex:angle-slider:set-value",
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

    LiveView.push_event(socket, "angle_slider_set_value", %{
      id: angle_slider_id,
      value: angle
    })
  end

  @doc type: :api
  @doc """
  Requests the angle slider value from the browser. Returns a `Phoenix.LiveView.JS` command.

  Options:

  - `:respond_to` — `:server` (default, LiveView `angle_slider_value_response` only), `:both` (also dispatches
    `angle-slider-value`), or `:client` (DOM `angle-slider-value` only). When `:server` and the LiveView is not connected, nothing is pushed.

  The hook pushes `angle_slider_value_response` when `:respond_to` is `:both` or `:server`, and dispatches
  `angle-slider-value` on the element when `:respond_to` is `:both` or `:client`.

  ## Examples

      <.action phx-click={Corex.AngleSlider.value("my-angle-slider")} class="button button--sm">
        Value
      </.action>
      <.action phx-click={Corex.AngleSlider.value("my-angle-slider", respond_to: :client)} class="button button--sm">
        Value (client only)
      </.action>

      ```javascript
      const el = document.getElementById("my-angle-slider");
      el?.addEventListener("angle-slider-value", (e) => console.log(e.detail));
      ```

      <.action
        phx-click={JS.dispatch("corex:angle-slider:value",
          to: "#my-angle-slider",
          detail: %{respond_to: "client"},
          bubbles: false
        )}
        class="button button--sm"
      >
        Value (JS.dispatch, client only)
      </.action>
  """

  def value(angle_slider_id) when is_binary(angle_slider_id), do: value(angle_slider_id, [])

  def value(angle_slider_id, opts) when is_binary(angle_slider_id) and is_list(opts) do
    JS.dispatch("corex:angle-slider:value",
      to: "##{angle_slider_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Requests the angle slider value from the client. Pushes a LiveView event handled by the hook.

  See `value/2` for `:respond_to`. The hook pushes `angle_slider_value_response` and/or dispatches `angle-slider-value`
  accordingly.

  ## Examples

      def handle_event("angle_slider_value_response", %{"id" => id, "value" => value}, socket) do
        {:noreply, assign(socket, :angle, {id, value})}
      end
  """

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
