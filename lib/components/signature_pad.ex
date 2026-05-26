defmodule Corex.SignaturePad do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Signature Pad](https://zagjs.com/components/react/signature-pad).

  ## Anatomy

  <!-- tabs-open -->

  ### Basic Usage

  ```heex
  <.signature_pad class="signature-pad">
    <:label>Sign here</:label>
    <:clear_trigger>
      <.heroicon name="hero-x-mark" />
    </:clear_trigger>
  </.signature_pad>
  ```

  ### With Callback

  ```heex
  <.signature_pad
    on_draw_end="signature_drawn"
    class="signature-pad">
    <:label>Sign here</:label>
    <:clear_trigger>
      <.heroicon name="hero-x-mark" />
    </:clear_trigger>
  </.signature_pad>
  ```

  ```elixir
  def handle_event("signature_drawn", %{"paths" => paths}, socket) do
    {:noreply, put_flash(socket, :info, "Signature drawn with #{length(paths)} paths")}
  end
  ```

  ### Custom Drawing Options

  ```heex
  <.signature_pad
    drawing_fill="blue"
    drawing_size={3}
    drawing_simulate_pressure
    class="signature-pad">
    <:label>Sign here</:label>
    <:clear_trigger>
      <.heroicon name="hero-x-mark" />
    </:clear_trigger>
  </.signature_pad>
  ```

  <!-- tabs-close -->

  ## Form

  When using with Phoenix forms, set the form `id` in `to_form/2` (for example `to_form(changeset, as: :name, id: "my-form")`) and use `<.form for={@form}>`. For `phx-change` and `used_input?/1`, set `phx-change` on `<.form>` so the whole form is sent (not on a single input only).

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. Pass `invalid={Corex.FormField.invalid?(@form[:signature])}` when you want alert borders after validation.

  With `field={@form[:signature]}`, paths submit as `name="…[]"` hidden array inputs. On draw or clear, the hook updates those inputs and dispatches `input` so LiveView tracks the field. Errors render only when `Phoenix.Component.used_input?/1` is true for the field.

  ### Controller

  Build the form from an Ecto changeset:

  ```elixir
  def form_page(conn, _params) do
    form =
      %MyApp.Form.SignatureForm{}
      |> MyApp.Form.SignatureForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :signature_form, id: "signature-form")
    render(conn, :form_page, form: form)
  end
  ```

  ```heex
  <.form :let={f} for={@form} action={@action} method="post">
    <.signature_pad field={f[:signature]} class="signature-pad">
      <:label>Sign here</:label>
      <:clear_trigger>
        <.heroicon name="hero-x-mark" />
      </:clear_trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.signature_pad>
    <button type="submit">Submit</button>
  </.form>
  ```

  ### Live View

  Prefer building the form from an Ecto changeset (see "With Ecto changeset" below).

  ### With Ecto changeset

  First create your schema and changeset:

  ```elixir
  defmodule MyApp.Accounts.User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field :name, :string
      field :signature, :text
      timestamps(type: :utc_datetime)
    end

    def changeset(user, attrs) do
      user
      |> cast(attrs, [:name, :signature])
      |> validate_required([:name, :signature])
    end
  end
  ```

  ```elixir
  defmodule MyAppWeb.UserLive do
    use MyAppWeb, :live_view
    alias MyApp.Accounts.User

    def mount(_params, _session, socket) do
      {:ok, assign(socket, :form, to_form(User.changeset(%User{}, %{})))}
    end

    def handle_event("validate", %{"user" => user_params}, socket) do
      changeset = User.changeset(%User{}, user_params)
      {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
    end

    def render(assigns) do
      ~H"""
      <.form for={@form} phx-change="validate">
        <.signature_pad
          field={@form[:signature]}
          id="my-signature-pad"
          class="signature-pad"
        >
          <:label>Sign here</:label>
          <:clear_trigger>
            <.heroicon name="hero-x-mark" />
          </:clear_trigger>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.signature_pad>
      </.form>
      """
    end
  end
  ```

  ## API

  Requires a stable `id` on `<.signature_pad>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`clear/1`](#clear/1) | Clear canvas (client) | `%Phoenix.LiveView.JS{}` |
  | [`clear/2`](#clear/2) | Clear canvas (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.signature_pad>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_draw_end="signature_drawn"` | Stroke ends | `%{"id" => id, "paths" => paths}` |

  <!-- tabs-open -->

  ### on_draw_end

  ```heex
  <.signature_pad
    class="signature-pad"
    on_draw_end="signature_drawn"
  >
    <:label>Sign here</:label>
    <:clear_trigger>
      <.heroicon name="hero-x-mark" />
    </:clear_trigger>
  </.signature_pad>
  ```

  ```elixir
  def handle_event("signature_drawn", %{"id" => _id, "paths" => paths}, socket) do
    {:noreply, assign(socket, :path_count, length(paths))}
  end
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### LiveView sync

  Pass `paths` from a LiveView assign and handle `on_draw_end` so the server owns stroke data.

  ```heex
  <.signature_pad
    class="signature-pad"
    paths={@signature_paths}
    on_draw_end="signature_drawn"
  >
    <:label>Sign here</:label>
    <:clear_trigger>
      <.heroicon name="hero-x-mark" />
    </:clear_trigger>
  </.signature_pad>
  ```

  ```elixir
  def handle_event("signature_drawn", %{"paths" => paths}, socket) do
    {:noreply, assign(socket, :signature_paths, paths)}
  end
  ```

  <!-- tabs-close -->

  ## Style

  Use data attributes to target elements:

  ```css
  [data-scope="signature-pad"][data-part="root"] {}
  [data-scope="signature-pad"][data-part="label"] {}
  [data-scope="signature-pad"][data-part="control"] {}
  [data-scope="signature-pad"][data-part="segment"] {}
  [data-scope="signature-pad"][data-part="guide"] {}
  [data-scope="signature-pad"][data-part="clear-trigger"] {}
  [data-scope="signature-pad"][data-part="hidden-input"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `signature-pad` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/signature-pad.css";
  ```

  Drawing stroke color is set with the `drawing_fill` attribute (a CSS color value such as
  `var(--color-ink)` or `var(--color-accent)`). It is not controlled by root modifier classes.

  Trigger color, size, and corner radius use modifier classes on the root:

  ```heex
  <.signature_pad
    class="signature-pad signature-pad--accent signature-pad--lg signature-pad--rounded-xl"
    drawing_fill="var(--color-ink)"
  >
  ```

  | Modifier | Applies to |
  | -------- | ---------- |
  | `signature-pad--{accent,brand,alert,success,info}` | Clear trigger only |
  | `signature-pad--{sm,md,lg,xl}` | Label, control height, clear trigger |
  | `signature-pad--rounded-{none,sm,md,lg,xl,full}` | Control, pad surface, clear trigger |

  The guide line (`data-part="guide"`) is not themed by color modifiers.

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.SignaturePad.Anatomy.{
    ClearTrigger,
    Control,
    Error,
    Guide,
    HiddenInput,
    Label,
    Path,
    Props,
    Root,
    Segment
  }

  alias Corex.SignaturePad.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  @doc """
  Renders a signature pad component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the signature pad, useful for API to identify the signature pad"
  )

  attr(:drawing_fill, :string,
    default: "black",
    doc: "CSS color for drawing strokes (e.g. `var(--color-ink)` or `var(--color-accent)`)"
  )

  attr(:drawing_size, :integer,
    default: 2,
    doc: "The size/thickness of drawing strokes"
  )

  attr(:drawing_simulate_pressure, :boolean,
    default: false,
    doc: "Whether to simulate pressure for drawing strokes"
  )

  attr(:drawing_smoothing, :float,
    default: 0.9,
    doc: "Smoothing factor for drawing strokes (0–1, perfect-freehand option)"
  )

  attr(:drawing_easing, :string,
    default: nil,
    doc: "Easing function for drawing strokes (perfect-freehand option)"
  )

  attr(:drawing_thinning, :float,
    default: nil,
    doc: "Thinning factor for drawing strokes (perfect-freehand option)"
  )

  attr(:drawing_streamline, :float,
    default: 0.1,
    doc: "Streamline factor for drawing strokes (perfect-freehand option)"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the signature pad. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:on_draw_end, :string,
    default: nil,
    doc: "The server event name when drawing ends"
  )

  attr(:on_draw_end_client, :string,
    default: nil,
    doc: "The client event name when drawing ends"
  )

  attr(:paths, :any,
    default: nil,
    doc:
      "Initial stroke paths: a list of SVG d strings, or one string with lines separated by newline, sent as `data-default-paths` to the hook."
  )

  attr(:name, :string, doc: "The name of the signature pad input for form submission")

  attr(:errors, :list,
    default: [],
    doc: "List of error messages to display"
  )

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field from the form, e.g. @form[:signature]. Sets id, name, paths, and errors. Errors are filtered with `used_input?/1` (see the Phoenix Form Integration section)."
  )

  attr(:field_used, :boolean,
    default: false,
    doc: "Whether Phoenix considers the field used (internal; set from field=)"
  )

  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :clear_trigger, required: false do
    attr(:class, :string, required: false)

    attr(:aria_label, :string,
      doc:
        "Accessibility label for the clear button. Defaults to 'Clear signature' if not provided."
    )
  end

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  def signature_pad(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    paths_value =
      case field.value do
        nil -> []
        "" -> []
        value when is_list(value) -> Enum.filter(value, &is_binary/1)
        value when is_binary(value) -> path_d_strings(value)
        _ -> []
      end

    assigns
    |> Corex.FormField.assign_form_field(field)
    |> assign(:paths, paths_value)
    |> signature_pad()
  end

  def signature_pad(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "signature-pad-#{System.unique_integer([:positive])}" end)
      |> assign_new(:form_field, fn -> false end)
      |> then(fn a -> assign(a, :paths, paths_from_paths_attr(a[:paths])) end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:name, fn -> "name-#{System.unique_integer([:positive])}" end)
      |> assign_new(:field_used, fn -> false end)
      |> Corex.FormField.assign_list_submit()

    ~H"""
    <div
      id={@id}
      phx-hook="SignaturePad"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])} 
      {@rest}
      {Connect.props(%Props{
        id: @id,
        form_field: @form_field,
        field_used: @field_used,
        paths: @paths,
        drawing_fill: @drawing_fill,
        drawing_size: @drawing_size,
        drawing_simulate_pressure: @drawing_simulate_pressure,
        drawing_smoothing: @drawing_smoothing,
        drawing_easing: @drawing_easing,
        drawing_thinning: @drawing_thinning,
        drawing_streamline: @drawing_streamline,
        dir: @dir,
        on_draw_end: @on_draw_end,
        on_draw_end_client: @on_draw_end_client,
        name: @name,
        submit_name: @submit_name
      })}
    >
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir})} {Connect.root(%Root{id: @id, dir: @dir})}>
        <div
          :if={@submit_name}
          data-scope="signature-pad"
          data-part="array-inputs"
          phx-update="ignore"
          id={"signature-pad:#{@id}:array-inputs"}
        >
          <input
            :for={path <- @paths}
            type="hidden"
            data-scope="signature-pad"
            data-part="array-input"
            name={@submit_name}
            value={path}
          />
          <input
            :if={@paths == []}
            type="hidden"
            data-scope="signature-pad"
            data-part="array-input"
            data-empty
            name={if(@field_used, do: @submit_name)}
            value=""
          />
        </div>
        <label
          :if={@label != []}
          phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir})}
          {Connect.label(%Label{id: @id, dir: @dir})}
        >
          {render_slot(@label)}
        </label>
        <div phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir})} {Connect.control(%Control{id: @id, dir: @dir})}>
          <svg phx-mounted={Connect.ignore_segment(%Segment{id: @id, dir: @dir})} {Connect.segment(%Segment{id: @id, dir: @dir})} fill={@drawing_fill}>
            <path
              :for={{path, idx} <- Enum.with_index(@paths)}
              phx-mounted={Connect.ignore_path(%Path{id: @id, index: idx})}
              {Connect.path(%Path{id: @id, index: idx})}
              d={path}
            />
          </svg>
          <button
            :if={@clear_trigger != []}
            phx-mounted={Connect.ignore_clear_trigger(%ClearTrigger{
              id: @id,
              dir: @dir,
              has_paths: has_paths?(@paths),
              aria_label: case @clear_trigger do
                [entry | _] -> Map.get(entry, :aria_label)
                _ -> nil
              end
            })}
            {Connect.clear_trigger(%ClearTrigger{
              id: @id,
              dir: @dir,
              has_paths: has_paths?(@paths),
              aria_label: case @clear_trigger do
                [entry | _] -> Map.get(entry, :aria_label)
                _ -> nil
              end
            })}
          >
            {render_slot(@clear_trigger)}
          </button>
          <div phx-mounted={Connect.ignore_guide(%Guide{id: @id, dir: @dir})} {Connect.guide(%Guide{id: @id, dir: @dir})} />
        </div>
        <input
          value={if(@submit_name, do: "", else: hidden_input_value(@paths))}
          phx-mounted={Connect.ignore_hidden_input(%HiddenInput{id: @id, dir: @dir, name: @name, form: @form})}
          {Connect.hidden_input(%HiddenInput{id: @id, dir: @dir, name: if(@submit_name, do: nil, else: @name), form: @form})}
        />
      </div>
      <div
      :if={!Enum.empty?(@errors)}
      :for={{msg, idx} <- Enum.with_index(@errors)}
      phx-mounted={Connect.ignore_error(%Error{id: @id, index: idx})}
      {Connect.error(%Error{id: @id, index: idx})}
    >
      {render_slot(@error, msg)}
    </div>
    </div>
    """
  end

  api_doc(~S"""
  Clear all strokes from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.SignaturePad.clear("my-signature-pad")}>Clear</.action>
  <.signature_pad id="my-signature-pad" class="signature-pad">
    <:label>Sign</:label>
    <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
  </.signature_pad>
  ```

  ```javascript
  document.getElementById("my-signature-pad")?.dispatchEvent(
    new CustomEvent("corex:signature-pad:clear", {
      bubbles: false,
      detail: { id: "my-signature-pad" },
    })
  );
  ```
  """)

  def clear(signature_pad_id) when is_binary(signature_pad_id) do
    JS.dispatch("corex:signature-pad:clear",
      to: "##{signature_pad_id}",
      detail: %{id: signature_pad_id},
      bubbles: false
    )
  end

  api_doc(~S"""
  Clear strokes from `handle_event`.

  ```heex
  <.action phx-click="clear_sig">Clear</.action>
  <.signature_pad id="my-signature-pad" class="signature-pad">
    <:label>Sign</:label>
    <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
  </.signature_pad>
  ```

  ```elixir
  def handle_event("clear_sig", _, socket) do
    {:noreply, Corex.SignaturePad.clear(socket, "my-signature-pad")}
  end
  ```
  """)

  def clear(socket, signature_pad_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(signature_pad_id) do
    LiveView.push_event(socket, "signature_pad_clear", %{
      signature_pad_id: signature_pad_id
    })
  end

  defp paths_from_paths_attr(nil), do: []
  defp paths_from_paths_attr(paths) when is_list(paths), do: Enum.filter(paths, &is_binary/1)
  defp paths_from_paths_attr(paths) when is_binary(paths), do: path_d_strings(paths)
  defp paths_from_paths_attr(_), do: []

  defp has_paths?([]), do: false
  defp has_paths?(paths) when is_list(paths), do: true
  defp has_paths?(_), do: false

  defp hidden_input_value([]), do: ""
  defp hidden_input_value(paths) when is_list(paths), do: Enum.join(paths, "\n")

  defp path_d_strings(s) when is_binary(s) do
    s
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
