defmodule Corex.DataList do
  @moduledoc ~S'''
  Phoenix component for rendering semantic data lists.

  ## Examples

  <!-- tabs-open -->

  ### Basic

  Pass items directly as slots. The `:item` slot requires a `title` attribute;
  the inner block renders as the value.

  ```heex
  <.data_list>
    <:item title="Name">Marie Curie</:item>
    <:item title="Field">Physics</:item>
    <:item title="Born">1867</:item>
  </.data_list>
  ```

  ### Items List

  Pass a list of `%Corex.DataList.Item{}` structs. The component renders title and value
  using the default `dt`/`dd` structure.

  ```heex
  <.data_list items={Corex.DataList.Item.new([
    %{title: "Name", value: "Marie Curie"},
    %{title: "Field", value: "Physics"},
    %{title: "Born", value: "1867"}
  ])} />
  ```

  ### Custom Items

  Combine both slots for full control over the content, while the component
  still owns the `dt`/`dd` structure and `data-scope` attributes.

  ```heex
  <.data_list items={Corex.DataList.Item.new([
    %{title: "Status", value: "Active", meta: %{color: "green", icon: "hero-check"}},
    %{title: "Role", value: "Admin", meta: %{color: "blue", icon: "hero-shield-check"}}
  ])}>
    <:title :let={item}>
      <.icon name={item.meta.icon} />{item.title}
    </:title>
    <:value :let={item}>
      <.badge color={item.meta.color}>{item.value}</.badge>
    </:value>
  </.data_list>
  ```

  <!-- tabs-close -->

  ## Styling

  ```css
  [data-scope="data-list"][data-part="root"] {}
  [data-scope="data-list"][data-part="item"] {}
  [data-scope="data-list"][data-part="title"] {}
  [data-scope="data-list"][data-part="value"] {}
  ```
  '''

  @doc type: :component

  use Phoenix.Component

  @doc """
  Renders a semantic data list.

  ## Examples

    <!-- tabs-open -->

  ### Basic

  Pass items directly as slots. The `:item` slot requires a `title` attribute;
  the inner block renders as the value.

  ```heex
  <.data_list>
    <:item title="Name">Marie Curie</:item>
    <:item title="Field">Physics</:item>
    <:item title="Born">1867</:item>
  </.data_list>
  ```

  ### Items List

  Pass a list of `%Corex.DataList.Item{}` structs. The component renders title and value
  using the default `dt`/`dd` structure.

  ```heex
  <.data_list items={Corex.DataList.Item.new([
    %{title: "Name", value: "Marie Curie"},
    %{title: "Field", value: "Physics"},
    %{title: "Born", value: "1867"}
  ])} />
  ```

  ### Custom Items

  Combine both slots for full control over the content, while the component
  still owns the `dt`/`dd` structure and `data-scope` attributes.

  ```heex
  <.data_list items={Corex.DataList.Item.new([
    %{title: "Status", value: "Active", meta: %{color: "green", icon: "hero-check"}},
    %{title: "Role", value: "Admin", meta: %{color: "blue", icon: "hero-shield-check"}}
  ])}>
    <:title :let={item}>
      <.icon name={item.meta.icon} />{item.title}
    </:title>
    <:value :let={item}>
      <.badge color={item.meta.color}>{item.value}</.badge>
    </:value>
  </.data_list>
  ```

  <!-- tabs-close -->
  """

  attr(:items, :list, default: nil, doc: "List of %Corex.DataList.Item{} structs for the items API")
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

  slot :item,
    required: false,
    doc: "Slot API: each item with a required title attr and inner block as value" do
    attr(:title, :string, required: true)
    attr(:class, :string)
  end

  slot(:title,
    required: false,
    doc:
      "Items API: customize the title content. Use :let={item} to access the %Corex.DataList.Item{} struct."
  )

  slot(:value,
    required: false,
    doc:
      "Items API: customize the value content. Use :let={item} to access the %Corex.DataList.Item{} struct."
  )

  def data_list(assigns) do
    ~H"""
    <div {@rest}>
      <dl
        data-scope="data-list"
        data-part="root"
        data-orientation={@orientation}
        dir={@dir}
      >
        <div
          :for={item <- @item}
          class={item[:class]}
          data-scope="data-list"
          data-part="item"
        >
          <dt data-scope="data-list" data-part="title">{item.title}</dt>
          <dd data-scope="data-list" data-part="value">{render_slot(item)}</dd>
        </div>

        <div
          :for={entry <- @items || []}
          data-scope="data-list"
          data-part="item"
        >
          <dt data-scope="data-list" data-part="title">
            {if @title != [], do: render_slot(@title, entry), else: entry.title}
          </dt>
          <dd data-scope="data-list" data-part="value">
            {if @value != [], do: render_slot(@value, entry), else: entry.value}
          </dd>
        </div>
      </dl>
    </div>
    """
  end
end
