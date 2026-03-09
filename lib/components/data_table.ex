defmodule Corex.DataTable do
  @moduledoc ~S'''
  Renders a table with data based on Phoenix Core Components.
  '''

  defmodule Translation do
    @moduledoc """
    Translation struct for DataTable component strings.

    Without gettext: `translation={%DataTable.Translation{ actions: "Actions" }}`

    With gettext: `translation={%DataTable.Translation{ actions: gettext("Actions") }}`
    """
    defstruct [:actions]
  end

  @doc type: :component
  use Phoenix.Component
  import Corex.Gettext, only: [gettext: 1]

  @doc """
  Renders a table with data.

  ## Examples

      <.data_table id="users" rows={@users}>
        <:col :let={user} label="id">{user.id}</:col>
        <:col :let={user} label="username">{user.username}</:col>
      </.data_table>
  """
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

  def data_table(assigns) do
    assigns =
      assigns
      |> assign_new(:translation, fn -> %Translation{actions: gettext("Actions")} end)
      |> resolve_row_id()

    ~H"""
    <div {@rest}>
      <table data-scope="data-table" data-part="root">
        <thead data-scope="data-table" data-part="thead">
          <tr>
            <th :for={col <- @col} data-scope="data-table" data-part="cell">
              <div :if={@on_sort != nil && col[:name]} data-scope="data-table" data-part="sort-header">
                <span data-scope="data-table" data-part="sort-text">{col[:label]}</span>
                <button
                  phx-click={@on_sort}
                  phx-value-sort_by={col[:name]}
                  data-scope="data-table"
                  data-part="sort-trigger"
                >
                  <%= if @sort_by == col[:name] && @sort_icon != [] do %>
                    <%= for icon <- @sort_icon do %>
                      {render_slot(icon, %{direction: @sort_order})}
                    <% end %>
                  <% end %>
                </button>
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
          <tr :for={row <- @rows} id={@row_id && @row_id.(row)} data-scope="data-table" data-part="row">
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
