defmodule E2eWeb.Model do
  @moduledoc "Base model with shared test utilities"

  def wait(session, time) do
    Process.sleep(time)
    session
  end

  defmacro __using__(opts) do
    component = Keyword.get(opts, :component)

    quote do
      import Wallaby.Query
      import Wallaby.Browser

      @component unquote(component)

      def goto(session, mode \\ :static) do
        path =
          case mode do
            :static -> "/en/#{@component}"
            :live -> "/en/live/#{@component}"
            custom when is_binary(custom) -> custom
          end

        visit(session, path)
      end

      def press_key(session, key, times \\ 1) do
        Enum.reduce(1..times, session, fn _, s ->
          Wallaby.Browser.send_keys(s, [key])
        end)
      end

      def press_space(session) do
        Wallaby.Browser.send_keys(session, [:space])
      end

      def press_enter(session) do
        Wallaby.Browser.send_keys(session, [:enter])
      end

      def type(session, value) do
        Wallaby.Browser.send_keys(session, [value])
      end

      def click_outside(session) do
        execute_script(session, "document.body.click()")
      end

      def wait(session, time) do
        Process.sleep(time)
        session
      end

      def wait_for_text(session, text, opts \\ []) do
        timeout_ms = Keyword.get(opts, :timeout, 5_000)
        interval_ms = Keyword.get(opts, :interval, 200)
        deadline = System.monotonic_time(:millisecond) + timeout_ms

        wait_until_text_visible(session, text, deadline, interval_ms)
        assert_has(session, Wallaby.Query.text(text))
        session
      end

      defp wait_until_text_visible(session, text, deadline, interval_ms) do
        if has?(session, Wallaby.Query.text(text)) do
          :ok
        else
          if System.monotonic_time(:millisecond) >= deadline do
            raise "Expected to find text \"#{text}\" within timeout, but it was not visible"
          else
            Process.sleep(interval_ms)
            wait_until_text_visible(session, text, deadline, interval_ms)
          end
        end
      end

      def see(session, text_value) do
        assert_has(session, Wallaby.Query.text(text_value))
      end

      def dont_see(session, text_value) do
        refute_has(session, Wallaby.Query.text(text_value))
      end

      def check_accessibility(session, selector \\ nil) do
        session = wait(session, 5000)

        case selector do
          nil -> A11yAudit.Wallaby.assert_no_violations(session)
          sel -> A11yAudit.Wallaby.assert_no_violations(session, context: sel)
        end
      end

      defoverridable goto: 2
    end
  end
end
