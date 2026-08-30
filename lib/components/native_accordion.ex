defmodule Corex.NativeAccordion do
  @moduledoc ~S'''
  Experimental accordion driven by LiveView JS command pipes — **no `phx-hook`, no Zag.js**.

  Same `data-scope="accordion"` anatomy as `Corex.Accordion`, so Corex Design CSS applies.
  Prefer `Corex.Accordion` for production a11y parity with Zag; use this module to explore
  server-owned or pure-`JS` behavior and LiveViewTest coverage without Wallaby.

  ## Controlled (default)

  LiveView owns open items via `value` + `on_value_change`. Triggers push a toggle event;
  handle it with `handle_toggle/4` (or your own assign update).

  ```heex
  <.native_accordion
    id="faq"
    class="accordion"
    controlled
    value={@open}
    on_value_change="faq_toggle"
    multiple={false}
    items={
      Corex.Content.new([
        %{value: "lorem", label: "Lorem", content: "Body one."},
        %{value: "duis", label: "Duis", content: "Body two."}
      ])
    }
  >
    <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
  </.native_accordion>
  ```

  ```elixir
  def handle_event("faq_toggle", params, socket) do
    {:noreply, Corex.NativeAccordion.handle_toggle(socket, :open, params, multiple: false)}
  end
  ```

  ## Uncontrolled

  Set `controlled={false}`. Clicks run client `JS` pipes (`toggle_item/3`) with no round trip.
  Query APIs (`value/1`, `focused/1`, …) are **not** implemented — those stay on Zag accordion.

  ## Keyboard (vertical MVP)

  Enter/Space activate the focused trigger (native button). ArrowDown/ArrowUp/Home/End move
  focus between triggers via `JS.focus` (no hook). Horizontal / RTL arrow mapping is deferred.

  ## Parity gaps vs `Corex.Accordion`

  | Feature | Zag Accordion | Native Accordion |
  | -------- | ------------- | ---------------- |
  | Hook / Zag machine | Yes | No |
  | Controlled / uncontrolled | Yes (default uncontrolled) | Yes (default **controlled**) |
  | `set_value` client/server | Machine API | Client `JS` / assign helpers |
  | `value` / `focused` / `item_state` queries | Yes | Not implemented |
  | `on_focus_change*` / `on_value_change_client` | Yes | Not implemented |
  | Height `animation: "js"` | Yes | Instant only |
  | Horizontal + RTL keys | Yes | Deferred |
  '''

  use Phoenix.Component
  use Corex.Component, [:connect]

  alias Corex.NativeAccordion.Ids
  alias Corex.NativeAccordion.JS, as: AccordionJS
  alias Corex.NativeAccordion.State
  alias Phoenix.LiveView.JS

  @doc """
  Apply a controlled toggle from an `on_value_change` push.

  Expects params `%{"item" => item}` (and optional `"id"`). Updates `assign_key` on the socket.
  """
  @spec handle_toggle(Phoenix.LiveView.Socket.t(), atom(), map(), keyword()) ::
          Phoenix.LiveView.Socket.t()
  def handle_toggle(socket, assign_key, params, opts \\ [])
      when is_atom(assign_key) and is_map(params) and is_list(opts) do
    item = params["item"] || params[:item]
    multiple? = Keyword.get(opts, :multiple, true)
    collapsible? = Keyword.get(opts, :collapsible, true)

    if is_binary(item) do
      current = State.value_list(socket.assigns[assign_key])

      next =
        State.toggle(current, item, multiple: multiple?, collapsible: collapsible?)

      Phoenix.Component.assign(socket, assign_key, next)
    else
      socket
    end
  end

  @doc """
  Client helper: uncontrolled `set_value` via JS attribute pipes.
  Pass `all_values:` so closed items are cleared.
  """
  @spec set_value(String.t(), term(), keyword()) :: JS.t()
  defdelegate set_value(accordion_id, value, opts \\ []), to: AccordionJS

  @doc """
  Uncontrolled toggle JS for one item.
  """
  @spec toggle_item(String.t(), String.t(), keyword()) :: JS.t()
  defdelegate toggle_item(accordion_id, item_value, opts \\ []), to: AccordionJS

  attr(:id, :string,
    required: false,
    doc: "Stable DOM id. Required for controlled mode and JS targeting."
  )

  attr(:items, :list,
    default: [],
    doc: "Items from `Corex.Content.new/1`"
  )

  attr(:value, :any,
    default: [],
    doc: "Open item values (string or list). Source of truth when `controlled`."
  )

  attr(:compound, :boolean, default: false, doc: "Enable compound mode with `:let={ctx}`.")

  attr(:controlled, :boolean,
    default: true,
    doc: "When true (default), LiveView owns open state via `value` + `on_value_change`."
  )

  attr(:collapsible, :boolean, default: true, doc: "Whether an open item can be closed.")

  attr(:multiple, :boolean,
    default: true,
    doc: "Whether multiple items may be open."
  )

  attr(:orientation, :string,
    default: "vertical",
    values: ["horizontal", "vertical"],
    doc: "Orientation (keyboard arrows are vertical-only in this spike)."
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "Text direction."
  )

  attr(:on_value_change, :string,
    default: nil,
    doc: "LiveView event for controlled toggles. Required when `controlled`."
  )

  attr(:focused_value, :string,
    default: nil,
    doc: "Optional roving-tabindex focus value (defaults to first enabled open/closed item)."
  )

  attr(:rest, :global)

  slot(:inner_block,
    required: false,
    doc: "Compound mode content. `ctx` keys: `id`, `values`, `orientation`, `dir`, `item_values`, `disabled_values`, `controlled`, `multiple`, `collapsible`, `on_value_change`, `focused_value`."
  )

  slot :indicator, required: false do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
  end

  slot :trigger, required: false do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
    attr(:disabled, :boolean, required: false)
  end

  slot :content, required: false do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
    attr(:disabled, :boolean, required: false)
  end

  def native_accordion(assigns) do
    assigns =
      assigns
      |> Corex.FormField.assign_stable_id("native-accordion")
      |> update(:value, &State.value_list/1)
      |> then(fn assigns ->
        if not assigns.compound and Enum.empty?(assigns.items) and
             assigns.trigger == [] and assigns.content == [] do
          Corex.Content.assert_content_items!(assigns, "NativeAccordion")
        else
          assigns
        end
      end)
      |> then(&assert_trigger_content_pair!/1)
      |> then(&assign_manual_mode!/1)
      |> then(&assign_panels/1)
      |> then(&assign_navigation/1)
      |> then(&maybe_warn_controlled!/1)

    ctx = %{
      id: assigns.id,
      values: assigns.value,
      orientation: assigns.orientation,
      dir: assigns.dir,
      item_values: assigns.item_values,
      disabled_values: assigns.disabled_values,
      controlled: assigns.controlled,
      multiple: assigns.multiple,
      collapsible: assigns.collapsible,
      on_value_change: assigns.on_value_change,
      focused_value: assigns.focused_value
    }

    assigns = assign(assigns, :ctx, ctx)

    ~H"""
    <div
      id={@id}
      data-scope="accordion"
      data-native=""
      data-controlled={presence_attr(@controlled)}
      data-collapsible={presence_attr(@collapsible)}
      data-multiple={presence_attr(@multiple)}
      data-orientation={@orientation}
      data-value={Enum.join(@value, ",")}
      {dir_attrs(@dir)}
      {@rest}
    >
      {if @compound, do: render_slot(@inner_block, @ctx)}

      <div
        :if={not @compound}
        id={Ids.root_id(@id)}
        data-scope="accordion"
        data-part="root"
        data-orientation={@orientation}
        {dir_attrs(@dir)}
      >
        <.native_accordion_item
          :for={panel <- @panels}
          ctx={@ctx}
          value={panel.value}
          disabled={panel.disabled}
          label={panel_source_label(panel)}
          :let={item}
        >
          <.native_accordion_trigger item={item}>
            {cond do
              panel.source == :slots -> render_slot(panel.trigger_slot)
              @trigger != [] -> render_slot(@trigger, panel.item_entry)
              true -> panel.item_entry.label
            end}
            <:indicator :if={panel_has_indicator?(panel, @indicator)}>
              <.native_accordion_indicator item={item}>
                {if panel.source == :slots,
                  do: render_slot(panel.indicator_slot),
                  else: render_slot(@indicator, panel.item_entry)}
              </.native_accordion_indicator>
            </:indicator>
          </.native_accordion_trigger>

          <.native_accordion_content item={item}>
            {cond do
              panel.source == :slots -> render_slot(panel.content_slot)
              @content != [] -> render_slot(@content, panel.item_entry)
              true -> nil
            end}
            <p :if={panel.source == :items and @content == []}>{panel.item_entry.content}</p>
          </.native_accordion_content>
        </.native_accordion_item>
      </div>
    </div>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def native_accordion_root(assigns) do
    ~H"""
    <div
      id={Ids.root_id(@ctx.id)}
      data-scope="accordion"
      data-part="root"
      data-orientation={@ctx.orientation}
      {dir_attrs(@ctx.dir)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:value, :string, required: true)
  attr(:disabled, :boolean, default: false)
  attr(:label, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def native_accordion_item(assigns) do
    expanded = assigns.value in assigns.ctx.values

    item = %{
      id: assigns.ctx.id,
      value: assigns.value,
      disabled: assigns.disabled,
      values: assigns.ctx.values,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir,
      label: assigns.label,
      expanded: expanded,
      item_values: assigns.ctx.item_values,
      disabled_values: assigns.ctx.disabled_values,
      controlled: assigns.ctx.controlled,
      multiple: assigns.ctx.multiple,
      collapsible: assigns.ctx.collapsible,
      on_value_change: assigns.ctx.on_value_change,
      focused_value: assigns.ctx.focused_value,
      prev_value: neighbor(assigns.ctx, assigns.value, :prev),
      next_value: neighbor(assigns.ctx, assigns.value, :next),
      first_value: neighbor(assigns.ctx, assigns.value, :first),
      last_value: neighbor(assigns.ctx, assigns.value, :last)
    }

    assigns = assign(assigns, :item, item)

    ~H"""
    <div
      id={Ids.item_id(@item.id, @item.value)}
      data-scope="accordion"
      data-part="item"
      data-value={@item.value}
      data-disabled={presence_attr(@item.disabled)}
      data-orientation={@item.orientation}
      data-state={if(@item.expanded, do: "open", else: "closed")}
      {dir_attrs(@item.dir)}
      {@rest}
    >
      {render_slot(@inner_block, @item)}
    </div>
    """
  end

  attr(:item, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)
  slot(:indicator, required: false)

  def native_accordion_trigger(assigns) do
    item = assigns.item
    click_js = trigger_click_js(item)
    tab = if item.focused_value == item.value or (is_nil(item.focused_value) and item.value == item.first_value), do: "0", else: "-1"

    assigns =
      assigns
      |> assign(:click_js, click_js)
      |> assign(:tabindex, tab)
      |> assign(:trigger_dom_id, Ids.trigger_id(item.id, item.value))

    ~H"""
    <h3
      phx-keydown={AccordionJS.focus_item(@item.id, @item.first_value)}
      phx-key="Home"
    >
      <div phx-keydown={AccordionJS.focus_item(@item.id, @item.last_value)} phx-key="End">
        <div
          phx-keydown={AccordionJS.focus_item(@item.id, @item.prev_value)}
          phx-key="ArrowUp"
        >
          <button
            id={@trigger_dom_id}
            type="button"
            data-scope="accordion"
            data-part="item-trigger"
            data-orientation={@item.orientation}
            data-state={if(@item.expanded, do: "open", else: "closed")}
            data-controls={Ids.content_id(@item.id, @item.value)}
            data-ownedby={Ids.root_id(@item.id)}
            aria-expanded={if(@item.expanded, do: "true", else: "false")}
            aria-controls={Ids.content_id(@item.id, @item.value)}
            aria-disabled={if(@item.disabled, do: "true", else: "false")}
            disabled={@item.disabled}
            tabindex={@tabindex}
            phx-click={@click_js}
            phx-keydown={AccordionJS.focus_item(@item.id, @item.next_value)}
            phx-key="ArrowDown"
            {dir_attrs(@item.dir)}
            {@rest}
          >
            <span data-scope="accordion" data-part="item-text">
              {render_slot(@inner_block)}
            </span>
            {render_slot(@indicator)}
          </button>
        </div>
      </div>
    </h3>
    """
  end

  attr(:item, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def native_accordion_indicator(assigns) do
    ~H"""
    <span
      id={Ids.indicator_id(@item.id, @item.value)}
      data-scope="accordion"
      data-part="item-indicator"
      aria-hidden="true"
      data-state={if(@item.expanded, do: "open", else: "closed")}
      data-disabled={presence_attr(@item.disabled)}
      data-orientation={@item.orientation}
      {dir_attrs(@item.dir)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr(:item, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def native_accordion_content(assigns) do
    ~H"""
    <div
      id={Ids.content_id(@item.id, @item.value)}
      data-scope="accordion"
      data-part="item-content"
      role="region"
      tabindex="0"
      data-state={if(@item.expanded, do: "open", else: "closed")}
      data-disabled={presence_attr(@item.disabled)}
      data-orientation={@item.orientation}
      aria-labelledby={Ids.trigger_id(@item.id, @item.value)}
      hidden={if(@item.expanded, do: nil, else: true)}
      {dir_attrs(@item.dir)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp trigger_click_js(%{disabled: true}), do: %JS{}

  defp trigger_click_js(%{controlled: true, on_value_change: event} = item)
       when is_binary(event) and event != "" do
    AccordionJS.push_toggle(event, item.id, item.value)
  end

  defp trigger_click_js(%{controlled: true}), do: %JS{}

  defp trigger_click_js(item) do
    AccordionJS.toggle_item(item.id, item.value,
      multiple: item.multiple,
      sibling_values: item.item_values
    )
  end

  defp neighbor(ctx, current, direction) do
    State.next_item(ctx.item_values, current, ctx.disabled_values, direction) || current
  end

  defp dir_attrs(dir) when dir in ["ltr", "rtl"], do: %{"dir" => dir, "data-dir" => dir}
  defp dir_attrs(_), do: %{}

  defp maybe_warn_controlled!(assigns) do
    if assigns.controlled and
         (is_nil(assigns.on_value_change) or assigns.on_value_change == "") do
      IO.warn(
        "Corex.NativeAccordion id=#{inspect(assigns.id)} is controlled but on_value_change is nil; clicks will no-op"
      )
    end

    assigns
  end

  defp assert_trigger_content_pair!(assigns) do
    if not assigns.compound and Enum.empty?(assigns.items) do
      tri = assigns.trigger != []
      con = assigns.content != []

      if tri != con do
        raise ArgumentError,
              "NativeAccordion with an empty :items list requires both :trigger and :content slots together, or use :items."
      end
    end

    assigns
  end

  defp assign_manual_mode!(assigns) do
    if not assigns.compound and Enum.empty?(assigns.items) and assigns.trigger != [] and
         assigns.content != [] do
      panels =
        Corex.Slot.resolve_panels!(
          %{trigger: assigns.trigger, content: assigns.content, indicator: assigns.indicator},
          required: [:trigger, :content],
          optional: [:indicator],
          disabled: &panel_disabled?/1,
          component: "NativeAccordion"
        )

      assigns
      |> assign(:manual_mode, true)
      |> assign(:manual_panels, panels)
    else
      assigns
      |> assign(:manual_mode, false)
      |> assign(:manual_panels, [])
    end
  end

  defp panel_disabled?(entries) do
    entries
    |> Map.take([:trigger, :content])
    |> Map.values()
    |> Enum.any?(fn
      nil -> false
      entry -> Map.get(entry, :disabled, false) == true
    end)
  end

  defp assign_panels(assigns) do
    panels =
      cond do
        assigns.compound ->
          []

        assigns.manual_mode ->
          Enum.map(assigns.manual_panels, fn p ->
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

  defp assign_navigation(assigns) do
    item_values = Enum.map(assigns.panels, & &1.value)
    disabled_values = for p <- assigns.panels, p.disabled, do: p.value

    focused =
      cond do
        is_binary(assigns.focused_value) and assigns.focused_value in item_values ->
          assigns.focused_value

        true ->
          State.next_item(item_values, List.first(item_values) || "", disabled_values, :first)
      end

    assigns
    |> assign(:item_values, item_values)
    |> assign(:disabled_values, disabled_values)
    |> assign(:focused_value, focused)
  end

  defp panel_has_indicator?(%{source: :slots, indicator_slot: slot}, _top), do: !!slot
  defp panel_has_indicator?(%{source: :items}, top_indicator), do: top_indicator != []

  defp panel_source_label(%{source: :items, item_entry: %{label: label}}) when is_binary(label),
    do: label

  defp panel_source_label(_), do: nil
end
