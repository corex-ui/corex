defmodule Corex.VariantsLayoutBemTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component

  test "layout BEM modifiers prefix axis names to match exported CSS" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Layout.Stack.stack
            padding="none"
            gap="lg"
            align="stretch"
            justify="start"
            width="full"
            min_height="dvh"
            grow="fill"
            direction="column"
          >
            child
          </Corex.Layout.Stack.stack>
          """
        end,
        %{}
      )

    assert html =~ "stack--padding-none"
    assert html =~ "stack--gap-lg"
    assert html =~ "stack--align-stretch"
    assert html =~ "stack--justify-start"
    assert html =~ "stack--w-full"
    assert html =~ "stack--min-height-dvh"
    assert html =~ "stack--grow-fill"
    assert html =~ "stack--direction-column"
    refute html =~ "stack--stretch"
    refute html =~ "stack--width-full"
    refute html =~ "stack--column"
  end

  test "component BEM modifiers match tailwind utility suffixes" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Switch.switch
            id="sw"
            semantic="accent"
            size="md"
            radius="xl"
            max_width="md"
          />
          """
        end,
        %{}
      )

    assert html =~ "switch--semantic-accent"
    assert html =~ "switch--size-md"
    assert html =~ "switch--rounded-xl"
    assert html =~ "switch--max-w-md"
    refute html =~ "switch--accent"
    refute html =~ "switch--md"
  end

  test "component unstyled keeps only the class assign" do
    assert Corex.Accordion.corex_style_class(%{unstyled: true, class: "foo"}) == "foo"
  end
end
