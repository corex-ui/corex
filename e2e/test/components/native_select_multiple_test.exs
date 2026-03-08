defmodule E2eWeb.NativeSelectMultipleTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Browser
  import Wallaby.Query

  alias E2eWeb.NativeInputModel, as: NativeInput

  defp wait(session, ms) do
    Process.sleep(ms)
    session
  end

  feature "submit without selection shows empty tags", %{session: session} do
    session
    |> visit("/en/live/native-input/form")
    |> wait(500)
    |> NativeInput.fill_input_via_script("profile_name", "Test")
    |> NativeInput.fill_input_via_script("profile_email", "test@example.com")
    |> NativeInput.click_checkbox()
    |> wait(500)
    |> click(css("#native-input-form-live-submit"))
    |> wait(1000)
    |> assert_has(Wallaby.Query.text("tags=[]"))
  end

  feature "select multiple options and submit shows selected tags", %{session: session} do
    session
    |> visit("/en/live/native-input/form")
    |> wait(500)
    |> NativeInput.fill_input_via_script("profile_name", "Test")
    |> NativeInput.fill_input_via_script("profile_email", "test@example.com")
    |> NativeInput.click_checkbox()
    |> select_multiple_options("native-input-form-tags-input", ["elixir", "phoenix"])
    |> wait(500)
    |> click(css("#native-input-form-live-submit"))
    |> wait_for_text("elixir", timeout: 5000)
    |> assert_has(Wallaby.Query.text("phoenix"))
  end

  feature "has no A11y violations", %{session: session} do
    session
    |> visit("/en/live/native-input/form")
    |> wait(500)
    |> A11yAudit.Wallaby.assert_no_violations()
  end

  defp select_multiple_options(session, select_id, values) when is_list(values) do
    values_js = inspect(values)

    script = """
    (function() {
      var select = document.getElementById('#{select_id}');
      if (!select) return 'select not found';
      var values = #{values_js};
      for (var i = 0; i < select.options.length; i++) {
        select.options[i].selected = values.indexOf(select.options[i].value) !== -1;
      }
      select.dispatchEvent(new Event('change', { bubbles: true }));
      return 'ok';
    })()
    """

    Wallaby.Browser.execute_script(session, script)
    session
  end

  defp wait_for_text(session, text, opts) do
    timeout_ms = Keyword.get(opts, :timeout, 5_000)
    interval_ms = Keyword.get(opts, :interval, 200)
    deadline = System.monotonic_time(:millisecond) + timeout_ms
    wait_until_text_visible(session, text, deadline, interval_ms)
    assert_has(session, Wallaby.Query.text(text))
    session
  end

  defp wait_until_text_visible(session, search_text, deadline, interval_ms) do
    if has?(session, Wallaby.Query.text(search_text)) do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        raise "Expected to find text \"#{search_text}\" within timeout, but it was not visible"
      else
        Process.sleep(interval_ms)
        wait_until_text_visible(session, search_text, deadline, interval_ms)
      end
    end
  end
end
