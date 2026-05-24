defmodule E2eWeb.PinInputModel do
  use E2eWeb.Model, component: "pin-input"

  @anatomy_sections ~W(
    pin-input-anatomy-minimal
    pin-input-anatomy-default
  )

  def anatomy_section_ids, do: @anatomy_sections

  def wait_section_pin_input_ready(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="PinInput"]:not([data-loading])|,
        visible: :any
      )
    )

    session
  end

  def wait_root_pin_input_ready(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid pin input host dom id"
    end

    assert_has(
      session,
      css(~s|##{host_dom_id}[phx-hook="PinInput"]:not([data-loading])|, visible: :any)
    )

    session
  end

  def fill_pin_in_section(session, section_dom_id, pin, host_id) when is_binary(pin) do
    Enum.reduce(Enum.with_index(String.graphemes(pin)), session, fn {char, idx}, s ->
      q =
        css(
          ~s|section##{section_dom_id} ##{host_id} [data-scope="pin-input"][data-part="input"][data-index="#{idx}"]|,
          visible: :any
        )

      s
      |> click(q)
      |> fill_in(q, with: char)
    end)
  end

  def wait_pin_complete_in_section(session, host_id, pin, opts \\ []) when is_binary(pin) do
    wait_for_has(
      session,
      css(
        ~s|##{host_id} [data-scope="pin-input"][data-part="hidden-input"][value="#{pin}"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def pin_host_id_for_section("pin-input-anatomy-minimal"), do: "pin-input-anatomy-minimal"
  def pin_host_id_for_section("pin-input-anatomy-default"), do: "pin-input-anatomy-default"

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

  def pin_input_events_server_log_has_row?(session) do
    has?(session, css("#pin-input-events-log-server tr[data-part='row']", visible: :any))
  end

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/pin-input/form"
        :live -> "/en/pin-input/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  def fill_pin_at_host(session, pin, host_id) when is_binary(pin) do
    Enum.reduce(Enum.with_index(String.graphemes(pin)), session, fn {char, idx}, s ->
      q =
        css(
          ~s|##{host_id} [data-scope="pin-input"][data-part="input"][data-index="#{idx}"]|,
          visible: :any
        )

      s
      |> click(q)
      |> fill_in(q, with: char)
    end)
  end

  def fill_pin_input(session, pin, mode \\ :static) when is_binary(pin) do
    host_id =
      case mode do
        :live -> "pin-input-live-form-phoenix_pin"
        _ -> "pin-input-form-phoenix_pin"
      end

    session =
      case mode do
        :live ->
          wait_section_pin_input_ready(session, "pin-input-live-form-phoenix-section")

        _ ->
          assert_has(
            session,
            css(
              ~s|##{host_id} [data-scope="pin-input"][data-part="input"][data-index="0"]|,
              visible: :any
            )
          )

          session
      end

    fill_pin_at_host(session, pin, host_id)
  end

  def submit_form(session, mode \\ :static) do
    id =
      case mode do
        :live -> "pin-input-live-form-phoenix-submit"
        _ -> "pin-input-form-phoenix-submit"
      end

    click(session, css("##{id}"))
  end

  def wait_for_redirect(session) do
    assert_has(session, css("#pin-input-form-page"))
  end

  def see_flash(session, flash_text) do
    assert_toast(session, flash_text)
  end
end
