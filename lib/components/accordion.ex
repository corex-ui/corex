defmodule Corex.Accordion do
  @moduledoc ~S'''
  Expandable panels for Phoenix LiveView. Behavior follows [Zag.js Accordion](https://zagjs.com/components/react/accordion).

  Examples, events, patterns, and styling: [Accordion guide](components/accordion.html).
  '''

  @doc type: :component
  use Phoenix.Component

  use Corex.Component, :api

  import Corex.Api.Doc

  alias Corex.Accordion.Anatomy.{Item, Props, Root}

  alias Corex.Accordion.Connect

  alias Corex.Api.RespondTo

  alias Corex.Selectors

  alias Phoenix.LiveView

  alias Phoenix.LiveView.JS

  @doc """
  Renders an accordion. See the module documentation for list-driven `items`, With slots, Custom slots, Manual and Compound modes, patterns, API, and events.
  """

  attr(:id, :string,
    required: false,
    doc:
      "DOM id on the accordion root. Used by `set_value`, `value`, `focused`, and `item_state`. Optional; derived from :name when present, otherwise a prefixed random id (pass a stable :id when using controlled or server on_* handlers)."
  )

  attr(:items, :list,
    default: [],
    doc: "Items from `Corex.Content.new/1` (see `Corex.Content` for the full contract)"
  )

  attr(:value, :any,
    default: [],
    doc:
      "Initial or controlled open state: one string or a list of strings (`value` of each item)."
  )

  attr(:compound, :boolean,
    default: false,
    doc:
      "Enable compound mode. Use with :let={ctx} and sub-components to fully control structure."
  )

  attr(:controlled, :boolean,
    default: false,
    doc: "When true, LiveView owns open items via `value` and `on_value_change`."
  )

  attr(:collapsible, :boolean, default: true, doc: "Whether the accordion is collapsible")

  attr(:multiple, :boolean,
    default: true,
    doc: "Whether the accordion allows multiple items to be selected"
  )

  attr(:animation, :string,
    default: "js",
    values: ["instant", "js", "custom"],
    doc: """
    How items animate when opening or closing.
    - `instant` — toggle `hidden` immediately
    - `js` — built-in height and opacity (`animation_options` / `Corex.Animation.Height`)
    - `custom` — no built-in animation; use `on_value_change_client` with Motion or other JS
    """
  )

  attr(:animation_options, Corex.Animation.Height,
    default: %Corex.Animation.Height{},
    doc:
      "Used when `animation` is `js`. Ignored for `instant` and `custom`. See `Corex.Animation.Height`."
  )

  attr(:orientation, :string,
    default: "vertical",
    values: ["horizontal", "vertical"],
    doc: "The orientation of the accordion"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the accordion. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:on_value_change, :string,
    default: nil,
    doc: ~S"""
    LiveView event when open items change. Pick any event name.

    ```heex
    <.accordion
      id="faq"
      class="accordion"
      on_value_change="items_changed"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    >
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    ```

    ```elixir
    def handle_event("items_changed", %{"id" => _id, "value" => values}, socket) do
      {:noreply, assign(socket, :open_items, values)}
    end
    ```
    """
  )

  attr(:on_value_change_client, :string,
    default: nil,
    doc: ~S"""
    Browser event on the accordion element when open items change (same moment as `on_value_change`).

    ```heex
    <.accordion
      id="faq"
      class="accordion"
      on_value_change_client="items-changed"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    >
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    ```

    ```javascript
    document.getElementById("faq")?.addEventListener("items-changed", (e) => {
      console.log(e.detail.value, e.detail.added, e.detail.removed);
    });
    ```
    """
  )

  attr(:on_focus_change, :string,
    default: nil,
    doc: ~S"""
    LiveView event when keyboard focus moves to another item.

    ```heex
    <.accordion
      id="faq"
      class="accordion"
      on_focus_change="focus_changed"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    >
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    ```

    ```elixir
    def handle_event("focus_changed", %{"id" => _id, "value" => item}, socket) do
      {:noreply, assign(socket, :focused_item, item)}
    end
    ```
    """
  )

  attr(:on_focus_change_client, :string,
    default: nil,
    doc: ~S"""
    Browser event on the accordion element when focus moves.

    ```heex
    <.accordion
      id="faq"
      class="accordion"
      on_focus_change_client="focus-changed"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    >
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    ```

    ```javascript
    document.getElementById("faq")?.addEventListener("focus-changed", (e) => {
      console.log(e.detail.value);
    });
    ```
    """
  )

  attr(:rest, :global)

  slot(:inner_block,
    required: false,
    doc: """
    Compound mode inner content. Use with the `compound` attribute and `:let={ctx}`.
    `ctx` is a map with keys: `id`, `values`, `orientation`, `dir`.
    """
  )

  slot :indicator,
    required: false,
    doc:
      "Optional slot after each trigger. With `:items`, use `:let={item}`. Without `:items` (manual mode), use one slot per item and a matching `value` on `:trigger` and `:content`." do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
  end

  slot :trigger,
    required: false,
    doc:
      "With `:items`, optional custom trigger; use `:let={item}`. Without `:items` (manual mode), one slot per item with `value` (or default `item-0`, …)." do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
    attr(:disabled, :boolean, required: false)
  end

  slot :content,
    required: false,
    doc:
      "With `:items`, optional custom content; use `:let={item}`. Without `:items` (manual mode), one slot per item with `value` (or default `item-0`, …)." do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
    attr(:disabled, :boolean, required: false)
  end

  def accordion(assigns) do
    assigns =
      assigns
      |> Corex.FormField.assign_stable_id("accordion")
      |> update(:value, &accordion_value_list/1)
      |> then(fn assigns ->
        if not assigns.compound and Enum.empty?(assigns.items) and
             assigns.trigger == [] and assigns.content == [] do
          Corex.Content.assert_content_items!(assigns, "Accordion")
        else
          assigns
        end
      end)
      |> then(&accordion_assert_trigger_content_pair!/1)
      |> then(&accordion_assign_manual_mode!/1)
      |> then(&accordion_assign_panels/1)

    ctx = %{
      id: assigns.id,
      values: assigns.value,
      orientation: assigns.orientation,
      dir: assigns.dir,
      animation: assigns.animation
    }

    assigns = assign(assigns, :ctx, ctx)

    ~H"""
    <div
      id={@id}
      phx-hook="Accordion"
      {Corex.Hook.loading()}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        value: @value,
        collapsible: @collapsible,
        multiple: @multiple,
        orientation: @orientation,
        dir: @dir,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client,
        on_focus_change: @on_focus_change,
        on_focus_change_client: @on_focus_change_client,
        animation: @animation,
        animation_options: @animation_options
      })}
      {@rest}
    >

    {if @compound do render_slot(@inner_block, @ctx) end}

    <div :if={not @compound}
        {Connect.mounted_root(%Root{id: @id, orientation: @orientation, dir: @dir})}
        >
        <.accordion_item
          :for={panel <- @panels}
          ctx={@ctx}
          value={panel.value}
          disabled={panel.disabled}
          label={panel_source_label(panel)}
          :let={item}
        >
          <.accordion_trigger item={item}>
            {cond do
              panel.source == :slots -> render_slot(panel.trigger_slot)
              @trigger != [] -> render_slot(@trigger, panel.item_entry)
              true -> panel.item_entry.label
            end}
            <:indicator :if={accordion_panel_has_indicator?(panel, @indicator)}>
              <.accordion_indicator item={item}>
                {if panel.source == :slots,
                  do: render_slot(panel.indicator_slot),
                  else: render_slot(@indicator, panel.item_entry)}
              </.accordion_indicator>
            </:indicator>
          </.accordion_trigger>

          <.accordion_content item={item} animation={@animation}>
            {cond do
              panel.source == :slots -> render_slot(panel.content_slot)
              @content != [] -> render_slot(@content, panel.item_entry)
              true -> nil
            end}
            <p :if={panel.source == :items and @content == []}>{panel.item_entry.content}</p>
          </.accordion_content>
        </.accordion_item>
      </div>
    </div>
    """
  end

  @doc type: :compound
  @doc """
  Renders the root container for an accordion in compound mode.

  Use inside `accordion` compound mode with `:let={ctx}`, wrapping all `accordion_item` components.
  """

  @doc type: :compound
  attr(:ctx, :map,
    required: true,
    doc: "The context map yielded by the parent accordion via :let={ctx}"
  )

  attr(:rest, :global)
  slot(:inner_block, required: true)

  def accordion_root(assigns) do
    root = %Root{
      id: assigns.ctx.id,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir
    }

    assigns = assign(assigns, :root, root)

    ~H"""
    <div
      {Connect.mounted_root(@root)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  @doc """
  Renders an accordion item. Use inside `accordion` compound mode with `:let={ctx}`.

  Yields the `%Item{}` struct via `:let` for use in child parts.
  """

  @doc type: :compound
  attr(:ctx, :map,
    required: true,
    doc: "The context map yielded by the parent accordion via :let={ctx}"
  )

  attr(:value, :string, required: true, doc: "The unique value identifying this item")
  attr(:disabled, :boolean, default: false, doc: "Whether the item is disabled")
  attr(:label, :string, default: nil, doc: "Visible item label for unique region names")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def accordion_item(assigns) do
    item = %Item{
      id: assigns.ctx.id,
      value: assigns.value,
      disabled: assigns.disabled,
      values: assigns.ctx.values,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir,
      animation: Map.get(assigns.ctx, :animation, "instant"),
      label: assigns[:label]
    }

    assigns = assign(assigns, :item, item)

    ~H"""
    <div {Connect.mounted_item(@item)} {@rest}>
      {render_slot(@inner_block, @item)}
    </div>
    """
  end

  @doc type: :compound
  @doc """
  Renders the trigger button for an accordion item.

  Use inside `accordion_item` with `:let={item}`, passing the yielded `item` as the `item` attr.
  Place `accordion_indicator` inside this component's inner block if needed.
  """

  attr(:item, :map, required: true)

  attr(:rest, :global)
  slot(:inner_block, required: true)
  slot(:indicator, required: false)

  def accordion_trigger(assigns) do
    ~H"""
    <h3>
      <button {Connect.mounted_trigger(@item)} {@rest}>
        <span data-scope="accordion" data-part="item-text">
          {render_slot(@inner_block)}
        </span>
        {render_slot(@indicator)}
      </button>
    </h3>
    """
  end

  @doc type: :compound
  @doc """
  Renders the indicator for an accordion item.

  Use inside `accordion_trigger` inner block, passing the same `item` from `accordion_item`.
  """

  attr(:item, :map,
    required: true,
    doc: "The item struct yielded by accordion_item via :let={item}"
  )

  attr(:rest, :global)
  slot(:inner_block, required: true)

  def accordion_indicator(assigns) do
    ~H"""
    <span {Connect.mounted_indicator(@item)} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc type: :compound
  @doc """
  Renders the content area for an accordion item.

  Use inside `accordion_item` with `:let={item}`, passing the yielded `item` as the `item` attr.
  """

  attr(:item, :map,
    required: true,
    doc: "The item struct yielded by accordion_item via :let={item}"
  )

  attr(:animation, :string,
    default: nil,
    doc:
      "Override animation mode; defaults to the parent accordion `animation` from compound ctx."
  )

  attr(:rest, :global)
  slot(:inner_block, required: true)

  def accordion_content(assigns) do
    animation = assigns.animation || assigns.item.animation

    assigns = assign(assigns, :resolved_animation, animation)

    ~H"""
    <div
      phx-mounted={Connect.ignore_content(@item)}
      {Connect.content(@item, @resolved_animation)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :component
  @doc """
  Renders a loading skeleton for the accordion component.
  """

  attr(:count, :integer, default: 3)
  attr(:rest, :global)

  slot :trigger do
    attr(:class, :string, required: false)
  end

  slot :indicator do
    attr(:class, :string, required: false)
  end

  slot :content do
    attr(:class, :string, required: false)
  end

  def accordion_skeleton(assigns) do
    ~H"""
    <div {@rest}>
      <div data-scope="accordion" data-part="root" data-async>
        <div :for={_item <- 1..@count} data-scope="accordion" data-part="item">
          <div data-scope="accordion" data-part="item-trigger">
            <span data-scope="accordion" data-part="item-text">
              {render_slot(@trigger)}
            </span>
            <span data-scope="accordion" data-part="item-indicator">
              {render_slot(@indicator)}
            </span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Open or close items from `phx-click`. Pass a list (`["lorem"]`), a comma string (`"lorem,donec"`), or `[]` to close all.

  ```heex
  <.action phx-click={Corex.Accordion.set_value("my-accordion", "lorem")}>Open Lorem</.action>
  <.action phx-click={Corex.Accordion.set_value("my-accordion", [])}>Close all</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}>
    <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
  </.accordion>
  ```

  ```javascript
  document.getElementById("my-accordion")?.dispatchEvent(
    new CustomEvent("corex:accordion:set-value", {
      bubbles: false,
      detail: { value: ["lorem"] }
    })
  );
  ```
  """)

  @spec set_value(String.t(), Corex.Value.coercible()) :: Phoenix.LiveView.JS.t()
  @spec set_value(Phoenix.LiveView.Socket.t(), String.t(), Corex.Value.coercible()) ::
          Phoenix.LiveView.Socket.t()
  def set_value(accordion_id, value) when is_binary(accordion_id) do
    JS.dispatch("corex:accordion:set-value",
      to: Selectors.css_id(accordion_id),
      detail: %{value: parse_string_list(value, "Corex.Accordion.set_value/2")},
      bubbles: false
    )
  end

  api_doc(~S"""
  Open or close items from `handle_event`. Pushes `accordion_set_value` (no reply event).

  ```heex
  <.action phx-click="open_lorem" phx-value-value="lorem">Open Lorem</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```elixir
  def handle_event("open_lorem", %{"value" => value}, socket) do
    {:noreply, Corex.Accordion.set_value(socket, "my-accordion", value)}
  end
  ```
  """)

  def set_value(socket, accordion_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) do
    RespondTo.push_set_value(
      socket,
      "accordion_set_value",
      accordion_id,
      parse_string_list(value, "Corex.Accordion.set_value/2")
    )
  end

  api_doc(~S"""
  Read open items from `phx-click`. Dispatches `corex:accordion:value`. Optional `respond_to:` `:server` (default), `:client`, or `:both`.

  | | Reply | Payload |
  | - | ----- | ------- |
  | Server | `accordion_value_response` | `%{"id" => id, "value" => values}` |
  | Client | `accordion-value` on the accordion | `detail`: `id`, `value` |

  ```heex
  <.action phx-click={Corex.Accordion.value("my-accordion", respond_to: :both)}>Which items are open?</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```javascript
  document.getElementById("my-accordion")?.dispatchEvent(
    new CustomEvent("corex:accordion:value", {
      bubbles: false,
      detail: { respond_to: "both" }
    })
  );
  ```

  ```elixir
  def handle_event("accordion_value_response", %{"id" => _id, "value" => values}, socket) do
    {:noreply, assign(socket, :open_items, values)}
  end
  ```

  `values` is a list of open item `value` strings, or `nil`.
  """)

  @spec value(String.t()) :: Phoenix.LiveView.JS.t()
  @spec value(String.t(), keyword()) :: Phoenix.LiveView.JS.t()
  @spec value(Phoenix.LiveView.Socket.t(), String.t(), keyword()) :: Phoenix.LiveView.Socket.t()
  def value(accordion_id, opts) when is_binary(accordion_id) and is_list(opts) do
    JS.dispatch("corex:accordion:value",
      to: Selectors.css_id(accordion_id),
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  def value(socket, accordion_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id),
      do: value(socket, accordion_id, [])

  def value(accordion_id) when is_binary(accordion_id), do: value(accordion_id, [])

  api_doc(~S"""
  Read open items from `handle_event` (`accordion_value`). Same replies as [`value/2`](#value/2).

  | Reply | Payload |
  | ----- | ------- |
  | `accordion_value_response` | `%{"id" => id, "value" => values}` |

  ```heex
  <.action phx-click="read_items">Which items are open?</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```elixir
  def handle_event("read_items", _params, socket) do
    {:noreply, Corex.Accordion.value(socket, "my-accordion", respond_to: :server)}
  end

  def handle_event("accordion_value_response", %{"id" => _id, "value" => values}, socket) do
    {:noreply, assign(socket, :open_items, values)}
  end
  ```
  """)

  def value(socket, accordion_id, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "accordion_value",
      Map.merge(%{id: accordion_id}, respond_to_fields(opts))
    )
  end

  api_doc(~S"""
  Read the focused item from `phx-click`. Dispatches `corex:accordion:focused`. Optional `respond_to:` `:server` (default), `:client`, or `:both`.

  | | Reply | Payload |
  | - | ----- | ------- |
  | Server | `accordion_focused_response` | `%{"id" => id, "value" => value}` |
  | Client | `accordion-focused` on the accordion | `detail`: `id`, `value` |

  ```heex
  <.action phx-click={Corex.Accordion.focused("my-accordion", respond_to: :both)}>Focused item</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```javascript
  document.getElementById("my-accordion")?.dispatchEvent(
    new CustomEvent("corex:accordion:focused", {
      bubbles: false,
      detail: { respond_to: "both" }
    })
  );
  ```

  ```elixir
  def handle_event("accordion_focused_response", %{"id" => _id, "value" => item}, socket) do
    {:noreply, assign(socket, :focused_item, item)}
  end
  ```
  """)

  @spec focused(String.t()) :: Phoenix.LiveView.JS.t()
  @spec focused(String.t(), keyword()) :: Phoenix.LiveView.JS.t()
  @spec focused(Phoenix.LiveView.Socket.t(), String.t(), keyword()) :: Phoenix.LiveView.Socket.t()
  def focused(accordion_id, opts) when is_binary(accordion_id) and is_list(opts) do
    JS.dispatch("corex:accordion:focused",
      to: Selectors.css_id(accordion_id),
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  def focused(socket, accordion_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id),
      do: focused(socket, accordion_id, [])

  def focused(accordion_id) when is_binary(accordion_id), do: focused(accordion_id, [])

  api_doc(~S"""
  Read the focused item from `handle_event` (`accordion_focused`). Same replies as [`focused/2`](#focused/2).

  | Reply | Payload |
  | ----- | ------- |
  | `accordion_focused_response` | `%{"id" => id, "value" => value}` |

  ```heex
  <.action phx-click="read_focus">Focused item</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```elixir
  def handle_event("read_focus", _params, socket) do
    {:noreply, Corex.Accordion.focused(socket, "my-accordion", respond_to: :server)}
  end

  def handle_event("accordion_focused_response", %{"id" => _id, "value" => item}, socket) do
    {:noreply, assign(socket, :focused_item, item)}
  end
  ```
  """)

  def focused(socket, accordion_id, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "accordion_focused",
      Map.merge(%{id: accordion_id}, respond_to_fields(opts))
    )
  end

  api_doc(~S"""
  Read expanded, focused, and disabled state for one item from `phx-click`. Dispatches `corex:accordion:item-state`. Optional `disabled:` and `respond_to:` `:server` (default), `:client`, or `:both`.

  | | Reply | Payload |
  | - | ----- | ------- |
  | Server | `accordion_item_state_response` | `%{"id" => id, "value" => value, "state" => %{"expanded" => bool, "focused" => bool, "disabled" => bool}}` |
  | Client | `accordion-item-state` on the accordion | `detail`: `id`, `value`, `state` |

  ```heex
  <.action phx-click={Corex.Accordion.item_state("my-accordion", "lorem", respond_to: :both)}>State for Lorem</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```javascript
  document.getElementById("my-accordion")?.dispatchEvent(
    new CustomEvent("corex:accordion:item-state", {
      bubbles: false,
      detail: { value: "lorem", respond_to: "both" }
    })
  );
  ```

  ```elixir
  def handle_event("accordion_item_state_response", %{"id" => _id, "value" => item, "state" => state}, socket) do
    {:noreply, assign(socket, :item_state, {item, state})}
  end
  ```
  """)

  @spec item_state(String.t(), String.t()) :: Phoenix.LiveView.JS.t()
  @spec item_state(String.t(), String.t(), keyword()) :: Phoenix.LiveView.JS.t()
  @spec item_state(Phoenix.LiveView.Socket.t(), String.t(), String.t(), keyword()) ::
          Phoenix.LiveView.Socket.t()
  def item_state(accordion_id, item_value, opts)
      when is_binary(accordion_id) and is_binary(item_value) and is_list(opts) do
    disabled = Keyword.get(opts, :disabled, false)

    JS.dispatch("corex:accordion:item-state",
      to: Selectors.css_id(accordion_id),
      detail:
        Map.merge(
          %{value: accordion_validate_item_value!(item_value), disabled: disabled},
          respond_to_fields(opts)
        ),
      bubbles: false
    )
  end

  def item_state(socket, accordion_id, item_value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_binary(item_value) do
    item_state(socket, accordion_id, item_value, [])
  end

  def item_state(accordion_id, item_value)
      when is_binary(accordion_id) and is_binary(item_value) do
    item_state(accordion_id, item_value, [])
  end

  api_doc(~S"""
  Read item state from `handle_event` (`accordion_item_state`). Same replies as [`item_state/3`](#item_state/3).

  | Reply | Payload |
  | ----- | ------- |
  | `accordion_item_state_response` | `%{"id" => id, "value" => value, "state" => %{"expanded" => bool, "focused" => bool, "disabled" => bool}}` |

  ```heex
  <.action phx-click="read_lorem">State for Lorem</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```elixir
  def handle_event("read_lorem", _params, socket) do
    {:noreply, Corex.Accordion.item_state(socket, "my-accordion", "lorem", respond_to: :server)}
  end

  def handle_event("accordion_item_state_response", %{"id" => _id, "value" => item, "state" => state}, socket) do
    {:noreply, assign(socket, :item_state, {item, state})}
  end
  ```
  """)

  def item_state(socket, accordion_id, item_value, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_binary(item_value) and is_list(opts) do
    disabled = Keyword.get(opts, :disabled, false)

    LiveView.push_event(
      socket,
      "accordion_item_state",
      Map.merge(
        %{
          id: accordion_id,
          value: accordion_validate_item_value!(item_value),
          disabled: disabled
        },
        respond_to_fields(opts)
      )
    )
  end

  defp accordion_validate_item_value!(v) when is_binary(v) and byte_size(v) > 0, do: v

  defp accordion_validate_item_value!(_),
    do: raise(ArgumentError, "accordion item value must be a non-empty string")

  defp accordion_assert_trigger_content_pair!(assigns) do
    if not assigns.compound and Enum.empty?(assigns.items) do
      tri = assigns.trigger != []
      con = assigns.content != []

      if tri != con do
        raise ArgumentError,
              "Accordion with an empty :items list requires both :trigger and :content slots together, or use :items."
      end
    end

    assigns
  end

  defp accordion_assign_manual_mode!(assigns) do
    if manual_accordion_mode?(assigns) do
      panels =
        Corex.Slot.resolve_panels!(
          %{trigger: assigns.trigger, content: assigns.content, indicator: assigns.indicator},
          required: [:trigger, :content],
          optional: [:indicator],
          disabled: &accordion_panel_disabled?/1,
          component: "Accordion"
        )

      assigns
      |> assign(:accordion_manual_mode, true)
      |> assign(:accordion_manual_panels, panels)
    else
      assigns
      |> assign(:accordion_manual_mode, false)
      |> assign(:accordion_manual_panels, [])
    end
  end

  defp manual_accordion_mode?(assigns) do
    not assigns.compound and Enum.empty?(assigns.items) and assigns.trigger != [] and
      assigns.content != []
  end

  defp accordion_panel_disabled?(entries) do
    entries
    |> Map.take([:trigger, :content])
    |> Map.values()
    |> Enum.any?(&truthy_disabled?/1)
  end

  defp truthy_disabled?(nil), do: false
  defp truthy_disabled?(entry), do: Map.get(entry, :disabled, false) == true

  defp accordion_assign_panels(assigns) do
    panels =
      cond do
        assigns.compound ->
          []

        assigns.accordion_manual_mode ->
          Enum.map(assigns.accordion_manual_panels, fn p ->
            %{
              source: :slots,
              value: p.value,
              disabled: p.disabled,
              trigger_slot: p.trigger,
              content_slot: p.content,
              indicator_slot: p.indicator
            }
          end)

        true ->
          assigns.items
          |> Enum.with_index()
          |> Enum.map(fn {entry, index} ->
            %{
              source: :items,
              value: entry.value || "item-#{index}",
              disabled: entry.disabled,
              item_entry: entry
            }
          end)
      end

    assign(assigns, :panels, panels)
  end

  defp accordion_panel_has_indicator?(%{source: :slots, indicator_slot: slot}, _top), do: !!slot
  defp accordion_panel_has_indicator?(%{source: :items}, top_indicator), do: top_indicator != []

  defp panel_source_label(%{source: :items, item_entry: %{label: label}}) when is_binary(label),
    do: label

  defp panel_source_label(_), do: nil

  defp accordion_value_list(nil), do: []
  defp accordion_value_list(v) when is_binary(v), do: [v]
  defp accordion_value_list(v) when is_list(v), do: v
  defp accordion_value_list(_), do: []
end
