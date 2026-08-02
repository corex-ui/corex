defmodule E2eWeb.SwitchModel do
  @moduledoc """
  Behavior map:
    anatomy  - click control, assert data-state flipped
    api      - binding Off/On, assert host data-state
    events   - server log growth + value mention
    patterns - controlled click, assert root checked
    form     - submit, validation errors
  """

  use E2eWeb.Model, component: "switch"

  @anatomy_sections ~W(
    switch-anatomy-minimal
    switch-anatomy-labeled
  )

  def anatomy_section_ids, do: @anatomy_sections

  def assert_checked(session, host_dom_id) do
    wait_state(session, host_dom_id, "checked")
  end

  def assert_unchecked(session, host_dom_id) do
    wait_state(session, host_dom_id, "unchecked")
  end

  def wait_state(session, host_dom_id, expected, opts \\ [])
      when expected in ~w(checked unchecked) do
    timeout = Keyword.get(opts, :timeout, 8_000)

    wait_for_has(
      session,
      css(
        "##{host_dom_id} [data-scope=\"switch\"][data-part=\"root\"][data-state=\"#{expected}\"]",
        visible: :any
      ),
      timeout: timeout
    )

    session
  end

  def wait_playground_switch_ready(session) do
    assert_has(
      session,
      css("#switch-playground[phx-hook='Switch']:not([data-loading])", visible: :any)
    )

    session
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#switch-patterns-page", visible: :any))
    session
  end

  def click_playground_switch_control(session) do
    session
    |> assert_has(css("#switch-playground[phx-hook='Switch']:not([data-loading])", visible: :any))
    |> click(css("#switch-playground [data-scope='switch'][data-part='control']", visible: :any))
  end

  def click_control_in_section(session, section_dom_id) do
    session
    |> assert_has(css("##{section_dom_id} [phx-hook='Switch']:not([data-loading])"))
    |> click(css("##{section_dom_id} [data-scope='switch'][data-part='control']"))
  end

  def click_api_off(session) do
    click(
      session,
      xpath(
        "//*[@id='switch-api-set-checked-client-binding']//button[contains(normalize-space(),'Off')]"
      )
    )

    session
  end

  def click_api_on(session) do
    click(
      session,
      xpath(
        "//*[@id='switch-api-set-checked-client-binding']//button[contains(normalize-space(),'On')]"
      )
    )

    session
  end

  def click_api_js_on(session) do
    click(
      session,
      xpath(
        "//*[@id='switch-api-set-checked-client-js']//button[contains(normalize-space(),'On')]"
      )
    )

    session
  end

  def click_api_server_on(session) do
    click(
      session,
      xpath("//*[@id='switch-api-set-checked-server']//button[contains(normalize-space(),'On')]")
    )

    session
  end

  def root_data_state(session, host_dom_id) when is_binary(host_dom_id) do
    key = {:switch_root_state, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        const root = document.querySelector(
          '#' + arguments[0] + ' [data-scope="switch"][data-part="root"]'
        );
        return root ? root.getAttribute('data-state') : null;
        """,
        [host_dom_id],
        fn value -> Process.put(key, value) end
      )

    Process.delete(key)
  end

  def root_data_state_in_section(session, section_dom_id) when is_binary(section_dom_id) do
    key = {:switch_section_state, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        const root = document.querySelector(
          '#' + arguments[0] + ' [data-scope="switch"][data-part="root"]'
        );
        return root ? root.getAttribute('data-state') : null;
        """,
        [section_dom_id],
        fn value -> Process.put(key, value) end
      )

    Process.delete(key)
  end

  def wait_root_data_state(session, host_dom_id, expected, opts \\ [])
      when is_binary(host_dom_id) and is_binary(expected) do
    wait_for_has(
      session,
      css(
        "##{host_dom_id} [data-scope='switch'][data-part='root'][data-state='#{expected}']",
        visible: :any
      ),
      timeout: Keyword.get(opts, :timeout, 5_000)
    )
  end

  def wait_root_data_state_in_section(session, section_dom_id, expected, opts \\ [])
      when is_binary(section_dom_id) and is_binary(expected) do
    wait_for_has(
      session,
      css(
        "##{section_dom_id} [data-scope='switch'][data-part='root'][data-state='#{expected}']",
        visible: :any
      ),
      timeout: Keyword.get(opts, :timeout, 5_000)
    )
  end

  def switch_events_client_log_has_row?(session) do
    has?(session, css("#switch-events-log-client tr[data-part='row']"))
  end

  def switch_events_server_log_has_row?(session) do
    has?(session, css("#switch-events-log-server tr[data-part='row']"))
  end

  def goto_form(session, mode) do
    {path, page_id} =
      case mode do
        :static -> {"/en/switch/form", "switch-form-page"}
        :live -> {"/en/switch/live-form", "switch-form-live-page"}
      end

    goto_form_page(session, path, page_id, mode)
  end

  def wait_switch_host_ready(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid switch host dom id"
    end

    wait_ready(session, "##{host_dom_id}")
  end

  def click_switch(session, mode \\ :static) do
    host_dom_id =
      case mode do
        :live -> "switch-live-form-ecto_notifications"
        _ -> "switch-form-phoenix_notifications"
      end

    session =
      session
      |> wait_switch_host_ready(host_dom_id)
      |> click_switch_control(host_dom_id)

    wait_for_has(
      session,
      css(
        "##{host_dom_id} [data-scope='switch'][data-part='root'][data-state='checked']",
        visible: :any
      ),
      timeout: 10_000
    )

    session
  end

  def click_switch_control(session, host_dom_id) when is_binary(host_dom_id) do
    _ =
      execute_script(
        session,
        """
        const host = document.getElementById(arguments[0]);
        const control = host?.querySelector('[data-scope="switch"][data-part="control"]');
        if (!control) throw new Error("switch control not found");
        control.click();
        """,
        [host_dom_id]
      )

    session
  end

  def press_space_on_switch(session) do
    session
    |> focus_element("[data-scope='switch'][data-part='control']")
    |> then(&Wallaby.Browser.send_keys(&1, [:space]))
  end

  defp focus_element(session, selector) do
    Wallaby.Browser.execute_script(session, "document.querySelector('#{selector}').focus()")
  end

  def focus_control_in_section(session, section_dom_id) when is_binary(section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    execute_script(
      session,
      """
      const host = document.querySelector(
        '[id="#{section_dom_id}"][phx-hook="Switch"]'
      ) || document.getElementById('#{section_dom_id}');
      const input = host && host.querySelector(
        '[data-scope="switch"][data-part="hidden-input"], input[type="checkbox"]'
      );
      if (!input) return false;
      input.style.cssText =
        'position:fixed;left:8px;top:8px;width:16px;height:16px;opacity:0.01;clip:auto;margin:0;border:0;padding:0;overflow:visible;';
      input.focus();
      return document.activeElement === input;
      """,
      [],
      fn v -> assert v == true, "expected focus on switch input in ##{section_dom_id}" end
    )

    session
  end

  def press_key_on_active(session, key) do
    press_key(session, key, 1)
  end

  def submit_form(session, mode \\ :static) do
    case mode do
      :live ->
        session
        |> assert_has(css("#switch-live-form-ecto [phx-hook='Switch']:not([data-loading])"))
        |> click(css("#switch-live-form-ecto-submit"))

      _ ->
        click(session, css("#switch-form-phoenix-submit"))
    end
  end

  def see_error(session, error_text, mode \\ :live) do
    form_id =
      case mode do
        :static -> "switch-form-ecto"
        :live -> "switch-live-form-ecto"
      end

    wait_for_field_error(session, form_id, "switch", error_text)
  end
end
