defmodule E2eWeb.DataTableFeatureTest do
  use E2eWeb.FeatureCase, async: false

  import Wallaby.Query

  alias E2eWeb.DataTableModel, as: DataTable

  feature "sorting  -  clicking headers sorts the table", %{session: session} do
    session =
      session
      |> DataTable.visit_path("/en/data-table/patterns#data-table-patterns-sort")
      |> DataTable.wait_for_has(css("#data-table-patterns-page"), visible: :any)
      |> DataTable.wait_for_has(css("#data-table-patterns-sort"), visible: :any, timeout: 15_000)

    session = DataTable.click_sort_header(session, "name")
    DataTable.assert_row_exists(session, "Alice")
  end

  feature "selection  -  clicking select all", %{session: session} do
    session =
      session
      |> DataTable.visit_path("/en/data-table/patterns#data-table-patterns-select")
      |> DataTable.wait_for_has(css("#data-table-patterns-page"), visible: :any)
      |> DataTable.wait_for_has(css("#data-table-patterns-select"),
        visible: :any,
        timeout: 15_000
      )

    DataTable.click_select_all(session)
  end

  feature "with database  -  table and pagination render", %{session: session} do
    session =
      session
      |> DataTable.visit_path("/en/data-table/patterns#data-table-patterns-database")
      |> DataTable.wait_for_has(css("#data-table-patterns-page"), visible: :any)
      |> DataTable.wait_for_has(css("#data-table-patterns-database"),
        visible: :any,
        timeout: 15_000
      )

    DataTable.wait_for_has(session, css("#pattern-db-table"), visible: :any)
    DataTable.wait_for_has(session, css("#pattern-db-pagination"), visible: :any)
  end

  feature "with flop  -  table and pagination render", %{session: session} do
    session =
      session
      |> DataTable.visit_path("/en/data-table/patterns#data-table-patterns-flop")
      |> DataTable.wait_for_has(css("#data-table-patterns-page"), visible: :any)
      |> DataTable.wait_for_has(css("#data-table-patterns-flop"), visible: :any, timeout: 15_000)

    DataTable.wait_for_has(session, css("#pattern-flop-table"), visible: :any)
    DataTable.wait_for_has(session, css("#pattern-flop-pagination"), visible: :any)
  end
end
