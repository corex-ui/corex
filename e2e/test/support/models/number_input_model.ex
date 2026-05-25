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

  def goto_form(session, mode, form \\ :phoenix) do
    path =
      case {mode, form} do
        {:static, :native} -> "/en/number-input/form#number-input-form-native"
        {:static, _} -> "/en/number-input/form#number-input-form-phoenix"
        {:live, _} -> "/en/number-input/live-form"
      end

    session = visit_path(session, path)

    if mode == :live do
      prepare_live_form(session)
    else
      session
    end
  end

  def fill_number_input(session, value, mode \\ :static, form \\ :phoenix)

  def fill_number_input(session, value, mode, form) when is_number(value) do
    fill_number_input(session, to_string(value), mode, form)
  end

  def fill_number_input(session, value, mode, form) when is_binary(value) do
    if mode == :static and form == :native do
      visible_q =
        css(
          "#number-input-plain-value [data-scope='number-input'][data-part='input']",
          visible: :any
        )

      ready_q =
        css(
          "#number-input-plain-form [phx-hook='NumberInput']:not([data-loading])",
          visible: :any
        )

      session
      |> assert_has(ready_q)
      |> click(visible_q)
      |> send_keys(visible_q, [:control, "a"])
      |> send_keys(visible_q, value)
      |> assert_value_synced("number-input-plain-form", value)
    else
      form_id =
        case mode do
          :live -> "number-input-live-form-phoenix"
          _ -> "number-input-form-phoenix"
        end

      visible_q =
        css(~s|##{form_id} input[data-scope="number-input"][data-part="input"]|)

      ready_q = css(~s|##{form_id} [phx-hook="NumberInput"]:not([data-loading])|, visible: :any)

      session =
        session
        |> assert_has(ready_q)
        |> set_number_input_value(form_id, value)
        |> click(visible_q)

      session =
        if mode == :live do
          session
          |> nudge_number_input_change(form_id, value)
          |> wait_live_number_input_used(form_id)
          |> wait(400)
        else
          session
          |> click(visible_q)
          |> send_keys(visible_q, [:control, "a"])
          |> send_keys(visible_q, value)
        end

      assert_value_synced(session, form_id, value)
    end
  end

  defp set_number_input_value(session, form_id, value) when is_binary(value) do
    enc_form = Jason.encode!(form_id)
    enc_value = Jason.encode!(value)

    num =
      case Float.parse(value) do
        {n, _} -> n
        :error -> value
      end

    enc_num = Jason.encode!(num)

    execute_script(
      session,
      """
      return (function () {
        var form = document.getElementById(#{enc_form});
        var hook = form?.querySelector('[phx-hook="NumberInput"]');
        if (!hook) return;
        hook.dispatchEvent(
          new CustomEvent("corex:number-input:set-value", {
            bubbles: true,
            detail: { value: #{enc_num} }
          })
        );
        var visible = hook.querySelector('[data-scope="number-input"][data-part="input"]');
        var setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, "value").set;
        if (visible) setter.call(visible, #{enc_value});
      })();
      """
    )

    session
  end

  defp nudge_number_input_change(session, form_id, value \\ nil) do
    enc_form = Jason.encode!(form_id)
    enc_value = if(value, do: Jason.encode!(value), else: "null")

    execute_script(
      session,
      """
      return (function () {
        var form = document.getElementById(#{enc_form});
        var hook = form?.querySelector('[phx-hook="NumberInput"]');
        var visible = hook?.querySelector('[data-scope="number-input"][data-part="input"]');
        var hidden = hook?.querySelector('[data-scope="number-input"][data-part="value-input"]');
        if (!visible) return;
        var v = #{enc_value};
        var setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, "value").set;
        if (v == null) {
          v = hidden?.value ?? visible.value ?? "";
        }
        setter.call(visible, v);
        visible.dispatchEvent(new Event("input", { bubbles: true }));
        visible.dispatchEvent(new Event("change", { bubbles: true }));
        if (hidden) {
          setter.call(hidden, v);
          if (!hidden.phxPrivate) hidden.phxPrivate = {};
          hidden.phxPrivate["phx-has-focused"] = true;
          hidden.dispatchEvent(new Event("input", { bubbles: true }));
          hidden.dispatchEvent(new Event("change", { bubbles: true }));
        }
      })();
      """
    )

    session
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

  def submit_form(session, mode \\ :static, form \\ :phoenix) do
    case {mode, form} do
      {:static, :native} ->
        session
        |> assert_has(
          css(
            "#number-input-plain-form [phx-hook='NumberInput']:not([data-loading])",
            visible: :any
          )
        )
        |> click(css("#number-input-plain-submit"))

      {:live, _} ->
        form_id = "number-input-live-form-phoenix"

        session
        |> assert_has(
          css("##{form_id} [phx-hook='NumberInput']:not([data-loading])", visible: :any)
        )
        |> wait_number_input_hidden_value(form_id, :live)
        |> nudge_number_input_change(form_id)
        |> wait_live_number_input_used(form_id)
        |> click(css("##{form_id} button[type='submit']"))

      _ ->
        form_id = "number-input-form-phoenix"

        session
        |> assert_has(
          css("##{form_id} [phx-hook='NumberInput']:not([data-loading])", visible: :any)
        )
        |> wait_number_input_hidden_value(form_id, :static)
        |> click(css("##{form_id} button[type='submit']"))
    end
  end

  defp wait_number_input_hidden_value(session, form_id, _mode) do
    deadline = System.monotonic_time(:millisecond) + 8_000
    busy_wait_hidden_value(session, form_id, deadline)
    session
  end

  defp wait_live_number_input_used(session, form_id) do
    enc_form = Jason.encode!(form_id)
    key = {:e2e_number_input_used, self(), make_ref()}

    Wallaby.Browser.retry(fn ->
      _ =
        execute_script(
          session,
          """
          var form = document.getElementById(#{enc_form});
          var hidden = form?.querySelector('[data-scope="number-input"][data-part="value-input"]');
          return !!(hidden?.phxPrivate && hidden.phxPrivate["phx-has-focused"]);
          """,
          [],
          fn value -> Process.put(key, value in [true, "true", 1, "1"]) end
        )

      if Process.get(key, false), do: {:ok, session}, else: {:error, :not_used}
    end)

    Process.delete(key)
    session
  end

  defp busy_wait_hidden_value(session, form_id, deadline) do
    value = hidden_value_in_form(session, form_id)

    if value != "" do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        :ok
      else
        Process.sleep(50)
        busy_wait_hidden_value(session, form_id, deadline)
      end
    end
  end

  defp hidden_value_in_form(session, form_id) do
    key = {:e2e_number_input_value, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        const form = document.getElementById(arguments[0]);
        const input = form?.querySelector('input[data-scope="number-input"][data-part="value-input"]');
        return input?.value ?? "";
        """,
        [form_id],
        fn value -> Process.put(key, to_string(value || "")) end
      )

    Process.get(key, "")
  end

  def wait_for_redirect(session) do
    assert_has(session, css("#number-input-form-page", visible: :any))
    session
  end

  def see_flash(session, flash_text, _opts \\ []) do
    assert_toast(session, flash_text)
  end
end
