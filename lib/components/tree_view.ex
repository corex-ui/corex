defmodule Corex.TreeView do
  @moduledoc ~S'''
  Phoenix implementation of the [Zag.js Tree View](https://zagjs.com/components/react/tree-view).

  ## Anatomy

  Render from a list with `Corex.Tree.new/1`.

  <!-- tabs-open -->

  ### Basic

  Each item supports `:value`, `:label`, optional `:children`, `:to`, `:redirect`, `:new_tab`, `:disabled`.

  ```heex
  <.tree_view
    items={
      Corex.Tree.new([
        %{label: "Components", value: "components", children: [
          %{label: "Accordion", value: "accordion"},
          %{label: "Checkbox", value: "checkbox"},
          %{label: "Tree view", value: "tree-view"}
        ]},
        %{label: "Form", value: "form"},
        %{label: "Tree", value: "tree", children: [%{label: "Tree.Item", value: "tree-item"}]}
      ])
    }
  />
  ```

  ### With Label

  ```heex
  <.tree_view
    items={
      Corex.Tree.new([
        %{label: "Guides", value: "guides"},
        %{label: "Reference", value: "reference"}
      ])
    }
  >
    <:label>My Documents</:label>
  </.tree_view>
  ```

  ### With Indicator

  ```heex
  <.tree_view
    items={
      Corex.Tree.new([
        %{label: "src", value: "src", children: [
          %{label: "components", value: "components"},
          %{label: "index.ts", value: "index.ts"}
        ]},
        %{label: "README.md", value: "readme"}
      ])
    }
  >
    <:branch_indicator :let={item}>
      <.heroicon :if={item.children && item.children != []} name="hero-chevron-right" />
    </:branch_indicator>
    <:item_indicator>
      <.heroicon name="hero-check" />
    </:item_indicator>
  </.tree_view>
  ```

  <!-- tabs-close -->

  ### Custom slots

  ```heex
  <.tree_view
    items={
      Corex.Tree.new([
        %{label: "src", value: "src", children: [
          %{label: "components", value: "components", children: [%{label: "tree-view.tsx", value: "tree-view.tsx"}]},
          %{label: "main.ts", value: "main.ts"}
        ]},
        %{label: "README.md", value: "readme"}
      ])
    }
  >
    <:label>Project</:label>
    <:branch :let={item}>
      <.heroicon name="hero-folder" /> {item.label}
    </:branch>
    <:item :let={item}>
      <.heroicon name="hero-document" /> {item.label}
    </:item>
  </.tree_view>
  ```

  ### Compound

  Take full structural control with `tree_view_root`, `tree_view_branch`, and `tree_view_item`. Branches and items resolve their path from `ctx.items`.

  ```heex
  <.tree_view
    :let={ctx}
    compound
    items={
      Corex.Tree.new([
        %{label: "Components", value: "components", children: [
          %{label: "Accordion", value: "accordion"},
          %{label: "Checkbox", value: "checkbox"}
        ]},
        %{label: "Form", value: "form"}
      ])
    }
  >
    <.tree_view_root ctx={ctx}>
      <:label>Project</:label>
      <.tree_view_branch :let={branch} :for={item <- ctx.items} ctx={ctx} item={item}>
        <.tree_view_branch_trigger branch={branch}>
          {item.label}
          <:indicator>
            <.heroicon name="hero-chevron-right" />
          </:indicator>
        </.tree_view_branch_trigger>
        <.tree_view_branch_content branch={branch}>
          <.tree_view_item :for={child <- item.children || []} ctx={ctx} item={child}>
            {child.label}
          </.tree_view_item>
        </.tree_view_branch_content>
      </.tree_view_branch>
    </.tree_view_root>
  </.tree_view>
  ```

  `ctx` is a map with `:id`, `:dir`, `:animation`, `:items`, `:expanded_value`, `:value`, and an internal `:index_paths` map. Items referenced from `tree_view_branch` / `tree_view_item` must be present in `ctx.items` (they are resolved to their path).

  ## Styling

  Style attrs and BEM classes are equivalent. See [Unstyled](unstyled.html). Axes: `semantic`, `size`, `radius`.

  <!-- tabs-open -->

  ### With attributes

  ```heex
  <.tree_view semantic="accent" size="md" class="tree-view" items={
    Corex.Tree.new([
      %{label: "Guides", value: "guides"},
      %{label: "Reference", value: "reference"}
    ])
  } />
  ```

  ### With classes

  ```heex
  <.tree_view class="tree-view tree-view--semantic-accent tree-view--size-md" items={
    Corex.Tree.new([
      %{label: "Guides", value: "guides"},
      %{label: "Reference", value: "reference"}
    ])
  } />
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Initial expanded/selected

  `expanded_value` and `value` are lists of item values matching the tree.

  ```heex
  <.tree_view
    expanded_value={["src", "components"]}
    value={["tree-view.tsx"]}
    items={
      Corex.Tree.new([
        %{label: "src", value: "src", children: [
          %{label: "components", value: "components", children: [%{label: "tree-view.tsx", value: "tree-view.tsx"}]},
          %{label: "main.ts", value: "main.ts"}
        ]}
      ])
    }
  />
  ```

  ### Async (`assign_async`)

  ```elixir
  def mount(_params, _session, socket) do
    socket =
      assign_async(socket, :tree, fn ->
        {:ok, %{tree: Corex.Tree.new([%{label: "Docs", value: "docs"}])}}
      end)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.async_result :let={tree} assign={@tree}>
      <:loading><.tree_view_skeleton count={3} class="tree-view" /></:loading>
      <:failed>Could not load the tree.</:failed>
      <.tree_view id="async-tree" items={tree} />
    </.async_result>
    """
  end
  ```

  ### Navigation (redirect)

  Set `redirect` on the component so selection navigates. Per item, the navigation kind comes from `:redirect`:

  - `:href` (default)  -  full page redirect via `window.location` (safe everywhere)
  - `:patch`  -  LiveView `js().patch(url)` (caller asserts: same LV mount + matching live route)
  - `:navigate`  -  LiveView `js().navigate(url)` (caller asserts: another LV in the same `live_session`)
  - `false`  -  disable redirect for this item

  Set `:new_tab` on an item to open its destination via `window.open`.

  ```heex
  <.tree_view redirect items={
    Corex.Tree.new([
      %{label: "Home", value: "home", to: "/", redirect: :patch},
      %{label: "External", value: "ext", to: "https://example.com", new_tab: true}
    ])
  } />
  ```

  <!-- tabs-close -->

  ## Animation

  Set `animation` on the outer `tree_view`. The hook reads `data-animation` and `data-animation-*` on the root.

  <!-- tabs-open -->

  ### `instant`

  Zag toggles the native `hidden` attribute; no height animation on branch content.

  ```heex
  <.tree_view
    animation="instant"
    items={
      Corex.Tree.new([
        %{label: "Components", value: "components", children: [%{label: "Accordion", value: "accordion"}]},
        %{label: "Form", value: "form"}
      ])
    }
  />
  ```

  ### `js` (default)

  Built-in height and opacity via the Web Animations API. Tune timing with `animation_options` using `Corex.Animation.Height`.

  ```heex
  <.tree_view
    animation="js"
    animation_options={%Corex.Animation.Height{duration: 0.3, easing: "ease-out"}}
    items={
      Corex.Tree.new([
        %{label: "Components", value: "components", children: [%{label: "Accordion", value: "accordion"}]},
        %{label: "Form", value: "form"}
      ])
    }
  />
  ```

  ### `custom`

  The hook removes `hidden` and dispatches a browser `CustomEvent` whose **type** is `on_expanded_change_client`. The event `detail` is enriched with deltas:

      // event.detail (TreeViewExpandedChangedDetail)
      { id, expandedValue, previousExpandedValue, added, removed, focusedValue }

  Animate branch content yourself, using `added`/`removed` to drive the transition without diffing on the client side. The example below also seeds initial closed-state styling on mount and after LiveView navigations.

  ```heex
  <.tree_view
    animation="custom"
    on_expanded_change_client="my-tree-expanded"
    items={
      Corex.Tree.new([
        %{label: "Components", value: "components", children: [%{label: "Accordion", value: "accordion"}]},
        %{label: "Form", value: "form"}
      ])
    }
  />
  ```

  ```javascript
  import { animate } from "motion"
  import {
    findTreeBranch,
    animateHeightOpen,
    animateHeightClose,
  } from "corex"

  const reducedMotion = () =>
    window.matchMedia("(prefers-reduced-motion: reduce)").matches

  document.addEventListener("my-tree-expanded", (e) => {
    const root = document.getElementById(e.detail.id)
    if (!root) return
    e.detail.added.forEach((v) => {
      const el = findTreeBranch(root, v)
      if (!el) return
      animateHeightOpen(el, { animator: animate, duration: 0.5, easing: [0.16, 1, 0.3, 1] })
      if (!reducedMotion()) {
        animate(
          el,
          { filter: ["blur(8px)", "blur(0px)"], y: [-10, 0] },
          { duration: 0.55, easing: [0.16, 1, 0.3, 1] },
        )
      }
    })
    e.detail.removed.forEach((v) => {
      const el = findTreeBranch(root, v)
      if (!el) return
      animateHeightClose(el, { animator: animate, duration: 0.28, easing: "ease-in" })
      if (!reducedMotion()) {
        animate(
          el,
          { filter: ["blur(0px)", "blur(8px)"], y: [0, -8] },
          { duration: 0.26, easing: "ease-in" },
        )
      }
    })
  })
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.tree_view>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_selected_value/2`](#set_selected_value/2) | Set selection (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_selected_value/3`](#set_selected_value/3) | Set selection (server) | `socket` |
  | [`set_expanded_value/2`](#set_expanded_value/2) | Set expanded nodes (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_expanded_value/3`](#set_expanded_value/3) | Set expanded nodes (server) | `socket` |
  | [`value/1`](#value/1) | Read selection (client) | `%Phoenix.LiveView.JS{}` |
  | [`value/3`](#value/3) | Read selection (server) | `socket` |
  | [`expanded_value/1`](#expanded_value/1) | Read expanded (client) | `%Phoenix.LiveView.JS{}` |
  | [`expanded_value/3`](#expanded_value/3) | Read expanded (server) | `socket` |

  For `value` and `expanded_value`, use `respond_to: :server | :client | :both`.

  ## Events

  Pick an event name and pass it to `on_*` on `<.tree_view>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_selection_change="tree_selected"` | Selection changes | `%{"id" => id, "selectedValue" => values, ...}` |
  | `on_expanded_change="tree_expanded"` | Expanded nodes change | `%{"id" => id, "expandedValue" => values, ...}` |

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_selection_change_client="tree-selection-changed"` | Selection changes | `id`, `selectedValue`, `added`, `removed` |
  | `on_expanded_change_client="tree-expanded-changed"` | Expanded changes | `id`, `expandedValue`, `added`, `removed` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use [Corex Design](styled.html): `@import "./corex.tailwind.css"` in `app.css`.

  ```css
  [data-scope="tree-view"][data-part="root"] {}
  [data-scope="tree-view"][data-part="label"] {}
  [data-scope="tree-view"][data-part="tree"] {}
  [data-scope="tree-view"][data-part="branch"] {}
  [data-scope="tree-view"][data-part="branch-content"] {}
  [data-scope="tree-view"][data-part="item"] {}
  ```

  Stack modifiers on the host (`class` on `<.tree_view>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `tree-view` |
  | Accent | `tree-view tree-view--semantic-accent` |
  | Brand | `tree-view tree-view--semantic-brand` |
  | Alert | `tree-view tree-view--semantic-alert` |
  | Info | `tree-view tree-view--semantic-info` |
  | Success | `tree-view tree-view--semantic-success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `tree-view tree-view--size-sm` |
  | MD | `tree-view tree-view--size-md` |
  | LG | `tree-view tree-view--size-lg` |
  | XL | `tree-view tree-view--size-xl` |

  <!-- tabs-close -->


  '''

  @doc type: :component
  use Phoenix.Component

  use Corex.Api.Imports, to: Corex.TreeView.Api

  alias Corex.TreeView.Anatomy.{Branch, Item, Label, Props, Root}
  alias Corex.TreeView.Connect

  use Corex.Bem.Variants,
    kind: :polymorphic,
    looks: [treeview: "tree-view", navigation: "tree-navigation"],
    default_as: :treeview,
    axes: [:width, :max_width, :height, :max_height, :semantic, :size, :text, :radius]

  @doc """
  Renders a tree view. Pass `items` as `Corex.Tree.new/1`. Component id = tree root id; names capitalized from labels.
  """
  attr(:id, :string,
    required: false,
    doc: "The id of the tree view, useful for API to identify the component"
  )

  attr(:items, :list,
    required: true,
    doc: "The tree items: list of Corex.Tree.Item structs (use Corex.Tree.new/1)"
  )

  attr(:compound, :boolean,
    default: false,
    doc:
      "Enable compound mode. Use with :let={ctx}, tree_view_root, and tree_view_branch / tree_view_item."
  )

  attr(:redirect, :boolean,
    default: false,
    doc: """
    When true, selecting an item triggers redirect-on-select using the item value (or `:to`)
    as the destination. Each item picks the navigation kind via its `:redirect` field
    (`:href` (default) | `:patch` | `:navigate` | `false`); set `:new_tab` to open in a new tab.
    """
  )

  attr(:value, :list,
    default: [],
    doc: "Initial selected node value(s)."
  )

  attr(:expanded_value, :list,
    default: [],
    doc: "Initial expanded node value(s)."
  )

  attr(:selection_mode, :string,
    default: "single",
    values: ["single", "multiple"],
    doc: "Selection mode: single or multiple"
  )

  attr(:typeahead, :boolean,
    default: true,
    doc: "When true, type characters to move focus among nodes"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "The direction of the tree."
  )

  attr(:on_selection_change, :string,
    default: nil,
    doc:
      "Server event name when selection changes. Payload: `%{id, selectedValue, previousSelectedValue, added, removed, focusedValue, isItem}`."
  )

  attr(:on_selection_change_client, :string,
    default: nil,
    doc:
      "DOM event name dispatched on selection change. `event.detail` matches `TreeViewSelectionChangedDetail`."
  )

  attr(:on_expanded_change, :string,
    default: nil,
    doc:
      "Server event name when expanded state changes. Payload: `%{id, expandedValue, previousExpandedValue, added, removed, focusedValue}`."
  )

  attr(:on_expanded_change_client, :string,
    default: nil,
    doc:
      "DOM event name dispatched on expanded change. `event.detail` matches `TreeViewExpandedChangedDetail`. Required for `animation=\"custom\"`."
  )

  attr(:animation, :string,
    default: "js",
    values: ["instant", "js", "custom"],
    doc: "Branch open/close: instant, built-in js, or custom via on_expanded_change_client"
  )

  attr(:animation_options, Corex.Animation.Height,
    default: %Corex.Animation.Height{},
    doc:
      "Wired to the host when `animation` is `js` only. Custom transitions ignore this assign. See `Corex.Animation.Height` (opacity, height, `block_interaction`)."
  )

  attr(:loading, :boolean,
    default: true,
    doc: "When true, the host renders with `data-loading` until the hook mounts."
  )

  attr(:rest, :global)

  slot(:inner_block,
    required: false,
    doc: """
    Compound mode inner content. Use with the `compound` attribute and `:let={ctx}`.
    `ctx` is a map with keys: `id`, `dir`, `animation`, `items`, `expanded_value`, `value`.
    """
  )

  slot :label, doc: "Optional label slot" do
    attr(:class, :string, required: false)
  end

  slot :branch,
    doc: "Optional label for each branch row. Use :let={item} (Corex.Tree.Item)." do
    attr(:class, :string, required: false)
  end

  slot :branch_indicator,
    doc: "Optional indicator for each branch row. Use :let={item}." do
    attr(:class, :string, required: false)
  end

  slot :item,
    doc: "Optional label for each leaf row. Use :let={item}." do
    attr(:class, :string, required: false)
  end

  slot :item_indicator, doc: "Optional indicator for each leaf row. Use :let={item}." do
    attr(:class, :string, required: false)
  end

  def tree_view(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "tree-view-#{System.unique_integer([:positive])}" end)
      |> validate_items()
      |> put_tree()

    index_paths = index_paths_for_items(assigns.items)

    ctx = %{
      id: assigns.id,
      dir: assigns.dir,
      animation: assigns.animation,
      animation_options: assigns.animation_options,
      items: assigns.items,
      index_paths: index_paths,
      expanded_value: assigns.expanded_value,
      value: assigns.value
    }

    assigns = assign(assigns, :ctx, ctx)

    ~H"""
    <div
      id={@id}
      phx-hook="TreeView"
      data-loading={@loading && ""}
      phx-mounted={@loading && Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      class={corex_style_class(assigns)}
     
      {@rest}
      {Connect.props(%Props{
        id: @id,
        tree: @tree,
        value: @value,
        expanded_value: @expanded_value,
        selection_mode: @selection_mode,
        redirect: @redirect,
        typeahead: @typeahead,
        dir: @dir,
        on_selection_change: @on_selection_change,
        on_selection_change_client: @on_selection_change_client,
        on_expanded_change: @on_expanded_change,
        on_expanded_change_client: @on_expanded_change_client,
        animation: @animation,
        animation_options: @animation_options
      })}
    >
      {if @compound do render_slot(@inner_block, @ctx) end}

      <div :if={not @compound} phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir})} {Connect.root(%Root{id: @id, dir: @dir})}>
        <div
          :if={@label != []}
          class={Map.get(List.first(@label), :class, nil)}
          phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir})}
          {Connect.label(%Label{id: @id, dir: @dir})}
        >
          {render_slot(@label)}
        </div>
        <div phx-mounted={Connect.ignore_tree(%Props{id: @id, dir: @dir})} {Connect.tree(%Props{id: @id, dir: @dir})}>
          <.tree_view_line
            :for={{item, i} <- Enum.with_index(@items)}
            id={@id}
            dir={@dir}
            animation={@animation}
            animation_options={@animation_options}
            tree_item={item}
            index_path={[i]}
            expanded_value={@expanded_value}
            value={@value}
            use_branch_slot={match?([_ | _], @branch)}
            use_branch_indicator_slot={match?([_ | _], @branch_indicator)}
            use_item_slot={match?([_ | _], @item)}
            use_item_indicator_slot={match?([_ | _], @item_indicator)}
          >
            <:branch :if={@branch != []} :let={it}>{render_slot(@branch, it)}</:branch>
            <:branch_indicator :if={@branch_indicator != []} :let={it}>{render_slot(@branch_indicator, it)}</:branch_indicator>
            <:item :if={@item != []} :let={it}>{render_slot(@item, it)}</:item>
            <:item_indicator :if={@item_indicator != []} :let={it}>{render_slot(@item_indicator, it)}</:item_indicator>
          </.tree_view_line>
        </div>
      </div>
    </div>
    """
  end

  @doc type: :compound
  attr(:id, :string, required: false)
  attr(:dir, :string, required: true)
  attr(:animation, :string, required: true)
  attr(:animation_options, Corex.Animation.Height, default: %Corex.Animation.Height{})
  attr(:tree_item, :any, required: true)
  attr(:index_path, :list, required: true)
  attr(:expanded_value, :list, default: [])
  attr(:value, :list, default: [])
  attr(:use_branch_slot, :boolean, default: false)
  attr(:use_branch_indicator_slot, :boolean, default: false)
  attr(:use_item_slot, :boolean, default: false)
  attr(:use_item_indicator_slot, :boolean, default: false)

  slot :branch, required: false do
    attr(:class, :string, required: false)
  end

  slot :branch_indicator, required: false do
    attr(:class, :string, required: false)
  end

  slot :item, required: false do
    attr(:class, :string, required: false)
  end

  slot :item_indicator, required: false do
    attr(:class, :string, required: false)
  end

  def tree_view_line(assigns) do
    branch_row =
      build_branch_for_line(assigns, assigns.tree_item, assigns.index_path)

    item_row =
      build_item_for_line(assigns, assigns.tree_item, assigns.index_path)

    assigns =
      assigns
      |> assign(:branch_row, branch_row)
      |> assign(:item_row, item_row)

    if assigns.tree_item.children && !Enum.empty?(assigns.tree_item.children) do
      ~H"""
      <div phx-mounted={Connect.ignore_branch(@branch_row)} {Connect.branch(@branch_row)}>
        <div phx-mounted={Connect.ignore_branch_trigger(@branch_row)} {Connect.branch_trigger(@branch_row)}>
          <span phx-mounted={Connect.ignore_branch_text(@branch_row)} {Connect.branch_text(@branch_row)}>
            {if @use_branch_slot, do: render_slot(@branch, @tree_item), else: @tree_item.label}
          </span>
          <span phx-mounted={Connect.ignore_branch_indicator(@branch_row)} {Connect.branch_indicator(@branch_row)}>
            {if @use_branch_indicator_slot, do: render_slot(@branch_indicator, @tree_item), else: nil}
          </span>
        </div>
        <div phx-mounted={Connect.ignore_branch_content(@branch_row)} {Connect.branch_content(@branch_row)}>
          <div phx-mounted={Connect.ignore_branch_indent_guide(@branch_row)} {Connect.branch_indent_guide(@branch_row)}></div>
          <.tree_view_line
            :for={{child, j} <- Enum.with_index(@tree_item.children)}
            id={@id}
            dir={@dir}
            animation={@animation}
            animation_options={@animation_options}
            tree_item={child}
            index_path={@index_path ++ [j]}
            expanded_value={@expanded_value}
            value={@value}
            use_branch_slot={@use_branch_slot}
            use_branch_indicator_slot={@use_branch_indicator_slot}
            use_item_slot={@use_item_slot}
            use_item_indicator_slot={@use_item_indicator_slot}
          >
            <:branch :if={@use_branch_slot} :let={it}>{render_slot(@branch, it)}</:branch>
            <:branch_indicator :if={@use_branch_indicator_slot} :let={it}>{render_slot(@branch_indicator, it)}</:branch_indicator>
            <:item :if={@use_item_slot} :let={it}>{render_slot(@item, it)}</:item>
            <:item_indicator :if={@use_item_indicator_slot} :let={it}>{render_slot(@item_indicator, it)}</:item_indicator>
          </.tree_view_line>
        </div>
      </div>
      """
    else
      ~H"""
      <div phx-mounted={Connect.ignore_item(@item_row)} {Connect.item(@item_row)}>
        <span phx-mounted={Connect.ignore_item_text(@item_row)} {Connect.item_text(@item_row)}>
          {if @use_item_slot, do: render_slot(@item, @tree_item), else: @tree_item.label}
        </span>
        <span
          :if={@use_item_indicator_slot}
          phx-mounted={Connect.ignore_item_indicator(@item_row)}
          {Connect.item_indicator(@item_row)}
        >
          {render_slot(@item_indicator, @tree_item)}
        </span>
      </div>
      """
    end
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  def tree_view_root(assigns) do
    root = %Root{id: assigns.ctx.id, dir: assigns.ctx.dir}
    label = %Label{id: assigns.ctx.id, dir: assigns.ctx.dir}

    assigns =
      assigns
      |> assign(:root, root)
      |> assign(:label_assigns, label)

    ~H"""
    <div phx-mounted={Connect.ignore_root(@root)} {Connect.root(@root)} {@rest}>
      <h3
        :if={@label != []}
        class={Map.get(List.first(@label), :class, nil)}
        phx-mounted={Connect.ignore_label(@label_assigns)}
        {Connect.label(@label_assigns)}
      >
        {render_slot(@label)}
      </h3>
      <div phx-mounted={Connect.ignore_tree(%Props{id: @ctx.id, dir: @ctx.dir})} {Connect.tree(%Props{id: @ctx.id, dir: @ctx.dir})}>
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:item, :any, required: true)
  slot(:inner_block, required: true)

  def tree_view_branch(assigns) do
    item = assigns.item

    if item.children == nil or item.children == [] do
      raise ArgumentError, "tree_view_branch requires an item with children"
    end

    index_path = fetch_index_path!(assigns.ctx, item)
    branch = branch_for_ctx(assigns.ctx, item, index_path)
    assigns = assign(assigns, :branch, branch)

    ~H"""
    <div phx-mounted={Connect.ignore_branch(@branch)} {Connect.branch(@branch)}>
      {render_slot(@inner_block, @branch)}
    </div>
    """
  end

  @doc type: :compound
  attr(:branch, :map, required: true)
  slot(:inner_block, required: true)

  slot :indicator, required: false do
    attr(:class, :string, required: false)
  end

  def tree_view_branch_trigger(assigns) do
    ~H"""
    <div phx-mounted={Connect.ignore_branch_trigger(@branch)} {Connect.branch_trigger(@branch)}>
      <span phx-mounted={Connect.ignore_branch_text(@branch)} {Connect.branch_text(@branch)}>
        {render_slot(@inner_block)}
      </span>
      <span phx-mounted={Connect.ignore_branch_indicator(@branch)} {Connect.branch_indicator(@branch)}>
        {if @indicator != [], do: render_slot(@indicator), else: nil}
      </span>
    </div>
    """
  end

  @doc type: :compound
  attr(:branch, :map, required: true)
  slot(:inner_block, required: true)

  def tree_view_branch_indicator(assigns) do
    ~H"""
    <span phx-mounted={Connect.ignore_branch_indicator(@branch)} {Connect.branch_indicator(@branch)}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc type: :compound
  attr(:branch, :map, required: true)
  slot(:inner_block, required: true)

  def tree_view_branch_content(assigns) do
    ~H"""
    <div phx-mounted={Connect.ignore_branch_content(@branch)} {Connect.branch_content(@branch)}>
      <div phx-mounted={Connect.ignore_branch_indent_guide(@branch)} {Connect.branch_indent_guide(@branch)}></div>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:item, :any, required: true)
  slot(:inner_block, required: false)

  slot :item_indicator, required: false do
    attr(:class, :string, required: false)
  end

  def tree_view_item(assigns) do
    item = assigns.item

    if item.children != nil and item.children != [] do
      raise ArgumentError, "tree_view_item is for leaves only"
    end

    index_path = fetch_index_path!(assigns.ctx, item)
    row = item_for_ctx(assigns.ctx, item, index_path)
    assigns = assign(assigns, :row, row)

    ~H"""
    <div phx-mounted={Connect.ignore_item(@row)} {Connect.item(@row)}>
      <span phx-mounted={Connect.ignore_item_text(@row)} {Connect.item_text(@row)}>
        {if @inner_block != [], do: render_slot(@inner_block), else: @item.label}
      </span>
      <span :if={@item_indicator != []} phx-mounted={Connect.ignore_item_indicator(@row)} {Connect.item_indicator(@row)}>
        {render_slot(@item_indicator)}
      </span>
    </div>
    """
  end

  @doc type: :compound
  attr(:item, :map, required: true)
  slot(:inner_block, required: true)

  def tree_view_item_indicator(assigns) do
    ~H"""
    <span phx-mounted={Connect.ignore_item_indicator(@item)} {Connect.item_indicator(@item)}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc type: :component
  attr(:count, :integer, default: 3)
  attr(:rest, :global)

  def tree_view_skeleton(assigns) do
    ~H"""
    <div {@rest}>
      <div data-scope="tree-view" data-part="root" data-loading>
        <div data-scope="tree-view" data-part="tree">
          <div :for={_ <- 1..@count} data-scope="tree-view" data-part="branch">
            <div data-scope="tree-view" data-part="branch-control">
              <span data-scope="tree-view" data-part="branch-text"></span>
              <span data-scope="tree-view" data-part="branch-indicator"></span>
            </div>
            <div data-scope="tree-view" data-part="branch-content"></div>
          </div>
          <div data-scope="tree-view" data-part="item">
            <span data-scope="tree-view" data-part="item-text"></span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc type: :component
  @doc "Renders a tree leaf row for custom server markup or tests. Prefer compound `tree_view_item` when possible."
  attr(:item, :map, required: true)
  slot(:inner_block, required: true)

  def tree_view_markup_item(assigns) do
    ~H"""
    <div phx-mounted={Connect.ignore_item(@item)} {Connect.item(@item)}>
      <span phx-mounted={Connect.ignore_item_text(@item)} {Connect.item_text(@item)}>
        {render_slot(@inner_block)}
      </span>
    </div>
    """
  end

  @doc type: :component
  @doc "Renders a tree branch row for custom server markup or tests. Prefer compound `tree_view_branch` when possible."
  attr(:row, :map, required: true)
  attr(:animation, :string, default: "js")

  slot(:inner_block, required: true)

  slot :branch, required: true do
    attr(:class, :string, required: false)
  end

  slot :branch_indicator, required: true do
    attr(:class, :string, required: false)
  end

  def tree_view_markup_branch(assigns) do
    branch = Branch.with_animation(assigns.row, assigns.animation)

    assigns = assign(assigns, :branch_connect, branch)

    ~H"""
    <div phx-mounted={Connect.ignore_branch(@branch_connect)} {Connect.branch(@branch_connect)}>
      <div phx-mounted={Connect.ignore_branch_trigger(@branch_connect)} {Connect.branch_trigger(@branch_connect)}>
        {render_slot(@branch)}
        <span phx-mounted={Connect.ignore_branch_indicator(@branch_connect)} {Connect.branch_indicator(@branch_connect)}>
          {render_slot(@branch_indicator)}
        </span>
      </div>
      <div phx-mounted={Connect.ignore_branch_content(@branch_connect)} {Connect.branch_content(@branch_connect)}>
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set expanded branches from `phx-click`. Dispatches `corex:tree-view:set-expanded-value`; `value` must be an expanded-path list accepted by Zag.

  ```heex
  <.action phx-click={Corex.TreeView.set_expanded_value("my-tree", ["src"])}>Open src</.action>
  <.tree_view id="my-tree" class="tree-view" items={Corex.Tree.new([%{label: "src", value: "src", children: [%{label: "a.ts", value: "a"}]}])} />
  ```

  ```javascript
  document.getElementById("my-tree")?.dispatchEvent(
    new CustomEvent("corex:tree-view:set-expanded-value", {
      bubbles: false,
      detail: { value: ["src"] },
    })
  );
  ```
  """)

  defdelegate set_expanded_value(tree_view_id, value), to: Api

  api_doc(~S"""
  Set the selection from `phx-click`. Dispatches `corex:tree-view:set-selected-value` with `detail.value`.

  ```heex
  <.action phx-click={Corex.TreeView.set_selected_value("my-tree", ["readme"])}>Select readme</.action>
  <.tree_view id="my-tree" class="tree-view" items={Corex.Tree.new([%{label: "README.md", value: "readme"}])} />
  ```
  """)

  defdelegate set_selected_value(tree_view_id, value), to: Api

  api_doc(~S"""
  Set expanded branches from `handle_event` (`tree_view_set_expanded_value`). Payload uses `tree_view_id` matching the DOM `id`.

  ```elixir
  def handle_event("expand", _, socket) do
    {:noreply, Corex.TreeView.set_expanded_value(socket, "my-tree", ["src"])}
  end
  ```
  """)

  defdelegate set_expanded_value(socket, tree_view_id, value), to: Api

  api_doc(~S"""
  Set the selection from `handle_event` (`tree_view_set_selected_value`).

  ```elixir
  def handle_event("select_item", _, socket) do
    {:noreply, Corex.TreeView.set_selected_value(socket, "my-tree", ["a"])}
  end
  ```
  """)

  defdelegate set_selected_value(socket, tree_view_id, value), to: Api

  api_doc(~S"""
  Read the selected paths from `phx-click`. Dispatches `corex:tree-view:value`. Optional `respond_to:` `:server`, `:client`, or `:both`.

  | | Reply | Payload |
  | - | ----- | ------- |
  | Server | `tree_view_value_response` | `%{"id" => id, "value" => selection}` |
  | Client | `tree-view-value` on the root | same fields in `detail` |

  ```heex
  <.action phx-click={Corex.TreeView.value("my-tree")}>Read selection</.action>
  <.tree_view id="my-tree" class="tree-view" items={Corex.Tree.new([%{label: "Guide", value: "g"}])} />
  ```

  ```elixir
  def handle_event("tree_view_value_response", %{"id" => _, "value" => v}, socket) do
    {:noreply, assign(socket, :sel, v)}
  end
  ```
  """)

  def value(tree_view_id, opts) when is_binary(tree_view_id) and is_list(opts),
    do: Api.value(tree_view_id, opts)

  api_doc_hidden()

  def value(socket, tree_view_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) do
    Api.value(socket, tree_view_id, [])
  end

  api_doc_short("Same as [`value/2`](#value/2) with default `respond_to:`.")
  def value(tree_view_id) when is_binary(tree_view_id), do: Api.value(tree_view_id)

  api_doc(~S"""
  Read selection from `handle_event` (`tree_view_value`). Same replies as [`value/2`](#value/2).

  | Reply | Payload |
  | ----- | ------- |
  | `tree_view_value_response` | `%{"id" => id, "value" => selection}` |

  ```elixir
  def handle_event("read_tree", _, socket) do
    {:noreply, Corex.TreeView.value(socket, "my-tree", respond_to: :server)}
  end
  ```
  """)

  def value(socket, tree_view_id, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) and
             is_list(opts),
      do: Api.value(socket, tree_view_id, opts)

  api_doc(~S"""
  Read expanded paths from `phx-click`. Dispatches `corex:tree-view:expanded-value`.

  | | Reply | Payload |
  | - | ----- | ------- |
  | Server | `tree_view_expanded_value_response` | `%{"id" => id, "value" => expanded_paths}` |
  | Client | `tree-view-expanded-value` | same fields in `detail` |

  ```heex
  <.action phx-click={Corex.TreeView.expanded_value("my-tree")}>Expanded</.action>
  <.tree_view id="my-tree" class="tree-view" items={Corex.Tree.new([%{label: "A", value: "a"}])} />
  ```
  """)

  def expanded_value(tree_view_id, opts) when is_binary(tree_view_id) and is_list(opts),
    do: Api.expanded_value(tree_view_id, opts)

  api_doc_hidden()

  def expanded_value(socket, tree_view_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) do
    Api.expanded_value(socket, tree_view_id, [])
  end

  api_doc_short("Same as [`expanded_value/2`](#expanded_value/2) with default `respond_to:`.")

  def expanded_value(tree_view_id) when is_binary(tree_view_id),
    do: Api.expanded_value(tree_view_id)

  api_doc(~S"""
  Read expanded paths from `handle_event` (`tree_view_expanded_value`). Same replies as [`expanded_value/2`](#expanded_value/2).

  | Reply | Payload |
  | ----- | ------- |
  | `tree_view_expanded_value_response` | `%{"id" => id, "value" => expanded_paths}` |

  ```elixir
  def handle_event("read_expanded", _, socket) do
    {:noreply, Corex.TreeView.expanded_value(socket, "my-tree", respond_to: :server)}
  end
  ```
  """)

  def expanded_value(socket, tree_view_id, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) and
             is_list(opts),
      do: Api.expanded_value(socket, tree_view_id, opts)

  defp items_to_tree(component_id, items) when is_binary(component_id) and is_list(items) do
    %{
      "value" => component_id,
      "name" => "",
      "children" => Enum.map(items, &item_to_node/1)
    }
  end

  defp item_to_node(%Corex.Tree.Item{} = item) do
    children = Enum.map(item.children || [], &item_to_node/1)

    node = %{
      "value" => item.value,
      "name" => item.label,
      "children" => children
    }

    node = if item.to, do: Map.put(node, "to", item.to), else: node
    node = if item.disabled, do: Map.put(node, "disabled", true), else: node

    node =
      case item.redirect do
        false ->
          Map.put(node, "redirect", false)

        mode when mode in [:href, :patch, :navigate] ->
          Map.put(node, "redirect", Atom.to_string(mode))

        _ ->
          node
      end

    if item.new_tab do
      Map.put(node, "new_tab", true)
    else
      node
    end
  end

  defp build_branch_for_line(assigns, tree_item, index_path) do
    expanded = tree_item.value in List.wrap(assigns.expanded_value)
    selected = tree_item.value in List.wrap(assigns.value)

    %Branch{
      id: assigns.id,
      value: tree_item.value,
      index_path: index_path,
      name: tree_item.label,
      dir: assigns.dir,
      expanded: expanded,
      selected: selected,
      focused: false,
      animation: assigns.animation,
      animation_options: Map.get(assigns, :animation_options, %Corex.Animation.Height{})
    }
  end

  defp build_item_for_line(assigns, tree_item, index_path) do
    selected = tree_item.value in List.wrap(assigns.value)

    %Item{
      id: assigns.id,
      value: tree_item.value,
      to: tree_item.to,
      index_path: index_path,
      name: tree_item.label,
      dir: assigns.dir,
      redirect: tree_item.redirect,
      new_tab: tree_item.new_tab,
      selected: selected,
      focused: false
    }
  end

  defp branch_for_ctx(ctx, tree_item, index_path) do
    expanded = tree_item.value in List.wrap(ctx.expanded_value)
    selected = tree_item.value in List.wrap(ctx.value)

    %Branch{
      id: ctx.id,
      value: tree_item.value,
      index_path: index_path,
      name: tree_item.label,
      dir: ctx.dir,
      expanded: expanded,
      selected: selected,
      focused: false,
      animation: ctx.animation,
      animation_options: Map.get(ctx, :animation_options, %Corex.Animation.Height{})
    }
  end

  defp item_for_ctx(ctx, tree_item, index_path) do
    selected = tree_item.value in List.wrap(ctx.value)

    %Item{
      id: ctx.id,
      value: tree_item.value,
      to: tree_item.to,
      index_path: index_path,
      name: tree_item.label,
      dir: ctx.dir,
      redirect: tree_item.redirect,
      new_tab: tree_item.new_tab,
      selected: selected,
      focused: false
    }
  end

  defp index_paths_for_items(items) when is_list(items) do
    items
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {item, i}, acc ->
      Map.merge(acc, index_paths_for_item(item, [i]))
    end)
  end

  defp index_paths_for_item(%Corex.Tree.Item{} = item, index_path) do
    child_paths =
      (item.children || [])
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {child, j}, acc ->
        Map.merge(acc, index_paths_for_item(child, index_path ++ [j]))
      end)

    Map.put(child_paths, item.value, index_path)
  end

  defp fetch_index_path!(%{index_paths: index_paths} = _ctx, %Corex.Tree.Item{value: value})
       when is_map(index_paths) and is_binary(value) do
    case index_paths do
      %{^value => index_path} ->
        index_path

      _ ->
        raise ArgumentError,
              "tree_view compound item #{inspect(value)} is not present in ctx.items"
    end
  end

  defp fetch_index_path!(_ctx, item) do
    raise ArgumentError,
          "tree_view compound expects a Corex.Tree.Item from ctx.items, got: #{inspect(item)}"
  end

  defp validate_items(%{items: nil} = _assigns) do
    raise ArgumentError, """
    tree_view requires :items to be a list of Corex.Tree.Item structs.

    Example:

        items = Corex.Tree.new([
          %{label: "Src", value: "src", children: [%{label: "index.ts", value: "src/index"}]},
          %{label: "Readme", value: "readme"}
        ])
        <.tree_view id="my-tree" items={items} />
    """
  end

  defp validate_items(%{items: items} = assigns) when is_list(items) do
    Enum.each(items, fn item ->
      unless is_struct(item, Corex.Tree.Item) do
        raise ArgumentError, """
        Invalid item in :items. Expected Corex.Tree.Item struct, got: #{inspect(item)}

        Use Corex.Tree.new/1:

            items = Corex.Tree.new([
              %{label: "Folder", value: "folder", children: [%{label: "File", value: "file"}]},
              %{label: "Other", value: "other"}
            ])
            <.tree_view id="my-tree" items={items} />
        """
      end
    end)

    assigns
  end

  defp validate_items(assigns), do: assigns

  defp put_tree(assigns) do
    assign(assigns, :tree, items_to_tree(assigns.id, assigns.items))
  end
end
