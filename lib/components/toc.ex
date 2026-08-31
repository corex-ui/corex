defmodule Corex.Toc do
  @moduledoc ~S'''
  Toc for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/tree-view).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.toc class="toc" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.toc>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="toc_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.toc class="toc" />
    ```

    ```elixir
    def handle_event("toc_changed", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="toc-changed"` | Value changes | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="toc"`.

    ```css
    [data-scope="toc"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Size**, **Radius**. No variant axis. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `toc` |
  | Accent | `toc ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Toc.Anatomy.{Props, Root}
  alias Corex.Toc.Connect

  @spec default_items() :: list()
  def default_items do
    [
      %{value: "intro", depth: 2},
      %{value: "install", depth: 2},
      %{value: "usage", depth: 3},
      %{value: "api", depth: 2},
      %{value: "a11y", depth: 2}
    ]
  end

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:items, :list, default: nil)
  attr(:scroll_el, :string, default: nil)

  attr(:rest, :global)

  def toc(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "toc")
    items = assigns.items || default_items()
    assigns = assign(assigns, :toc_items, items)

    ~H"""
    <div
      id={@id}
      phx-hook="Toc"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        items: @toc_items,
        scroll_el: @scroll_el,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <nav {Connect.mounted_root(%Root{id: @id, dir: @dir})}>
        <p data-scope="toc" data-part="title">On this page</p>
        <div data-scope="toc" data-part="indicator"></div>
        <ul data-scope="toc" data-part="list">
          <li
            :for={item <- @toc_items}
            data-scope="toc"
            data-part="item"
            data-value={item.value}
            data-depth={item.depth}
          >
            <a
              data-scope="toc"
              data-part="link"
              data-value={item.value}
              data-depth={item.depth}
              href={"##{item.value}"}
            >
              {toc_label(item)}
            </a>
          </li>
        </ul>
      </nav>
    </div>
    """
  end

  defp toc_label(%{label: label}) when is_binary(label), do: label
  defp toc_label(%{value: "intro"}), do: "Introduction"
  defp toc_label(%{value: "install"}), do: "Install"
  defp toc_label(%{value: "usage"}), do: "Usage"
  defp toc_label(%{value: "api"}), do: "API"
  defp toc_label(%{value: "a11y"}), do: "Accessibility"
  defp toc_label(%{value: value}), do: value
end
