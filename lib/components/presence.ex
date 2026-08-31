defmodule Corex.Presence do
  @moduledoc ~S'''
  Presence for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/presence).
  Additive mount/unmount primitive (`setNode`, `on_exit_complete`). It does not replace existing `data-state` animation on dialog or collapsible.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.action phx-click={Corex.Presence.set_present("presence-anatomy-minimal", true)} class="button ui-size-sm">Show</.action>
    <.action phx-click={Corex.Presence.set_present("presence-anatomy-minimal", false)} class="button ui-size-sm">Hide</.action>
    <.presence id="presence-anatomy-minimal" class="presence">
      Panel that animates in and out
    </.presence>
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.presence>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_exit_complete="presence_exited"` | Exit animation finishes | `%{"id" => id}` |

  <!-- tabs-open -->

  ### on_exit_complete

    ```heex
    <.presence class="presence" />
    ```

    ```elixir
    def handle_event("presence_exited", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_exit_complete_client="presence-exited"` | Exit animation finishes | `id` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="presence"`.

    ```css
    [data-scope="presence"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Size**, **Radius**. No variant axis. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `presence` |
  | Accent | `presence ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Presence.Anatomy.{Props, Root}
  alias Corex.Presence.Connect
  alias Corex.Selectors
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_exit_complete, :string, default: nil)
  attr(:on_exit_complete_client, :string, default: nil)
  attr(:present, :boolean, default: true)
  slot(:inner_block, required: false)

  attr(:rest, :global)

  def presence(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "presence")

    ~H"""
    <div
      id={@id}
      phx-hook="Presence"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        present: @present,
        on_exit_complete: @on_exit_complete,
        on_exit_complete_client: @on_exit_complete_client
      })}
    >
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir})} data-state={if(@present, do: "open", else: "closed")}>
        {if @inner_block != [], do: render_slot(@inner_block), else: "Present"}
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Toggle presence from a control (`phx-click`). The trigger lives outside the wrapper.
  """)

  @spec set_present(String.t(), boolean()) :: Phoenix.LiveView.JS.t()
  @spec set_present(Phoenix.LiveView.Socket.t(), String.t(), boolean()) ::
          Phoenix.LiveView.Socket.t()
  def set_present(presence_id, present) when is_binary(presence_id) and is_boolean(present) do
    JS.dispatch("corex:presence:set-present",
      to: Selectors.css_id(presence_id),
      detail: %{present: present},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set present from `handle_event`.
  """)

  def set_present(socket, presence_id, present)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(presence_id) and
             is_boolean(present) do
    LiveView.push_event(socket, "presence_set_present", %{id: presence_id, present: present})
  end
end
