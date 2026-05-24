defmodule E2eWeb.NumberInputModel do
  use E2eWeb.Model, component: "number-input"

  @anatomy_sections ~W(
    number-input-anatomy-minimal
    number-input-anatomy-bounds
  )

  def anatomy_section_ids, do: @anatomy_sections

  def wait_section_number_input_ready(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="NumberInput"]:not([data-loading])|,
        visible: :any
      )
    )

    session
  end

  def wait_root_number_input_ready(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid number input host dom id"
    end

    assert_has(
      session,
      css(~s|##{host_dom_id}[phx-hook="NumberInput"]:not([data-loading])|, visible: :any)
    )

    session
  end

  def wait_playground_number_input_ready(session) do
    wait_root_number_input_ready(session, "number-input-playground")
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#number-input-patterns-page", visible: :any))
    session
  end

  def click_increment_in_section(session, section_dom_id) do
    click(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="number-input"][data-part="increment-trigger"]|,
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
      xpath("(//*[@id='#{section_id}']//button[normalize-space(.)='#{label}'])[1]")
    )

    session
  end

  def hidden_value_at_host(session, host_dom_id) when is_binary(host_dom_id) do
    key = {:e2e_number_input_value, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        const host = document.getElementById(arguments[0]);
        const hidden = host?.querySelector('[data-part="value-input"]');
        const visible = host?.querySelector('[data-part="input"]');
        return (hidden || visible)?.value ?? "";
        """,
        [host_dom_id],
        fn value -> Process.put(key, to_string(value || "")) end
      )

    Process.get(key, "")
  end

  def hidden_value_in_section(session, section_dom_id) do
    key = {:e2e_number_input_value, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        const section = document.querySelector(arguments[0]);
        const hidden = section?.querySelector('[data-part="value-input"]');
        const visible = section?.querySelector('[data-part="input"]');
        return (hidden || visible)?.value ?? "";
        """,
        ["section#" <> section_dom_id],
        fn value -> Process.put(key, to_string(value || "")) end
      )

    Process.get(key, "")
  end

  def number_input_events_server_log_has_row?(session) do
    has?(session, css("#number-input-events-log-server tr[data-part='row']"))
  end

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/number-input/form"
        :live -> "/en/number-input/live-form"
      end

    session = visit_path(session, path)

    if mode == :live do
      prepare_live_form(session)
    else
      session
    end
  end

  def fill_number_input(session, value, mode \\ :static)

  def fill_number_input(session, value, mode) when is_number(value) do
    fill_number_input(session, to_string(value), mode)
  end

  def fill_number_input(session, value, mode) when is_binary(value) do
    form_id =
      case mode do
        :live -> "number-input-live-changeset-form"
        :static -> "number-input-changeset-form"
      end

    visible_q =
      css(~s|##{form_id} input[data-scope="number-input"][data-part="input"]|)

    ready_q = css(~s|##{form_id} [phx-hook="NumberInput"]:not([data-loading])|, visible: :any)

    session
    |> assert_has(ready_q)
    |> click(visible_q)
    |> send_keys(visible_q, [:control, "a"])
    |> send_keys(visible_q, value)
    |> assert_value_synced(form_id, value)
  end

  defp assert_value_synced(session, form_id, expected) do
    enc_form = Jason.encode!(form_id)
    enc_val = Jason.encode!(expected)

    script = """
    return (function () {
      var form = document.getElementById(#{enc_form});
      if (!form) throw new Error("assert_value_synced: form not found: " + #{enc_form});
      var hidden = form.querySelector('input[data-scope="number-input"][data-part="value-input"]');
      if (!hidden) throw new Error("assert_value_synced: hidden value-input not found in #" + #{enc_form});
      var fd = new FormData(form);
      var name = hidden.getAttribute("name");
      var sent = String(fd.get(name));
      var want = String(#{enc_val});
      if (sent !== want && sent !== want + ".0") {
        throw new Error("assert_value_synced: form would submit " + JSON.stringify(sent) + " for " + name + ", expected " + want);
      }
      return sent;
    })();
    """

    Wallaby.Browser.execute_script(session, script)
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live,
        do: "number-input-form-live-changeset-submit",
        else: "number-input-changeset-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text, _opts \\ []) do
    assert_toast(session, flash_text)
  end
end
