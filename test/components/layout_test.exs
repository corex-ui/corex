defmodule Corex.LayoutTest do
  use CorexTest.ComponentCase, async: true

  alias CorexTest.LayoutHelpers

  defp assert_has_classes(element, expected) do
    classes = element |> Floki.attribute("class") |> List.first() |> String.split(" ", trim: true)
    assert Enum.all?(expected, &(&1 in classes))
  end

  test "box renders padding attribute and content" do
    result = render_component(&LayoutHelpers.render_box/1, %{})
    assert [box] = find_in_html(result, "div")
    assert_has_classes(box, ~w(box box--padding-lg))
    assert text_in_html(result) =~ "boxed"
  end

  test "row renders gap and justify attributes" do
    result = render_component(&LayoutHelpers.render_row/1, %{})

    assert [row] = find_in_html(result, "div")
    assert_has_classes(row, ~w(row row--gap-lg row--justify-between))
  end

  test "row derives the padding family from its recipe and emits no margin" do
    result = render_component(&LayoutHelpers.render_row_padding/1, %{})

    assert [row] = find_in_html(result, "div")
    assert_has_classes(row, ~w(row row--padding-inline-xl row--padding-block-md))
    refute result =~ "data-row-margin"
  end

  test "stack renders explicit gap attribute" do
    result = render_component(&LayoutHelpers.render_stack/1, %{})

    assert [stack] = find_in_html(result, "div")
    assert_has_classes(stack, ~w(stack stack--gap-md))
  end

  test "grid renders column count" do
    result = render_component(&LayoutHelpers.render_grid/1, %{})
    assert [grid] = find_in_html(result, "div")
    assert_has_classes(grid, ~w(grid grid--columns-3 grid--gap-lg))
  end

  test "container renders size and is a div by default" do
    result = render_component(&LayoutHelpers.render_container/1, %{})
    assert [container] = find_in_html(result, "div")
    assert_has_classes(container, ~w(container container--size-lg))
  end

  test "spacer renders a bare design attribute" do
    result = render_component(&LayoutHelpers.render_spacer/1, %{})
    assert [spacer] = find_in_html(result, "div")
    assert_has_classes(spacer, ~w(spacer))
  end

  test "divider renders an hr with orientation" do
    result = render_component(&LayoutHelpers.render_divider/1, %{})

    assert [divider] = find_in_html(result, "hr")
    assert_has_classes(divider, ~w(divider divider--orientation-horizontal))
  end
end
