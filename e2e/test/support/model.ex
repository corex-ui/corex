defmodule E2eWeb.Model do
  @moduledoc """
  Base model with shared test utilities.

  All wait/poll helpers are thin wrappers over Wallaby's native
  `assert_has/2` and `refute_has/2`, which retry implicitly up to
  `:wallaby, :max_wait_time` (configured in `config/test.exs`).

  Readiness contract:

    * Interactive Zag-backed components keep the `data-loading`
      attribute on their host element. The base `Component` class in
      `core.ts` removes `data-loading` once the underlying state
      machine has started, so tests wait on
      `css("...:not([data-loading])")` to know a component is
      interactive.

    * The layout `Toast` group is special: it lives in the layout,
      uses `phx-update="ignore"`, and is never a direct interaction
      target. Instead of `data-loading`, the `Toast` hook publishes a
      positive `data-ready` flag once `createToastGroup` succeeds.
      `prepare_live_form/1` waits for `#layout-toast[data-ready]`
      before returning, and `assert_toast/2` / `refute_toast/2` look
      for substrings inside the rendered toast container
      (`#layout-toast [data-scope='toast'][data-part='root']`)
      rather than the whole `body`.
  """

  def wait(session, time) do
    Process.sleep(time)
    session
  end

  defmacro __using__(opts) do
    component = Keyword.get(opts, :component)

    quote do
      import Wallaby.Query
      import Wallaby.Browser
      import ExUnit.Assertions

      @component unquote(component)

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

      def visit_path(session, path) when is_binary(path) do
        visit(session, path)
      end

      def goto(session, path) when is_binary(path) do
        visit_path(session, path)
      end

      def wait_ready(session, %Wallaby.Query{} = query) do
        assert_has(session, query)
      end

      def wait_ready(session, css_selector) when is_binary(css_selector) do
        assert_has(
          session,
          css(css_selector <> "[data-loading]", count: 0, visible: :any)
        )
      end

      def prepare_live_form(session) do
        assert_has(session, css("#layout-toast[data-ready]", visible: :any))
      end

      def prepare_live_form_for_push_toast(session) do
        prepare_live_form(session)
      end

      def assert_toast(session, substring) when is_binary(substring) do
        assert_has(
          session,
          css("#layout-toast [data-scope='toast'][data-part='root']", text: substring)
        )
      end

      def refute_toast(session, substring) when is_binary(substring) do
        assert_has(
          session,
          css("#layout-toast [data-scope='toast'][data-part='root']",
            count: 0,
            text: substring
          )
        )
      end

      def assert_submitted(session, substring) when is_binary(substring) do
        assert_toast(session, substring)
      end

      def wait_for_has(session, %Wallaby.Query{} = query, _opts \\ []) do
        assert_has(session, query)
      end

      def wait_for_text(session, text, _opts \\ []) when is_binary(text) do
        assert_has(session, css("body", text: text))
      end

      def wait_for_flash(session, substring, _opts \\ []) when is_binary(substring) do
        assert_toast(session, substring)
      end

      def visit_ready(session, path, %Wallaby.Query{} = ready_query, _opts \\ []) do
        session
        |> visit_path(path)
        |> assert_has(ready_query)
      end

      def visit_and_check_a11y(session, path, %Wallaby.Query{} = ready_query) do
        conds = Keyword.put(ready_query.conditions, :visible, :any)
        ready = %{ready_query | conditions: conds}

        session
        |> visit_ready(path, ready)
        |> check_accessibility()
      end

      def visit_page_when_ready_and_check_a11y(session, path, %Wallaby.Query{} = ready_query) do
        visit_and_check_a11y(session, path, ready_query)
      end

      def see(session, text_value) do
        assert_has(session, css("body", text: text_value))
      end

      def dont_see(session, text_value) do
        assert_has(session, css("body", count: 0, text: text_value))
      end

      def check_accessibility(session) do
        do_check_accessibility(session, nil, [])
      end

      def check_accessibility(session, %Wallaby.Query{} = q) do
        do_check_accessibility(session, q, [])
      end

      def check_accessibility(session, nil) do
        do_check_accessibility(session, nil, [])
      end

      def check_accessibility(session, scope) when is_binary(scope) do
        do_check_accessibility(session, scope, [])
      end

      def check_accessibility(session, %Wallaby.Query{} = q, opts) when is_list(opts) do
        do_check_accessibility(session, q, opts)
      end

      def check_accessibility(session, nil, opts) when is_list(opts) do
        do_check_accessibility(session, nil, opts)
      end

      def check_accessibility(session, scope, opts) when is_binary(scope) and is_list(opts) do
        do_check_accessibility(session, scope, opts)
      end

      defp do_check_accessibility(session, nil, opts) do
        A11yAudit.Wallaby.assert_no_violations(session, opts)
      end

      defp do_check_accessibility(session, %Wallaby.Query{} = q, opts) do
        check_accessibility_scoped_axe!(session, q, opts)
      end

      defp do_check_accessibility(session, scope, opts) when is_binary(scope) do
        check_accessibility_scoped_axe!(session, scope, opts)
      end

      defp check_accessibility_scoped_axe!(session, %Wallaby.Query{} = q, opts) do
        css =
          case Wallaby.Query.compile(q) do
            {:css, s} when is_binary(s) ->
              s

            _ ->
              flunk(
                "check_accessibility: use css(...) for a scoped axe run, e.g. css(\"#my-accordion\")"
              )
          end

        check_accessibility_scoped_axe!(session, css, opts)
      end

      defp check_accessibility_scoped_axe!(session, css, opts)
           when is_binary(css) and is_list(opts) do
        run =
          "const sel = " <>
            Jason.encode!(css) <>
            "; const el = document.querySelector(sel); if (!el) { throw new Error('a11y: scope not found: ' + sel); } return await axe.run(el);"

        session
        |> Wallaby.Browser.execute_script(A11yAudit.JS.axe_core())
        |> Wallaby.Browser.execute_script(run, [], fn res ->
          map =
            case res do
              s when is_binary(s) -> Jason.decode!(s)
              %{} = m -> m
            end

          _ = A11yAudit.Assertions.assert_no_violations(A11yAudit.Results.from_json(map), opts)
        end)
      end
    end
  end
end
