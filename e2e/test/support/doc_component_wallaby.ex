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
    case Wallaby.Browser.retry(fn ->
           if E2eWeb.Model.layout_toast_hook_ready?(session) do
             {:ok, session}
           else
             {:error, :not_ready}
           end
         end) do
      {:ok, session} -> session
      {:error, _} -> session
    end
  end

  defp assert_hook_page(session, _component, page_key, scope, hook, root_id) do
    session = wait_hooks_ready(session, scope, hook, root_id, page_key)

    case page_key do
      :anatomy -> assert_anatomy_interaction(session, scope, hook, root_id)
      :api -> assert_api_interaction(session, scope, hook, root_id)
      :events -> assert_events_interaction(session, scope, hook, root_id)
      :patterns -> assert_patterns_interaction(session, scope, hook, root_id)
      :playground -> assert_scope_present(session, scope, root_id)
      :style -> assert_scope_present(session, scope, root_id)
      :form -> assert_scope_present(session, scope, root_id)
      :live_form -> assert_scope_present(session, scope, root_id)
      _ -> assert_scope_present(session, scope, root_id)
    end

    session
  end

  defp assert_static_page(session, _component, page_key, scope, root_id) do
    case page_key do
      :anatomy -> assert_static_anatomy(session, scope, root_id)
      :style -> assert_has(session, css("##{root_id}"))
      :form -> assert_has(session, css("##{root_id} form", minimum: 1))
      :patterns -> assert_has(session, css("##{root_id}"))
      _ -> assert_has(session, css("##{root_id}"))
    end

    session
  end

  defp wait_hooks_ready(session, scope, hook, root_id, _page_key) do
    base = page_scope_selector(root_id, scope)

    q =
      css("#{base} [phx-hook=\"#{hook}\"]:not([data-loading])", minimum: 1, visible: :any)

    assert_has(session, q)
    session
  end

  defp assert_anatomy_interaction(session, scope, _hook, root_id) do
    session = assert_scope_present(session, scope, root_id)

    cond do
      click_if_present(session, page_scope_selector(root_id, scope) <> " [data-part=\"trigger\"]") ->
        wait_open_state(session, scope, root_id)

      click_if_present(session, page_scope_selector(root_id, scope) <> " [data-part=\"item\"]") ->
        assert_has(
          session,
          css(
            page_scope_selector(root_id, scope) <>
              " [data-scope=\"#{scope}\"][data-part=\"item\"]",
            visible: :any
          )
        )

      click_if_present(session, page_scope_selector(root_id, scope) <> " [data-part=\"root\"]") ->
        assert_scope_present(session, scope, root_id)

      true ->
        assert_scope_present(session, scope, root_id)
    end

    session
  end

  defp assert_api_interaction(session, scope, _hook, root_id) do
    assert_scope_present(session, scope, root_id)
    session
  end

  defp assert_events_interaction(session, scope, hook, root_id) do
    session = assert_scope_present(session, scope, root_id)
    host_sel = first_hook_host_selector(root_id, scope, hook)

    if host_sel && click_if_present(session, host_sel <> " [data-part=\"trigger\"]") do
      wait_for_log_row(session, root_id)
    else
      if host_sel && click_if_present(session, host_sel <> " [data-part=\"root\"]") do
        wait_for_log_row(session, root_id)
      else
        if host_sel && click_if_present(session, host_sel <> " [data-part=\"item\"]") do
          wait_for_log_row(session, root_id)
        else
          session
        end
      end
    end

    session
  end

  defp assert_patterns_interaction(session, scope, hook, root_id) do
    session = assert_scope_present(session, scope, root_id)
    host_sel = first_hook_host_selector(root_id, scope, hook)

    if host_sel && click_if_present(session, host_sel <> " [data-part=\"item\"]") do
      assert_has(
        session,
        css(host_sel <> " [data-part=\"item\"]", visible: :any)
      )
    else
      if host_sel && click_if_present(session, host_sel <> " [data-part=\"root\"]") do
        assert_scope_present(session, scope, root_id)
      else
        session
      end
    end

    session
  end

  defp assert_static_anatomy(session, scope, root_id) do
    if ComponentWireIndex.hookless?(scope) do
      assert_has(session, css("##{root_id}"))
    else
      assert_scope_present(session, scope, root_id)
    end

    session
  end

  defp assert_scope_present(session, scope, root_id) do
    assert_has(
      session,
      css(
        page_scope_selector(root_id, scope) <> " [data-scope=\"#{scope}\"]",
        minimum: 1,
        visible: :any
      )
    )

    session
  end

  defp wait_open_state(session, scope, root_id) do
    assert_has(
      session,
      css(
        page_scope_selector(root_id, scope) <>
          " [data-scope=\"#{scope}\"][data-state=\"open\"], " <>
          page_scope_selector(root_id, scope) <>
          " [data-scope=\"#{scope}\"][data-part=\"content\"]",
        visible: :any
      )
    )

    session
  end

  defp wait_for_log_row(session, root_id) do
    assert_has(
      session,
      css("##{root_id} tr[data-part='row'], ##{root_id} [data-part='row']", visible: :any)
    )

    session
  end

  defp page_scope_selector(root_id, _scope), do: "##{root_id}"

  defp first_hook_host_selector(root_id, scope, hook) do
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
      use ExUnit.Case, async: false
      use Wallaby.Feature

      setup do
        Localize.put_locale(:en)
        :ok
      end

      unquote_splicing(page_features)
    end
  end
end
