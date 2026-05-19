defmodule Corex.DataTableTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.DataTable

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
  end
end
