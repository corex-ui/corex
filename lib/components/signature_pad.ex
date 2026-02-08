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
        <:clear_trigger>
      <.icon name="hero-x-mark" />
    </:clear_trigger>
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

  attr(:dir, :string,
    default: "ltr",
    values: ["ltr", "rtl"],
    doc: "The direction of the signature pad"
  )

  attr(:on_draw_end, :string,
    default: nil,
    doc: "The server event name when drawing ends"
  )

  attr(:on_draw_end_client, :string,
    default: nil,
    doc: "The client event name when drawing ends"
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

  def signature_pad(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "signature-pad-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div
      id={@id}
      phx-hook="SignaturePad"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        drawing_fill: @drawing_fill,
        drawing_size: @drawing_size,
        drawing_simulate_pressure: @drawing_simulate_pressure,
        dir: @dir,
        on_draw_end: @on_draw_end,
        on_draw_end_client: @on_draw_end_client
      })}
    >
      <div {Connect.root(%Root{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})}>
        <label :if={@label != []} {Connect.label(%Label{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})}>
          {render_slot(@label)}
        </label>
        <div {Connect.control(%Control{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})}>
          <svg {Connect.segment(%Segment{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})}>
          </svg>
          <button
            :if={@clear_trigger != []}
            {Connect.clear_trigger(%ClearTrigger{
              id: @id,
              dir: @dir,
              changed: Map.get(assigns, :__changed__, nil) != nil,
              aria_label: case @clear_trigger do
                [entry | _] -> Map.get(entry, :aria_label)
                _ -> nil
              end
            })}
          >
            {render_slot(@clear_trigger)}
          </button>
          <div {Connect.guide(%Guide{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})} />
        </div>
        <input {Connect.hidden_input(%HiddenInput{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})} />
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
end
