defmodule E2eWeb.ActionTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Browser
  import Wallaby.Query

  alias E2eWeb.ActionModel, as: Action
  alias E2eWeb.ComponentBehaviorSpec

  @moduletag :action

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "style" do
    feature "initial  -  recipe defaults stamp solid md modifiers", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Action, :action, :style)
        |> assert_has(css("#my-action"))

      el = find(session, css("#my-action"))
      classes = Wallaby.Element.attr(el, "class")
      assert String.contains?(classes, "button")
      assert String.contains?(classes, "button--variant-solid")
      assert String.contains?(classes, "button--size-md")
    end

    feature "as link at defaults  -  link look with recipe modifiers", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Action, :action, :style)
        |> assert_has(css("#my-action"))
        |> select_option("action-as", "link")

      el = find(session, css("#my-action"))
      classes = Wallaby.Element.attr(el, "class")
      assert String.contains?(classes, "link")
      assert String.contains?(classes, "link--variant-solid")
      assert String.contains?(classes, "link--size-md")
      refute String.contains?(classes, "button--")
    end

    feature "as link  -  link look stamps link BEM modifiers on the host", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Action, :action, :style)
        |> assert_has(css("#my-action"))
        |> select_option("action-as", "link")

      el = find(session, css("#my-action"))
      classes = Wallaby.Element.attr(el, "class")
      assert String.contains?(classes, "link")
      refute String.contains?(classes, "button--")
    end

    feature "semantic  -  accent adds semantic modifier on the host", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Action, :action, :style)
        |> assert_has(css("#my-action"))
        |> select_option("action-semantic", "accent")

      el = find(session, css("#my-action"))
      classes = Wallaby.Element.attr(el, "class")
      assert String.contains?(classes, "button--semantic-accent")
    end

    feature "variant  -  ghost adds ghost modifier on the host", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Action, :action, :style)
        |> assert_has(css("#my-action"))
        |> select_option("action-variant", "ghost")

      el = find(session, css("#my-action"))
      classes = Wallaby.Element.attr(el, "class")
      assert String.contains?(classes, "button--variant-ghost")
    end
  end

  defp select_option(session, select_id, value) do
    session
    |> assert_has(css("##{select_id}[phx-hook='Select']:not([data-loading])"))
    |> click(css("##{select_id} [data-part='trigger']"))
    |> assert_has(css(~S([data-scope="select"][data-part="content"][data-state="open"]), visible: :any))
    |> click(
      css(
        "[data-scope=\"select\"][data-part=\"item\"][data-value=\"#{value}\"]:not([data-template])",
        visible: :any
      )
    )
    |> assert_has(css("#my-action"))
  end
end
