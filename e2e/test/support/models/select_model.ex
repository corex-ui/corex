defmodule E2eWeb.SelectModel do
  use E2eWeb.Model, component: "select"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/select/form"
        :live -> "/en/select/live-form"
      end

    session = visit_path(session, path)

    if mode == :live do
      prepare_live_form_for_push_toast(session)
    else
      session
    end
  end

  def wait_for_select_field_error(session, mode \\ :static, opts \\ []) do
    timeout_ms = Keyword.get(opts, :timeout, 10_000)
    interval_ms = Keyword.get(opts, :interval, 200)
    deadline = System.monotonic_time(:millisecond) + timeout_ms

    form_id =
      case mode do
        :live -> "select-form"
        :static -> "select-changeset-form"
      end

    q = css(~s(##{form_id} [data-scope="select"][data-part="error"]), visible: :any)
    wait_until_select_error(session, q, deadline, interval_ms)
    el = find(session, q)
    assert String.contains?(Wallaby.Element.text(el), "blank")
    session
  end

  defp wait_until_select_error(session, q, deadline, interval_ms) do
    if has?(session, q) do
      el = find(session, q)

      if String.contains?(Wallaby.Element.text(el), "blank") do
        :ok
      else
        if System.monotonic_time(:millisecond) >= deadline do
          flunk(
            "expected select error text to mention \"blank\", got #{inspect(Wallaby.Element.text(el))}"
          )
        else
          Process.sleep(interval_ms)
          wait_until_select_error(session, q, deadline, interval_ms)
        end
      end
    else
      if System.monotonic_time(:millisecond) >= deadline do
        flunk("expected select error [data-part=error] within timeout")
      else
        Process.sleep(interval_ms)
        wait_until_select_error(session, q, deadline, interval_ms)
      end
    end
  end

  def click_select_trigger(session) do
    click(session, css("[data-scope='select'][data-part='trigger']"))
  end

  def click_form_select_trigger(session, mode \\ :static) do
    form_id = if mode == :live, do: "select-form", else: "select-changeset-form"
    click(session, css("##{form_id} [data-scope='select'][data-part='trigger']"))
  end

  def select_item(session, value) when is_binary(value) do
    click(session, css("[data-scope='select'][data-part='item'][data-value='#{value}']"))
  end

  def set_select_value(session, id, value) do
    hidden_id = if String.ends_with?(id, "-value"), do: id, else: "#{id}-value"

    script = """
    (function() {
      var el = document.getElementById('#{hidden_id}');
      if (!el) return 'not found';
      el.value = '#{value}';
      el.dispatchEvent(new Event('input', { bubbles: true }));
      el.dispatchEvent(new Event('change', { bubbles: true }));
      return 'ok';
    })()
    """

    Wallaby.Browser.execute_script(session, script)
    session
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "select-form-live-submit", else: "select-changeset-submit"
    click(session, css("##{id}"))
  end

  def see_submitted_value(session, key, value) do
    wait_for_text(session, "#{key}=#{value}")
  end

  def see_flash(session, flash_text, opts \\ []) do
    wait_for_flash(session, flash_text, opts)
  end
end
