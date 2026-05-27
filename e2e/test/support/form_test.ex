defmodule E2eWeb.FormTest do
  @moduledoc false

  import ExUnit.Assertions
  import Wallaby.Query
  import Wallaby.Browser

  @page_ready_timeout 15_000

  def visit_path(session, path) when is_binary(path) do
    session
    |> visit(path)
    |> scroll_to_fragment(path)
  end

  def goto_form_page(session, path, page_selector, mode, opts \\ [])
      when is_binary(path) and is_binary(page_selector) and mode in [:static, :live] do
    timeout = Keyword.get(opts, :timeout, @page_ready_timeout)

    session =
      session
      |> visit_path(path)
      |> maybe_prepare_live_form(mode)

    wait_for_form_page(session, page_selector, timeout: timeout)
  end

  defp maybe_prepare_live_form(session, :live) do
    E2eWeb.Model.with_layout_toast_ready(
      session,
      "expected #layout-toast to exist with data-ready before LiveView interactions"
    )
  end

  defp maybe_prepare_live_form(session, :static), do: session

  def wait_for_form_page(session, page_selector, opts \\ [])
      when is_binary(page_selector) do
    timeout = Keyword.get(opts, :timeout, @page_ready_timeout)
    query = css("##{page_selector}", visible: :any)

    deadline = System.monotonic_time(:millisecond) + timeout
    busy_wait_has(session, query, deadline)
    assert_has(session, query)
    session
  end

  def wait_for_field_error(session, form_id, data_scope, error_text \\ "can't be blank")
      when is_binary(form_id) and is_binary(data_scope) and is_binary(error_text) do
    assert_has(
      session,
      css(
        ~s|##{form_id} [data-scope="#{data_scope}"][data-part="error"]|,
        text: error_text,
        minimum: 1
      )
    )

    session
  end

  def refute_success_toast(session, substring) when is_binary(substring) do
    refute E2eWeb.Model.layout_toast_contains?(session, substring),
           "expected #layout-toast innerText not to include #{inspect(substring)}"

    session
  end

  def assert_success_toast(session, substring) when is_binary(substring) do
    E2eWeb.Model.with_layout_toast_text(
      session,
      substring,
      "expected #layout-toast textContent to include #{inspect(substring)}"
    )
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

  defp busy_wait_has(session, query, deadline) do
    if has?(session, query) do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        :ok
      else
        Process.sleep(50)
        busy_wait_has(session, query, deadline)
      end
    end
  end
end
