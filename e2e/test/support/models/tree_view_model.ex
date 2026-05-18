defmodule E2eWeb.TreeViewModel do
  use E2eWeb.Model, component: "tree-view"

  import Wallaby.Query

  @anatomy_sections ~w(
    tree-view-anatomy-minimal
    tree-view-anatomy-with-indicator
    tree-view-anatomy-custom-slots
    tree-view-anatomy-compound
  )

  @anatomy_section_to_host_id %{
    "tree-view-anatomy-minimal" => "tree-minimal",
    "tree-view-anatomy-with-indicator" => "tree-with-indicator",
    "tree-view-anatomy-custom-slots" => "tree-custom-slots",
    "tree-view-anatomy-compound" => "tree-compound"
  }

  def anatomy_section_ids, do: @anatomy_sections

  def host_id_for_anatomy_section(section_id),
    do: Map.fetch!(@anatomy_section_to_host_id, section_id)

  def valid_dom_id?(dom_id) do
    String.match?(dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(dom_id) > 0
  end

  def wait_host_tree_view_ready(session, host_dom_id, opts \\ []) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(~s|##{host_dom_id}[phx-hook="TreeView"]:not([data-loading])|, visible: :any)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_section_tree_view_ready(session, section_dom_id, opts \\ []) do
    if not valid_dom_id?(section_dom_id), do: raise(ArgumentError, "invalid section dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(
        ~s|section##{section_dom_id} [phx-hook="TreeView"]:not([data-loading])|,
        visible: :any
      )

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def click_first_branch_control_in_host(session, host_dom_id) do
    click(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="tree-view"][data-part="branch-control"]|,
        at: 0,
        visible: :any
      )
    )

    session
  end

  def wait_any_branch_content_open_in_host(session, host_dom_id, opts \\ []) do
    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="tree-view"][data-part="branch-content"][data-state="open"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def any_branch_content_open_in_host?(session, host_dom_id) do
    has?(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="tree-view"][data-part="branch-content"][data-state="open"]|,
        visible: :any
      )
    )
  end

  def click_in_section(session, section_id, button_label)
      when is_binary(section_id) and is_binary(button_label) do
    if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
      raise ArgumentError, "click_in_section/3 label must not include quotes"
    end

    click(
      session,
      xpath("(//*[@id=\'#{section_id}\']//button[normalize-space(.)=\'#{button_label}\'])[1]")
    )

    session
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#tree-view-patterns-page", visible: :any))
    session
  end

  def tree_view_events_server_log_has_row?(session) do
    has?(session, css("#tree-events-log-server tr[data-part='row']", visible: :any))
  end

  def tree_view_events_client_log_has_row?(session) do
    has?(session, css("#tree-events-log-client tr[data-part='row']", visible: :any))
  end
end
