defmodule E2eWeb.DocComponentWallaby do
  @moduledoc false

  import Wallaby.Query
  import Wallaby.Browser
  alias E2eWeb.{ComponentBehaviorSpec, ComponentWireIndex}

  @live_pages MapSet.new([
                :api,
                :events,
                :patterns,
                :playground,
                :controlled,
                :animation,
                :live_form
              ])

  @layout_hook_components [:toast]

  def assert_page_behavior(session, component, page_key)
      when is_atom(component) and is_atom(page_key) do
    scope = E2eWeb.ZagScope.for_component(component)
    hook = ComponentWireIndex.hook_for_id(component)
    {path, root_sel} = ComponentBehaviorSpec.page(component, page_key)
    locale_path = "/en" <> path
    root_id = String.trim_leading(root_sel, "#")

    session =
      session
      |> visit(locale_path)
      |> assert_has(css(root_sel, visible: :any))

    session =
      if MapSet.member?(@live_pages, page_key) do
        prepare_live_form(session)
      else
        session
      end

    if hook do
      assert_hook_page(session, component, page_key, scope, hook, root_id)
    else
      assert_static_page(session, component, page_key, scope, root_id)
    end
  end

  defp prepare_live_form(session) do
    E2eWeb.Model.with_layout_toast_ready(
      session,
      "expected #layout-toast to exist with data-ready before LiveView interactions"
    )
  rescue
    Wallaby.ExpectationNotMetError -> session
  end

  defp assert_hook_page(session, component, page_key, scope, hook, root_id) do
    session
    |> wait_hooks_ready(component, scope, hook, root_id, page_key)
    |> run_hook_page_interaction(component, page_key, scope, hook, root_id)
  end

  defp run_hook_page_interaction(session, component, :anatomy, scope, hook, root_id) do
    assert_anatomy_interaction(session, component, scope, hook, root_id)
  end

  defp run_hook_page_interaction(session, component, :api, scope, hook, root_id) do
    assert_api_interaction(session, component, scope, hook, root_id)
  end

  defp run_hook_page_interaction(session, component, :events, scope, hook, root_id) do
    assert_events_interaction(session, component, scope, hook, root_id)
  end

  defp run_hook_page_interaction(session, component, :patterns, scope, hook, root_id) do
    assert_patterns_interaction(session, component, scope, hook, root_id)
  end

  defp run_hook_page_interaction(session, component, _page_key, scope, _hook, root_id) do
    assert_scope_present(session, component, scope, root_id)
  end

  defp assert_static_page(session, component, page_key, scope, root_id) do
    case page_key do
      :anatomy -> assert_static_anatomy(session, component, scope, root_id)
      :style -> assert_has(session, css("##{root_id}"))
      :form -> assert_has(session, css("##{root_id} form", minimum: 1))
      :patterns -> assert_has(session, css("##{root_id}"))
      _ -> assert_has(session, css("##{root_id}"))
    end

    session
  end

  defp wait_hooks_ready(session, component, _scope, hook, _root_id, _page_key)
       when component in @layout_hook_components do
    E2eWeb.Model.with_layout_toast_ready(
      session,
      "expected #layout-toast[phx-hook=\"#{hook}\"][data-ready] before #{component} doc interactions"
    )
  end

  defp wait_hooks_ready(session, component, scope, hook, root_id, _page_key) do
    base = page_scope_selector(component, root_id, scope)

    q =
      css("#{base} [phx-hook=\"#{hook}\"]:not([data-loading])", minimum: 1, visible: :any)

    assert_has(session, q)
    session
  end

  defp assert_anatomy_interaction(session, component, scope, _hook, root_id) do
    session = assert_scope_present(session, component, scope, root_id)

    cond do
      click_if_present(
        session,
        page_scope_selector(component, root_id, scope) <> " [data-part=\"trigger\"]"
      ) ->
        wait_open_state(session, component, scope, root_id)

      click_if_present(
        session,
        page_scope_selector(component, root_id, scope) <> " [data-part=\"item\"]"
      ) ->
        assert_has(
          session,
          css(
            page_scope_selector(component, root_id, scope) <>
              " [data-scope=\"#{scope}\"][data-part=\"item\"]",
            visible: :any
          )
        )

      click_if_present(
        session,
        page_scope_selector(component, root_id, scope) <> " [data-part=\"root\"]"
      ) ->
        assert_scope_present(session, component, scope, root_id)

      true ->
        assert_scope_present(session, component, scope, root_id)
    end

    session
  end

  defp assert_api_interaction(session, component, scope, _hook, root_id) do
    assert_scope_present(session, component, scope, root_id)
    session
  end

  defp assert_events_interaction(session, component, scope, hook, root_id) do
    session = assert_scope_present(session, component, scope, root_id)
    host_sel = first_hook_host_selector(component, root_id, scope, hook)

    clicked? =
      host_sel &&
        Enum.any?(~W(trigger root item), fn part ->
          click_if_present(session, host_sel <> " [data-part=\"#{part}\"]")
        end)

    if clicked?, do: wait_for_log_row(session, root_id), else: session
  end

  defp assert_patterns_interaction(session, component, scope, hook, root_id) do
    session = assert_scope_present(session, component, scope, root_id)
    host_sel = first_hook_host_selector(component, root_id, scope, hook)

    if host_sel && click_if_present(session, host_sel <> " [data-part=\"item\"]") do
      assert_has(
        session,
        css(host_sel <> " [data-part=\"item\"]", visible: :any)
      )
    else
      if host_sel && click_if_present(session, host_sel <> " [data-part=\"root\"]") do
        assert_scope_present(session, component, scope, root_id)
      else
        session
      end
    end

    session
  end

  defp assert_static_anatomy(session, component, scope, root_id) do
    if ComponentWireIndex.hookless?(scope) do
      assert_has(session, css("##{root_id}"))
    else
      assert_scope_present(session, component, scope, root_id)
    end

    session
  end

  defp assert_scope_present(session, component, scope, root_id) do
    assert_has(
      session,
      css(
        page_scope_selector(component, root_id, scope) <> " [data-scope=\"#{scope}\"]",
        minimum: 1,
        visible: :any
      )
    )

    session
  end

  defp wait_open_state(session, component, scope, root_id) do
    base = page_scope_selector(component, root_id, scope)

    open_sel =
      ~s|#{base} [data-scope="#{scope}"][data-state="open"], #{base} [data-scope="#{scope}"][data-part="content"]|

    assert_has(session, css(open_sel, visible: :any))
    session
  end

  defp wait_for_log_row(session, root_id) do
    assert_has(
      session,
      css("##{root_id} tr[data-part='row'], ##{root_id} [data-part='row']", visible: :any)
    )

    session
  end

  defp page_scope_selector(:toast, _root_id, _scope), do: "#layout-toast"

  defp page_scope_selector(_component, root_id, _scope), do: "##{root_id}"

  defp first_hook_host_selector(:toast, _root_id, scope, hook) do
    "#layout-toast [phx-hook=\"#{hook}\"][data-scope=\"#{scope}\"]"
  end

  defp first_hook_host_selector(_component, root_id, scope, hook) do
    "##{root_id} [phx-hook=\"#{hook}\"][data-scope=\"#{scope}\"]"
  end

  defp click_if_present(session, selector) do
    q = css(selector, visible: :any)

    if Wallaby.Browser.has?(session, q) do
      click(session, q)
      true
    else
      false
    end
  end

  defmacro __using__(opts) do
    component = Keyword.fetch!(opts, :component)
    skip? = Keyword.get(opts, :skip, false)

    page_features =
      if skip? do
        []
      else
        for page_key <- E2eWeb.DocPageMatrix.wallaby_pages(component) do
          quote do
            describe unquote(Atom.to_string(page_key)) do
              feature "primary doc interaction", %{session: session} do
                E2eWeb.DocComponentWallaby.assert_page_behavior(
                  session,
                  unquote(component),
                  unquote(page_key)
                )
              end
            end
          end
        end
      end

    quote do
      use E2eWeb.FeatureCase, async: false

      unquote_splicing(page_features)
    end
  end
end
