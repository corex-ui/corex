defmodule Corex.Tour do
  @moduledoc ~S'''
  Tour for Phoenix LiveView. Behavior follows [Zag.js Tour](https://zagjs.com/components/react/tour).

  The overlay is always closed on the server. Call `start/1` after JavaScript is
  available — there is no `open` attribute.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.action phx-click={Corex.Tour.start("tour-anatomy-minimal")} class="button">Start tour</.action>
    <button id="tour-target-nav" type="button" class="button ui-size-sm">Docs</button>
    <button id="tour-target-playground" type="button" class="button ui-size-sm">Playground</button>
    <.tour id="tour-anatomy-minimal" class="tour" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.tour>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`start/1`](#start/1) | Start the tour (client) | `%Phoenix.LiveView.JS{}` |
  | [`start/2`](#start/2) | Start the tour (server) | `socket` |

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_step_change="tour_step_changed"` | Step changes | `%{"id" => id, "value" => step_id, "step" => index}` |

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_step_change_client="tour-step-changed"` | Step changes | `id`, `value`, `step` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="tour"`.

    ```css
    [data-scope="tour"][data-part="content"] {}
    [data-scope="tour"][data-part="backdrop"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Selectors

  alias Corex.Tour.Anatomy.{
    Backdrop,
    CloseTrigger,
    Content,
    Description,
    Positioner,
    ProgressText,
    Props,
    Root,
    Spotlight,
    Title
  }

  alias Corex.Tour.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  @default_steps [
    %{
      "id" => "welcome",
      "type" => "dialog",
      "title" => "Welcome to Corex",
      "description" =>
        "This overlay stays closed on the server. Start it after JavaScript hydrates.",
      "actions" => [%{"label" => "Next", "action" => "next"}]
    },
    %{
      "id" => "docs",
      "type" => "tooltip",
      "title" => "Docs",
      "description" => "Open Anatomy, API, Events, and Style from the sidebar.",
      "target" => "#tour-target-nav",
      "actions" => [
        %{"label" => "Back", "action" => "prev"},
        %{"label" => "Next", "action" => "next"}
      ]
    },
    %{
      "id" => "playground",
      "type" => "tooltip",
      "title" => "Playground",
      "description" => "Try interactions live, then copy the anatomy into your app.",
      "target" => "#tour-target-playground",
      "actions" => [
        %{"label" => "Back", "action" => "prev"},
        %{"label" => "Next", "action" => "next"}
      ]
    },
    %{
      "id" => "done",
      "type" => "dialog",
      "title" => "You’re set",
      "description" => "That’s the tour. Close when you’re ready to explore.",
      "actions" => [%{"label" => "Finish", "action" => "dismiss"}]
    }
  ]

  @spec default_steps() :: list()
  def default_steps, do: @default_steps

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:steps, :list, default: nil)
  attr(:on_step_change, :string, default: nil)
  attr(:on_step_change_client, :string, default: nil)
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:rest, :global)

  def tour(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "tour")

    ~H"""
    <div
      id={@id}
      phx-hook="Tour"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        steps: @steps,
        on_step_change: @on_step_change || @on_value_change,
        on_step_change_client: @on_step_change_client || @on_value_change_client
      })}
    >
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir})}>
        <div {Connect.mounted_backdrop(%Backdrop{id: @id, dir: @dir})}></div>
        <div {Connect.mounted_spotlight(%Spotlight{id: @id, dir: @dir})}></div>
        <div {Connect.mounted_positioner(%Positioner{id: @id, dir: @dir})}>
          <div {Connect.mounted_content(%Content{id: @id, dir: @dir})}>
            <h3 {Connect.mounted_title(%Title{id: @id, dir: @dir})}></h3>
            <p {Connect.mounted_description(%Description{id: @id, dir: @dir})}></p>
            <p {Connect.mounted_progress_text(%ProgressText{id: @id, dir: @dir})}></p>
            <div data-scope="tour" data-part="actions"></div>
            <button {Connect.mounted_close_trigger(%CloseTrigger{id: @id, dir: @dir})} aria-label="Close">
              ×
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Start the tour from a control (`phx-click`) after JS is available.
  """)

  @spec start(String.t()) :: Phoenix.LiveView.JS.t()
  @spec start(Phoenix.LiveView.Socket.t(), String.t()) :: Phoenix.LiveView.Socket.t()
  def start(tour_id) when is_binary(tour_id) do
    JS.dispatch("corex:tour:start",
      to: Selectors.css_id(tour_id),
      detail: %{},
      bubbles: false
    )
  end

  api_doc(~S"""
  Start the tour from `handle_event`.
  """)

  def start(socket, tour_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tour_id) do
    LiveView.push_event(socket, "tour_start", %{id: tour_id})
  end
end
