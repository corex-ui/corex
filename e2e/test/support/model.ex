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

    * The layout toast group uses `phx-update="ignore"` and publishes
      `data-ready` once the Toast hook mounts. Toast items use fixed
      positioning and opacity transitions; Wallaby CSS/text queries on
      `#layout-toast` are unreliable in CI, so `prepare_live_form/1`,
      `assert_toast/2`, and `refute_toast/2` use `execute_script` on
      `#layout-toast` innerText plus `Wallaby.Browser.retry/1`.
  """

  def layout_toast_hook_ready?(session) do
    key = script_result_key()

    _ =
      Wallaby.Browser.execute_script(
        session,
        """
        var el = document.getElementById('layout-toast');
        return !!(el && el.hasAttribute('data-ready'));
        """,
        [],
        fn value ->
          Process.put(key, script_truthy?(value))
        end
      )

    case Process.delete(key) do
      true -> true
      _ -> false
    end
  end

  def layout_toast_contains?(session, needle) when is_binary(needle) do
    key = script_result_key()

    _ =
      Wallaby.Browser.execute_script(
        session,
        """
        var root = document.getElementById('layout-toast');
        var needle = arguments[0];
        var text = root ? (root.textContent || '') : '';
        return text.indexOf(needle) !== -1;
        """,
        [needle],
        fn value ->
          Process.put(key, script_truthy?(value))
        end
      )

    case Process.delete(key) do
      true -> true
      _ -> false
    end
  end

  defp script_result_key do
    {:e2e_wallaby_execute_script, self(), make_ref()}
  end

  defp script_truthy?(value) when value in [true, "true", 1, "1"], do: true
  defp script_truthy?(_), do: false

  def with_layout_toast_ready(session, error_message) when is_binary(error_message) do
    case Wallaby.Browser.retry(fn ->
           if layout_toast_hook_ready?(session), do: {:ok, session}, else: {:error, :not_ready}
         end) do
      {:ok, session} -> session
      {:error, _} -> raise Wallaby.ExpectationNotMetError, message: error_message
    end
  end

  def with_layout_toast_text(session, needle, error_message)
      when is_binary(needle) and is_binary(error_message) do
    case Wallaby.Browser.retry(fn ->
           if layout_toast_contains?(session, needle),
             do: {:ok, session},
             else: {:error, :no_match}
         end) do
      {:ok, session} -> session
      {:error, _} -> raise Wallaby.ExpectationNotMetError, message: error_message
    end
  end

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

      def click_in_section(session, section_id, button_label)
          when is_binary(section_id) and is_binary(button_label) do
        if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
          raise ArgumentError, "click_in_section: label must not include quotes"
        end

        click(
          session,
          xpath("(//*[@id='#{section_id}']//button[normalize-space(.)='#{button_label}'])[1]")
        )

        session
      end

      def click_by_id(session, element_id) when is_binary(element_id) do
        if not (String.match?(element_id, ~r/^[a-zA-Z0-9_-]+$/) and element_id != "") do
          raise ArgumentError, "invalid element id"
        end

        click(session, css("##{element_id}", visible: :any))
        session
      end

      def log_row_count(session, log_dom_id) when is_binary(log_dom_id) do
        case find(session, css("##{log_dom_id} tr[data-part='row']", count: :any, visible: :any)) do
          elements when is_list(elements) -> length(elements)
          _ -> 0
        end
      rescue
        Wallaby.QueryError -> 0
      end

      def wait_log_rows_grew(session, log_dom_id, before_count, opts \\ [])
          when is_binary(log_dom_id) and is_integer(before_count) do
        wait_for_has(
          session,
          css(
            "##{log_dom_id} tr[data-part='row']",
            minimum: before_count + 1,
            visible: :any
          ),
          opts
        )

        session
      end

      def wait_for_refute_has(session, %Wallaby.Query{} = query, opts \\ []) do
        query = maybe_query_visible(query, opts)

        case Keyword.get(opts, :timeout) do
          nil ->
            refute_has(session, query)

          max_ms when is_integer(max_ms) and max_ms > 0 ->
            deadline = System.monotonic_time(:millisecond) + max_ms
            busy_wait_refute_query(session, query, deadline)
            refute_has(session, query)
        end

        session
      end

      defp busy_wait_refute_query(session, query, deadline) do
        if Wallaby.Browser.has?(session, query) do
          if System.monotonic_time(:millisecond) >= deadline do
            :ok
          else
            Process.sleep(50)
            busy_wait_refute_query(session, query, deadline)
          end
        else
          :ok
        end
      end

      def wait_section_hook(session, section_dom_id, hook, opts \\ []) do
        if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and section_dom_id != "") do
          raise ArgumentError, "invalid section dom id"
        end

        timeout = Keyword.get(opts, :timeout)

        q =
          css(
            ~s|section##{section_dom_id} [phx-hook="#{hook}"]:not([data-loading])|,
            visible: :any,
            minimum: 1
          )

        case timeout do
          nil ->
            assert_has(session, q)

          max_ms when is_integer(max_ms) and max_ms > 0 ->
            wait_for_has(session, q, timeout: max_ms)
        end

        session
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
        session
        |> visit(path)
        |> scroll_to_fragment(path)
      end

      defp scroll_to_fragment(session, path) do
        case String.split(path, "#", parts: 2) do
          [_base, id] when id != "" ->
            execute_script(
              session,
              "document.getElementById(arguments[0])?.scrollIntoView({block: 'start'})",
              [id]
            )

          _ ->
            session
        end
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
        E2eWeb.Model.with_layout_toast_ready(
          session,
          "expected #layout-toast to exist with data-ready before LiveView interactions"
        )
      end

      def assert_toast(session, substring) when is_binary(substring) do
        E2eWeb.Model.with_layout_toast_text(
          session,
          substring,
          "expected #layout-toast textContent to include #{inspect(substring)}"
        )
      end

      def refute_toast(session, substring) when is_binary(substring) do
        refute E2eWeb.Model.layout_toast_contains?(session, substring),
               "expected #layout-toast innerText not to include #{inspect(substring)}"

        session
      end

      def assert_submitted(session, substring) when is_binary(substring) do
        assert_toast(session, substring)
      end

      def wait_for_has(session, %Wallaby.Query{} = query, opts \\ []) do
        query = maybe_query_visible(query, opts)

        case Keyword.get(opts, :timeout) do
          nil ->
            assert_has(session, query)

          max_ms when is_integer(max_ms) and max_ms > 0 ->
            deadline = System.monotonic_time(:millisecond) + max_ms
            busy_wait_query(session, query, deadline)
            assert_has(session, query)
        end

        session
      end

      defp maybe_query_visible(%Wallaby.Query{} = query, opts) do
        case Keyword.get(opts, :visible) do
          :any -> %{query | conditions: Keyword.put(query.conditions, :visible, :any)}
          _ -> query
        end
      end

      defp busy_wait_query(session, query, deadline) do
        if Wallaby.Browser.has?(session, query) do
          :ok
        else
          if System.monotonic_time(:millisecond) >= deadline do
            :ok
          else
            Process.sleep(50)
            busy_wait_query(session, query, deadline)
          end
        end
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
