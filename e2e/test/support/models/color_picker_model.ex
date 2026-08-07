defmodule E2eWeb.ColorPickerModel do
  @moduledoc """
  Behavior map:
    anatomy  - each section mounts, trigger opens content
    api      - set value (binding/server), assert value changed
    events   - server log growth after preset click
    form     - submit, validation
  """

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
    {path, page_id} =
      case mode do
        :static -> {"/en/color-picker/form", "color-picker-form-page"}
        :live -> {"/en/color-picker/live-form", "color-picker-form-live-page"}
      end

    goto_form_page(session, path, page_id, mode)
  end

  def submit_form(session, mode \\ :static) do
    form_id =
      if mode == :live,
        do: "color-picker-live-form-phoenix",
        else: "color-picker-form-phoenix"

    click(session, css("##{form_id} button[type='submit']"))
  end

  def hidden_input_value(session, host_dom_id) when is_binary(host_dom_id) do
    key = {:e2e_cp_value, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        const host = document.getElementById(arguments[0]);
        const input = host && host.querySelector('[data-scope="color-picker"][data-part="hidden-input"]');
        return input ? input.value : "";
        """,
        [host_dom_id],
        fn value -> Process.put(key, to_string(value || "")) end
      )

    Process.get(key, "")
  end

  def wait_value(session, host_dom_id, expected, opts \\ []) when is_binary(expected) do
    timeout = Keyword.get(opts, :timeout, 8_000)
    deadline = System.monotonic_time(:millisecond) + timeout
    busy_wait_value(session, host_dom_id, expected, deadline)
    session
  end

  defp busy_wait_value(session, host_dom_id, expected, deadline) do
    actual = hidden_input_value(session, host_dom_id)

    if color_values_match?(actual, expected) do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        raise Wallaby.ExpectationNotMetError,
          message:
            "expected color picker #{host_dom_id} value #{inspect(expected)}, got #{inspect(actual)}"
      else
        Process.sleep(50)
        busy_wait_value(session, host_dom_id, expected, deadline)
      end
    end
  end

  defp color_values_match?(actual, expected) when is_binary(actual) and is_binary(expected) do
    a = String.downcase(String.trim(actual))
    e = String.downcase(String.trim(expected))

    a == e or
      (e == "#ff0000" and (String.contains?(a, "255, 0, 0") or String.contains?(a, "255,0,0"))) or
      (e == "#3b82f6" and String.contains?(a, "59, 130, 246"))
  end

  def assert_content_open(session, host_dom_id, opts \\ []) when is_binary(host_dom_id) do
    timeout = Keyword.get(opts, :timeout, 8_000)

    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="color-picker"][data-part="content"][data-state="open"]|,
        visible: :any
      ),
      timeout: timeout
    )

    session
  end
end
