defmodule E2eWeb.DialogModel do
  use E2eWeb.Model, component: "dialog"

  @anatomy_sections ~w(
    dialog-anatomy-minimal
    dialog-anatomy-title-description
    dialog-anatomy-actions
  )

  def anatomy_section_ids, do: @anatomy_sections

  def wait_section_dialog_ready(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="Dialog"]:not([data-loading])|,
        visible: :any
      )
    )

    session
  end

  def wait_root_dialog_ready(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid dialog host dom id"
    end

    assert_has(
      session,
      css(~s|##{host_dom_id}[phx-hook="Dialog"]:not([data-loading])|, visible: :any)
    )

    session
  end

  def wait_playground_dialog_ready(session) do
    wait_root_dialog_ready(session, "dialog-playground")
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#dialog-patterns-page", visible: :any))
    session
  end

  def open_dialog_in_section(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    click(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="Dialog"] [data-scope="dialog"][data-part="trigger"]|,
        visible: :any
      )
    )
  end

  def open_dialog_by_host_id(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid dialog host dom id"
    end

    click(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="dialog"][data-part="trigger"]|,
        visible: :any
      )
    )
  end

  def wait_dialog_open_in_section(session, section_dom_id, opts \\ []) do
    wait_for_has(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="dialog"][data-part="content"][data-state="open"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def wait_dialog_open_by_host_id(session, host_dom_id, opts \\ []) do
    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="dialog"][data-part="content"][data-state="open"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def click_button_in_section(session, section_id, label) when is_binary(label) do
    if String.contains?(label, "'") or String.contains?(label, "\"") do
      raise ArgumentError, "click_button_in_section: label must not include quotes"
    end

    click(
      session,
      xpath("//*[@id='#{section_id}']//button[normalize-space(.)='#{label}']")
    )

    session
  end

  def dialog_events_log_has_row?(session) do
    has?(session, css("#dialog-events-log tr[data-part='row']"))
  end
end
