defmodule E2eWeb.EditableModel do
  use E2eWeb.Model, component: "editable"

  import Wallaby.Query

  @anatomy_sections ~W(
    editable-anatomy-minimal
    editable-anatomy-triggers
  )

  def anatomy_section_ids, do: @anatomy_sections

  def valid_dom_id?(dom_id) do
    String.match?(dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(dom_id) > 0
  end

  def wait_host_editable_ready(session, host_dom_id, opts \\ []) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(~s|##{host_dom_id}[phx-hook="Editable"]:not([data-loading])|, visible: :any)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_section_editable_ready(session, section_dom_id, opts \\ []) do
    if not valid_dom_id?(section_dom_id), do: raise(ArgumentError, "invalid section dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(
        ~s|section##{section_dom_id} [phx-hook="Editable"]:not([data-loading])|,
        visible: :any
      )

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def click_edit_trigger_in_host(session, host_dom_id) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    click(
      session,
      css(~s|##{host_dom_id} [data-scope="editable"][data-part="edit-trigger"]|, visible: :any)
    )

    session
  end

  def click_submit_trigger_in_host(session, host_dom_id) do
    click(
      session,
      css(~s|##{host_dom_id} [data-scope="editable"][data-part="submit-trigger"]|, visible: :any)
    )

    session
  end

  def focus_input_in_host(session, host_dom_id) do
    _ =
      execute_script(
        session,
        """
        const root = document.getElementById(arguments[0]);
        const input = root?.querySelector('[data-scope="editable"][data-part="input"]');
        if (input) input.focus();
        """,
        [host_dom_id]
      )

    session
  end

  def type_in_focused_input(session, text) when is_binary(text) do
    Wallaby.Browser.send_keys(session, [text])
    session
  end

  def type_in_host(session, host_dom_id, text) when is_binary(text) do
    fill_in(
      session,
      css(~s|##{host_dom_id} [data-scope="editable"][data-part="input"]|, visible: :any),
      with: text
    )
  end

  def preview_text_in_host(session, host_dom_id) do
    el =
      find(
        session,
        css(~s|##{host_dom_id} [data-scope="editable"][data-part="preview"]|, visible: :any)
      )

    Wallaby.Element.text(el)
  end

  def wait_preview_contains_in_host(session, host_dom_id, substring, opts \\ [])
      when is_binary(substring) do
    if String.contains?(substring, "'") do
      raise ArgumentError, "substring must not contain single quote"
    end

    wait_for_has(
      session,
      xpath(
        "//*[@id='#{host_dom_id}']//*[@data-scope='editable'][@data-part='preview'][contains(., '#{substring}')]"
      ),
      opts
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

  def editable_events_server_log_has_row?(session) do
    has?(session, css("#editable-events-log-server tr[data-part='row']", visible: :any))
  end

  def editable_events_client_log_has_row?(session) do
    has?(session, css("#editable-events-log-client tr[data-part='row']", visible: :any))
  end

  def set_live_form_text(session, text) when is_binary(text) do
    session
    |> wait_for_has(
      css("#editable-live-form-phoenix-section", visible: :any),
      timeout: 15_000
    )
    |> execute_script(
      """
      const input = document.querySelector('input[name="editable_phoenix[text]"]');
      if (input) {
        input.value = arguments[0];
        input.dispatchEvent(new Event("input", { bubbles: true }));
        input.dispatchEvent(new Event("change", { bubbles: true }));
      }
      const host = document.getElementById("editable-live-form-phoenix-text");
      host?.dispatchEvent(
        new CustomEvent("corex:editable:set-value", {
          bubbles: false,
          detail: { value: arguments[0] }
        })
      );
      """,
      [text]
    )
  end

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/editable/form"
        :live -> "/en/editable/live-form#editable-live-form-phoenix-section"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live,
        do: "editable-live-form-phoenix-submit",
        else: "editable-form-phoenix-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    assert_toast(session, flash_text)
  end
end
