defmodule E2eWeb.TreeViewModel do
  import ExUnit.Assertions

  use E2eWeb.Model, component: "tree-view"

  @anatomy_sections ~w(
    tree-view-anatomy-minimal
    tree-view-anatomy-with-indicator
    tree-view-anatomy-custom-slots
    tree-view-anatomy-compound
  )

  def anatomy_section_ids, do: @anatomy_sections

  def prepare_lazy_tree_view(session), do: session

  def wait_until_css_match_count(session, css_selector, opts \\ []) when is_binary(css_selector) do
    timeout_ms = Keyword.get(opts, :timeout, 20_000)
    min = Keyword.get(opts, :minimum, 1)
    deadline = System.monotonic_time(:millisecond) + timeout_ms
    script = "return document.querySelectorAll(" <> Jason.encode!(css_selector) <> ").length;"
    wait_until_script_count(session, script, min, deadline)
  end

  defp wait_until_script_count(session, script, min, deadline) do
    me = self()
    ref = make_ref()

    _ =
      Wallaby.Browser.execute_script(
        session,
        script,
        [],
        fn v -> send(me, {ref, :count, script_count(v)}) end
      )

    n =
      receive do
        {^ref, :count, x} -> x
      after
        5_000 -> 0
      end

    if n >= min do
      session
    else
      if System.monotonic_time(:millisecond) >= deadline do
        flunk(
          "wait_until_script_count: expected count >= #{min}, last #{n}, script #{String.slice(script, 0, 160)}"
        )
      else
        Process.sleep(150)
        wait_until_script_count(session, script, min, deadline)
      end
    end
  end

  defp script_count(v) when is_integer(v), do: v
  defp script_count(v) when is_float(v), do: trunc(v)

  defp script_count(v) when is_binary(v) do
    case Integer.parse(v) do
      {i, _} -> i
      :error -> 0
    end
  end

  defp script_count(_), do: 0

  defp dom_script_bool(session, script) when is_binary(script) do
    me = self()
    ref = make_ref()

    _ =
      Wallaby.Browser.execute_script(
        session,
        script,
        [],
        fn v -> send(me, {ref, :v, v}) end
      )

    receive do
      {^ref, :v, true} -> true
      {^ref, :v, "true"} -> true
      {^ref, :v, _} -> false
    after
      3_000 -> false
    end
  end

  def first_branch_state(session, section_dom_id) do
    el = find(session, branch_control_query(section_dom_id))
    Wallaby.Element.attr(el, "data-state")
  end

  defp branch_control_query(section_dom_id) do
    css(~s(##{section_dom_id} [data-part='branch-control']), at: 0)
  end

  def click_first_branch(session, section_dom_id) do
    click(session, branch_control_query(section_dom_id))
    session
  end

  def assert_first_branch_toggles(session, section_dom_id) do
    before = first_branch_state(session, section_dom_id)

    session =
      session
      |> click_first_branch(section_dom_id)
      |> wait(400)

    after_state = first_branch_state(session, section_dom_id)
    assert before != after_state
    session
  end

  def click_expand_lib_api(session) do
    script = """
    (function(){
      var el = document.getElementById("tree-api-set-expanded-client");
      if (!el) return;
      el.dispatchEvent(
        new CustomEvent("corex:tree-view:set-expanded-value", {
          bubbles: false,
          detail: { value: ["repo-lib"] }
        })
      );
    })();
    """

    _ = Wallaby.Browser.execute_script(session, script, [], fn _ -> nil end)
    session
  end

  def lib_expanded_in?(session, tree_id) do
    sel = ~s([id="tree-view:#{tree_id}:node:repo-lib"])

    script = """
    return (function(){
      var el = document.querySelector(#{Jason.encode!(sel)});
      return !!(el && el.getAttribute("data-state") === "open");
    })();
    """

    dom_script_bool(session, script)
  end

  def click_events_server_first_branch(session) do
    script = """
    (function(){
      var section = document.getElementById("tree-view-events-server");
      if (!section) return;
      var b = section.querySelector("[data-part=branch-control]");
      if (b) b.click();
    })();
    """

    _ = Wallaby.Browser.execute_script(session, script, [], fn _ -> nil end)
    session
  end

  def events_server_log_has_row?(session) do
    script = """
    return !!document.querySelector("#tree-events-log-server tr[data-part=row]");
    """

    dom_script_bool(session, script)
  end
end
