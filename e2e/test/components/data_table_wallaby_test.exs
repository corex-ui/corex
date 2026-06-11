defmodule E2eWeb.DataTableWallabyTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.DataTableModel, as: DataTable

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal section renders rows", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DataTable, :data_table, :anatomy)

      assert_has(
        session,
        css("#data-table-anatomy-minimal [data-part='row']", text: "Alice", minimum: 1)
      )
    end

    feature "with action section renders edit control", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DataTable, :data_table, :anatomy)

      assert_has(
        session,
        css("#data-table-anatomy-with-action [aria-label='Edit Alice']", visible: :any)
      )
    end

    feature "empty section renders empty message", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DataTable, :data_table, :anatomy)

      assert_has(session, css("#data-table-anatomy-empty-msg", text: "No rows"))
    end
  end

  describe "style" do
    feature "color section renders tables", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DataTable, :data_table, :style)

      assert_has(session, css("#data-table-style-color table", minimum: 1, visible: :any))
      DataTable.see_in_section(session, "data-table-style-color", "Alice")
    end

    feature "size section renders tables", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DataTable, :data_table, :style)

      assert_has(session, css("#data-table-style-size table", minimum: 1, visible: :any))
    end

    feature "max width section renders tables", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DataTable, :data_table, :style)

      assert_has(session, css("#data-table-style-max-width table", minimum: 1, visible: :any))
    end
  end

  describe "patterns" do
    feature "row click section updates message", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DataTable, :data_table, :patterns)
        |> DataTable.prepare_live_form()
        |> click(css("#data-table-patterns-row-click [data-part='row']", at: 0, visible: true))

      DataTable.see_in_section(session, "data-table-patterns-row-click", "Row clicked: Alice")
    end

    feature "stream section add item", %{session: session} do
      session =
        session
        |> DataTable.visit_path("/en/data-table/patterns#data-table-patterns-stream")
        |> DataTable.wait_for_has(css("#data-table-patterns-page"), visible: :any)
        |> DataTable.wait_for_has(css("#data-table-patterns-stream"),
          visible: :any,
          timeout: 15_000
        )
        |> DataTable.prepare_live_form()

      assert_has(
        session,
        css(
          "#data-table-patterns-stream tr[data-scope='data-table'][data-part='row']",
          minimum: 3,
          visible: :any
        )
      )

      session
      |> click(css("#data-table-patterns-stream [phx-click='pattern_stream_add']", visible: :any))
      |> DataTable.wait_for_has(
        css(
          "#data-table-patterns-stream tr[data-scope='data-table'][data-part='row']",
          minimum: 4,
          visible: :any
        ),
        timeout: 10_000
      )
    end

    feature "sort section sorts by name", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DataTable, :data_table, :patterns)
        |> DataTable.prepare_live_form()
        |> DataTable.wait_for_has(css("#data-table-patterns-sort"),
          visible: :any,
          timeout: 15_000
        )

      DataTable.click_sort_header(session, "name")
      DataTable.assert_row_exists(session, "Alice")
    end

    feature "select section select all", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DataTable, :data_table, :patterns)
        |> DataTable.prepare_live_form()
        |> DataTable.wait_for_has(css("#data-table-patterns-select"),
          visible: :any,
          timeout: 15_000
        )

      DataTable.click_select_all(session)
    end

    feature "database section renders pagination", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DataTable, :data_table, :patterns)
        |> DataTable.prepare_live_form()
        |> DataTable.wait_for_has(css("#data-table-patterns-database"),
          visible: :any,
          timeout: 15_000
        )

      DataTable.wait_for_has(session, css("#pattern-db-table"), visible: :any)
      DataTable.wait_for_has(session, css("#pattern-db-pagination"), visible: :any)
    end
  end

  describe "playground" do
    feature "table renders sample rows", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DataTable, :data_table, :playground)
        |> DataTable.prepare_live_form()

      assert_has(session, css("#data-table-playground-table", text: "Alice"))
    end
  end
end
