defmodule Corex.DataList do
  @moduledoc ~S'''
  Phoenix component for rendering semantic data lists.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  Pass a list of `%Corex.Content.Item{}` structs via `Corex.Content.new/1`.

  ```heex
  <.data_list
    items={
      Corex.Content.new([
        %{label: "Name", content: "Marie Curie"},
        %{label: "Field", content: "Physics"},
        %{label: "Born", content: "1867"}
      ])
    }
  />
  ```

  ### Manual slots

  With an empty `items` list, use `:label` and `:content` slots with a matching `value` on each pair.

  ```heex
  <.data_list>
    <:label value="lorem">Lorem ipsum dolor sit amet</:label>
    <:content value="lorem">Consectetur adipiscing elit.</:content>
    <:label value="duis">Duis dictum gravida odio ac pharetra?</:label>
    <:content value="duis">Nullam eget vestibulum ligula.</:content>
  </.data_list>
  ```

  ### Custom slots

  Combine `items` with `:label` and `:content` slots using `:let={item}` for custom markup.

  ```heex
  <.data_list
    items={
      Corex.Content.new([
        %{value: "status", label: "Status", content: "Active", meta: %{color: "green"}},
        %{value: "role", label: "Role", content: "Admin", meta: %{color: "blue"}}
      ])
    }
  >
    <:label :let={item}>{item.label}</:label>
    <:content :let={item}>{item.content}</:content>
  </.data_list>
  ```

  ### Empty

  Optional `<:empty>` when there are no rows. The empty block renders beside the `<dl>` (not inside it) and is hidden by CSS when items exist (stream-friendly).

  ```heex
  <.data_list items={[]}>
    <:empty>No entries</:empty>
  </.data_list>
  ```

  <!-- tabs-close -->

  ## Styling

  Style attrs and BEM classes are equivalent. See [Unstyled](unstyled.html). Axes: `size`.

  <!-- tabs-open -->

  ### With attributes

  ```heex
  <.data_list size="md" class="data-list" items={
    Corex.Content.new([
      %{label: "Name", content: "Marie Curie"},
      %{label: "Field", content: "Physics"}
    ])
  } />
  ```

  ### With classes

  ```heex
  <.data_list class="data-list data-list--size-md" items={
    Corex.Content.new([
      %{label: "Name", content: "Marie Curie"},
      %{label: "Field", content: "Physics"}
    ])
  } />
  ```

  <!-- tabs-close -->

  ## Stream

  Keep a plain list assign for `items` and update it alongside `stream_insert/3` or `stream/3` reset.
  Pass `items={Corex.Content.new(@items_list)}` to the component. Include `<:empty>` so an empty list shows the empty state without counting stream entries.

  ## Style

  Target parts with `data-scope` and `data-part`, or use [Corex Design](styled.html): `@import "./corex.tailwind.css"` in `app.css`.

  ```css
  [data-scope="data-list"][data-part="root"] {}
  [data-scope="data-list"][data-part="item"] {}
  [data-scope="data-list"][data-part="label"] {}
  [data-scope="data-list"][data-part="content"] {}
  [data-scope="data-list"][data-part="empty"] {}
  ```

  Stack modifiers on the host (`class` on `<.data_list>`).

  <!-- tabs-open -->

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `data-list data-list--size-sm` |
  | MD | `data-list data-list--size-md` |
  | LG | `data-list data-list--size-lg` |
  | XL | `data-list data-list--size-xl` |

  <!-- tabs-close -->
  '''

  @doc type: :component

  use Phoenix.Component

  use Corex.Variants,
    base: "data-list",
    axes: [
      width: :width,
      max_width: :max_width,
      height: :height,
      max_height: :max_height,
      size: :size
    ],
    defaults: [
      width: "full",
      max_width: "md",
      height: "auto",
      max_height: "none",
      size: "md"
    ]

  @doc """
  Renders a semantic data list.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.data_list
    items={
      Corex.Content.new([
        %{label: "Name", content: "Marie Curie"},
        %{label: "Field", content: "Physics"}
      ])
    }
  />
  ```

  ### Manual slots

  ```heex
  <.data_list class="data-list">
    <:label value="lorem">Lorem ipsum dolor sit amet</:label>
    <:content value="lorem">Consectetur adipiscing elit.</:content>
  </.data_list>
  ```

  ### Custom slots

  ```heex
  <.data_list class="data-list" items={Corex.Content.new([...])}>
    <:label :let={item}>{item.label}</:label>
    <:content :let={item}>{item.content}</:content>
  </.data_list>
  ```

  ### Empty

  ```heex
  <.data_list class="data-list" items={[]}>
    <:empty>No entries</:empty>
  </.data_list>
  ```

  <!-- tabs-close -->
  """

  attr(:items, :list,
    default: [],
    doc: "List of %Corex.Content.Item{} structs from Corex.Content.new/1"
  )

  attr(:rest, :global)

  attr(:orientation, :string,
    default: "vertical",
    values: ["vertical", "horizontal"],
    doc: "Layout orientation of items"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "Text direction"
  )

  slot :label,
    required: false,
    doc: "Manual: label slot with `value`. Custom: `:let={item}` with `items`." do
    attr(:value, :string)
    attr(:class, :string)
  end

  slot :content,
    required: false,
    doc: "Manual: content slot with `value`. Custom: `:let={item}` with `items`." do
    attr(:value, :string)
    attr(:class, :string)
  end

  slot(:empty, doc: "Optional content when the list has no rows")

  def data_list(assigns) do
    assigns =
      assigns
      |> assign(:items, assigns.items || [])
      |> data_list_assign_manual_mode!()
      |> then(fn a -> assign(a, :data_list_has_items, data_list_has_items?(a)) end)

    ~H"""
    <div class={corex_style_class(assigns)} {@rest}>
      <div
        :if={@empty != []}
        data-scope="data-list"
        data-part="empty"
      >
        {render_slot(@empty)}
      </div>
      <dl
        :if={@data_list_has_items}
        data-scope="data-list"
        data-part="root"
        data-orientation={@orientation}
        dir={@dir}
      >
        <div
          :if={@data_list_manual_mode}
          :for={panel <- @data_list_manual_panels}
          class={panel_label_class(panel)}
          data-scope="data-list"
          data-part="item"
        >
          <dt data-scope="data-list" data-part="label">
            {render_slot(panel.label)}
          </dt>
          <dd data-scope="data-list" data-part="content">
            {render_slot(panel.content)}
          </dd>
        </div>

        <div
          :if={!@data_list_manual_mode}
          :for={entry <- @items}
          data-scope="data-list"
          data-part="item"
        >
          <dt data-scope="data-list" data-part="label">
            {if @label != [], do: render_slot(@label, entry), else: entry.label}
          </dt>
          <dd data-scope="data-list" data-part="content">
            {if @content != [], do: render_slot(@content, entry), else: entry.content}
          </dd>
        </div>
      </dl>
    </div>
    """
  end

  defp data_list_assign_manual_mode!(assigns) do
    manual? = manual_data_list_mode?(assigns)

    if manual? and assigns.items != [] do
      raise ArgumentError,
            "DataList: use either items={Corex.Content.new([...])} or manual :label/:content slots, not both"
    end

    if not manual? and assigns.items != [] and manual_slot_entries?(assigns) do
      raise ArgumentError,
            "DataList: manual :label/:content slots with value require an empty items list; use :let={item} with items"
    end

    if manual? do
      panels =
        Corex.Slot.resolve_panels!(
          %{label: assigns.label, content: assigns.content},
          required: [:label, :content],
          component: "DataList"
        )

      assign(assigns, :data_list_manual_mode, true)
      |> assign(:data_list_manual_panels, panels)
    else
      assign(assigns, :data_list_manual_mode, false)
      |> assign(:data_list_manual_panels, [])
    end
  end

  defp manual_data_list_mode?(assigns) do
    Enum.empty?(assigns.items) and assigns.label != [] and assigns.content != []
  end

  defp manual_slot_entries?(assigns) do
    Enum.any?(assigns.label, &Map.get(&1, :value)) or
      Enum.any?(assigns.content, &Map.get(&1, :value))
  end

  defp data_list_has_items?(assigns) do
    (assigns.data_list_manual_mode and assigns.data_list_manual_panels != []) or
      (!assigns.data_list_manual_mode and assigns.items != [])
  end

  defp panel_label_class(%{label: label}) when is_map(label) do
    Map.get(label, :class)
  end

  defp panel_label_class(_), do: nil
end
