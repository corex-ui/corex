# Tree view

Tree view for Phoenix LiveView. Behavior follows [Zag.js Tree View](https://zagjs.com/components/react/tree-view).

## Anatomy

Render from a list with `Corex.Tree.new/1`.

<!-- tabs-open -->

### Basic

Each item supports `:value`, `:label`, optional `:children`, `:to`, `:redirect`, `:new_tab`, `:disabled`.

```heex
<.tree_view
  class="tree-view"
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
  class="tree-view"
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
  class="tree-view"
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
  class="tree-view"
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
  class="tree-view"
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

## Patterns

<!-- tabs-open -->

### Initial expanded/selected

`expanded_value` and `value` are lists of item values matching the tree.

```heex
<.tree_view
  class="tree-view"
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
    <.tree_view id="async-tree" class="tree-view" items={tree} />
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
<.tree_view class="tree-view" redirect items={
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
  class="tree-view"
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
  class="tree-view"
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
  class="tree-view"
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

Target parts with `data-scope` and `data-part`, or use Corex Design: import tokens and `tree-view.css`, then set `class="tree-view"` on `<.tree_view>`.

```css
[data-scope="tree-view"][data-part="root"] {}
[data-scope="tree-view"][data-part="label"] {}
[data-scope="tree-view"][data-part="tree"] {}
[data-scope="tree-view"][data-part="branch"] {}
[data-scope="tree-view"][data-part="branch-content"] {}
[data-scope="tree-view"][data-part="item"] {}
```

```css
@import "../corex/corex.css";
```

Stack modifiers on the host (`class` on `<.tree_view>`).

Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). No variant axis. See the [modifier guide](modifiers.html).

Semantic modifiers set palette variables for the filled selected state. Unselected items stay neutral. There is no variant axis.

<!-- tabs-open -->

### Semantic

| Modifier | Classes |
| -------- | ------- |
| Default | `tree-view` |
| Accent | `tree-view ui-accent` |
| Brand | `tree-view ui-brand` |
| Alert | `tree-view ui-alert` |
| Info | `tree-view ui-info` |
| Success | `tree-view ui-success` |


### Size

| Modifier | Classes |
| -------- | ------- |
| SM | `tree-view ui-size-sm` |
| MD | `tree-view ui-size-md` |
| LG | `tree-view ui-size-lg` |
| XL | `tree-view ui-size-xl` |

<!-- tabs-close -->
