defmodule Corex.Steps do
  @moduledoc ~S'''
  Steps for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/steps).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.steps class="steps" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.steps>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_step_change="steps_changed"` | Step changes | `%{"id" => id, "step" => step}` |

  <!-- tabs-open -->

  ### on_step_change

    ```heex
    <.steps class="steps" />
    ```

    ```elixir
    def handle_event("steps_changed", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_step_change_client="steps-changed"` | Step changes | `id`, `step` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="steps"`.

    ```css
    [data-scope="steps"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Size**, **Radius**. No variant axis. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `steps` |
  | Accent | `steps ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Steps.Anatomy.{Props, Root}
  alias Corex.Steps.Connect

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_step_change, :string, default: nil)
  attr(:on_step_change_client, :string, default: nil)
  attr(:count, :integer, default: 3)
  attr(:step, :integer, default: 0)
  attr(:linear, :boolean, default: false)
  attr(:orientation, :string, default: "horizontal", values: ["horizontal", "vertical"])

  attr(:rest, :global)

  def steps(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "steps")

    ~H"""
    <div
      id={@id}
      phx-hook="Steps"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        count: @count,
        step: @step,
        linear: @linear,
        orientation: @orientation,
        on_step_change: @on_step_change,
        on_step_change_client: @on_step_change_client
      })}
    >
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir})}>
        <div data-scope="steps" data-part="list">
          <div :for={i <- 0..(@count - 1)} data-scope="steps" data-part="item" data-index={i}>
            <button type="button" data-scope="steps" data-part="trigger" data-index={i}>
              <span data-scope="steps" data-part="indicator" data-index={i}>{i + 1}</span>
              Step {i + 1}
            </button>
            <div :if={i < @count - 1} data-scope="steps" data-part="separator" data-index={i}></div>
          </div>
        </div>
        <div :for={i <- 0..(@count - 1)} data-scope="steps" data-part="content" data-index={i}>
          Step {i + 1}
        </div>
        <button data-scope="steps" data-part="prev-trigger" type="button">Back</button>
        <button data-scope="steps" data-part="next-trigger" type="button">Next</button>
      </div>
    </div>
    """
  end
end
