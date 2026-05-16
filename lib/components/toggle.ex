defmodule Corex.Toggle do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Toggle](https://zagjs.com/components/react/toggle).

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.toggle id="bold-toggle" class="toggle">
    Bold
  </.toggle>
  ```

  ### With indicator

  ```heex
  <.toggle id="bold-toggle" class="toggle">
    <:indicator><.heroicon name="hero-bold" /></:indicator>
    Bold
  </.toggle>
  ```

  ### Controlled

  ```heex
  <.toggle id="t1" class="toggle" controlled pressed={@pressed} on_pressed_change="toggle_changed">
    Label
  </.toggle>
  ```

  ```elixir
  def handle_event("toggle_changed", %{"pressed" => pressed}, socket) do
    {:noreply, assign(socket, :pressed, pressed)}
  end
  ```

  <!-- tabs-close -->

  ## Programmatic control

  ```heex
  <button phx-click={Corex.Toggle.set_pressed("my-toggle", true)}>On</button>
  ```

  ```elixir
  def handle_event("on", _, socket) do
    {:noreply, Corex.Toggle.set_pressed(socket, "my-toggle", true)}
  end
  ```

  ## Styling

  ```css
  [data-scope="toggle"][data-part="root"] {}
  [data-scope="toggle"][data-part="indicator"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/toggle.css";
  ```

  ```heex
  <.toggle class="toggle toggle--accent toggle--sm">
  ```

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Toggle.Anatomy.{Indicator, Props, Root}
  alias Corex.Toggle.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)

  attr(:pressed, :boolean,
    default: false,
    doc: "Initial or controlled pressed state"
  )

  attr(:controlled, :boolean, default: false)
  attr(:disabled, :boolean, default: false)

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "When nil, derived from document"
  )

  attr(:on_pressed_change, :string, default: nil)
  attr(:on_pressed_change_client, :string, default: nil)

  attr(:rest, :global)

  slot :inner_block, required: false

  slot :indicator, required: false do
    attr(:class, :string, required: false)
  end

  def toggle(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "toggle-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)

    ~H"""
    <div
      id={@id}
      phx-hook="Toggle"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        pressed: @pressed,
        disabled: @disabled,
        dir: @dir,
        on_pressed_change: @on_pressed_change,
        on_pressed_change_client: @on_pressed_change_client
      })}
    >
      <button
        phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, pressed: @pressed, disabled: @disabled})}
        {Connect.root(%Root{id: @id, dir: @dir, pressed: @pressed, disabled: @disabled})}
      >
        <span
          :if={@indicator != []}
          class={Map.get(Enum.at(@indicator, 0), :class)}
          phx-mounted={Connect.ignore_indicator(%Indicator{id: @id, dir: @dir, pressed: @pressed, disabled: @disabled})}
          {Connect.indicator(%Indicator{id: @id, dir: @dir, pressed: @pressed, disabled: @disabled})}
        >
          {render_slot(@indicator)}
        </span>
        {render_slot(@inner_block)}
      </button>
    </div>
    """
  end

  @doc type: :api
  def set_pressed(toggle_id, pressed) when is_binary(toggle_id) and is_boolean(pressed) do
    JS.dispatch("corex:toggle:set-pressed",
      to: "##{toggle_id}",
      detail: %{pressed: pressed},
      bubbles: false
    )
  end

  def set_pressed(socket, toggle_id, pressed)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toggle_id) and is_boolean(pressed) do
    LiveView.push_event(socket, "toggle_set_pressed", %{
      id: toggle_id,
      pressed: pressed
    })
  end

  @doc type: :api
  def toggle_pressed(toggle_id) when is_binary(toggle_id) do
    JS.dispatch("corex:toggle:toggle-pressed",
      to: "##{toggle_id}",
      bubbles: false
    )
  end

  def toggle_pressed(socket, toggle_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toggle_id) do
    LiveView.push_event(socket, "toggle_toggle_pressed", %{id: toggle_id})
  end
end
