defmodule E2eWeb.Model do
  @moduledoc "Base model with shared test utilities"

  @layout_toast_script """
  (function () {
    const inGroup = (document.querySelector('#layout-toast') || { textContent: '' }).textContent || '';
    const titles = Array.from(document.querySelectorAll('[data-scope="toast"][data-part="title"]'))
      .map(function (n) { return n.textContent || ''; });
    const descs = Array.from(document.querySelectorAll('[data-scope="toast"][data-part="description"]'))
      .map(function (n) { return n.textContent || ''; });
    return [inGroup].concat(titles, descs).join('\\n');
  })()
  """
  @pdict_layout_toast_inner_text :e2e_web_model_layout_toast_inner_text
  @pdict_body_text :e2e_web_model_body_text
  @pdict_body_text_content :e2e_web_model_body_text_content

  @body_text_script "return (document.body && document.body.innerText) ? document.body.innerText : '';"
  @body_text_content_script "return (document.body && document.body.textContent) ? document.body.textContent : '';"

  def body_text_for_assert(session) do
    _ =
      Wallaby.Browser.execute_script(
        session,
        @body_text_script,
        [],
        fn v ->
          Process.put(@pdict_body_text, if(is_binary(v), do: v, else: ""))
          nil
        end
      )

    t = Process.get(@pdict_body_text, "")
    Process.delete(@pdict_body_text)
    t
  end

  def body_text_content_for_assert(session) do
    _ =
      Wallaby.Browser.execute_script(
        session,
        @body_text_content_script,
        [],
        fn v ->
          Process.put(@pdict_body_text_content, if(is_binary(v), do: v, else: ""))
          nil
        end
      )

    t = Process.get(@pdict_body_text_content, "")
    Process.delete(@pdict_body_text_content)
    t
  end

  def layout_toast_inner_text(session) do
    _ =
      Wallaby.Browser.execute_script(
        session,
        @layout_toast_script,
        [],
        fn v ->
          Process.put(@pdict_layout_toast_inner_text, if(is_binary(v), do: v, else: ""))
          nil
        end
      )

    val = Process.get(@pdict_layout_toast_inner_text, "")
    Process.delete(@pdict_layout_toast_inner_text)
    val
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

      def prepare_live_form_for_push_toast(session) do
        wait_for_has(session, css(~s(#layout-toast[data-toast-group="true"]), visible: :any),
          timeout: 10_000
        )
      end

      def wait_for_has(session, %Wallaby.Query{} = query, opts \\ []) do
        timeout_ms = Keyword.get(opts, :timeout, 10_000)
        interval_ms = Keyword.get(opts, :interval, 100)
        deadline = System.monotonic_time(:millisecond) + timeout_ms
        wait_for_has_loop(session, query, deadline, interval_ms)
      end

      defp wait_for_has_loop(session, query, deadline, interval_ms) do
        if has?(session, query) do
          session
        else
          if System.monotonic_time(:millisecond) >= deadline do
            flunk("wait_for_has: not found #{inspect(query)}")
          else
            Process.sleep(interval_ms)
            wait_for_has_loop(session, query, deadline, interval_ms)
          end
        end
      end

      def visit_ready(session, path, %Wallaby.Query{} = ready_query, opts \\ []) do
        timeout = Keyword.get(opts, :timeout, 15_000)
        session |> visit_path(path) |> wait_for_has(ready_query, timeout: timeout)
      end

      def visit_and_check_a11y(session, path, %Wallaby.Query{} = ready_query) do
        conds = Keyword.put(ready_query.conditions, :visible, :any)
        q = %{ready_query | conditions: conds}

        session
        |> visit_ready(path, q, timeout: 15_000)
        |> wait(400)
        |> check_accessibility()
      end

      def visit_page_when_ready_and_check_a11y(session, path, %Wallaby.Query{} = ready_query) do
        visit_and_check_a11y(session, path, ready_query)
      end

      def wait_for_text(session, text, opts \\ []) do
        timeout_ms = Keyword.get(opts, :timeout, 5_000)
        interval_ms = Keyword.get(opts, :interval, 200)
        deadline = System.monotonic_time(:millisecond) + timeout_ms
        tq = Wallaby.Query.text(text, visible: :any)

        wait_until_text_content(session, tq, text, deadline, interval_ms)
        assert_has(session, tq)
        session
      end

      def wait_for_flash(session, substring, opts \\ []) when is_binary(substring) do
        timeout_ms = Keyword.get(opts, :timeout, 5_000)
        interval_ms = Keyword.get(opts, :interval, 200)
        deadline = System.monotonic_time(:millisecond) + timeout_ms

        wait_until_flash_contains(session, substring, deadline, interval_ms)
        session
      end

      defp wait_until_flash_contains(session, substring, deadline, interval_ms) do
        if flash_contains?(session, substring) do
          :ok
        else
          if System.monotonic_time(:millisecond) >= deadline do
            info =
              if has?(session, css("#layout-toast", visible: :any)) do
                el = find(session, css("#layout-toast", visible: :any))
                Wallaby.Element.attr(el, "data-flash-info")
              end

            err =
              if has?(session, css("#layout-toast", visible: :any)) do
                el = find(session, css("#layout-toast", visible: :any))
                Wallaby.Element.attr(el, "data-flash-error")
              end

            inner = E2eWeb.Model.layout_toast_inner_text(session) |> String.slice(0, 400)

            raise "Expected to find flash or toast text containing \"#{substring}\" within timeout, but it was not visible. " <>
                    "Pushed toasts (push_event) may leave data-flash-info/data-flash-error nil; check Zag title/description in the page. " <>
                    "data-flash-info=#{inspect(info)} data-flash-error=#{inspect(err)} " <>
                    "layout-toast-inner-text-prefix=#{inspect(inner)}"
          else
            Process.sleep(interval_ms)
            wait_until_flash_contains(session, substring, deadline, interval_ms)
          end
        end
      end

      defp flash_contains?(session, substring) do
        body = E2eWeb.Model.body_text_for_assert(session)
        body_text_content = E2eWeb.Model.body_text_content_for_assert(session)
        zag = E2eWeb.Model.layout_toast_inner_text(session)

        cond do
          String.contains?(body, substring) or String.contains?(body_text_content, substring) or
              String.contains?(zag, substring) ->
            true

          has?(session, css("#layout-toast", visible: :any)) ->
            el = find(session, css("#layout-toast", visible: :any))
            info = Wallaby.Element.attr(el, "data-flash-info") || ""
            err = Wallaby.Element.attr(el, "data-flash-error") || ""

            info = if is_binary(info), do: info, else: ""
            err = if is_binary(err), do: err, else: ""

            String.contains?(info, substring) or String.contains?(err, substring)

          true ->
            false
        end
      end

      defp wait_until_text_content(
             session,
             %Wallaby.Query{} = tq,
             text,
             deadline,
             interval_ms
           ) do
        if has?(session, tq) do
          :ok
        else
          if System.monotonic_time(:millisecond) >= deadline do
            raise "Expected to find text \"#{text}\" within timeout, but it was not visible"
          else
            Process.sleep(interval_ms)
            wait_until_text_content(session, tq, text, deadline, interval_ms)
          end
        end
      end

      def see(session, text_value) do
        assert_has(session, Wallaby.Query.text(text_value))
      end

      def dont_see(session, text_value) do
        refute_has(session, Wallaby.Query.text(text_value))
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
        session = wait(session, 800)
        A11yAudit.Wallaby.assert_no_violations(session, opts)
      end

      defp do_check_accessibility(session, %Wallaby.Query{} = q, opts) do
        session = wait(session, 800)
        check_accessibility_scoped_axe!(session, q, opts)
      end

      defp do_check_accessibility(session, scope, opts) when is_binary(scope) do
        session = wait(session, 800)
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
