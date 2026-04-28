defmodule E2eWeb.DataTableFeatureTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.DataTableModel, as: DataTable

  feature "sorting — clicking headers sorts the table", %{session: session} do
    session =
      session
      |> DataTable.visit_path("/en/data-table/patterns#data-table-patterns-sort")
      |> DataTable.wait_for_has(css("#data-table-patterns-sort"), timeout: 15_000)

    session = DataTable.click_sort_header(session, "name")
    DataTable.assert_row_exists(session, "Alice")
  end

  feature "selection — clicking select all", %{session: session} do
    session =
      session
      |> DataTable.visit_path("/en/data-table/patterns#data-table-patterns-select")
      |> DataTable.wait_for_has(css("#data-table-patterns-select"), timeout: 15_000)

    DataTable.click_select_all(session)
  end
end
