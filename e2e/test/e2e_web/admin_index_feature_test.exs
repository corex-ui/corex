defmodule E2eWeb.AdminIndexFeatureTest do
  @moduledoc false

  use E2eWeb.FeatureCase, async: false

  import Wallaby.Query
  import Wallaby.Browser

  alias E2eWeb.CheckboxModel
  alias E2eWeb.FormHelpers
  alias E2eWeb.MenuModel
  alias E2eWeb.SelectModel
  alias E2eWeb.ToggleGroupModel

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
    CheckboxModel.assert_aria_checked(session, "tickets-command-select-all", "mixed")

    session =
      CheckboxModel.press_space_on_checkbox_control(
        session,
        "tickets-table-select-#{row_id}"
      )

    wait_selected_count(session, "0 selected")
  end

  feature "table and command select-all do not loop", %{session: session} do
    session = wait_tickets_index(session)

    session =
      CheckboxModel.press_space_on_checkbox_control(session, "tickets-table-select-all")

    session = wait_selected_count(session, "25 selected")
    Process.sleep(1_000)
    session = wait_selected_count(session, "25 selected")
    CheckboxModel.assert_aria_checked(session, "tickets-command-select-all", "true")
    CheckboxModel.assert_aria_checked(session, "tickets-table-select-all", "true")

    session =
      CheckboxModel.press_space_on_checkbox_control(session, "tickets-table-select-all")

    session = wait_selected_count(session, "0 selected")

    session =
      CheckboxModel.press_space_on_checkbox_control(session, "tickets-command-select-all")

    session = wait_selected_count(session, "25 selected")
    Process.sleep(1_000)
    session = wait_selected_count(session, "25 selected")
    CheckboxModel.assert_aria_checked(session, "tickets-table-select-all", "true")

    session =
      CheckboxModel.press_space_on_checkbox_control(session, "tickets-command-select-all")

    wait_selected_count(session, "0 selected")
  end

  feature "status filter widgets reset and chip X clear Zag state", %{session: session} do
    session = wait_tickets_index(session)

    session =
      session
      |> ToggleGroupModel.click_item_by_value_in_host("tickets-filter-status", "open")
      |> ToggleGroupModel.wait_item_on_in_host("tickets-filter-status", "open")

    assert_has(session, css(".admin-chips", text: "Status: open"))
    assert_has(session, css(".admin-command-bar .badge.ui-trigger--square", text: "1"))
    assert current_url(session) =~ "filters[status]"

    session =
      click(session, css(~s(button[phx-click="reset_filter"][phx-value-field="status"])))

    wait_item_off(session, "tickets-filter-status", "open")
    refute_has(session, css(".admin-chips", text: "Status: open"))
    refute current_url(session) =~ "filters[status]"

    session =
      session
      |> ToggleGroupModel.click_item_by_value_in_host("tickets-filter-status", "done")
      |> ToggleGroupModel.wait_item_on_in_host("tickets-filter-status", "done")

    session = click(session, css(~s(button[aria-label="Clear Status"])))

    wait_item_off(session, "tickets-filter-status", "done")
    refute_has(session, css(".admin-chips", text: "Status: done"))
  end

  feature "per page select and row kebab menu", %{session: session} do
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
    menu_id = "tickets-row-#{row_id}"

    session = MenuModel.wait_root_menu_ready(session, menu_id)

    assert_has(
      session,
      css(~s([id="menu:#{menu_id}"] .button.ui-trigger--square), visible: :any)
    )

    assert_row_menu_is_topmost(session, menu_id)

    session =
      session
      |> MenuModel.open_menu_by_host_id(menu_id)
      |> click_open_menu_item(menu_id, "show:#{row_id}")
      |> wait_path("/en/admin/tickets/#{row_id}")

    assert current_url(session) =~ "/en/admin/tickets/#{row_id}"
  end

  defp wait_tickets_index(session) do
    session
    |> FormHelpers.visit_path("/en/admin/tickets")
    |> wait_selected_count("0 selected")
    |> assert_has(
      css("#tickets-command-select-all[phx-hook='Checkbox']:not([data-loading])", visible: :any)
    )
    |> assert_has(
      css("#tickets-table-select-all[phx-hook='Checkbox']:not([data-loading])", visible: :any)
    )
    |> assert_has(
      css("#tickets-filter-status[phx-hook='ToggleGroup']:not([data-loading])", visible: :any)
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

  defp wait_item_off(session, host_id, value) do
    ToggleGroupModel.wait_for_has(
      session,
      css(
        ~s|##{host_id} [data-scope="toggle-group"][data-part="item"][data-value="#{value}"][data-state="off"]|,
        visible: :any
      ),
      timeout: 8_000
    )
  end

  defp assert_row_menu_is_topmost(session, menu_id) do
    execute_script(
      session,
      """
      var id = arguments[0];
      var trigger = document.querySelector(
        '[id="menu:' + id + '"] [data-scope="menu"][data-part="trigger"]'
      );
      if (!trigger) return {ok: false, reason: 'missing-trigger'};
      trigger.scrollIntoView({block: 'center', inline: 'nearest'});
      var rect = trigger.getBoundingClientRect();
      var hit = document.elementFromPoint(
        rect.left + rect.width / 2,
        rect.top + rect.height / 2
      );
      var host = trigger.closest('[phx-hook="Menu"]');
      return {
        ok: !!(host && hit && host.contains(hit)),
        hitId: hit && hit.id,
        hitPart: hit && hit.getAttribute('data-part'),
        hitScope: hit && hit.getAttribute('data-scope'),
        width: rect.width,
        height: rect.height
      };
      """,
      [menu_id],
      fn result ->
        assert result["ok"] == true,
               "expected the row menu trigger to be the topmost hit target, got #{inspect(result)}"

        assert is_number(result["width"]) and result["width"] > 0
        assert is_number(result["height"]) and result["height"] > 0
      end
    )

    session
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
      var el = document.querySelector('.admin-command-bar-start .admin-muted');
      return el ? el.textContent.trim() : null;
      """,
      fn actual -> "expected selected count #{inspect(text)}, got #{inspect(actual)}" end
    )
  end

  defp click_open_menu_item(session, menu_id, value) do
    execute_script(
      session,
      """
      var id = arguments[0];
      var value = arguments[1];
      var el = document.querySelector(
        '[id="menu:' + id + ':content"] [data-scope="menu"][data-part="item"][data-value="' + value + '"]'
      );
      if (!el) return {ok: false, reason: 'missing-item'};
      var to = el.getAttribute('data-to');
      var rect = el.getBoundingClientRect();
      var opts = {
        bubbles: true,
        cancelable: true,
        pointerType: 'mouse',
        isPrimary: true,
        button: 0,
        clientX: rect.left + rect.width / 2,
        clientY: rect.top + rect.height / 2,
        view: window
      };
      el.dispatchEvent(new PointerEvent('pointerdown', opts));
      el.dispatchEvent(new PointerEvent('pointerup', opts));
      el.dispatchEvent(new MouseEvent('click', opts));
      return {ok: true, to: to, redirect: el.getAttribute('data-redirect')};
      """,
      [menu_id, value],
      fn result ->
        assert result["ok"] == true, "expected to click menu item #{value}: #{inspect(result)}"

        assert is_binary(result["to"]) and String.starts_with?(result["to"], "/"),
               "expected menu item #{value} to have a path data-to, got #{inspect(result)}"
      end
    )

    session
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
          cond do
            is_float(value) and value == trunc(value) -> trunc(value)
            true -> value
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
