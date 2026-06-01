defmodule Corex.DataTableTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.DataTable
  alias Phoenix.LiveView.JS

  defp cols do
    [
      %{label: "Name", name: :name, inner_block: fn _assigns, row -> row.name end}
    ]
  end

  describe "data_table/1" do
    test "renders basic table" do
      assigns = %{
        rows: [
          %{id: 1, name: "Alice"},
          %{id: 2, name: "Bob"}
        ]
      }

      html =
        render_component(&DataTable.data_table/1,
          id: "users",
          rows: assigns.rows,
          col: [
            %{label: "ID", name: :id, inner_block: fn _assigns, row -> row.id end},
            %{label: "Name", name: :name, inner_block: fn _assigns, row -> row.name end}
          ]
        )

      assert html =~ ~S(data-scope="data-table")
      assert html =~ ~S(data-part="root")
      assert html =~ ~S(data-part="thead")
      assert html =~ ~S(data-part="tbody")
      assert html =~ ~S(data-part="row")
      assert html =~ ~S(data-part="cell")

      assert html =~ "Alice"
      assert html =~ "Bob"
      assert html =~ "ID"
      assert html =~ "Name"
    end

    test "renders sortable headers when on_sort is provided" do
      assigns = %{
        rows: [%{id: 1, name: "Alice"}]
      }

      html =
        render_component(&DataTable.data_table/1,
          id: "users",
          rows: assigns.rows,
          sort_by: :name,
          sort_order: :asc,
          on_sort: "sort_event",
          col: [
            %{label: "Name", name: :name, inner_block: fn _assigns, row -> row.name end}
          ]
        )

      assert html =~ ~S(data-part="sort-header")
      assert html =~ ~S(data-part="sort-trigger")
      assert html =~ ~S(phx-click="sort_event")
      assert html =~ ~S(phx-value-sort_by="name")
      assert html =~ ~S(data-active="true")
    end

    test "renders selectable checkboxes when selectable is true" do
      assigns = %{
        rows: [%{id: 1, name: "Alice"}, %{id: 2, name: "Bob"}],
        selected: ["user-1"]
      }

      html =
        render_component(&DataTable.data_table/1,
          id: "users",
          rows: assigns.rows,
          row_id: fn row -> "user-#{row.id}" end,
          selectable: true,
          selected: assigns.selected,
          col: [
            %{label: "Name", name: :name, inner_block: fn _assigns, row -> row.name end}
          ]
        )

      assert html =~ ~S(data-part="selection-header")
      assert html =~ ~S(data-part="selection-cell")

      # Check for header checkbox
      assert html =~ ~S(id="users-select-all")

      # Check for individual row checkboxes
      assert html =~ ~S(id="users-select-user-1")
      assert html =~ ~S(id="users-select-user-2")

      # Check that the selected row is checked (rendered as checked or with checked inside)
      assert html =~ ~S(value="user-1")
    end

    test "renders actions in the last column" do
      assigns = %{
        rows: [%{id: 1, name: "Alice"}]
      }

      html =
        render_component(&DataTable.data_table/1,
          id: "users",
          rows: assigns.rows,
          col: [
            %{label: "Name", name: :name, inner_block: fn _assigns, row -> row.name end}
          ],
          action: [
            %{inner_block: fn _assigns, row -> "Edit #{row.name}" end}
          ]
        )

      assert html =~ ~S(data-part="action-header")
      assert html =~ ~S(data-part="action-cell")
      assert html =~ ~S(data-part="actions")
      assert html =~ "Edit Alice"
    end

    test "renders dir on wrapper" do
      html =
        render_component(&DataTable.data_table/1,
          id: "users",
          dir: "rtl",
          rows: [%{id: 1, name: "Alice"}],
          col: [
            %{label: "Name", inner_block: fn _assigns, row -> row.name end}
          ]
        )

      assert html =~ ~S(dir="rtl")
    end

    test "renders empty slot when there are no rows" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <DataTable.data_table id="users" rows={assigns.rows}>
              <:col :let={row} label="Name" name={:name}>{row.name}</:col>
              <:empty>No users yet</:empty>
            </DataTable.data_table>
            """
          end,
          %{rows: []}
        )

      assert html =~ ~S(data-part="empty-row")
      assert html =~ "No users yet"
    end

    test "renders sort desc with custom sort_icon slot" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <DataTable.data_table
              id="users"
              rows={assigns.rows}
              sort_by={:name}
              sort_order={:desc}
              on_sort="sort_event"
            >
              <:col :let={row} label="Name" name={:name}>{row.name}</:col>
              <:sort_icon :let={%{direction: dir}}>{dir}</:sort_icon>
            </DataTable.data_table>
            """
          end,
          %{rows: [%{name: "Alice"}]}
        )

      assert html =~ "desc"
      assert html =~ ~S(phx-value-sort_by="name")
    end

    test "renders plain column label when column has no name" do
      html =
        render_component(&DataTable.data_table/1,
          id: "users",
          rows: [%{name: "Alice"}],
          on_sort: "sort_event",
          col: [
            %{label: "Notes", inner_block: fn _assigns, row -> row.name end}
          ]
        )

      assert html =~ "Notes"
      refute html =~ ~S(data-part="sort-header")
    end

    test "select-all checkbox checked when every row is selected" do
      rows = [%{id: 1, name: "Alice"}, %{id: 2, name: "Bob"}]

      html =
        render_component(&DataTable.data_table/1,
          id: "users",
          rows: rows,
          row_id: fn row -> "user-#{row.id}" end,
          selectable: true,
          selected: ["user-1", "user-2"],
          on_select_all: "select_all",
          col: cols()
        )

      assert html =~ ~S(id="users-select-all")
      assert html =~ ~S(data-checked)
    end

    test "renders row_click and row_item" do
      html =
        render_component(&DataTable.data_table/1,
          id: "users",
          rows: [%{id: 1, name: "alice"}],
          row_click: fn row -> JS.push("row", value: %{id: row.id}) end,
          row_item: fn row -> Map.put(row, :name, String.upcase(row.name)) end,
          col: cols()
        )

      assert html =~ "ALICE"
      assert html =~ ~S(phx-click=)
    end

    test "renders checkbox_indicator slot" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <DataTable.data_table
              id="users"
              rows={assigns.rows}
              selectable
              selected={[]}
              row_id={fn row -> "user-#{row.id}" end}
            >
              <:col :let={row} label="Name" name={:name}>{row.name}</:col>
              <:checkbox_indicator>✓</:checkbox_indicator>
            </DataTable.data_table>
            """
          end,
          %{rows: [%{id: 1, name: "Alice"}]}
        )

      assert html =~ "✓"
    end

    test "selectable without row_id uses inspect fallback for checkbox ids" do
      row = %{id: 1, name: "Alice"}

      html =
        render_component(&DataTable.data_table/1,
          id: "users",
          rows: [row],
          selectable: true,
          selected: [],
          col: cols()
        )

      assert html =~ "users-select-"
      assert html =~ "users-select-%{id: 1"
    end

    test "selectable with tuple rows and stream row_id uses dom id for checkbox ids" do
      row = {"user-1", %{id: 1, name: "Alice"}}

      html =
        render_component(&DataTable.data_table/1,
          id: "users",
          rows: [row],
          selectable: true,
          selected: [],
          row_id: fn {id, _item} -> id end,
          col: [
            %{
              label: "Name",
              inner_block: fn _assigns, {_id, item} -> item.name end
            }
          ]
        )

      assert html =~ ~S(id="users-select-user-1")
    end

    test "renders with LiveStream rows and phx-update stream" do
      stream = %Phoenix.LiveView.LiveStream{
        name: :users,
        dom_id: & &1,
        inserts: [{"user-1", %{id: 1, name: "Alice"}}],
        deletes: [],
        reset?: false
      }

      html =
        render_component(&DataTable.data_table/1,
          id: "users",
          rows: stream,
          col: cols()
        )

      assert html =~ ~S(phx-update="stream")
    end

    test "renders custom translation strings" do
      html =
        render_component(&DataTable.data_table/1,
          id: "users",
          rows: [%{id: 1, name: "Alice"}],
          selectable: true,
          selected: [],
          translation: %Corex.DataTable.Translation{
            select_all: "Pick all",
            select_row: "Pick row",
            actions: "Ops"
          },
          action: [%{inner_block: fn _assigns, _row -> "Go" end}],
          col: cols()
        )

      assert html =~ "Pick all"
      assert html =~ "Ops"
    end
  end
end
