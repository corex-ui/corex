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
end
