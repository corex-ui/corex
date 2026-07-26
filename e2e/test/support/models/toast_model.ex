defmodule E2eWeb.ToastModel do
  use E2eWeb.Model, component: "toast"

  def wait_toast_host_ready(session) do
    E2eWeb.Model.with_layout_toast_ready(
      session,
      "expected #layout-toast[data-ready] to exist"
    )
  end

  def toast_count(session) do
    key = {:e2e_toast_count, self(), make_ref()}

    _ =
      Wallaby.Browser.execute_script(
        session,
        """
        var host = document.getElementById('layout-toast');
        if (!host) return 0;
        return host.querySelectorAll('[data-scope="toast"]').length;
        """,
        [],
        fn value -> Process.put(key, value) end
      )

    case Process.delete(key) do
      n when is_integer(n) -> n
      _ -> 0
    end
  end

  def assert_toast_visible(session) do
    wait_for_has(
      session,
      css(~s|#layout-toast [data-scope="toast"]|, minimum: 1, visible: :any),
      timeout: 8_000
    )
  end

  def assert_toast_visible_with_text(session, text) when is_binary(text) do
    E2eWeb.Model.with_layout_toast_text(
      session,
      text,
      "expected #layout-toast to contain #{inspect(text)}"
    )
  end

  def create_via_playground(session) do
    click(session, css(~s|#toast-playground form [type="submit"]|))
    session
  end

  def click_server_info(session) do
    click(session, css(~s|#toast-api-create-server .button|, at: 0))
    session
  end

  def dismiss_first_toast(session) do
    click(session, css(~s|#layout-toast [data-scope="toast"] [data-part="close-trigger"]|, at: 0))
    session
  end

  def has_close_trigger?(session) do
    has?(
      session,
      css(~s|#layout-toast [data-scope="toast"] [data-part="close-trigger"]|, visible: :any)
    )
  end

  def wait_toast_gone(session, before_count) when is_integer(before_count) do
    deadline = System.monotonic_time(:millisecond) + 8_000
    poll_toast_count_below(session, before_count, deadline)
    session
  end

  defp poll_toast_count_below(session, target, deadline) do
    if toast_count(session) < target do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        :ok
      else
        Process.sleep(100)
        poll_toast_count_below(session, target, deadline)
      end
    end
  end
end
