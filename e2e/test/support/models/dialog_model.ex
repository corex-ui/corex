defmodule E2eWeb.DialogModel do
  use E2eWeb.Model, component: "dialog"

  @anatomy_sections ~W(
    dialog-anatomy-minimal
    dialog-anatomy-title-description
    dialog-anatomy-actions
  )

  @anatomy_section_to_host_id %{
    "dialog-anatomy-minimal" => "dialog-anatomy-minimal",
    "dialog-anatomy-title-description" => "dialog-anatomy-titled",
    "dialog-anatomy-actions" => "dialog-anatomy-actions"
  }

  def anatomy_section_ids, do: @anatomy_sections

  def host_id_for_anatomy_section(section_id),
    do: Map.fetch!(@anatomy_section_to_host_id, section_id)

  def wait_section_dialog_ready(session, section_dom_id, opts \\ []) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    wait_section_hook(session, section_dom_id, "Dialog", opts)
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
        ~s|##{host_dom_id} [data-scope="dialog"][data-part="trigger"][data-state="open"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def close_dialog_by_host_id(session, host_dom_id) when is_binary(host_dom_id) do
    click(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="dialog"][data-part="close-trigger"]|,
        visible: :any
      )
    )

    session
  end

  def wait_dialog_closed_by_host_id(session, host_dom_id, opts \\ []) do
    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="dialog"][data-part="trigger"][data-state="closed"]|,
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
      xpath("(//*[@id=\'#{section_id}\']//button[normalize-space(.)=\'#{label}\'])[1]")
    )

    session
  end

  def dialog_events_log_has_row?(session) do
    has?(session, css("#dialog-events-log tr[data-part='row']"))
  end

  def dialog_events_server_log_has_row?(session) do
    has?(session, css("#dialog-events-log-server tr[data-part='row']", visible: :any))
  end

  def dialog_events_client_log_has_row?(session) do
    has?(session, css("#dialog-events-log-client tr[data-part='row']", visible: :any))
  end

  def events_log_text(session, log_dom_id) when is_binary(log_dom_id) do
    el = find(session, css("##{log_dom_id}", visible: :any))
    Wallaby.Element.text(el)
  end

  def assert_events_log_mentions(session, log_dom_id, substring)
      when is_binary(log_dom_id) and is_binary(substring) do
    text = events_log_text(session, log_dom_id)

    assert String.contains?(text, substring),
           "expected ##{log_dom_id} to mention #{inspect(substring)}, got: #{inspect(text)}"

    session
  end

  def assert_active_element_id(session, dom_id) when is_binary(dom_id) do
    if not (String.match?(dom_id, ~r/^[a-zA-Z0-9_:-]+$/) and String.length(dom_id) > 0) do
      raise ArgumentError, "only safe id strings for assert_active_element_id/2"
    end

    execute_script(
      session,
      "return document.activeElement?.id",
      [],
      fn id -> assert id == dom_id end
    )

    session
  end

  defp safe_dom_token?(token), do: String.match?(token, ~r/^[a-zA-Z0-9_-]+$/) and token != ""

  def press_key_on_active(session, key) do
    press_key(session, key, 1)
  end

  def dialog_open?(session, host_dom_id) when is_binary(host_dom_id) do
    has?(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="dialog"][data-part="trigger"][data-state="open"]|,
        visible: :any
      )
    )
  end

  def assert_focus_inside_dialog(session, host_dom_id) when is_binary(host_dom_id) do
    if not safe_dom_token?(host_dom_id), do: raise(ArgumentError, "invalid dialog host dom id")

    execute_script(
      session,
      """
      const root = document.getElementById('#{host_dom_id}');
      const content = root && root.querySelector(
        '[data-scope="dialog"][data-part="content"][data-state="open"]'
      );
      return !!(content && content.contains(document.activeElement));
      """,
      [],
      fn v ->
        assert v == true, "expected focus inside open dialog content in ##{host_dom_id}"
      end
    )

    session
  end
end
