defmodule Corex.Steps do
  @moduledoc ~S'''
  Steps for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/steps).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.steps class="steps">
      <:content index={0}>Create your account. We’ll use this email for billing and product updates.</:content>
      <:content index={1}>Name your workspace so projects, tokens, and members stay grouped.</:content>
      <:content index={2}>Review the details, then continue. Invite teammates from settings anytime.</:content>
    </.steps>
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

  alias Corex.Steps.Anatomy.{Content, List, Props, Root, Trigger}
  alias Corex.Steps.Connect

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_step_change, :string, default: nil)
  attr(:on_step_change_client, :string, default: nil)
  attr(:count, :integer, default: 3)
  attr(:step, :integer, default: 0)
  attr(:linear, :boolean, default: false)
  attr(:orientation, :string, default: "horizontal", values: ["horizontal", "vertical"])

  slot :content, required: false do
    attr(:index, :integer, required: false)
  end

  attr(:rest, :global)

  def steps(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "steps")
    contents = Map.new(assigns.content, fn s -> {s[:index], s} end)
    assigns = assign(assigns, :content_by_index, contents)

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
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir})} data-orientation={@orientation}>
        <div {Connect.mounted_list(%List{id: @id, dir: @dir, orientation: @orientation})}>
          <div
            :for={i <- 0..(@count - 1)}
            data-scope="steps"
            data-part="item"
            data-index={i}
            data-orientation={@orientation}
          >
            <button {Connect.mounted_trigger(%Trigger{id: @id, dir: @dir, index: i})}>
              <span data-scope="steps" data-part="indicator" data-index={i}>{i + 1}</span>
              {step_title(i)}
            </button>
            <div
              :if={i < @count - 1}
              data-scope="steps"
              data-part="separator"
              data-index={i}
              data-orientation={@orientation}
            >
            </div>
          </div>
        </div>
        <div
          :for={i <- 0..(@count - 1)}
          {Connect.mounted_content(%Content{id: @id, dir: @dir, index: i, step: @step})}
        >
          <%= if slot = @content_by_index[i] do %>
            {render_slot(slot)}
          <% else %>
            {step_copy(i)}
          <% end %>
        </div>
        <div data-scope="steps" data-part="actions">
          <button data-scope="steps" data-part="prev-trigger" type="button">Back</button>
          <button data-scope="steps" data-part="next-trigger" type="button">Continue</button>
        </div>
      </div>
    </div>
    """
  end

  defp step_title(0), do: "Account"
  defp step_title(1), do: "Workspace"
  defp step_title(2), do: "Review"
  defp step_title(i), do: "Step #{i + 1}"

  defp step_copy(0),
    do: "Create your account. We’ll use this email for billing and product updates."

  defp step_copy(1),
    do: "Name your workspace so projects, tokens, and members stay grouped."

  defp step_copy(2),
    do: "Review the details, then continue. Invite teammates from settings anytime."

  defp step_copy(i), do: "Step #{i + 1}"
end
