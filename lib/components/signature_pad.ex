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
      <.icon name="hero-x-mark" />
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
      <.icon name="hero-x-mark" />
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
      <.icon name="hero-x-mark" />
    </:clear_trigger>
  </.signature_pad>
  ```

  <!-- tabs-close -->

  ## Phoenix Form Integration

  When using with Phoenix forms, you must add an id to the form using the `Corex.Form.get_form_id/1` function.

  ### Controller

  ```elixir
  defmodule MyAppWeb.PageController do
    use MyAppWeb, :controller

    def home(conn, params) do
      form = Phoenix.Component.to_form(Map.get(params, "user", %{}), as: :user)
      render(conn, :home, form: form)
    end
  end
  ```

  ```heex
  <.form :let={f} as={:user} for={@form} id={get_form_id(@form)} method="get">
    <.signature_pad field={f[:signature]} id="my-signature-pad" class="signature-pad">
      <:label>Sign here</:label>
      <:clear_trigger>
        <.icon name="hero-x-mark" />
      </:clear_trigger>
      <:error :let={msg}>
        <.icon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.signature_pad>
    <button type="submit">Submit</button>
  </.form>
  ```

  ### Live View

  When using Phoenix form in a Live view you must also add controlled mode. This allows the Live view to be the source of truth and the component to be in sync accordingly.

  ```elixir
  defmodule MyAppWeb.SignaturePadLive do
    use MyAppWeb, :live_view

    def mount(_params, _session, socket) do
      form = to_form(%{"signature" => nil}, as: :user)
      {:ok, assign(socket, :form, form)}
    end

    def render(assigns) do
      ~H"""
      <.form as={:user} for={@form} id={get_form_id(@form)}>
        <.signature_pad
          field={@form[:signature]}
          id="my-signature-pad"
          class="signature-pad"
          controlled
        >
          <:label>Sign here</:label>
          <:clear_trigger>
            <.icon name="hero-x-mark" />
          </:clear_trigger>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.signature_pad>
        <button type="submit">Submit</button>
      </.form>
      """
    end
  end
  ```

  ### With Ecto changeset

  When using Ecto changeset for validation and inside a Live view you must enable the controlled mode.

  This allows the Live View to be the source of truth and the component to be in sync accordingly.

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
      <.form for={@form} id={get_form_id(@form)} phx-change="validate">
        <.signature_pad
          field={@form[:signature]}
          id="my-signature-pad"
          class="signature-pad"
          controlled
        >
          <:label>Sign here</:label>
          <:clear_trigger>
            <.icon name="hero-x-mark" />
          </:clear_trigger>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
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
  This requires to install mix corex.design first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/signature-pad.css";
  ```

  You can then use modifiers

  ```heex
  <.signature_pad class="signature-pad signature-pad--accent signature-pad--lg">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/signature-pad#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.SignaturePad.Anatomy.{
    Props,
    Root,
    Label,
    Control,
    Segment,
    Guide,
    ClearTrigger,
    HiddenInput
  }

  alias Corex.SignaturePad.Connect

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

  attr(:controlled, :boolean,
    default: false,
    doc: "Whether the signature pad is controlled"
  )

  attr(:paths, :any,
    default: nil,
    doc:
      "The initial paths or the controlled paths of the signature pad. Can be a list or a JSON string."
  )

  attr(:name, :string, doc: "The name of the signature pad input for form submission")

  attr(:errors, :list,
    default: [],
    doc: "List of error messages to display"
  )

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field struct retrieved from the form, for example: @form[:signature]. Automatically sets id, name, value, and errors from the form field"
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
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    paths_value =
      case field.value do
        nil -> nil
        "" -> nil
        value when is_binary(value) -> value
        value when is_list(value) -> Corex.Json.encode!(value)
        _ -> nil
      end

    assigns =
      assigns
      |> assign(field: nil)
      |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
      |> assign_new(:id, fn -> field.id end)
      |> assign_new(:name, fn -> field.name end)
      |> assign(:paths, paths_value)

    signature_pad(assigns)
  end

  def signature_pad(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "signature-pad-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> "name-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div
      id={@id}
      phx-hook="SignaturePad"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
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
      <div {Connect.root(%Root{id: @id, dir: @dir})}>
        <label :if={@label != []} {Connect.label(%Label{id: @id, dir: @dir})}>
          {render_slot(@label)}
        </label>
        <div {Connect.control(%Control{id: @id, dir: @dir})}>
          <svg {Connect.segment(%Segment{id: @id, dir: @dir})}>
          </svg>
          <button
            :if={@clear_trigger != []}
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
          <div {Connect.guide(%Guide{id: @id, dir: @dir})} />
        </div>
        <input {Connect.hidden_input(%HiddenInput{id: @id, dir: @dir, name: @name})} />
        <div :if={!Enum.empty?(@errors)} :for={msg <- @errors} data-scope="signature-pad" data-part="error">
          {render_slot(@error, msg)}
        </div>
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
    Phoenix.LiveView.JS.dispatch("phx:signature-pad:clear",
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
    Phoenix.LiveView.push_event(socket, "signature_pad_clear", %{
      signature_pad_id: signature_pad_id
    })
  end

  defp has_paths?(nil), do: false
  defp has_paths?(""), do: false
  defp has_paths?(paths) when is_list(paths), do: paths != []

  defp has_paths?(paths) when is_binary(paths) do
    case Corex.Json.encoder().decode(paths) do
      {:ok, list} when is_list(list) -> list != []
      _ -> false
    end
  end

  defp has_paths?(_), do: false
end
