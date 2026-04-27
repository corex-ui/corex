defmodule E2eWeb.TreeViewModel do
  import ExUnit.Assertions
  import Wallaby.Query

  use E2eWeb.Model, component: "tree-view"

  @anatomy_sections ~w(
    tree-anatomy-minimal
    tree-anatomy-with-indicator
    tree-anatomy-custom-slots
    tree-anatomy-compound
  )

  def anatomy_section_ids, do: @anatomy_sections

  def prepare_lazy_tree_view(session), do: session

  def wait_until_css_match_count(session, css_selector, opts \\ [])
      when is_binary(css_selector) do
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

  def wait_section_tree_view_ready(session, section_dom_id, opts \\ []) do
    q = css(~s(##{section_dom_id} [data-part="branch-control"]))

    timeout_ms = Keyword.get(opts, :timeout, 20_000)
    interval_ms = Keyword.get(opts, :interval, 100)
    deadline = System.monotonic_time(:millisecond) + timeout_ms
    wait_until_has_loop(session, q, deadline, interval_ms)
  end

  defp wait_until_has_loop(session, %Wallaby.Query{} = query, deadline, interval_ms) do
    if Wallaby.Browser.has?(session, query) do
      session
    else
      if System.monotonic_time(:millisecond) >= deadline do
        flunk("expected element #{inspect(query)}, timeout after #{deadline}")
      else
        Process.sleep(interval_ms)
        wait_until_has_loop(session, query, deadline, interval_ms)
      end
    end
  end

  defp branch_control_query(section_dom_id) do
    css(~s(##{section_dom_id} [data-part="branch-control"]), at: 0)
  end

  def first_branch_state(session, section_dom_id) do
    el = find(session, branch_control_query(section_dom_id))
    Wallaby.Element.attr(el, "data-state")
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
    sel = ~s([id="tree:#{tree_id}:node:repo-lib"])

    script = """
    return (function(){
      var el = document.querySelector(#{Jason.encode!(sel)});
      return !!(el && el.getAttribute("data-state") === "open");
    })();
    """

    # Fixed: Use dom_script_bool pattern from original
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
    has?(session, css("#tree-events-log-server tr[data-part=row]"))
  end
end
