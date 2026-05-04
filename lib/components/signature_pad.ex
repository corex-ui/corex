defmodule Corex.SignaturePad do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Signature Pad](https://zagjs.com/components/react/signature-pad).

  ## Examples

  <!-- tabs-open -->

  ### Basic Usage

  ```heex
  <.signature_pad id="my-signature-pad" class="signature-pad">
    <:label>Sign here</:label>
    <:clear_trigger>
      <.heroicon name="hero-x-mark" />
    </:clear_trigger>
  </.signature_pad>
  ```

  ### With Callback

  ```heex
  <.signature_pad
    id="my-signature-pad"
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
    id="my-signature-pad"
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

  ## Phoenix Form Integration

  When using with Phoenix forms, set the form `id` in `to_form/2` (for example `to_form(changeset, as: :name, id: "my-form")`) and use `id={@form.id}` on `<.form>`. For `phx-change` and `used_input?/1`, set `phx-change` on `<.form>` so the whole form is sent (not on a single input only).

  The value field is a `type="text"` input with the HTML `hidden` attribute (Zag’s pattern), not a `type="hidden"` control, so the LiveView client can mark it “used” like a normal text field. The hook re-applies the same `phxPrivate` usage metadata LiveView stores on that input after draws, clear, and after server patches, so a morph of the value input does not drop “used” state and `used_input?/1` on the server matches expected behaviour.

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
  <.form :let={f} for={@form} id={@form.id} action={@action} method="post">
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
      <.form for={@form} id={@form.id} phx-change="validate">
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

  ## API Control

  In order to use the API, you must use an id on the component

  ***Client-side***

  ```heex
  <button phx-click={Corex.SignaturePad.clear("my-signature-pad")}>
    Clear Signature
  </button>
  ```

  ***Server-side***

  ```elixir
  def handle_event("clear_signature", _, socket) do
    {:noreply, Corex.SignaturePad.clear(socket, "my-signature-pad")}
  end
  ```

  ## Styling

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

  You can then use modifiers

  ```heex
  <.signature_pad class="signature-pad signature-pad--accent signature-pad--lg">
  ```

  '''

  @doc type: :component
  use Phoenix.Component

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
    doc: "The fill color for drawing strokes"
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
    default: "ltr",
    values: ["ltr", "rtl"],
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
    errors = signature_pad_field_errors(field) |> Enum.map(&Corex.Gettext.translate_error/1)

    paths_value =
      case field.value do
        nil -> []
        "" -> []
        value when is_list(value) -> Enum.filter(value, &is_binary/1)
        value when is_binary(value) -> path_d_strings(value)
        _ -> []
      end

    assigns =
      assigns
      |> assign(field: nil)
      |> assign(:errors, errors)
      |> assign_new(:id, fn -> field.id end)
      |> assign_new(:name, fn -> field.name end)
      |> assign_new(:form, fn -> field.form.id end)
      |> assign(:paths, paths_value)

    signature_pad(assigns)
  end

  def signature_pad(assigns) do
    assigns =
      assigns
      |> then(fn a -> assign(a, :paths, paths_from_paths_attr(a[:paths])) end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:id, fn -> "signature-pad-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> "name-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div
      id={@id}
      phx-hook="SignaturePad"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])} 
      {@rest}
      {Connect.props(%Props{
        id: @id,
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
        name: @name
      })}
    >
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir})} {Connect.root(%Root{id: @id, dir: @dir})}>
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
          value={hidden_input_value(@paths)}
          phx-mounted={Connect.ignore_hidden_input(%HiddenInput{id: @id, dir: @dir, name: @name, form: @form})}
          {Connect.hidden_input(%HiddenInput{id: @id, dir: @dir, name: @name, form: @form})}
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

  @doc type: :api
  @doc """
  Clears the signature pad from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.SignaturePad.clear("my-signature-pad")}>
        Clear
      </button>
  """
  def clear(signature_pad_id) when is_binary(signature_pad_id) do
    JS.dispatch("corex:signature-pad:clear",
      to: "##{signature_pad_id}",
      detail: %{id: signature_pad_id},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Clears the signature pad from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("clear_signature", _params, socket) do
        {:noreply, Corex.SignaturePad.clear(socket, "my-signature-pad")}
      end
  """
  def clear(socket, signature_pad_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(signature_pad_id) do
    LiveView.push_event(socket, "signature_pad_clear", %{
      signature_pad_id: signature_pad_id
    })
  end

  defp signature_pad_field_errors(%Phoenix.HTML.FormField{} = field) do
    if Phoenix.Component.used_input?(field), do: field.errors, else: []
  end

  defp paths_from_paths_attr(nil), do: []
  defp paths_from_paths_attr(paths) when is_list(paths), do: Enum.filter(paths, &is_binary/1)
  defp paths_from_paths_attr(paths) when is_binary(paths), do: path_d_strings(paths)
  defp paths_from_paths_attr(_), do: []

  defp has_paths?([]), do: false
  defp has_paths?(paths) when is_list(paths), do: paths != []
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
