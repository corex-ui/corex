defmodule E2eWeb.DatePickerModel do
  use E2eWeb.Model, component: "date-picker"

  @anatomy_sections ~W(
    date-picker-anatomy-minimal
    date-picker-anatomy-range
    date-picker-anatomy-multiple
  )

  def anatomy_section_ids, do: @anatomy_sections

  def wait_section_date_picker_ready(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="DatePicker"]:not([data-loading])|,
        visible: :any
      )
    )

    session
  end

  def wait_root_date_picker_ready(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid date picker host dom id"
    end

    assert_has(
      session,
      css(~s|##{host_dom_id}[phx-hook="DatePicker"]:not([data-loading])|, visible: :any)
    )

    session
  end

  def wait_playground_date_picker_ready(session) do
    wait_root_date_picker_ready(session, "date-picker-playground")
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#date-picker-patterns-page", visible: :any))
    session
  end

  def open_date_picker_in_section(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    click(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="DatePicker"] [data-scope="date-picker"][data-part="trigger"]|,
        visible: :any
      )
    )
  end

  def open_date_picker_by_host_id(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid date picker host dom id"
    end

    click(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="date-picker"][data-part="trigger"]|,
        visible: :any
      )
    )
  end

  def click_button_in_section(session, section_id, label) when is_binary(label) do
    if String.contains?(label, "'") or String.contains?(label, "\"") do
      raise ArgumentError, "click_button_in_section: label must not include quotes"
    end

    click(
      session,
      xpath("(//*[@id=\'#{section_id}\']//button[normalize-space(.)=\'#{label}\'])[1]")
    )

    session
  end

  def wait_input_value_in_section(session, section_dom_id, iso_date, opts \\ [])
      when is_binary(iso_date) do
    if not (String.match?(iso_date, ~r/^\d{4}-\d{2}-\d{2}$/) and
              String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/)) do
      raise ArgumentError, "invalid section dom id or ISO date"
    end

    deadline = Keyword.get(opts, :timeout, 8_000) + System.monotonic_time(:millisecond)
    busy_wait_selected_date_in_section(session, section_dom_id, iso_date, deadline)
    session
  end

  defp busy_wait_selected_date_in_section(session, section_dom_id, iso_date, deadline) do
    if input_value_matches_iso?(session, section_dom_id, iso_date) do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        actual = input_value_in_section(session, section_dom_id)

        raise Wallaby.ExpectationNotMetError,
          message:
            "expected date picker in #{section_dom_id} to select #{iso_date}, input value was #{inspect(actual)}"
      else
        Process.sleep(50)
        busy_wait_selected_date_in_section(session, section_dom_id, iso_date, deadline)
      end
    end
  end

  defp input_value_matches_iso?(session, section_dom_id, iso_date) do
    key = {:e2e_date_picker_match, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        const section = document.getElementById(arguments[0]);
        const input = section?.querySelector('[data-scope="date-picker"][data-part="input"]');
        const val = input?.value ?? "";
        const iso = arguments[1];
        if (!val) return false;
        if (val.includes(iso)) return true;
        const [y, m, d] = iso.split("-").map(Number);
        const parsed = Date.parse(val);
        if (isNaN(parsed)) return false;
        const dt = new Date(parsed);
        return dt.getFullYear() === y && dt.getMonth() + 1 === m && dt.getDate() === d;
        """,
        [section_dom_id, iso_date],
        fn result -> Process.put(key, result == true) end
      )

    Process.get(key, false)
  end

  defp input_value_in_section(session, section_dom_id) do
    key = {:e2e_date_picker_input_value, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        const section = document.getElementById(arguments[0]);
        const input = section?.querySelector('[data-scope="date-picker"][data-part="input"]');
        return input?.value ?? "";
        """,
        [section_dom_id],
        fn value -> Process.put(key, to_string(value || "")) end
      )

    Process.get(key, "")
  end

  def wait_patterns_status_contains(session, substring, opts \\ []) when is_binary(substring) do
    if String.contains?(substring, "'") do
      raise ArgumentError, "substring must not contain single quote"
    end

    wait_for_has(
      session,
      xpath("//*[@id='date-picker-patterns-status' and contains(., '#{substring}')]"),
      opts
    )

    session
  end

  def date_picker_events_server_value_log_has_row?(session) do
    has?(session, css("#date-picker-events-log-sv tr[data-part='row']"))
  end

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/date-picker/form"
        :live -> "/en/date-picker/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live,
        do: "date-picker-basic-form-live-submit",
        else: "date-picker-changeset-form-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    assert_toast(session, flash_text)
  end
end
