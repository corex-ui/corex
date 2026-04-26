defmodule E2eWeb.DataTableModel do
  use E2eWeb.Model, component: "data-table"

  def click_sort_header(session, name) do
    click(
      session,
      css("#data-table-patterns-sort [data-part='sort-trigger'][phx-value-sort_by='#{name}']")
    )
  end

  def click_row_checkbox(session, id) do
    # Find the checkbox for the specific row id
    click(session, css("input[type='checkbox'][value='#{id}']"))
  end

  def click_select_all(session) do
    click(
      session,
      css(
        "#data-table-patterns-select th[data-part='selection-header'] [data-scope='checkbox'][data-part='control']"
      )
    )
  end

  def assert_row_exists(session, text) do
    assert_has(session, Wallaby.Query.css("#data-table-patterns-sort", text: text))
  end

  def refute_row_exists(session, text) do
    dont_see(session, text)
  end
end
