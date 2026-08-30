defmodule Corex.NativeAccordionTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.NativeAccordion
  alias Corex.NativeAccordion.Ids
  alias Corex.NativeAccordion.State

  describe "State.toggle/3" do
    test "multiple collapsible opens and closes" do
      assert State.toggle([], "a", multiple: true, collapsible: true) == ["a"]
      assert State.toggle(["a"], "b", multiple: true, collapsible: true) == ["a", "b"]
      assert State.toggle(["a", "b"], "a", multiple: true, collapsible: true) == ["b"]
    end

    test "single collapsible replaces or clears" do
      assert State.toggle([], "a", multiple: false, collapsible: true) == ["a"]
      assert State.toggle(["a"], "b", multiple: false, collapsible: true) == ["b"]
      assert State.toggle(["a"], "a", multiple: false, collapsible: true) == []
    end

    test "single non-collapsible cannot clear last" do
      assert State.toggle(["a"], "a", multiple: false, collapsible: false) == ["a"]
      assert State.toggle(["a"], "b", multiple: false, collapsible: false) == ["b"]
    end
  end

  describe "State.key_direction/3" do
    test "vertical arrows" do
      assert State.key_direction("ArrowDown", "vertical") == :next
      assert State.key_direction("ArrowUp", "vertical") == :prev
      assert State.key_direction("ArrowRight", "vertical") == nil
    end

    test "horizontal arrows honor rtl" do
      assert State.key_direction("ArrowRight", "horizontal", "ltr") == :next
      assert State.key_direction("ArrowLeft", "horizontal", "ltr") == :prev
      assert State.key_direction("ArrowRight", "horizontal", "rtl") == :prev
      assert State.key_direction("ArrowLeft", "horizontal", "rtl") == :next
    end

    test "home and end" do
      assert State.key_direction("Home", "vertical") == :first
      assert State.key_direction("End", "horizontal") == :last
    end
  end

  describe "State.next_item/4" do
    test "wraps next and prev among enabled items" do
      values = ~W(a b c)
      assert State.next_item(values, "a", [], :next) == "b"
      assert State.next_item(values, "c", [], :next) == "a"
      assert State.next_item(values, "a", [], :prev) == "c"
      assert State.next_item(values, "b", [], :first) == "a"
      assert State.next_item(values, "b", [], :last) == "c"
    end

    test "skips disabled" do
      values = ~W(a b c)
      assert State.next_item(values, "a", ["b"], :next) == "c"
      assert State.next_item(values, "a", ["b"], :prev) == "c"
      assert State.next_item(values, "a", ["b"], :first) == "a"
      assert State.next_item(values, "a", ["b"], :last) == "c"
    end
  end

  describe "native_accordion/1" do
    test "renders anatomy without phx-hook or trigger phx-keydown" do
      items = Corex.Content.new([%{value: "lorem", label: "Lorem", content: "Body"}])

      html =
        render_component(&NativeAccordion.native_accordion/1,
          id: "faq",
          items: items,
          value: ["lorem"],
          controlled: true,
          on_value_change: "toggle"
        )

      assert html =~ ~S(data-scope="accordion")
      assert html =~ ~S(data-part="root")
      assert html =~ ~S(data-part="item-trigger")
      assert html =~ ~S(data-native="")
      refute html =~ "phx-hook"
      assert html =~ ~S(aria-expanded="true")
      refute html =~ "phx-keydown="
      refute html =~ "<script"
      assert html =~ "phx-window-keydown"
      assert html =~ ~S(phx-key="ArrowDown")
      assert html =~ "data-nav-next"
      assert html =~ ~S(:focus[data-nav-next])
      assert html =~ ~S(:focus[data-nav-prev])
      assert html =~ ~S(:focus[data-nav-first])
      assert html =~ ~S(:focus[data-nav-last])
      assert html =~ "onkeydown"
      assert html =~ "preventDefault"
      refute html =~ "focus-pin"
    end

    test "defaults to uncontrolled" do
      items = Corex.Content.new([%{value: "lorem", label: "Lorem", content: "Body"}])

      html =
        render_component(&NativeAccordion.native_accordion/1,
          id: "faq",
          items: items
        )

      refute html =~ "data-controlled=\"\""
      assert html =~ "phx-click"
    end

    test "uncontrolled collapsible click uses toggle_attr" do
      items = Corex.Content.new([%{value: "lorem", label: "Lorem", content: "Body"}])

      html =
        render_component(&NativeAccordion.native_accordion/1,
          id: "faq",
          items: items,
          value: ["lorem"],
          multiple: false,
          collapsible: true
        )

      assert html =~ ~S(data-collapsible="")
      assert html =~ "toggle_attr"
    end

    test "uncontrolled non-collapsible click opens without toggle_attr" do
      items = Corex.Content.new([%{value: "lorem", label: "Lorem", content: "Body"}])

      html =
        render_component(&NativeAccordion.native_accordion/1,
          id: "faq",
          items: items,
          value: ["lorem"],
          multiple: false,
          collapsible: false
        )

      refute html =~ ~S(data-collapsible="")
      refute html =~ "toggle_attr"
      assert html =~ "set_attr"
      assert html =~ ~S("open")
    end

    test "closed item is hidden" do
      items =
        Corex.Content.new([
          %{value: "a", label: "A", content: "A body"},
          %{value: "b", label: "B", content: "B body"}
        ])

      html =
        render_component(&NativeAccordion.native_accordion/1,
          id: "faq",
          items: items,
          value: ["a"],
          controlled: true,
          on_value_change: "toggle"
        )

      assert html =~ ~S(id="accordion:faq:trigger:a")
      assert html =~ ~S(aria-expanded="true")
      assert html =~ ~S(aria-expanded="false")
      assert html =~ "hidden"
    end

    test "uncontrolled renders click JS without on_value_change" do
      items = Corex.Content.new([%{value: "lorem", label: "Lorem", content: "Body"}])

      html =
        render_component(&NativeAccordion.native_accordion/1,
          id: "faq",
          items: items,
          value: [],
          controlled: false
        )

      refute html =~ "phx-hook"
      assert html =~ "phx-click"
    end

    test "region landmark names include accordion id" do
      items =
        Corex.Content.new([
          %{value: "a", label: "Lorem", content: "A body"},
          %{value: "b", label: "Lorem", content: "B body"}
        ])

      html =
        render_component(&NativeAccordion.native_accordion/1,
          id: "faq",
          items: items,
          value: ["a"]
        )

      a_trigger = Ids.trigger_id("faq", "a")
      a_region = Ids.region_label_id("faq", "a")
      b_region = Ids.region_label_id("faq", "b")

      assert html =~ ~s(aria-labelledby="#{a_trigger} #{a_region}")
      assert html =~ ~s(id="#{a_region}")
      assert html =~ ~s(id="#{b_region}")
      assert html =~ "faq:a"
      refute a_region == b_region
    end

    test "horizontal rtl compiles ArrowLeft as next" do
      items = Corex.Content.new([%{value: "lorem", label: "Lorem", content: "Body"}])

      html =
        render_component(&NativeAccordion.native_accordion/1,
          id: "faq",
          items: items,
          orientation: "horizontal",
          dir: "rtl"
        )

      assert html =~ ~S(phx-key="ArrowLeft")
      refute html =~ ~S(phx-key="ArrowDown")
    end

    test "renders indicator and dir" do
      items = Corex.Content.new([%{value: "lorem", label: "Lorem", content: "Body"}])

      html =
        render_component(
          fn assigns ->
            ~H"""
            <NativeAccordion.native_accordion
              id="faq"
              items={@items}
              value={[]}
              controlled={false}
              dir="rtl"
              orientation="horizontal"
            >
              <:indicator><span data-test="ind">*</span></:indicator>
            </NativeAccordion.native_accordion>
            """
          end,
          %{items: items}
        )

      assert html =~ ~S(data-part="item-indicator")
      assert html =~ ~S(dir="rtl")
      assert html =~ ~S(data-orientation="horizontal")
      assert html =~ ~S(data-test="ind")
    end
  end
end
