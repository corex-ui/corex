defmodule Corex.NativeAccordionTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.NativeAccordion
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

  describe "State.next_item/4" do
    test "wraps next and prev among enabled items" do
      values = ~w(a b c)
      assert State.next_item(values, "a", [], :next) == "b"
      assert State.next_item(values, "c", [], :next) == "a"
      assert State.next_item(values, "a", [], :prev) == "c"
      assert State.next_item(values, "b", [], :first) == "a"
      assert State.next_item(values, "b", [], :last) == "c"
    end

    test "skips disabled" do
      assert State.next_item(~w(a b c), "a", ["b"], :next) == "c"
    end
  end

  describe "native_accordion/1" do
    test "renders anatomy without phx-hook" do
      items = Corex.Content.new([%{value: "lorem", label: "Lorem", content: "Body"}])

      html =
        render_component(&NativeAccordion.native_accordion/1,
          id: "faq",
          items: items,
          value: ["lorem"],
          controlled: true,
          on_value_change: "toggle"
        )

      assert html =~ ~s(data-scope="accordion")
      assert html =~ ~s(data-part="root")
      assert html =~ ~s(data-part="item-trigger")
      assert html =~ ~s(data-part="item-content")
      assert html =~ ~s(data-native="")
      refute html =~ "phx-hook"
      assert html =~ ~s(aria-expanded="true")
      assert html =~ "Lorem"
      assert html =~ "Body"
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

      assert html =~ ~s(id="accordion:faq:trigger:a")
      assert html =~ ~s(aria-expanded="true")
      assert html =~ ~s(id="accordion:faq:trigger:b")
      assert html =~ ~s(aria-expanded="false")
      assert html =~ ~s(id="accordion:faq:content:b")
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
      assert html =~ "aria-expanded"
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
            >
              <:indicator><span data-test="ind">*</span></:indicator>
            </NativeAccordion.native_accordion>
            """
          end,
          %{items: items}
        )

      assert html =~ ~s(data-part="item-indicator")
      assert html =~ ~s(dir="rtl")
      assert html =~ ~s(data-test="ind")
    end
  end
end
