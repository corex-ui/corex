defmodule Corex.DataTable do
  @moduledoc ~S'''
  Renders a table with data based on Phoenix Core Components.
  '''

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
  attr(:id, :string, required: true)
  attr(:rows, :list, required: true)
  attr(:row_id, :any, default: nil, doc: "the function for generating the row id")
  attr(:row_click, :any, default: nil, doc: "the function for handling phx-click on each row")

  attr(:row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"
  )

  slot :col, required: true do
    attr(:label, :string)
  end

  slot(:action, doc: "the slot for showing user actions in the last table column")

  def data_table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <table data-scope="data-table" data-part="root">
      <thead data-scope="data-table" data-part="thead">
        <tr>
          <th :for={col <- @col} data-scope="data-table" data-part="cell">{col[:label]}</th>
          <th :if={@action != []} data-scope="data-table" data-part="cell">
            <span class="sr-only">{gettext("Actions")}</span>
          </th>
        </tr>
      </thead>
      <tbody data-scope="data-table" data-part="tbody" id={@id} phx-update={is_struct(@rows, Phoenix.LiveView.LiveStream) && "stream"}>
        <tr :for={row <- @rows} id={@row_id && @row_id.(row)} data-scope="data-table" data-part="row">
          <td
            :for={col <- @col}
            phx-click={@row_click && @row_click.(row)}
            class={@row_click && "hover:cursor-pointer"}
            data-scope="data-table"
            data-part="cell"
          >
            {render_slot(col, @row_item.(row))}
          </td>
          <td :if={@action != []} class="w-0 font-semibold" data-scope="data-table" data-part="cell">
            <div class="flex gap-4">
              <%= for action <- @action do %>
                {render_slot(action, @row_item.(row))}
              <% end %>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    """
  end
end
