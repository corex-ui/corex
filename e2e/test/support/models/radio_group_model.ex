defmodule E2eWeb.RadioGroupModel do
  use E2eWeb.Model, component: "radio-group"

  @anatomy_sections ~W(
    radio-group-anatomy-minimal
    radio-group-anatomy-indicator
    radio-group-anatomy-invalid
    radio-group-anatomy-readonly
  )

  def anatomy_section_ids, do: @anatomy_sections

  def wait_section_radio_group_ready(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="RadioGroup"]:not([data-loading])|,
        visible: :any
      )
    )

    session
  end

  def wait_root_radio_group_ready(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid radio group host dom id"
    end

    assert_has(
      session,
      css(~s|##{host_dom_id}[phx-hook="RadioGroup"]:not([data-loading])|, visible: :any)
    )

    session
  end

  def wait_playground_radio_group_ready(session) do
    wait_root_radio_group_ready(session, "radio-group-playground")
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#radio-group-patterns-page", visible: :any))
    session
  end

  def click_item_in_section(session, section_dom_id, value) do
    if String.contains?(value, "'") or String.contains?(value, "\"") do
      raise ArgumentError, "click_item_in_section: value must not contain quotes"
    end

    E2eWeb.FormInputHelpers.scroll_into_view(session, section_dom_id)

    session
    |> assert_has(
      css(
        ~s|section##{section_dom_id} [phx-hook="RadioGroup"]:not([data-loading])|,
        visible: :any
      )
    )
    |> click(
      css(
        ~s|section##{section_dom_id} [data-scope="radio-group"][data-part="item"][data-value="#{value}"]|
      )
    )
  end

  def click_item_by_host_id(session, host_dom_id, value) do
    if String.contains?(value, "'") or String.contains?(value, "\"") do
      raise ArgumentError, "click_item_by_host_id: value must not contain quotes"
    end

    session
    |> assert_has(
      css(~s|##{host_dom_id}[phx-hook="RadioGroup"]:not([data-loading])|, visible: :any)
    )
    |> click(
      css(~s|##{host_dom_id} [data-scope="radio-group"][data-part="item"][data-value="#{value}"]|)
    )
  end

  def item_checked_in_section?(session, section_dom_id, value) do
    has?(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="radio-group"][data-part="item"][data-value="#{value}"][data-state="checked"]|
      )
    )
  end

  def item_checked_by_host_id?(session, host_dom_id, value) do
    has?(
      session,
      css(
        "##{host_dom_id} [data-scope='radio-group'][data-part='item'][data-value='#{value}'][data-state='checked']"
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

  def radio_group_events_server_log_has_row?(session) do
    has?(session, css("#radio-group-events-log-server tr[data-part='row']"))
  end

  def radio_group_events_client_log_has_row?(session) do
    has?(session, css("#radio-group-events-log-client tr[data-part='row']"))
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

  def wait_item_checked_by_host_id(session, host_dom_id, value, opts \\ []) do
    wait_for_has(
      session,
      css(
        "##{host_dom_id} [data-scope='radio-group'][data-part='item'][data-value='#{value}'][data-state='checked']"
      ),
      opts
    )

    session
  end

  def wait_item_not_checked_by_host_id(session, host_dom_id, value, opts \\ []) do
    wait_for_refute_has(
      session,
      css(
        "##{host_dom_id} [data-scope='radio-group'][data-part='item'][data-value='#{value}'][data-state='checked']"
      ),
      opts
    )

    session
  end

  def assert_focus_inside(session, host_dom_id) when is_binary(host_dom_id) do
    execute_script(
      session,
      """
      const root = document.getElementById('#{host_dom_id}');
      return !!(root && root.contains(document.activeElement) && document.activeElement !== document.body);
      """,
      [],
      fn v ->
        assert v == true, "expected focus inside ##{host_dom_id}"
      end
    )

    session
  end

  def dispatch_set_value_js(session, host_dom_id, value) when is_binary(value) do
    execute_script(
      session,
      """
      const el = document.getElementById('#{host_dom_id}');
      if (el) {
        el.dispatchEvent(new CustomEvent('corex:radio-group:set-value', {
          bubbles: false,
          detail: { value: '#{value}' }
        }));
      }
      """,
      []
    )

    session
  end

  def goto_form(session, mode) do
    {path, page_id} =
      case mode do
        :static -> {"/en/radio-group/form", "radio-group-form-page"}
        :live -> {"/en/radio-group/live-form", "radio-group-form-live-page"}
      end

    goto_form_page(session, path, page_id, mode)
  end

  def click_radio_native(session, value) do
    click(
      session,
      css("#radio-group-plain-form input[type='radio'][value='#{value}']")
    )

    session
  end

  def click_radio_live(session, value) do
    session
    |> click_item_in_section("radio-group-live-form-ecto-section", value)
    |> wait_section_radio_choice("radio-group-live-form-ecto-section", value)
    |> wait_radio_choice_in_form("radio-group-live-form-ecto", value)
  end

  defp wait_radio_choice_in_form(session, form_id, value) do
    enc_form = Jason.encode!(form_id)
    enc_value = Jason.encode!(value)

    case Wallaby.Browser.retry(
           fn ->
             if radio_choice_in_form?(session, enc_form, enc_value),
               do: {:ok, session},
               else: {:error, :missing}
           end,
           count: 30,
           delay: 100
         ) do
      {:ok, session} -> session
      {:error, _} -> raise Wallaby.ExpectationNotMetError, message: "radio choice not in form"
    end
  end

  defp radio_choice_in_form?(session, enc_form, enc_value) do
    key = {:e2e_radio_choice, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        return (function () {
          var form = document.getElementById(#{enc_form});
          if (!form) return "";
          var fd = new FormData(form);
          for (var pair of fd.entries()) {
            if (pair[1] === #{enc_value}) return pair[0];
          }
          return "";
        })();
        """,
        [],
        fn name -> Process.put(key, to_string(name || "")) end
      )

    Process.get(key, "") != ""
  end

  def wait_section_radio_choice(session, section_dom_id, value) do
    assert_has(
      session,
      css(
        ~s|section##{section_dom_id} input[data-scope="radio-group"][data-part="item-hidden-input"][value="#{value}"]:checked|,
        visible: :any
      )
    )

    session
  end

  def click_radio_item(session, value) do
    click_radio_native(session, value)
  end

  def wait_for_redirect(session) do
    wait_for_form_page(session, "radio-group-form-page")
  end

  def wait_for_ecto_form_error(session, error_text \\ "can't be blank") do
    wait_for_field_error(session, "radio-group-form-ecto", "radio-group", error_text)
  end

  def wait_for_live_form_unchanged(session) do
    assert_has(session, css("#radio-group-live-form-ecto", text: "Choose one"))
    session
  end

  def submit_form(session, mode \\ :static, form \\ :native) do
    id =
      case {mode, form} do
        {:live, :ecto} -> "radio-group-form-live-strict-submit"
        {:live, _} -> "radio-group-live-form-phoenix-submit"
        {:static, :ecto} -> "radio-group-validate-submit"
        {:static, :phoenix} -> nil
        _ -> "radio-group-controller-submit"
      end

    if id do
      click(session, css("##{id}"))
    else
      click(session, css("#radio-group-form-phoenix button[type='submit']"))
    end
  end

  defp safe_dom_token?(token), do: String.match?(token, ~r/^[a-zA-Z0-9_-]+$/) and token != ""

  def focus_item_in_section(session, section_dom_id, value)
      when is_binary(section_dom_id) and is_binary(value) do
    if not safe_dom_token?(section_dom_id) or not safe_dom_token?(value),
      do: raise(ArgumentError, "invalid section or value id")

    execute_script(
      session,
      """
      const host = document.querySelector(
        '[id="#{section_dom_id}"][phx-hook="RadioGroup"]'
      );
      const input = host && host.querySelector(
        '[data-scope="radio-group"][data-part="item-hidden-input"][value="#{value}"]'
      );
      if (!input) return false;
      input.style.cssText =
        'position:fixed;left:8px;top:8px;width:16px;height:16px;opacity:0.01;clip:auto;margin:0;border:0;padding:0;overflow:visible;';
      input.focus();
      return document.activeElement === input;
      """,
      [],
      fn v ->
        assert v == true, "expected focus on radio item #{value} in ##{section_dom_id}"
      end
    )

    session
  end

  def press_key_on_active(session, key) do
    press_key(session, key, 1)
  end

  def wait_item_checked_in_section(session, section_dom_id, value, opts \\ []) do
    wait_for_has(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="radio-group"][data-part="item"][data-value="#{value}"][data-state="checked"]|,
        visible: :any
      ),
      opts
    )

    session
  end
end
