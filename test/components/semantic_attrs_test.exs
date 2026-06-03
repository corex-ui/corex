defmodule Corex.SemanticAttrsTest do
  use CorexTest.ComponentCase, async: false

  import Phoenix.Component

  test "switch maps semantic, size and radius to bem classes" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Switch.switch id="sw" semantic="accent" size="lg" radius="none" />
          """
        end,
        %{}
      )

    assert html =~ "switch--accent"
    assert html =~ "switch--lg"
    assert html =~ "switch--rounded-none"
    refute html =~ "data-switch-semantic"
  end

  test "toggle maps semantic, size and radius to bem classes" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Toggle.toggle id="tg" semantic="brand" size="sm" radius="xl">x</Corex.Toggle.toggle>
          """
        end,
        %{}
      )

    assert html =~ "toggle--brand"
    assert html =~ "toggle--sm"
    assert html =~ "toggle--rounded-xl"
    refute html =~ "data-toggle-semantic"
  end

  test "toggle_group maps semantic and radius to bem classes" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.ToggleGroup.toggle_group id="tgg" semantic="success" radius="lg">
            <:item value="a">A</:item>
          </Corex.ToggleGroup.toggle_group>
          """
        end,
        %{}
      )

    assert html =~ "toggle-group--success"
    assert html =~ "toggle-group--rounded-lg"
    refute html =~ "data-toggle-group-semantic"
  end

  test "select maps semantic, size, text and radius to bem classes" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Select.select id="sel" semantic="info" size="md" text="lg" radius="md" items={[%{label: "A", value: "a"}]}>
            <:trigger>v</:trigger>
          </Corex.Select.select>
          """
        end,
        %{}
      )

    assert html =~ "select--info"
    assert html =~ "select--md"
    assert html =~ "select--text-lg"
    assert html =~ "select--rounded-md"
    refute html =~ "data-select-semantic"
  end

  test "checkbox maps semantic and size to bem classes" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Checkbox.checkbox id="cb" semantic="alert" size="xl" />
          """
        end,
        %{}
      )

    assert html =~ "checkbox--alert"
    assert html =~ "checkbox--xl"
    refute html =~ "data-checkbox-semantic"
  end

  test "dialog maps semantic and as to bem classes" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Dialog.dialog id="dlg" semantic="info" as="side" side="start">
            <:trigger>Open</:trigger>
            <:content>Body</:content>
          </Corex.Dialog.dialog>
          """
        end,
        %{}
      )

    assert html =~ "dialog-side--info"
    assert html =~ "dialog-side--start"
    refute html =~ "data-dialog-side-semantic"
  end

  test "tree_view maps semantic, size and radius to bem classes" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.TreeView.tree_view
            id="tv"
            items={Corex.Tree.new([%{label: "A", value: "a"}])}
            semantic="accent"
            size="md"
            radius="md"
          />
          """
        end,
        %{}
      )

    assert html =~ "tree-view--accent"
    assert html =~ "tree-view--md"
    assert html =~ "tree-view--rounded-md"
    refute html =~ "data-tree-view-semantic"
  end

  test "accordion auto-merges root class without explicit class assign" do
    items = Corex.Content.new([%{label: "A", value: "a", content: "x"}])

    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Accordion.accordion id="acc" items={items} />
          """
        end,
        %{}
      )

    assert html =~ ~S(class="accordion)
    refute html =~ "data-accordion"
  end

  test "row layout auto-merges root class and bem modifiers" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Layout.Row.row gap="md">child</Corex.Layout.Row.row>
          """
        end,
        %{}
      )

    assert html =~ ~S(class="row)
    assert html =~ "row--gap-md"
    refute html =~ "data-row"
  end

  test "components forward user class alongside bem modifiers" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Switch.switch id="sw2" semantic="brand" class="extra" />
          """
        end,
        %{}
      )

    assert html =~ "switch--brand"
    assert html =~ " extra"
    refute html =~ "data-switch"
  end
end
