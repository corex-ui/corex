defmodule Corex.TreeView do
  @moduledoc ~S'''
   Phoenix implementation of the [Zag.js Tree View](https://zagjs.com/components/react/tree-view).

   ## Features

   - **Declarative** — render from a list of items with `Corex.Tree.new/1`
   - **Custom slots** — override label, branch, branch indicator, item, and item indicator with `:let={item}`
   - **Compound** — take full structural control with dedicated sub-components
   - **Animated** — instant, JS (Web Animations API), or fully custom branch expand/collapse
   - **Navigation** — per-item redirect modes (`:href` / `:patch` / `:navigate` / `false`) and `new_tab`
   - **Client/Server control** — uncontrolled by default; opt in to make LiveView the source of truth
   - **API control** — set selected/expanded from JavaScript, a Phoenix binding, or a LiveView event
   - **API events** — subscribe to selection/expanded changes from the client, the server, or both
   - **Async-ready** — pairs with `assign_async/3`; includes a skeleton for loading states
   - **Accessible** — WAI-ARIA compliant, full keyboard navigation and typeahead via Zag.js
   - **Unstyled** — target `data-part` attributes directly or use Corex Design tokens
   - **Localizable** — automatic LTR/RTL from the document

   ## Declarative

   Pass a list to `Corex.Tree.new/1` to build the tree items. Each item supports:

   | Field | Required | Description |
   |-------|----------|-------------|
   | `:id` | yes | Unique identifier used as the node value |
   | `:label` | yes | Label shown in the row |
   | `:children` | no | Nested list of items to make a branch |
   | `:to` | no | Destination URL when using `redirect` |
   | `:redirect` | no | `:href` (default) \| `:patch` \| `:navigate` \| `false` |
   | `:new_tab` | no | Open destination in a new tab |
   | `:disabled` | no | Prevents interaction |

   <!-- tabs-open -->

   ### Basic

   ```heex
   <.tree_view
     id="my-tree"
     class="tree-view"
     items={
       Corex.Tree.new([
         %{label: "Components", id: "components", children: [
           %{label: "Accordion", id: "accordion"},
           %{label: "Checkbox", id: "checkbox"},
           %{label: "Tree view", id: "tree-view"}
         ]},
         %{label: "Form", id: "form"},
         %{label: "Tree", id: "tree", children: [%{label: "Tree.Item", id: "tree-item"}]}
       ])
     }
   />
   ```

   ### With Label

   ```heex
   <.tree_view
     id="docs-tree"
     class="tree-view"
     items={
       Corex.Tree.new([
         %{label: "Guides", id: "guides"},
         %{label: "Reference", id: "reference"}
       ])
     }
   >
     <:label>My Documents</:label>
   </.tree_view>
   ```

   ### With Indicator

   ```heex
   <.tree_view
     id="tree-indicator"
     class="tree-view"
     items={
       Corex.Tree.new([
         %{label: "src", id: "src", children: [
           %{label: "components", id: "components"},
           %{label: "index.ts", id: "index.ts"}
         ]},
         %{label: "README.md", id: "readme"}
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

   ## Custom Slots

   Customize the rendering of each row with the `:label`, `:branch`, `:branch_indicator`, `:item`, and `:item_indicator` slots. Each of the per-row slots receives a `:let={item}` of type `Corex.Tree.Item`.

   ```heex
   <.tree_view
     id="custom-tree"
     class="tree-view"
     items={
       Corex.Tree.new([
         %{label: "src", id: "src", children: [
           %{label: "components", id: "components", children: [%{label: "tree-view.tsx", id: "tree-view.tsx"}]},
           %{label: "main.ts", id: "main.ts"}
         ]},
         %{label: "README.md", id: "readme"}
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

   ## Compound

   Take full structural control with the `tree_view_root`, `tree_view_branch`, `tree_view_branch_trigger`, `tree_view_branch_content`, and `tree_view_item` sub-components. Branches and items resolve their path from `ctx.items`; iterate recursively or statically.

   ```heex
   <.tree_view :let={ctx} compound id="compound-tree" class="tree-view" items={@items}>
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

   ## Patterns

   <!-- tabs-open -->

   ### Initial expanded/selected

   `expanded_value` and `value` are lists of ids matching items in the tree.

   ```heex
   <.tree_view
     class="tree-view"
     expanded_value={["src", "components"]}
     value={["tree-view.tsx"]}
     items={
       Corex.Tree.new([
         %{label: "src", id: "src", children: [
           %{label: "components", id: "components", children: [%{label: "tree-view.tsx", id: "tree-view.tsx"}]},
           %{label: "main.ts", id: "main.ts"}
         ]}
       ])
     }
   />
   ```

   ### Controlled (LiveView)

   ```elixir
   def handle_event("tree_expanded", %{"expandedValue" => expanded}, socket) do
     {:noreply, assign(socket, :expanded, expanded)}
   end

   def handle_event("tree_selected", %{"selectedValue" => selected}, socket) do
     {:noreply, assign(socket, :selected, selected)}
   end

   def render(assigns) do
     ~H"""
     <.tree_view
       id="controlled-tree"
       controlled
       class="tree-view"
       value={@selected}
       expanded_value={@expanded}
       on_selection_change="tree_selected"
       on_expanded_change="tree_expanded"
       items={@items}
     />
     """
   end
   ```

   ### Async (`assign_async`)

   ```elixir
   def mount(_params, _session, socket) do
     socket =
       assign_async(socket, :tree, fn ->
         {:ok, %{tree: Corex.Tree.new([%{label: "Docs", id: "docs"}])}}
       end)
     {:ok, socket}
   end

   def render(assigns) do
     ~H"""
     <.async_result :let={tree} assign={@tree}>
       <:loading><.tree_view_skeleton count={3} class="tree-view" /></:loading>
       <:failed>Could not load the tree.</:failed>
       <.tree_view id="async-tree" class="tree-view" items={tree} />
     </.async_result>
     """
   end
   ```

   ### Navigation (redirect)

   Set `redirect` on the component so selection navigates. Per item, the navigation kind comes from `:redirect`:

   - `:href` (default) — full page redirect via `window.location` (safe everywhere)
   - `:patch` — LiveView `js().patch(url)` (caller asserts: same LV mount + matching live route)
   - `:navigate` — LiveView `js().navigate(url)` (caller asserts: another LV in the same `live_session`)
   - `false` — disable redirect for this item

   Set `:new_tab` on an item to open its destination via `window.open`.

   ```heex
   <.tree_view id="nav" class="tree-view" redirect items={
     Corex.Tree.new([
       %{label: "Home", id: "home", to: "/", redirect: :patch},
       %{label: "External", id: "ext", to: "https://example.com", new_tab: true}
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
   <.tree_view class="tree-view" animation="instant" items={@items} />
   ```

   ### `js` (default)

   Built-in height and opacity via the Web Animations API. Tune timing with `animation_options` using `Corex.Animation.Height`.

   ```heex
   <.tree_view
     class="tree-view"
     animation="js"
     animation_options={%Corex.Animation.Height{duration: 0.3, easing: "ease-out"}}
     items={@items}
   />
   ```

   ### `custom`

   The hook removes `hidden` and dispatches a browser `CustomEvent` whose **type** is `on_expanded_change_client`. The event `detail` is enriched with deltas:

       // event.detail (TreeViewExpandedChangedDetail)
       { id, expandedValue, previousExpandedValue, added, removed, focusedValue }

   Animate branch content yourself, using `added`/`removed` to drive the transition without diffing on the client side. The example below also seeds initial closed-state styling on mount and after LiveView navigations.

   ```heex
   <.tree_view class="tree-view" animation="custom" on_expanded_change_client="my-tree-expanded" items={@items} />
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

   The API targets one specific tree view via its DOM `id`.

   - `set_selected_value/2` and `set_selected_value/3`
   - `set_expanded_value/2` and `set_expanded_value/3`
   - `value/1`, `value/2`, and `value/3`
   - `expanded_value/1`, `expanded_value/2`, and `expanded_value/3`

   For `value` and `expanded_value`, use `respond_to: :server | :client | :both` to control whether the response is pushed to LiveView, dispatched as a DOM event, or both.

   ```heex
   <.action phx-click={Corex.TreeView.set_selected_value("my-tree", ["lorem"])}>Select Lorem</.action>
   <.action phx-click={Corex.TreeView.set_expanded_value("my-tree", ["lorem"])}>Expand Lorem</.action>
   <.action phx-click={Corex.TreeView.value("my-tree")}>Value</.action>
   <.action phx-click={Corex.TreeView.expanded_value("my-tree")}>Expanded</.action>
   ```

   ## Events

   User interaction and imperative API use different channels. See also the `on_*` attributes on `tree_view/1`.

   ### User interaction

   When `phx-hook="TreeView"` is active, Zag invokes callbacks that map to:

   - **`on_selection_change`** — `pushEvent/3` to LiveView with the name you set. Params: `%{"id" => tree_dom_id, "selectedValue" => [...], "previousSelectedValue" => [...], "added" => [...], "removed" => [...], "focusedValue" => focused_or_nil, "isItem" => bool}` (TS: `TreeViewSelectionChangedDetail`).
   - **`on_selection_change_client`** — browser `CustomEvent` whose **type** is the string you set; `event.detail` mirrors the push payload (bubbles).
   - **`on_expanded_change`** — `pushEvent/3` with `%{"id" => dom_id, "expandedValue" => [...], "previousExpandedValue" => [...], "added" => [...], "removed" => [...], "focusedValue" => focused_or_nil}` (TS: `TreeViewExpandedChangedDetail`).
   - **`on_expanded_change_client`** — `CustomEvent` with the same `detail` shape (bubbles). Required for `animation="custom"`.

   ### Imperative API (LiveView helpers and client DOM)

   **From LiveView**, see the API list above. All push to the hook; optional `respond_to` controls where the answer goes.

   **From the client**, dispatch `CustomEvent`s on the tree view root (the same element as `id`, e.g. `#my-tree`):

   | Dispatch (type) | `detail` |
   |-----------------|----------|
   | `corex:tree-view:set-selected-value` | `value` — list of selected ids |
   | `corex:tree-view:set-expanded-value` | `value` — list of expanded ids |
   | `corex:tree-view:value` | optional `respond_to`: `"server"`, `"client"`, or `"both"` |
   | `corex:tree-view:expanded-value` | optional `respond_to` |

   **Responses to LiveView** (`push_event` from the hook; handle in `handle_event/3`):

   - `tree_view_value_response` — `%{"id" => ..., "value" => [...]}`
   - `tree_view_expanded_value_response` — `%{"id" => ..., "value" => [...]}`

   **Responses to the DOM** (listen on the tree view root element):

   - `tree-view-value` — `detail: { id, value }`
   - `tree-view-expanded-value` — `detail: { id, value }`

   ## Styling

   Zag exposes `data-scope="tree-view"` and `data-part` on each element:

   ```css
   [data-scope="tree-view"][data-part="root"] {}
   [data-scope="tree-view"][data-part="label"] {}
   [data-scope="tree-view"][data-part="tree"] {}
   [data-scope="tree-view"][data-part="branch"] {}
   [data-scope="tree-view"][data-part="branch-control"] {}
   [data-scope="tree-view"][data-part="branch-content"] {}
   [data-scope="tree-view"][data-part="branch-indicator"] {}
   [data-scope="tree-view"][data-part="branch-text"] {}
   [data-scope="tree-view"][data-part="branch-indent-guide"] {}
   [data-scope="tree-view"][data-part="item"] {}
   [data-scope="tree-view"][data-part="item-text"] {}
   [data-scope="tree-view"][data-part="item-indicator"] {}
   ```

   With Corex Design, import tokens and the tree-view stylesheet, then add the `tree-view` class and modifiers:

   ```css
   @import "../corex/main.css";
   @import "../corex/tokens/themes/neo/light.css";
   @import "../corex/components/tree-view.css";
   ```

   ```heex
   <.tree_view class="tree-view tree-view--accent tree-view--lg tree-view--rounded-md tree-view--text-md" items={@items}>
     <:label>Project</:label>
   </.tree_view>
   ```


  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.TreeView.Anatomy.{Branch, Item, Label, Props, Root}
  alias Corex.TreeView.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [validate_value!: 1, respond_to_fields: 1]

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
    doc: "Selected node value(s). Use with controlled."
  )

  attr(:expanded_value, :list,
    default: [],
    doc: "Expanded node value(s). Use with controlled."
  )

  attr(:controlled, :boolean,
    default: false,
    doc: "Whether the tree is controlled (value and expanded_value from server)."
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
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        tree: @tree,
        value: @value,
        expanded_value: @expanded_value,
        controlled: @controlled,
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

  attr(:id, :string, required: true)
  attr(:dir, :string, required: true)
  attr(:animation, :string, required: true)
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
  @doc "Renders a tree item (leaf). For custom server-rendered items or testing."
  attr(:item, :map, required: true)
  slot(:inner_block, required: true)

  def tree_item(assigns) do
    ~H"""
    <div phx-mounted={Connect.ignore_item(@item)} {Connect.item(@item)}>
      <span phx-mounted={Connect.ignore_item_text(@item)} {Connect.item_text(@item)}>
        {render_slot(@inner_block)}
      </span>
    </div>
    """
  end

  @doc type: :component
  @doc "Renders a tree branch (node with children). For custom server-rendered branches or testing."
  attr(:row, :map, required: true)
  attr(:animation, :string, default: "js")

  slot(:inner_block, required: true)

  slot :branch, required: true do
    attr(:class, :string, required: false)
  end

  slot :branch_indicator, required: true do
    attr(:class, :string, required: false)
  end

  def tree_branch(assigns) do
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

  @doc type: :api
  @doc "Sets the tree expanded value from client-side."
  def set_expanded_value(tree_view_id, value) when is_binary(tree_view_id) do
    JS.dispatch("corex:tree-view:set-expanded-value",
      to: "##{tree_view_id}",
      detail: %{value: validate_value!(value)},
      bubbles: false
    )
  end

  @doc type: :api
  @doc "Sets the tree selected value from client-side."
  def set_selected_value(tree_view_id, value) when is_binary(tree_view_id) do
    JS.dispatch("corex:tree-view:set-selected-value",
      to: "##{tree_view_id}",
      detail: %{value: validate_value!(value)},
      bubbles: false
    )
  end

  @doc type: :api
  @doc "Sets the tree expanded value from server-side."
  def set_expanded_value(socket, tree_view_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) do
    LiveView.push_event(socket, "tree_view_set_expanded_value", %{
      tree_view_id: tree_view_id,
      value: validate_value!(value)
    })
  end

  @doc type: :api
  @doc "Sets the tree selected value from server-side."
  def set_selected_value(socket, tree_view_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) do
    LiveView.push_event(socket, "tree_view_set_selected_value", %{
      tree_view_id: tree_view_id,
      value: validate_value!(value)
    })
  end

  @doc type: :api
  @doc """
  Requests the tree's current selected values from the browser. Returns a `Phoenix.LiveView.JS` command.

  Options:

  - `:respond_to` — `:server` (default, LiveView `tree_view_value_response` only), `:both` (also dispatches
    `tree-view-value`), or `:client` (DOM `tree-view-value` only). When `:server` and the LiveView is not connected,
    nothing is pushed.

  The hook pushes `tree_view_value_response` when `:respond_to` is `:both` or `:server`, and dispatches
  `tree-view-value` on the element when `:respond_to` is `:both` or `:client`.

  ## Examples

  #### From Client Binding

      <.action phx-click={Corex.TreeView.value("my-tree")} class="button button--sm">
        Value
      </.action>

      ```javascript
      const el = document.getElementById("my-tree");
      el?.addEventListener("tree-view-value", (e) => console.log(e.detail));
      ```

  #### JS.dispatch

      <.action
        phx-click={JS.dispatch("corex:tree-view:value",
          to: "#my-tree",
          detail: %{respond_to: "client"},
          bubbles: false
        )}
        class="button button--sm"
      >
        Value (JS.dispatch, client only)
      </.action>
  """

  def value(tree_view_id) when is_binary(tree_view_id), do: value(tree_view_id, [])

  def value(tree_view_id, opts) when is_binary(tree_view_id) and is_list(opts) do
    JS.dispatch("corex:tree-view:value",
      to: "##{tree_view_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Requests the tree's current selected values from the client. Pushes a LiveView event handled by the hook.

  See `value/2` for `:respond_to`. The hook pushes `tree_view_value_response` and/or dispatches `tree-view-value`
  accordingly.

  ## Examples

      def handle_event("tree_view_value_response", %{"id" => id, "value" => value}, socket) do
        {:noreply, assign(socket, :tree_view_value, {id, value})}
      end
  """

  def value(socket, tree_view_id, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "tree_view_value",
      Map.merge(%{id: tree_view_id}, respond_to_fields(opts))
    )
  end

  @doc type: :api
  @doc """
  Requests the tree's current expanded values from the browser. Returns a `Phoenix.LiveView.JS` command.

  Options:

  - `:respond_to` — `:server` (default, LiveView `tree_view_expanded_value_response` only), `:both` (also
    dispatches `tree-view-expanded-value`), or `:client` (DOM `tree-view-expanded-value` only).

  ## Examples

  #### From Client Binding

      <.action phx-click={Corex.TreeView.expanded_value("my-tree")} class="button button--sm">
        Expanded
      </.action>

      ```javascript
      const el = document.getElementById("my-tree");
      el?.addEventListener("tree-view-expanded-value", (e) => console.log(e.detail));
      ```

  #### JS.dispatch

      <.action
        phx-click={JS.dispatch("corex:tree-view:expanded-value",
          to: "#my-tree",
          detail: %{respond_to: "client"},
          bubbles: false
        )}
        class="button button--sm"
      >
        Expanded (JS.dispatch, client only)
      </.action>
  """

  def expanded_value(tree_view_id) when is_binary(tree_view_id),
    do: expanded_value(tree_view_id, [])

  def expanded_value(tree_view_id, opts) when is_binary(tree_view_id) and is_list(opts) do
    JS.dispatch("corex:tree-view:expanded-value",
      to: "##{tree_view_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Requests the tree's current expanded values from the client. Pushes a LiveView event handled by the hook.

  See `expanded_value/2` for `:respond_to`. The hook pushes `tree_view_expanded_value_response` and/or dispatches
  `tree-view-expanded-value` accordingly.

  ## Examples

      def handle_event("tree_view_expanded_value_response", %{"id" => id, "value" => value}, socket) do
        {:noreply, assign(socket, :tree_view_expanded_value, {id, value})}
      end
  """

  def expanded_value(socket, tree_view_id, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "tree_view_expanded_value",
      Map.merge(%{id: tree_view_id}, respond_to_fields(opts))
    )
  end

  defp items_to_tree(component_id, items) when is_binary(component_id) and is_list(items) do
    %{
      "id" => component_id,
      "name" => "",
      "children" => Enum.map(items, &item_to_node/1)
    }
  end

  defp item_to_node(%Corex.Tree.Item{} = item) do
    children = Enum.map(item.children || [], &item_to_node/1)

    node = %{
      "id" => item.id,
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
    expanded = tree_item.id in List.wrap(assigns.expanded_value)
    selected = tree_item.id in List.wrap(assigns.value)

    %Branch{
      id: assigns.id,
      value: tree_item.id,
      index_path: index_path,
      name: tree_item.label,
      dir: assigns.dir,
      expanded: expanded,
      selected: selected,
      focused: false,
      animation: assigns.animation
    }
  end

  defp build_item_for_line(assigns, tree_item, index_path) do
    selected = tree_item.id in List.wrap(assigns.value)

    %Item{
      id: assigns.id,
      value: tree_item.id,
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
    expanded = tree_item.id in List.wrap(ctx.expanded_value)
    selected = tree_item.id in List.wrap(ctx.value)

    %Branch{
      id: ctx.id,
      value: tree_item.id,
      index_path: index_path,
      name: tree_item.label,
      dir: ctx.dir,
      expanded: expanded,
      selected: selected,
      focused: false,
      animation: ctx.animation
    }
  end

  defp item_for_ctx(ctx, tree_item, index_path) do
    selected = tree_item.id in List.wrap(ctx.value)

    %Item{
      id: ctx.id,
      value: tree_item.id,
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

    Map.put(child_paths, item.id, index_path)
  end

  defp fetch_index_path!(%{index_paths: index_paths} = _ctx, %Corex.Tree.Item{id: id})
       when is_map(index_paths) and is_binary(id) do
    case index_paths do
      %{^id => index_path} ->
        index_path

      _ ->
        raise ArgumentError, "tree_view compound item #{inspect(id)} is not present in ctx.items"
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
          %{label: "Src", id: "src", children: [%{label: "index.ts", id: "src/index"}]},
          %{label: "Readme", id: "readme"}
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
              %{label: "Folder", id: "folder", children: [%{label: "File", id: "file"}]},
              %{label: "Other", id: "other"}
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
