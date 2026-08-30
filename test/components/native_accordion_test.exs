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

  describe "State.focus_target/1" do
    test "resolves next item from keydown payload" do
      params = %{
        "item" => "lorem",
        "key" => "ArrowDown",
        "orientation" => "vertical",
        "item_values" => ~w(lorem duis donec),
        "disabled_values" => []
      }

      assert State.focus_target(params) == "duis"
    end

    test "resolves prev with ArrowUp" do
      params = %{
        "item" => "duis",
        "key" => "ArrowUp",
        "orientation" => "vertical",
        "item_values" => ~w(lorem duis donec),
        "disabled_values" => []
      }

      assert State.focus_target(params) == "lorem"
    end

    test "horizontal ArrowRight" do
      params = %{
        "item" => "lorem",
        "key" => "ArrowRight",
        "orientation" => "horizontal",
        "dir" => "ltr",
        "item_values" => ~w(lorem duis),
        "disabled_values" => []
      }

      assert State.focus_target(params) == "duis"
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
          on_value_change: "toggle",
          on_keydown: "keydown"
        )

      assert html =~ ~s(data-scope="accordion")
      assert html =~ ~s(data-part="root")
      assert html =~ ~s(data-part="item-trigger")
      assert html =~ ~s(data-native="")
      refute html =~ "phx-hook"
      assert html =~ ~s(aria-expanded="true")
      assert html =~ "phx-keydown"
      refute html =~ ~s(phx-key="ArrowDown")
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
      assert html =~ ~s(aria-expanded="false")
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

    test "focus pin renders when focused_value matches" do
      items =
        Corex.Content.new([
          %{value: "a", label: "A", content: "A body"},
          %{value: "b", label: "B", content: "B body"}
        ])

      html =
        render_component(&NativeAccordion.native_accordion/1,
          id: "faq",
          items: items,
          value: [],
          controlled: false,
          on_keydown: "kd",
          focused_value: "b"
        )

      assert html =~ ~s(id="accordion:faq:trigger:b-focus-pin")
      refute html =~ ~s(id="accordion:faq:trigger:a-focus-pin")
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

      assert html =~ ~s(data-part="item-indicator")
      assert html =~ ~s(dir="rtl")
      assert html =~ ~s(data-orientation="horizontal")
      assert html =~ ~s(data-test="ind")
    end
  end
end
