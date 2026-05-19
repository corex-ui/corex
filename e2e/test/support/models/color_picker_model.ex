defmodule E2eWeb.ColorPickerModel do
  use E2eWeb.Model, component: "color-picker"

  @anatomy_sections ~W(
    color-picker-anatomy-minimal
    color-picker-anatomy-with-value
    color-picker-anatomy-with-preset
    color-picker-anatomy-positioning
  )

  def anatomy_section_ids, do: @anatomy_sections

  def wait_section_color_picker_ready(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="ColorPicker"]:not([data-loading])|,
        visible: :any
      )
    )

    session
  end

  def wait_root_color_picker_ready(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid color picker host dom id"
    end

    assert_has(
      session,
      css(~s|##{host_dom_id}[phx-hook="ColorPicker"]:not([data-loading])|, visible: :any)
    )

    session
  end

  def wait_playground_color_picker_ready(session) do
    wait_root_color_picker_ready(session, "color-picker-playground")
  end

  def open_color_picker_in_section(session, section_dom_id) do
    click(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="color-picker"][data-part="trigger"]|,
        visible: :any
      )
    )

    session
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

  def click_preset_by_host_id(session, host_dom_id, index) when is_integer(index) do
    swatch_id = "color-picker:#{host_dom_id}:swatch-trigger:#{index}"

    _ =
      execute_script(
        session,
        """
        (function () {
          const el = document.getElementById(#{Jason.encode!(swatch_id)});
          if (el) el.click();
        })();
        """,
        []
      )

    session
  end

  def color_picker_events_server_value_log_has_row?(session) do
    has?(session, css("#color-picker-events-sv-table tr[data-part='row']"))
  end

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/color-picker/form"
        :live -> "/en/color-picker/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live,
        do: "color-picker-basic-form-live-submit",
        else: "color-picker-form-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    assert_toast(session, flash_text)
  end
end
