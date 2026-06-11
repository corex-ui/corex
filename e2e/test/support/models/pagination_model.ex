defmodule E2eWeb.PaginationModel do
  import Wallaby.Query
  import Wallaby.Browser

  use E2eWeb.Model, component: "pagination"

  def wait_host_ready(session, host_id \\ "pagination-anatomy") do
    assert_has(
      session,
      css(~s(##{host_id}[phx-hook="Pagination"][data-loading]), count: 0, visible: :any)
    )

    session
  end

  def assert_has_part(session, part) when is_binary(part) do
    assert_has(session, css(~s/[data-scope="pagination"][data-part="#{part}"]/))
    session
  end

  def click_item(session, page) when is_integer(page) do
    click(
      session,
      css(~s/[data-scope="pagination"][data-part="item"], text: "#{page}"/)
    )
  end

  def assert_item_selected(session, page) when is_integer(page) do
    assert_has(
      session,
      css(~s/[data-scope="pagination"][data-part="item"][data-selected], text: "#{page}"/)
    )

    session
  end

  @anatomy_sections ~W(pagination-anatomy-minimal)

  @style_sections ~W(
    pagination-style-semantic
    pagination-style-size
    pagination-style-text
    pagination-style-radius
    pagination-style-max-width
  )

  @api_sections ~W(
    pagination-api-client-binding
    pagination-api-server
  )

  @events_sections ~W(
    pagination-events-server-section
    pagination-events-client-section
  )

  @pattern_sections ~W(
    pagination-patterns-controlled-section
    pagination-patterns-patch-section
    pagination-patterns-server-section
    pagination-patterns-client-section
  )

  def anatomy_section_ids, do: @anatomy_sections
  def style_section_ids, do: @style_sections
  def api_section_ids, do: @api_sections
  def events_section_ids, do: @events_sections
  def pattern_section_ids, do: @pattern_sections

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

  def wait_pagination_in_section(session, section_id, pagination_id) do
    assert_has(
      session,
      css(
        "##{section_id} ##{pagination_id}[phx-hook='Pagination']:not([data-loading])",
        visible: :any,
        minimum: 1
      )
    )

    session
  end

  def click_page_in_section(session, section_id, page) when is_integer(page) do
    click(
      session,
      css("##{section_id} [data-scope='pagination'][data-part='item']", text: "#{page}")
    )

    session
  end

  def assert_item_selected_in_section(session, section_id, page) when is_integer(page) do
    assert_has(
      session,
      css(
        "##{section_id} [data-scope='pagination'][data-part='item'][data-selected]",
        text: "#{page}"
      )
    )

    session
  end

  def events_server_log_has_row?(session) do
    has?(session, css("#pagination-events-log-server tr[data-part='row']"))
  end
end
