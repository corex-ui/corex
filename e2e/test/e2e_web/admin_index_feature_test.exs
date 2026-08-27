defmodule E2eWeb.AdminIndexFeatureTest do
  @moduledoc false

  use E2eWeb.FeatureCase, async: false

  import Wallaby.Query
  import Wallaby.Browser

  alias E2eWeb.CheckboxModel
  alias E2eWeb.FormHelpers
  alias E2eWeb.SelectModel

  feature "row checkbox stays checked and command bar count updates", %{session: session} do
    session = wait_tickets_index(session)
    row_id = first_row_id(session)

    session =
      CheckboxModel.press_space_on_checkbox_control(
        session,
        "tickets-table-select-#{row_id}"
      )

    session = wait_selected_count(session, "1 selected")
    assert current_url(session) =~ ~r{/en/admin/tickets(?:\?.*)?$}

    Process.sleep(1_000)
    session = wait_selected_count(session, "1 selected")

    session =
      CheckboxModel.press_space_on_checkbox_control(
        session,
        "tickets-table-select-#{row_id}"
      )

    wait_selected_count(session, "0 selected")
  end

  feature "table select-all does not loop", %{session: session} do
    session = wait_tickets_index(session)

    session =
      CheckboxModel.press_space_on_checkbox_control(session, "tickets-table-select-all")

    session = wait_selected_count(session, "25 selected")
    Process.sleep(1_000)
    session = wait_selected_count(session, "25 selected")
    CheckboxModel.assert_aria_checked(session, "tickets-table-select-all", "true")

    session =
      CheckboxModel.press_space_on_checkbox_control(session, "tickets-table-select-all")

    wait_selected_count(session, "0 selected")
  end

  feature "status filter widgets reset and chip X clear Zag state", %{session: session} do
    session = wait_tickets_index(session) |> open_ticket_filters()

    session = choose_status_filter(session, "open")
    assert_has(session, css(".admin-chips", text: "Status: open"))
    assert_has(session, css(".admin-command-bar .badge.ui-trigger--square", text: "1"))
    assert current_url(session) =~ "filters[status]"

    session =
      click(session, css(~S(button[phx-click="reset_filter"][phx-value-field="status"])))

    refute_has(session, css(".admin-chips", text: "Status: open"))
    refute current_url(session) =~ "filters[status]"

    session = choose_status_filter(session, "done")
    session = click(session, css(~S(button[aria-label="Clear Status"])))

    refute_has(session, css(".admin-chips", text: "Status: done"))
  end

  feature "sidebar Posts from ticket show live-navigates", %{session: session} do
    session = wait_tickets_index(session)
    row_id = first_row_id(session)

    session =
      session
      |> click(css(~s(tr[id="#{row_id}"] td[data-part="cell"]), at: 0))
      |> wait_path("/en/admin/tickets/#{row_id}")
      |> wait_live_connected()

    session =
      session
      |> click(
        css(
          ~S(#admin-nav-tree [data-scope="tree-view"][data-part="item"][data-to="/en/admin/posts"])
        )
      )
      |> wait_path("/en/admin/posts")

    assert_has(session, css("#posts-table", visible: :any))
  end

  feature "per page select and row show action", %{session: session} do
    session = wait_tickets_index(session)

    session =
      session
      |> SelectModel.open_select_by_host_id("tickets-page-size")
      |> SelectModel.click_item_by_host_id("tickets-page-size", "10")

    SelectModel.wait_for_has(
      session,
      css("body", text: "Showing 1–10 of 32"),
      timeout: 8_000
    )

    assert current_url(session) =~ "page_size=10"
    session = wait_live_connected(session)

    row_id = first_row_id(session)

    session =
      execute_script(
        session,
        """
        const row = document.querySelector('tr[data-scope="data-table"][data-part="row"]');
        if (row) row.scrollIntoView({block: 'center'});
        """
      )

    session =
      session
      |> click(css(~s(tr[id="#{row_id}"] td[data-part="cell"]), at: 0))
      |> wait_path("/en/admin/tickets/#{row_id}")

    assert current_url(session) =~ "/en/admin/tickets/#{row_id}"
  end

  defp wait_tickets_index(session) do
    session
    |> FormHelpers.visit_path("/en/admin/tickets")
    |> wait_selected_count("0 selected")
    |> assert_has(
      css("#tickets-table-select-all[phx-hook='Checkbox']:not([data-loading])", visible: :any)
    )
    |> assert_has(
      css("#tickets-filter-status[phx-hook='Select']:not([data-loading])", visible: :any)
    )
    |> assert_has(
      css("tr[data-part='row'] [phx-hook='Checkbox']:not([data-loading])",
        visible: :any,
        minimum: 1
      )
    )
    |> assert_has(css("#tickets-page-size[phx-hook='Select']:not([data-loading])", visible: :any))
    |> wait_live_connected()
  end

  defp open_ticket_filters(session) do
    click(
      session,
      css("#tickets-filters [data-scope='collapsible'][data-part='trigger']")
    )
  end

  defp choose_status_filter(session, value) do
    session
    |> SelectModel.open_select_by_host_id("tickets-filter-status")
    |> click(
      css(
        ~s|#tickets-filter-status [data-scope="select"][data-part="item"][data-value="#{value}"]:not([data-template])|
      )
    )
  end

  defp wait_live_connected(session, timeout \\ 8_000) do
    deadline = System.monotonic_time(:millisecond) + timeout
    wait_live_connected_loop(session, deadline)
  end

  defp wait_live_connected_loop(session, deadline) do
    parent = self()
    ref = make_ref()

    session =
      execute_script(
        session,
        """
        try {
          var s = window.liveSocket;
          if (!s) return false;
          if (typeof s.isConnected === 'function') return s.isConnected();
          if (s.getSocket && s.getSocket()) return s.getSocket().isConnected();
          return false;
        } catch (e) {
          return false;
        }
        """,
        [],
        fn v -> send(parent, {ref, v}) end
      )

    connected? =
      receive do
        {^ref, value} -> value
      after
        2_000 -> false
      end

    if connected? do
      session
    else
      if System.monotonic_time(:millisecond) >= deadline do
        flunk("expected LiveView socket to be connected")
      else
        Process.sleep(100)
        wait_live_connected_loop(session, deadline)
      end
    end
  end

  defp first_row_id(session) do
    session
    |> find(css("tr[data-scope='data-table'][data-part='row']", at: 0))
    |> Wallaby.Element.attr("id")
  end

  defp wait_selected_count(session, text, timeout \\ 8_000) do
    wait_script(
      session,
      text,
      timeout,
      """
      var el = document.querySelector('.admin-table-bar-count');
      return el ? el.textContent.trim() : null;
      """,
      fn actual -> "expected selected count #{inspect(text)}, got #{inspect(actual)}" end
    )
  end

  defp wait_script(session, expected, timeout, script, message_fun) do
    deadline = System.monotonic_time(:millisecond) + timeout
    wait_script_loop(session, expected, deadline, script, message_fun)
  end

  defp wait_script_loop(session, expected, deadline, script, message_fun) do
    parent = self()
    ref = make_ref()

    session =
      execute_script(session, script, [], fn v -> send(parent, {ref, v}) end)

    actual =
      receive do
        {^ref, value} ->
          if is_float(value) and value == trunc(value) do
            trunc(value)
          else
            value
          end
      after
        2_000 -> nil
      end

    if actual == expected do
      session
    else
      if System.monotonic_time(:millisecond) >= deadline do
        flunk(message_fun.(actual))
      else
        Process.sleep(100)
        wait_script_loop(session, expected, deadline, script, message_fun)
      end
    end
  end

  defp wait_path(session, path, timeout \\ 8_000) do
    deadline = System.monotonic_time(:millisecond) + timeout
    wait_path_loop(session, path, deadline)
  end

  defp wait_path_loop(session, path, deadline) do
    if String.contains?(current_url(session), path) do
      session
    else
      if System.monotonic_time(:millisecond) >= deadline do
        flunk("expected URL to include #{inspect(path)}, got #{inspect(current_url(session))}")
      else
        Process.sleep(100)
        wait_path_loop(session, path, deadline)
      end
    end
  end
end
