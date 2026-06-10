defmodule Corex.NativeInput do
  @moduledoc ~S'''
  Unified native input component based on  [Phoenix Core Components](https://hexdocs.pm/phoenix/components.html#corecomponents)
  Used for text, textarea, date, datetime-local, time, month, week, email, url, tel, search, color, number, password, checkbox, radio, and select.
  Optional icon slot and shared styling via data-scope="native-input".
  Uses same data-part structure as Corex components (root, label, control, input, error) for consistency.

  The icon slot is ignored for textarea, date/time types, color, number, checkbox, radio, and select.

  For text, email, url, tel, search, and password the icon slot is shown when provided.

  ## Anatomy

  ### Basic

  ```heex
  <.native_input type="text" name="user[name]">
    <:label>Name</:label>
  </.native_input>
  ```

  ### With icon

  ```heex
  <.native_input type="email" name="user[email]">
    <:label>Email</:label>
    <:icon><.heroicon name="hero-envelope" /></:icon>
  </.native_input>
  ```

  ### Textarea (icon slot ignored)

  ```heex
  <.native_input type="textarea" name="user[bio]">
    <:label>Bio</:label>
  </.native_input>
  ```

  ### Checkbox, select, radio

  ```heex
  <.native_input type="checkbox" name="user[agree]">
    <:label>I agree</:label>
  </.native_input>
  <.native_input type="select" name="user[role]" options={["Admin": "admin", "User": "user"]} prompt="Choose role">
    <:label>Role</:label>
  </.native_input>
  <.native_input type="radio" name="user[size]" options={["Small": "s", "Medium": "m", "Large": "l"]} value="m">
    <:label>Size</:label>
  </.native_input>
  ```

  ### With form field

  Use `field={f[:key]}` or `field={@form[:key]}` with a form built from an Ecto changeset. Set the form `id` in `to_form/2` and use `<.form for={@form}>`. See the Checkbox or NumberInput component docs for the full Controller and Live View pattern.

  ```heex
  <.form :let={f} for={@form}>
    <.native_input type="email" field={f[:email]}>
      <:label>Email</:label>
      <:error :let={msg}>{msg}</:error>
    </.native_input>
  </.form>
  ```

  ## Styling

  Style attrs and BEM classes are equivalent. See [Unstyled](unstyled.html). Axes: `semantic`, `size`, `radius`.

  <!-- tabs-open -->

  ### With attributes

  ```heex
  <.native_input type="text" name="user[name]" semantic="accent" size="md" class="native-input">
    <:label>Name</:label>
  </.native_input>
  ```

  ### With classes

  ```heex
  <.native_input type="text" name="user[name]" class="native-input native-input--semantic-accent native-input--size-md">
    <:label>Name</:label>
  </.native_input>
  ```

  <!-- tabs-close -->

  ## Read-only

  Pass `read_only={true}` or `readonly` in global attributes. Both set `data-readonly` on the root for Corex CSS and the HTML `readonly` attribute on the input.

  ```heex
  <.native_input type="text" name="user[code]" read_only>
    <:label>Code</:label>
  </.native_input>
  ```

  ## Form

  Use `field={f[:email]}` inside `<.form>` with a changeset-backed form.

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. Pass `invalid={Corex.FormField.invalid?(@form[:email])}` when you want alert borders after validation.

  For `type="select"` with `multiple`, the field name is suffixed with `[]` so Ecto `{:array, :string}` receives a list (same Phoenix convention as [`Corex.Select`](Corex.Select.html) `multiple`).

  ```heex
  <.form for={@form} phx-change="validate">
    <.native_input type="email" field={@form[:email]}>
      <:label>Email</:label>
      <:error :let={msg}>{msg}</:error>
    </.native_input>
  </.form>
  ```

  ## Style

  Target parts with `data-scope` and `data-part`, or use [Corex Design](styled.html): `@import "./corex.tailwind.css"` in `app.css`.

  ```css
  [data-scope="native-input"][data-part="root"] {}
  [data-scope="native-input"][data-part="label"] {}
  [data-scope="native-input"][data-part="control"] {}
  [data-scope="native-input"][data-part="icon"] {}
  [data-scope="native-input"][data-part="input"] {}
  [data-scope="native-input"][data-part="error"] {}
  ```

  The root has `data-no-icon` when no icon is shown (icon slot empty or type is textarea/date/time), so the input uses full-width padding.
  '''

  @doc type: :component
  use Phoenix.Component

  use Corex.Variants,
    base: "native-input",
    class_attr: false,
    axes: [
      width: :width,
      max_width: :max_width,
      height: :height,
      max_height: :max_height,
      semantic: :semantic,
      size: :size,
      radius: :radius
    ],
    defaults: [
      width: "full",
      max_width: "4xl",
      height: "auto",
      max_height: "none",
      size: "md"
    ]

  alias Phoenix.HTML.Form

  @types ~W(text textarea date datetime-local time month week email url tel search color number password checkbox radio select)

  attr(:type, :string, required: true, values: @types)
  attr(:id, :string, required: false)
  attr(:name, :string, required: false)
  attr(:value, :any)
  attr(:invalid, :boolean, default: false)

  attr(:read_only, :boolean,
    default: false,
    doc: "Read-only state; also sets HTML readonly on the input"
  )

  attr(:errors, :list, default: [], doc: "List of error messages to display")
  attr(:class, :any, default: nil)
  attr(:prompt, :string, default: nil, doc: "Prompt for select inputs")

  attr(:options, :list,
    default: nil,
    doc: "Options for select and radio. Same format as options_for_select."
  )

  attr(:multiple, :boolean, default: false, doc: "Multiple flag for select inputs")
  attr(:checked, :boolean, doc: "Checked flag for checkbox. Defaults from value.")

  attr(:field, Phoenix.HTML.FormField,
    doc: "A form field struct from the form, e.g. @form[:email]"
  )

  attr(:rest, :global,
    include:
      ~W(autocomplete disabled maxlength minlength pattern placeholder readonly required cols rows list form min max step accept) ++
        ~W(phx-change phx-blur phx-focus phx-target phx-debounce phx-throttle)
  )

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :icon,
    required: false,
    doc:
      "Optional. Ignored for textarea, date, datetime-local, time, month, week, color, number, checkbox, radio, select." do
    attr(:class, :string, required: false)
  end

  slot(:error, required: false) do
    attr(:class, :string, required: false)
  end

  def native_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    name = if assigns.multiple, do: field.name <> "[]", else: field.name

    assigns
    |> Corex.FormField.assign_form_field(field)
    |> assign(id: assigns[:id] || field.id)
    |> assign(:name, name)
    |> assign_new(:value, fn -> field.value end)
    |> assign_read_only()
    |> native_input()
  end

  @types_ignoring_icon ~W(textarea date datetime-local time month week color number checkbox radio select)

  def native_input(%{type: "checkbox"} = assigns) do
    assigns =
      assigns
      |> assign_read_only()
      |> assign_new(:id, fn -> "native-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:checked, fn ->
        Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div id={@id} class={corex_style_class(assigns)} data-invalid={@invalid && ""}>
      <div data-scope="native-input" data-part="root" data-readonly={@read_only && ""}>
        <div data-scope="native-input" data-part="control">
          <input
            type="hidden"
            name={@name}
            value="false"
            disabled={@rest[:disabled]}
          />
          <label data-scope="native-input" data-part="label" for={"#{@id}-input"}>
            <input
              type="checkbox"
              id={"#{@id}-input"}
              name={@name}
              value="true"
              checked={@checked}
              data-scope="native-input"
              data-part="input"
              data-invalid={@invalid && ""}
              {@rest}
            />
            <span :for={label <- @label}>{render_slot(label)}</span>
          </label>
        </div>
      </div>
      <div :for={msg <- @errors} class={error_wrapper_class(@error)} data-scope="native-input" data-part="error">
        <%= if @error != [] do %>
          {render_slot(@error, msg)}
        <% else %>
          {msg}
        <% end %>
      </div>
    </div>
    """
  end

  def native_input(%{type: "select"} = assigns) do
    assigns =
      assigns
      |> assign_read_only()
      |> assign_new(:id, fn -> "native-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:value, fn -> nil end)

    ~H"""
    <div id={@id} class={corex_style_class(assigns)} data-invalid={@invalid && ""}>
      <div data-scope="native-input" data-part="root" data-readonly={@read_only && ""}>
        <label :for={label <- @label} data-scope="native-input" data-part="label" for={"#{@id}-input"}>
          {render_slot(label)}
        </label>
        <div data-scope="native-input" data-part="control">
          <select
            id={"#{@id}-input"}
            name={@name}
            multiple={@multiple}
            data-scope="native-input"
            data-part="input"
            data-invalid={@invalid && ""}
            {@rest}
          >
            <option :if={@prompt} value="">{@prompt}</option>
            {Phoenix.HTML.Form.options_for_select(@options || [], @value)}
          </select>
        </div>
      </div>
      <div :for={msg <- @errors} class={error_wrapper_class(@error)} data-scope="native-input" data-part="error">
        <%= if @error != [] do %>
          {render_slot(@error, msg)}
        <% else %>
          {msg}
        <% end %>
      </div>
    </div>
    """
  end

  def native_input(%{type: "radio"} = assigns) do
    assigns =
      assigns
      |> assign_read_only()
      |> assign_new(:id, fn -> "native-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:value, fn -> nil end)
      |> assign(:options, assigns[:options] || [])

    ~H"""
    <div id={@id} class={corex_style_class(assigns)} data-invalid={@invalid && ""}>
      <div data-scope="native-input" data-part="root" data-readonly={@read_only && ""}>
        <label :for={label <- @label} data-scope="native-input" data-part="label">
          {render_slot(label)}
        </label>
        <div data-scope="native-input" data-part="control" data-has-items>
          <div :for={{opt_label, opt_value} <- @options} data-scope="native-input" data-part="item">
            <input
              type="radio"
              id={"#{@id}-input-#{opt_value}"}
              name={@name}
              value={opt_value}
              checked={to_string(@value || "") == to_string(opt_value)}
              data-scope="native-input"
              data-part="input"
              data-invalid={@invalid && ""}
              {@rest}
            />
            <label for={"#{@id}-input-#{opt_value}"} data-invalid={@invalid && ""}>{opt_label}</label>
          </div>
        </div>
      </div>
      <div :for={msg <- @errors} class={error_wrapper_class(@error)} data-scope="native-input" data-part="error">
        <%= if @error != [] do %>
          {render_slot(@error, msg)}
        <% else %>
          {msg}
        <% end %>
      </div>
    </div>
    """
  end

  def native_input(assigns) do
    assigns =
      assigns
      |> assign_read_only()
      |> assign_new(:id, fn -> "native-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:value, fn -> nil end)
      |> assign(:show_icon, show_icon?(assigns))

    ~H"""
    <div id={@id} class={corex_style_class(assigns)} data-no-icon={if @show_icon, do: nil, else: ""} data-invalid={@invalid && ""}>
      <div data-scope="native-input" data-part="root" data-readonly={@read_only && ""}>
        <label :for={label <- @label} class={Map.get(label, :class, nil)} data-scope="native-input" data-part="label" for={"#{@id}-input"}>
          {render_slot(label)}
        </label>
        <div data-scope="native-input" data-part="control">
          <span :if={@show_icon} :for={icon <- @icon} class={Map.get(icon, :class, nil)} data-scope="native-input" data-part="icon">
            {render_slot(icon)}
          </span>
          <textarea
            :if={@type == "textarea"}
            id={"#{@id}-input"}
            name={@name}
            data-scope="native-input"
            data-part="input"
            data-invalid={@invalid && ""}
            {@rest}
          >{Phoenix.HTML.Form.normalize_value("textarea", @value)}</textarea>
          <input
            :if={@type != "textarea"}
            type={@type}
            id={"#{@id}-input"}
            name={@name}
            value={Phoenix.HTML.Form.normalize_value(@type, @value)}
            data-scope="native-input"
            data-part="input"
            data-invalid={@invalid && ""}
            {@rest}
          />
        </div>
      </div>
      <div :for={msg <- @errors} class={error_wrapper_class(@error)} data-scope="native-input" data-part="error">
        <%= if @error != [] do %>
          {render_slot(@error, msg)}
        <% else %>
          {msg}
        <% end %>
      </div>
    </div>
    """
  end

  defp assign_read_only(assigns) do
    read_only =
      assigns[:read_only] == true ||
        assigns.rest[:readonly] == true ||
        assigns.rest[:readonly] == "readonly"

    rest =
      if read_only do
        Map.put(assigns.rest, :readonly, true)
      else
        assigns.rest
      end

    assign(assigns, read_only: read_only, rest: rest)
  end

  defp error_wrapper_class(error_slot) do
    case List.first(List.wrap(error_slot)) do
      m when is_map(m) ->
        m
        |> Map.new(fn {k, v} -> {to_string(k), v} end)
        |> Map.get("class")

      _ ->
        nil
    end
  end

  defp show_icon?(%{type: type, icon: icon}) do
    icon != [] and type not in @types_ignoring_icon
  end
end
