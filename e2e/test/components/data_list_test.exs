defmodule E2eWeb.DataListTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.DataListModel, as: DataList

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal section renders items", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(DataList, :data_list, :anatomy)
      |> DataList.see_in_section("data-list-anatomy-minimal", "Lorem ipsum dolor sit amet")
    end

    feature "manual slots section renders labels", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(DataList, :data_list, :anatomy)
      |> DataList.see_in_section("data-list-anatomy-manual-slots", "Lorem ipsum dolor sit amet")
      |> DataList.see_in_section(
        "data-list-anatomy-manual-slots",
        "Duis dictum gravida odio ac pharetra?"
      )
    end

    feature "custom slots section renders tags", %{session: session} do
      session =
        ComponentBehaviorSpec.visit_ready(session, DataList, :data_list, :anatomy)

      assert_has(session, css("#data-list-anatomy-custom-slots .tag", minimum: 1))
    end

    feature "empty section renders empty message", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(DataList, :data_list, :anatomy)
      |> DataList.see_in_section("data-list-anatomy-empty", "No entries")
    end
  end

  describe "style" do
    feature "color section renders items", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(DataList, :data_list, :style)
      |> DataList.see_in_section("data-list-style-semantic", "Lorem ipsum dolor sit amet")
    end

    feature "size section renders items", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(DataList, :data_list, :style)
      |> DataList.see_in_section("data-list-style-text", "Lorem ipsum dolor sit amet")
    end

    feature "max width section renders items", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(DataList, :data_list, :style)
      |> DataList.see_in_section("data-list-style-max-width", "Lorem ipsum dolor sit amet")
    end
  end

  describe "patterns" do
    feature "stream section add and reset", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(DataList, :data_list, :patterns)
      |> DataList.prepare_live_form()
      |> DataList.click_in_section("data-list-patterns-stream", "Add row")
      |> DataList.see_in_section("data-list-patterns-stream", "Row 4")
      |> DataList.click_in_section("data-list-patterns-stream", "Reset")
      |> DataList.see_in_section("data-list-patterns-stream", "No items")
    end
  end

  describe "playground" do
    feature "orientation toggle switches layout", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DataList, :data_list, :playground)
        |> DataList.prepare_live_form()
        |> DataList.assert_orientation("vertical")

      session
      |> click(
        css(
          "#data-list-playground #orientation [data-scope='toggle-group'][data-part='item'][data-value='horizontal']",
          visible: :any
        )
      )
      |> DataList.assert_orientation("horizontal")
    end
  end
end
