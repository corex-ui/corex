defmodule E2eWeb.Model do
  @moduledoc "Base model with shared test utilities"

  defmacro __using__(opts) do
    component = Keyword.get(opts, :component)

    quote do
      import Wallaby.Query
      import Wallaby.Browser

      @component unquote(component)

      def goto(session, mode \\ :static) do
        path =
          case mode do
            :static -> "/#{@component}"
            :live -> "/live/#{@component}"
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

      def see(session, text_value) do
        assert_has(session, Wallaby.Query.text(text_value))
      end

      def dont_see(session, text_value) do
        refute_has(session, Wallaby.Query.text(text_value))
      end

      def check_accessibility(session, selector \\ nil) do
        session = wait(session, 200)

        case selector do
          nil -> A11yAudit.Wallaby.assert_no_violations(session)
          sel -> A11yAudit.Wallaby.assert_no_violations(session, context: sel)
        end
      end

      defoverridable goto: 2
    end
  end
end
