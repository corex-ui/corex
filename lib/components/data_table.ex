defmodule Corex.DataTable do
  @moduledoc ~S'''
  Renders a table with data based on Phoenix Core Components.
  '''

  defmodule Translation do
    @moduledoc """
    Translation struct for DataTable component strings.

    Without gettext: `translation={%DataTable.Translation{ actions: "Actions", select_all: "Select all", select_row: "Select row" }}`

    With gettext: `translation={%DataTable.Translation{ actions: gettext("Actions"), select_all: gettext("Select all"), select_row: gettext("Select row") }}`
    """
    defstruct [:actions, :select_all, :select_row]
  end

  @doc type: :component
  use Phoenix.Component
  import Corex.Gettext, only: [gettext: 1]

  @doc ~S'''
   Renders a table with data.

   ## Examples

   <!-- tabs-open -->

   ### Basic

   ```heex
   <.data_table id="basic-table" class="data-table" rows={@list_rows}>
     <:col :let={row} label="ID">{row.id}</:col>
     <:col :let={row} label="Name">{row.name}</:col>
     <:col :let={row} label="Role">{row.role}</:col>
     <:col :let={row} label="Email">{row.email}</:col>
   </.data_table>
   ```

   ### Actions

   Use the `:action` slot to add actions for each row, like Edit and Delete buttons.

   ```heex
   <.data_table id="basic-table" class="data-table" rows={@list_rows}>
     <:col :let={row} label="ID">{row.id}</:col>
     <:col :let={row} label="Name">{row.name}</:col>
     <:col :let={row} label="Role">{row.role}</:col>
     <:col :let={row} label="Email">{row.email}</:col>
     <:action :let={row}>
       <.action phx-click="edit" phx-value-id={row.id}>Edit</.action>
       <.action phx-click="delete" phx-value-id={row.id}>Delete</.action>
     </:action>
   </.data_table>
   ```

   ### Streaming

   Pass the stream to `rows`. Column slot receives `{id, item}`. Items need an `:id` field (or use `stream_configure/3` with `:dom_id`). Add rows with `stream_insert/3`.

   ```elixir
   # mount
   socket |> stream(:items, []) |> assign(:next_id, 1)
   ```

   ```heex
   <.data_table id="my-table" class="data-table" rows={@streams.items}>
     <:col :let={{_id, item}} label="Name">{item.name}</:col>
   </.data_table>
   ```

   Add a row: `stream_insert(socket, :items, %{id: id, name: "New"})` from `handle_event` or `handle_info`.


   ### Sortable

   Set `sort_by`, `sort_order`, `on_sort`; give each sortable column a `name`. You still need `handle_event("sort", ...)` but delegate to the helper. LiveView minimum:

   ```elixir
   # mount
   socket
   |> assign(:users, users)
   |> Corex.DataTable.Sort.assign_for_sort(:users, default_sort_by: :id, default_sort_order: :asc)

   # handle_event("sort", params, socket)
   {:noreply, Corex.DataTable.Sort.handle_sort(socket, params, :users)}
   ```

   ```heex
   <.data_table id="users-sortable" class="data-table" rows={@users} sort_by={@sort_by} sort_order={@sort_order} on_sort="sort">
     <:col :let={user} label="ID" name={:id}>{user.id}</:col>
     <:col :let={user} label="Name" name={:name}>{user.name}</:col>
     <:sort_icon :let={%{direction: direction}}>
       <.heroicon name={%{asc: "hero-chevron-up", desc: "hero-chevron-down", none: "hero-chevron-up-down"}[direction]} />
     </:sort_icon>
   </.data_table>
   ```

   ### Selectable

   Set `selectable`, `selected`, `on_select`, `on_select_all`, and `row_id`. Delegate to `Corex.DataTable.Selection` in mount and in the two events. LiveView minimum:

   ```elixir
   # mount
   socket
   |> assign(:users, users)
   |> Corex.DataTable.Selection.assign_for_selection(:users, table_id: "users-table", row_id: &"user-#{&1.id}")

   def handle_event("select", params, socket) do
     {:noreply, Corex.DataTable.Selection.handle_select(socket, params, :users)}
   end

   def handle_event("select_all", params, socket) do
     {:noreply, Corex.DataTable.Selection.handle_select_all(socket, params, :users)}
   end
   ```

   ```heex
   <.data_table
     id="users-table"
     class="data-table"
     rows={@users}
     row_id={&"user-#{&1.id}"}
     selectable={true}
     selected={@selected}
     on_select="select"
     on_select_all="select_all"
     checkbox_class="checkbox"
   >
     <:checkbox_indicator>
       <.heroicon name="hero-check" class="data-checked" />
     </:checkbox_indicator>
     <:col :let={user} label="ID" name={:id}>{user.id}</:col>
     <:col :let={user} label="Name" name={:name}>{user.name}</:col>
     <:col :let={user} label="Email" name={:email}>{user.email}</:col>
   </.data_table>
   ```


   <!-- tabs-close -->

   ## Styling

   Use data attributes to target elements:

   ```css
   [data-scope="data-table"][data-part="root"] {}
   [data-scope="data-table"][data-part="thead"] {}
   [data-scope="data-table"][data-part="tbody"] {}
   [data-scope="data-table"][data-part="row"] {}
   [data-scope="data-table"][data-part="cell"] {}
   [data-scope="data-table"][data-part="sort-header"] {}
   [data-scope="data-table"][data-part="sort-text"] {}
   [data-scope="data-table"][data-part="sort-icon-container"] {}
   [data-scope="data-table"][data-part="sort-trigger"] {}
   [data-scope="data-table"][data-part="selection-header"] {}
   [data-scope="data-table"][data-part="selection-cell"] {}
   [data-scope="data-table"][data-part="action-header"] {}
   [data-scope="data-table"][data-part="actions"] {}
   ```

   If you wish to use the default Corex styling, you can use the class `data-table` on the component.
   This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

   ```css
   @import "../corex/main.css";
   @import "../corex/tokens/themes/neo/light.css";
   @import "../corex/components/data-table.css";
   ```
  '''

  attr(:id, :string, required: true, doc: "The id of the table, used for LiveStream updates")
  attr(:rows, :list, required: true, doc: "The list of row data to render")
  attr(:row_id, :any, default: nil, doc: "the function for generating the row id")
  attr(:row_click, :any, default: nil, doc: "the function for handling phx-click on each row")

  attr(:row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"
  )

  attr(:translation, Corex.DataTable.Translation, doc: "Override translatable strings")

  attr(:sort_by, :atom, default: nil, doc: "The currently sorted column name")

  attr(:sort_order, :atom,
    default: :asc,
    values: [:asc, :desc],
    doc: "The current sort direction"
  )

  attr(:on_sort, :any,
    default: nil,
    doc: "The event to trigger when a sortable header is clicked"
  )

  attr(:selectable, :boolean, default: false, doc: "Whether the rows are selectable")
  attr(:selected, :list, default: [], doc: "The list of currently selected row IDs")
  attr(:on_select, :any, default: nil, doc: "The event to trigger when a single row is selected")

  attr(:on_select_all, :any,
    default: nil,
    doc: "The event to trigger when the select all checkbox is toggled"
  )

  attr(:checkbox_class, :string,
    default: nil,
    doc: "The class applied to the internal checkboxes"
  )

  attr(:rest, :global)

  slot :col, required: true do
    attr(:label, :string)
    attr(:class, :string, required: false)
    attr(:name, :atom, required: false, doc: "The field name used for sorting")
  end

  slot :sort_icon, doc: "the slot for showing the sort icon" do
    attr(:direction, :atom, doc: "the current sort direction (:asc or :desc)")
  end

  slot :action, doc: "the slot for showing user actions in the last table column" do
    attr(:class, :string, required: false)
  end

  slot(:checkbox_indicator, doc: "the slot for showing the checkbox indicator icon")

  def data_table(assigns) do
    assigns =
      assigns
      |> assign_new(:translation, fn ->
        %Translation{
          actions: gettext("Actions"),
          select_all: gettext("Select all"),
          select_row: gettext("Select row")
        }
      end)
      |> resolve_row_id()

    ~H"""
    <div {@rest}>
      <table data-scope="data-table" data-part="root">
        <thead data-scope="data-table" data-part="thead">
          <tr>
            <th :if={@selectable} data-scope="data-table" data-part="selection-header" scope="col" aria-label={@translation.select_all}>
              <Corex.Checkbox.checkbox
                id={"#{@id}-select-all"}
                class={@checkbox_class}
                checked={is_list(@rows) && @selected != [] && length(@selected) == length(@rows)}
                on_checked_change={@on_select_all}
                controlled={true}
                aria_label={@translation.select_all}
              >
                <:indicator :if={@checkbox_indicator != []}>
                  {render_slot(@checkbox_indicator)}
                </:indicator>
              </Corex.Checkbox.checkbox>
            </th>
            <th :for={col <- @col} data-scope="data-table" data-part="cell">
              <div :if={@on_sort != nil && col[:name]} data-scope="data-table" data-part="sort-header">
                <span data-scope="data-table" data-part="sort-text">{col[:label]}</span>
                <span data-scope="data-table" data-part="sort-icon-container">
                  <button
                    phx-click={@on_sort}
                    phx-value-sort_by={col[:name]}
                    aria-label={"Sort by #{col[:label]}"}
                    data-scope="data-table"
                    data-part="sort-trigger"
                    data-active={to_string(@sort_by == col[:name])}
                  >
                    <%= if @sort_icon != [] do %>
                      <%= for icon <- @sort_icon do %>
                        {render_slot(icon, %{direction: if(@sort_by == col[:name], do: @sort_order, else: :none)})}
                      <% end %>
                    <% end %>
                  </button>
                </span>
              </div>
              <span :if={@on_sort == nil || is_nil(col[:name])}>
                {col[:label]}
              </span>
            </th>
            <th :if={@action != []} data-scope="data-table" data-part="action-header">
              {@translation.actions}
            </th>
          </tr>
        </thead>
        <tbody data-scope="data-table" data-part="tbody" id={@id} phx-update={is_struct(@rows, Phoenix.LiveView.LiveStream) && "stream"}>
          <tr :for={row <- @rows} id={@row_id && @row_id.(row)} data-scope="data-table" data-part="row" style={@row_click && "cursor: pointer"}>
            <td :if={@selectable} data-scope="data-table" data-part="selection-cell">
              <Corex.Checkbox.checkbox
                id={"#{@id}-select-#{if @row_id, do: @row_id.(row), else: inspect(row)}"}
                class={@checkbox_class}
                name={to_string(if @row_id, do: @row_id.(row), else: inspect(row))}
                value={to_string(if @row_id, do: @row_id.(row), else: inspect(row))}
                phx-value-id={if @row_id, do: @row_id.(row), else: inspect(row)}
                checked={(if @row_id, do: @row_id.(row), else: inspect(row)) in @selected}
                on_checked_change={@on_select}
                controlled={true}
                aria_label={@translation.select_row}
              >
                <:indicator :if={@checkbox_indicator != []}>
                  {render_slot(@checkbox_indicator)}
                </:indicator>
              </Corex.Checkbox.checkbox>
            </td>
            <td
              :for={col <- @col}
              phx-click={@row_click && @row_click.(row)}
              data-scope="data-table"
              data-part="cell"
            >
              {render_slot(col, @row_item.(row))}
            </td>
            <td :if={@action != []} data-scope="data-table" data-part="cell">
              <div data-scope="data-table" data-part="actions">
                <%= for action <- @action do %>
                  {render_slot(action, @row_item.(row))}
                <% end %>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  defp resolve_row_id(%{rows: %Phoenix.LiveView.LiveStream{}} = assigns) do
    assign(assigns, :row_id, assigns.row_id || fn {id, _item} -> id end)
  end

  defp resolve_row_id(assigns), do: assigns
end
