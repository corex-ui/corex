defmodule E2eWeb.DataTableModel do
  use E2eWeb.Model, component: "data-table"

  @anatomy_sections ~w(
    data-table-anatomy-minimal
    data-table-anatomy-with-action
    data-table-anatomy-empty
  )

  @style_sections ~w(
    data-table-styling-color
    data-table-styling-size
    data-table-styling-max-width
  )

  @pattern_sections ~w(
    data-table-patterns-row-click
    data-table-patterns-stream
    data-table-patterns-sort
    data-table-patterns-select
    data-table-patterns-full
    data-table-patterns-database
  )

  def anatomy_section_ids, do: @anatomy_sections
  def style_section_ids, do: @style_sections
  def pattern_section_ids, do: @pattern_sections

  def see_in_section(session, section_id, content_text)
      when is_binary(section_id) and is_binary(content_text) do
    assert_has(session, css("##{section_id}", text: content_text, minimum: 1))
    session
  end

  def assert_row_count(session, table_id, count) when is_integer(count) do
    assert_has(
      session,
      css("##{table_id} [data-scope='data-table'][data-part='row']", count: count, visible: :any)
    )

    session
  end

  def click_in_section(session, section_id, button_label)
      when is_binary(section_id) and is_binary(button_label) do
    if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
      raise ArgumentError, "click_in_section/3 label must not include quotes"
    end

    click(
      session,
      xpath("(//*[@id=\'#{section_id}\']//button[normalize-space(.)=\'#{button_label}\'])[1]")
    )

    session
  end

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
