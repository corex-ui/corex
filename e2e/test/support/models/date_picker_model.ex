defmodule E2eWeb.DatePickerModel do
  use E2eWeb.Model, component: "date-picker"

  @anatomy_sections ~w(
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

  def wait_input_value_in_section(session, section_dom_id, substring, opts \\ [])
      when is_binary(substring) do
    if String.contains?(substring, "'") do
      raise ArgumentError, "substring must not contain single quote"
    end

    wait_for_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="DatePicker"] [data-scope="date-picker"][data-part="input"][value*="#{substring}"]|,
        visible: :any
      ),
      opts
    )

    session
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
