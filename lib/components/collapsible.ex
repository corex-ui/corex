defmodule Corex.Collapsible do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Collapsible](https://zagjs.com/components/react/collapsible).

  ## Examples

  <!-- tabs-open -->

  ### Basic Usage

  ```heex
  <.collapsible id="my-collapsible">
    <:trigger>Toggle Content</:trigger>
    <:content>
      This content can be collapsed and expanded.
    </:content>
  </.collapsible>
  ```

  ### Controlled Mode

  ```heex
  <.collapsible
    id="my-collapsible"
    controlled
    open={@collapsible_open}
    on_open_change="collapsible_changed">
    <:trigger>Toggle Content</:trigger>
    <:content>
      This content can be collapsed and expanded.
    </:content>
  </.collapsible>
  ```

  ```elixir
  def handle_event("collapsible_changed", %{"open" => open}, socket) do
    {:noreply, assign(socket, :collapsible_open, open)}
  end
  ```

  <!-- tabs-close -->

  ## API Control

  In order to use the API, you must use an id on the component

  ***Client-side***

  ```heex
  <button phx-click={Corex.Collapsible.set_open("my-collapsible", true)}>
    Open
  </button>
  ```

  ***Server-side***

  ```elixir
  def handle_event("open_collapsible", _, socket) do
    {:noreply, Corex.Collapsible.set_open(socket, "my-collapsible", true)}
  end
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="collapsible"][data-part="root"] {}
  [data-scope="collapsible"][data-part="trigger"] {}
  [data-scope="collapsible"][data-part="content"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `collapsible` on the component.
  This requires to install mix corex.design first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/collapsible.css";
  ```

  You can then use modifiers

  ```heex
  <.collapsible class="collapsible collapsible--accent collapsible--lg">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/collapsible#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Collapsible.Anatomy.{Props, Root, Trigger, Content}
  alias Corex.Collapsible.Connect

  @doc """
  Renders a collapsible component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the collapsible, useful for API to identify the collapsible"
  )

  attr(:open, :boolean,
    default: false,
    doc: "The initial open state or the controlled open state"
  )

  attr(:controlled, :boolean,
    default: false,
    doc:
      "Whether the collapsible is controlled. Only in LiveView, the on_open_change event is required"
  )

  attr(:disabled, :boolean,
    default: false,
    doc: "Whether the collapsible is disabled"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the collapsible. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:on_open_change, :string,
    default: nil,
    doc: "The server event name when the open state changes"
  )

  attr(:on_open_change_client, :string,
    default: nil,
    doc: "The client event name when the open state changes"
  )

  attr(:rest, :global)

  slot :trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :content, required: true do
    attr(:class, :string, required: false)
  end

  def collapsible(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "collapsible-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div
      id={@id}
      phx-hook="Collapsible"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        open: @open,
        disabled: @disabled,
        dir: @dir,
        on_open_change: @on_open_change,
        on_open_change_client: @on_open_change_client
      })}
    >
      <div {Connect.root(%Root{id: @id, dir: @dir, open: @open})}>
        <button {Connect.trigger(%Trigger{id: @id, dir: @dir, open: @open, disabled: @disabled})}>
          {render_slot(@trigger)}
        </button>
        <div {Connect.content(%Content{id: @id, dir: @dir, open: @open, disabled: @disabled})}>
          {render_slot(@content)}
        </div>
      </div>
    </div>
    """
  end

  @doc type: :api
  @doc """
  Sets the collapsible open state from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.Collapsible.set_open("my-collapsible", true)}>
        Open
      </button>
  """
  def set_open(collapsible_id, open) when is_binary(collapsible_id) and is_boolean(open) do
    Phoenix.LiveView.JS.dispatch("phx:collapsible:set-open",
      to: "##{collapsible_id}",
      detail: %{open: open},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the collapsible open state from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("open_collapsible", _params, socket) do
        socket = Corex.Collapsible.set_open(socket, "my-collapsible", true)
        {:noreply, socket}
      end
  """
  def set_open(socket, collapsible_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(collapsible_id) and
             is_boolean(open) do
    Phoenix.LiveView.push_event(socket, "collapsible_set_open", %{
      collapsible_id: collapsible_id,
      open: open
    })
  end
end
