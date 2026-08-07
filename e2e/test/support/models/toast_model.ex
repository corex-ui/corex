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
      css(~S|#layout-toast [data-scope="toast"]|, minimum: 1, visible: :any),
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
    click(session, css(~S|#toast-playground form [type="submit"]|))
    session
  end

  def click_server_info(session) do
    click(session, css(~S|#toast-api-create-server .button|, at: 0))
    session
  end

  # Zag pauses auto-dismiss and expands the overlap stack on group mouseenter.
  # Wallaby flows often exceed the demo duration (5s) without this.
  def pause_toast_timers(session) do
    _ =
      Wallaby.Browser.execute_script(
        session,
        """
        var group = document.querySelector(
          '#layout-toast [data-scope="toast"][data-part="group"]'
        );
        if (!group) return false;
        group.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }));
        group.dispatchEvent(new MouseEvent('mousemove', { bubbles: true }));
        return true;
        """
      )

    session
  end

  def dismiss_first_toast(session) do
    # Skip closing roots still in removeDelay; click via DOM so overlap /
    # height reflow does not depend on Wallaby visibility.
    wait_for_has(
      session,
      css(
        ~S|#layout-toast [data-scope="toast"][data-part="root"][data-state="open"] [data-part="close-trigger"]|,
        minimum: 1,
        visible: :any
      ),
      timeout: 8_000
    )

    _ =
      Wallaby.Browser.execute_script(
        session,
        """
        var host = document.getElementById('layout-toast');
        if (!host) return false;
        var root = host.querySelector(
          '[data-scope="toast"][data-part="root"][data-state="open"]'
        );
        var btn = root && root.querySelector('[data-part="close-trigger"]');
        if (!btn) return false;
        btn.click();
        return true;
        """
      )

    session
  end

  def toast_root_count(session) do
    key = {:e2e_toast_root_count, self(), make_ref()}

    _ =
      Wallaby.Browser.execute_script(
        session,
        """
        var host = document.getElementById('layout-toast');
        if (!host) return 0;
        return host.querySelectorAll('[data-scope="toast"][data-part="root"]').length;
        """,
        [],
        fn value -> Process.put(key, value) end
      )

    case Process.delete(key) do
      n when is_integer(n) -> n
      _ -> 0
    end
  end

  def wait_toast_root_count(session, expected) when is_integer(expected) do
    deadline = System.monotonic_time(:millisecond) + 8_000
    poll_toast_root_count(session, expected, deadline)
    session
  end

  defp poll_toast_root_count(session, expected, deadline) do
    if toast_root_count(session) == expected do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        :ok
      else
        Process.sleep(100)
        poll_toast_root_count(session, expected, deadline)
      end
    end
  end

  def has_close_trigger?(session) do
    has?(
      session,
      css(~S|#layout-toast [data-scope="toast"] [data-part="close-trigger"]|, visible: :any)
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
