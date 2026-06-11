defmodule E2eWeb.DataTableModel do
  use E2eWeb.Model, component: "data-table"

  @anatomy_sections ~W(
    data-table-anatomy-minimal
    data-table-anatomy-with-action
    data-table-anatomy-empty
  )

  @style_sections ~W(
    data-table-style-color
    data-table-style-size
    data-table-style-max-width
  )

  @pattern_sections ~W(
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

  def assert_open_dialog_covers_table_chrome(session, table_id) when is_binary(table_id) do
    if not (String.match?(table_id, ~r/^[a-zA-Z0-9_-]+$/) and table_id != "") do
      raise ArgumentError, "invalid table id"
    end

    execute_script(
      session,
      """
      var table = document.getElementById(arguments[0]);
      if (!table) return JSON.stringify({ ok: false, error: "missing-table" });

      var backdrop = table.querySelector(
        '[data-scope="dialog"][data-part="backdrop"][data-state="open"]'
      );

      function zIndex(el) {
        if (!el) return null;
        var value = window.getComputedStyle(el).zIndex;
        if (value === "auto") return 0;
        return parseInt(value, 10);
      }

      function isOverlayHit(x, y) {
        var hit = document.elementFromPoint(x, y);

        while (hit) {
          if (hit === backdrop) return true;

          var part = hit.getAttribute("data-part");
          if (part === "backdrop" || part === "content" || part === "positioner") return true;

          hit = hit.parentElement;
        }

        return false;
      }

      function centerPoint(el) {
        var rect = el.getBoundingClientRect();
        return {
          x: rect.left + rect.width / 2,
          y: rect.top + rect.height / 2
        };
      }

      function centerInViewport(el) {
        var point = centerPoint(el);
        return (
          point.x >= 0 &&
          point.x <= window.innerWidth &&
          point.y >= 0 &&
          point.y <= window.innerHeight
        );
      }

      var openCell = table.querySelector(
        '[data-scope="data-table"][data-part="action-cell"]:has([data-scope="dialog"][data-part="backdrop"][data-state="open"])'
      );

      var otherCell = table.querySelector(
        '[data-scope="data-table"][data-part="action-cell"]:not(:has([data-scope="dialog"][data-part="backdrop"][data-state="open"]))'
      );

      var thead = table.querySelector('[data-scope="data-table"][data-part="thead"]');
      var actionHeader = table.querySelector(
        '[data-scope="data-table"][data-part="thead"] th[data-part="action-header"]'
      );

      var headerTargets = [thead, actionHeader].filter(Boolean);
      var headersCovered = headerTargets.every(function (target) {
        if (!centerInViewport(target)) return true;
        var point = centerPoint(target);
        return isOverlayHit(point.x, point.y);
      });

      var openCellZ = zIndex(openCell);
      var otherCellZ = zIndex(otherCell);
      var theadZ = zIndex(thead);
      var actionHeaderZ = zIndex(actionHeader);

      return JSON.stringify({
        ok:
          !!backdrop &&
          headersCovered &&
          openCellZ === 1 &&
          otherCellZ === 0 &&
          openCellZ > otherCellZ,
        backdrop: !!backdrop,
        openCellZ: openCellZ,
        otherCellZ: otherCellZ,
        theadZ: theadZ,
        actionHeaderZ: actionHeaderZ,
        headersCovered: headersCovered
      });
      """,
      [table_id],
      fn result ->
        decoded = Jason.decode!(result)

        assert decoded["ok"],
               "expected dialog backdrop to cover table chrome: #{inspect(decoded)}"
      end
    )

    session
  end
end
